import json
import uuid
from typing import List, Dict, Any
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct, Filter, FieldCondition, MatchValue
import voyageai
import logging
import os
import time
from collections import defaultdict

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration Voyage AI
VOYAGE_API_KEY = "pa-gPu9JZffTtb0O57mU8ZNtCzWBrQ7dDRy_7M_f6Cr8br"
EMBEDDING_DIM = 1024  # Voyage-law-2 utilise 1024 dimensions

class RateLimit:
    """Gestionnaire de taux de requête API pour Voyage"""
    
    def __init__(self):
        self.timestamps = defaultdict(list)
        self.limits = {
            "voyage": (30, 0.05)  # 30 requêtes par minute, 0.05s entre requêtes
        }
    
    def check_and_wait(self, model_name="voyage"):
        """Vérifie si on peut faire une requête, sinon attend le temps nécessaire"""
        current_time = time.time()
        
        # Déterminer les limites pour ce modèle
        rpm, min_delay = self.limits.get(model_name, (15, 0.1))
        
        # Supprimer les timestamps plus vieux qu'une minute
        self.timestamps[model_name] = [ts for ts in self.timestamps[model_name] if current_time - ts < 60]
        
        # Vérifier le délai minimum entre les requêtes
        if self.timestamps[model_name] and (current_time - self.timestamps[model_name][-1] < min_delay):
            wait_time = min_delay - (current_time - self.timestamps[model_name][-1])
            time.sleep(wait_time)
            current_time = time.time()
        
        # Si on a atteint la limite, calculer le temps d'attente
        if len(self.timestamps[model_name]) >= rpm:
            oldest = min(self.timestamps[model_name])
            wait_time = oldest + 60 - current_time
            
            if wait_time > 0:
                logger.debug(f"⏱️ Limite API atteinte pour {model_name}, attente de {wait_time:.2f} secondes...")
                time.sleep(wait_time + 0.1)
                current_time = time.time()
        
        # Ajouter le timestamp actuel
        self.timestamps[model_name].append(current_time)

class Article6Embedder:
    def __init__(self, 
                 qdrant_url: str = "http://13.39.82.37:6333",
                 collection_name: str = "FCT",
                 voyage_api_key: str = None):
        """
        Initialise le client Qdrant et le client Voyage AI pour l'article 6
        
        Args:
            qdrant_url: URL du serveur Qdrant
            collection_name: Nom de la collection dans Qdrant
            voyage_api_key: Clé API Voyage (si None, utilise la clé par défaut)
        """
        self.qdrant_url = qdrant_url
        self.client = QdrantClient(url=qdrant_url)
        self.collection_name = collection_name
        
        # Configuration du client Voyage AI
        api_key = voyage_api_key or VOYAGE_API_KEY
        self.voyage_client = voyageai.Client(api_key=api_key)
        self.model = "voyage-law-2"
        
        # Gestionnaire de taux de requête
        self.rate_limiter = RateLimit()
        
        # Cache pour les embeddings
        self.cache = {}
        self.cache_hits = 0
        self.cache_misses = 0
    
    def check_qdrant_connection(self) -> bool:
        """
        Vérifie la connexion avec Qdrant
        
        Returns:
            bool: True si la connexion est établie, False sinon
        """
        try:
            collections = self.client.get_collections()
            logger.info(f"✅ Connexion à Qdrant établie avec succès sur {self.qdrant_url}")
            logger.info(f"Collections disponibles: {len(collections.collections)}")
            return True
        except Exception as e:
            logger.error(f"❌ Impossible de se connecter à Qdrant sur {self.qdrant_url}")
            logger.error(f"Erreur: {e}")
            return False
    
    def delete_article_6(self):
        """
        Supprime tous les points de l'article 6 dans la collection Qdrant
        """
        try:
            # Créer un filtre pour l'article 6
            filter_condition = Filter(
                must=[
                    FieldCondition(
                        key="article",
                        match=MatchValue(value="6")
                    )
                ]
            )
            
            # Supprimer tous les points correspondant à l'article 6
            self.client.delete(
                collection_name=self.collection_name,
                points_selector=filter_condition
            )
            
            logger.info("✅ Article 6 supprimé avec succès de la base Qdrant")
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de la suppression de l'article 6: {e}")
            raise
    
    def prepare_text_for_embedding(self, chunk: Dict[str, Any]) -> str:
        """
        Prépare le texte pour l'embedding en incluant les nouveaux champs partie_article et nom_partie_article
        
        Args:
            chunk: Dictionnaire contenant les données d'un chunk
            
        Returns:
            Texte formaté pour l'embedding
        """
        text_parts = []
        
        # Ajout des informations hiérarchiques
        if chunk.get('partie'):
            text_parts.append(f"Partie {chunk['partie']}")
        if chunk.get('nom_partie'):
            text_parts.append(f": {chunk['nom_partie']}")
            
        if chunk.get('titre'):
            text_parts.append(f"\nTitre {chunk['titre']}")
        if chunk.get('nom_titre'):
            text_parts.append(f": {chunk['nom_titre']}")
            
        if chunk.get('chapitre'):
            text_parts.append(f"\nChapitre {chunk['chapitre']}")
        if chunk.get('nom_chapitre'):
            text_parts.append(f": {chunk['nom_chapitre']}")
            
        if chunk.get('section'):
            text_parts.append(f"\nSection {chunk['section']}")
        if chunk.get('nom_section'):
            text_parts.append(f": {chunk['nom_section']}")
            
        if chunk.get('article'):
            text_parts.append(f"\nArticle {chunk['article']}")
        if chunk.get('nom_article'):
            text_parts.append(f": {chunk['nom_article']}")
        
        # NOUVEAUX CHAMPS: partie_article et nom_partie_article
        if chunk.get('partie_article'):
            text_parts.append(f"\nPartie Article {chunk['partie_article']}")
        if chunk.get('nom_partie_article'):
            text_parts.append(f": {chunk['nom_partie_article']}")
            
        # Ajout du contenu principal
        if chunk.get('contenu'):
            text_parts.append(f"\n\nContenu: {chunk['contenu']}")
        
        return ''.join(text_parts)
    
    def get_voyage_embedding(self, text: str, max_retries: int = 3) -> List[float]:
        """
        Obtient l'embedding d'un texte via l'API Voyage AI
        
        Args:
            text: Texte à embedder
            max_retries: Nombre maximum de tentatives
            
        Returns:
            Vecteur d'embedding
        """
        # Vérifier le cache
        text_hash = hash(text)
        if text_hash in self.cache:
            self.cache_hits += 1
            return self.cache[text_hash]
        
        self.cache_misses += 1
        
        # Respecter les limites de taux
        self.rate_limiter.check_and_wait("voyage")
        
        for attempt in range(max_retries):
            try:
                response = self.voyage_client.embed(
                    texts=[text],
                    model=self.model,
                    input_type="document"
                )
                
                embedding = response.embeddings[0]
                
                # Mettre en cache
                if len(self.cache) < 500:
                    self.cache[text_hash] = embedding
                
                return embedding
                
            except Exception as e:
                logger.warning(f"Tentative {attempt + 1}/{max_retries} échouée pour l'embedding: {str(e)}")
                if attempt < max_retries - 1:
                    time.sleep(2 ** attempt)
                else:
                    logger.error(f"Échec de l'embedding après {max_retries} tentatives")
                    raise
    
    def create_metadata(self, chunk: Dict[str, Any]) -> Dict[str, Any]:
        """
        Crée les métadonnées à stocker avec le vecteur, incluant les nouveaux champs
        
        Args:
            chunk: Dictionnaire contenant les données d'un chunk
            
        Returns:
            Dictionnaire des métadonnées
        """
        metadata = {
            'partie': chunk.get('partie', ''),
            'nom_partie': chunk.get('nom_partie', ''),
            'titre': chunk.get('titre', ''),
            'nom_titre': chunk.get('nom_titre', ''),
            'chapitre': chunk.get('chapitre', ''),
            'nom_chapitre': chunk.get('nom_chapitre', ''),
            'section': chunk.get('section', ''),
            'nom_section': chunk.get('nom_section', ''),
            'article': chunk.get('article', ''),
            'nom_article': chunk.get('nom_article', ''),
            'partie_article': chunk.get('partie_article', ''),  # NOUVEAU CHAMP
            'nom_partie_article': chunk.get('nom_partie_article', ''),  # NOUVEAU CHAMP
            'contenu': chunk.get('contenu', '')
        }
        return metadata
    
    def embed_and_upload_article_6(self, json_file_path: str):
        """
        Lit le fichier JSON, supprime l'ancien article 6, crée les embeddings et les upload vers Qdrant
        
        Args:
            json_file_path: Chemin vers le fichier JSON contenant l'article 6
        """
        # Lecture du fichier JSON
        with open(json_file_path, 'r', encoding='utf-8') as file:
            chunks = json.load(file)
        
        logger.info(f"Chargement de {len(chunks)} parties de l'article 6 depuis {json_file_path}")
        
        # Vérifier que tous les chunks sont bien de l'article 6
        for chunk in chunks:
            if chunk.get('article') != '6':
                logger.warning(f"Attention: chunk trouvé qui n'est pas de l'article 6: {chunk.get('article')}")
        
        # 1. Supprimer l'ancien article 6
        logger.info("🗑️ Suppression de l'ancien article 6...")
        self.delete_article_6()
        
        # 2. Traiter les nouveaux chunks
        points = []
        
        for i, chunk in enumerate(chunks):
            try:
                # Préparation du texte pour l'embedding (avec les nouveaux champs)
                text_for_embedding = self.prepare_text_for_embedding(chunk)
                
                # Création de l'embedding avec Voyage AI
                embedding = self.get_voyage_embedding(text_for_embedding)
                
                # Création des métadonnées (avec les nouveaux champs)
                metadata = self.create_metadata(chunk)
                
                # Création du point pour Qdrant
                point = PointStruct(
                    id=str(uuid.uuid4()),
                    vector=embedding,
                    payload=metadata
                )
                points.append(point)
                
                logger.info(f"Partie {i + 1}/{len(chunks)} de l'article 6 traitée: {chunk.get('nom_partie_article', 'Sans nom')}")
                
            except Exception as e:
                logger.error(f"Erreur lors du traitement de la partie {i + 1}: {e}")
                continue
        
        # 3. Upload vers Qdrant
        if points:
            try:
                self.client.upsert(
                    collection_name=self.collection_name,
                    points=points
                )
                logger.info(f"✅ Article 6 mis à jour avec succès ({len(points)} parties uploadées)")
            except Exception as e:
                logger.error(f"❌ Erreur lors de l'upload: {e}")
                raise
        
        # Statistiques finales
        logger.info(f"Cache hits: {self.cache_hits}, Cache misses: {self.cache_misses}")
    
    def search_article_6(self, query: str, limit: int = 5) -> List[Dict]:
        """
        Recherche spécifiquement dans l'article 6
        
        Args:
            query: Texte de la requête
            limit: Nombre de résultats à retourner
            
        Returns:
            Liste des résultats avec scores et métadonnées
        """
        # Création de l'embedding pour la requête
        query_embedding = self.get_voyage_embedding(query)
        
        # Filtre pour l'article 6 uniquement
        filter_condition = Filter(
            must=[
                FieldCondition(
                    key="article",
                    match=MatchValue(value="6")
                )
            ]
        )
        
        # Recherche dans Qdrant
        search_results = self.client.search(
            collection_name=self.collection_name,
            query_vector=query_embedding,
            query_filter=filter_condition,
            limit=limit
        )
        
        results = []
        for result in search_results:
            results.append({
                'score': result.score,
                'metadata': result.payload
            })
        
        return results

def main():
    """
    Fonction principale pour exécuter le processus d'embedding de l'article 6
    """
    # Configuration
    json_file_path = "/Users/ayoub/Documents/GitHub/FB-Ahmed/FCT_6.json"
    qdrant_url = "http://13.39.82.37:6333"
    collection_name = "FCT"
    
    # Initialisation de l'embedder
    embedder = Article6Embedder(
        qdrant_url=qdrant_url,
        collection_name=collection_name
    )
    
    # Vérification de la connexion Qdrant
    logger.info("🔍 Vérification de la connexion à Qdrant...")
    if not embedder.check_qdrant_connection():
        logger.error("💥 Arrêt du programme: impossible de se connecter à Qdrant")
        return
    
    try:
        # Embedding et upload de l'article 6
        embedder.embed_and_upload_article_6(json_file_path)
        
        # Test de recherche dans l'article 6
        print("\n=== Test de recherche dans l'article 6 ===")
        query = "exonérations permanentes"
        results = embedder.search_article_6(query, limit=3)
        
        print(f"Résultats pour la requête: '{query}'")
        for i, result in enumerate(results, 1):
            print(f"\n{i}. Score: {result['score']:.4f}")
            print(f"   Article: {result['metadata']['article']} - {result['metadata']['nom_article']}")
            print(f"   Partie: {result['metadata']['partie_article']} - {result['metadata']['nom_partie_article']}")
            print(f"   Contenu: {result['metadata']['contenu'][:200]}...")
        
    except Exception as e:
        logger.error(f"Erreur lors de l'exécution: {e}")
        raise

if __name__ == "__main__":
    main()