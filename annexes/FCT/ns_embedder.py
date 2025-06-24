import json
import uuid
from typing import List, Dict, Any
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct
import voyageai
import logging
import time
from collections import defaultdict

# Configuration du logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration Voyage AI (même que annexevoyagev2.py)
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

class NSEmbedder:
    def __init__(self, 
                 qdrant_url: str = "http://13.39.82.37:6333",
                 collection_name: str = "FCT_Annexes",
                 voyage_api_key: str = None):
        """
        Initialise le client Qdrant et le client Voyage AI pour les notes de service
        
        Args:
            qdrant_url: URL du serveur Qdrant
            collection_name: Nom de la collection dans Qdrant
            voyage_api_key: Clé API Voyage (si None, utilise la clé par défaut)
        """
        self.qdrant_url = qdrant_url
        self.client = QdrantClient(url=qdrant_url)
        self.collection_name = collection_name
        
        # Configuration du client Voyage AI (même modèle que annexevoyagev2.py)
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
    
    def create_collection(self):
        """
        Crée ou recrée la collection FCT_Annexes
        """
        try:
            # Supprimer la collection si elle existe
            try:
                self.client.delete_collection(self.collection_name)
                logger.info(f"Collection {self.collection_name} supprimée")
            except:
                logger.info(f"Collection {self.collection_name} n'existait pas")
            
            # Créer la nouvelle collection
            self.client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
            logger.info(f"✅ Collection {self.collection_name} créée avec succès")
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de la création de la collection: {e}")
            raise
    
    def prepare_text_for_embedding(self, entry: Dict[str, Any]) -> str:
        """
        Prépare le texte pour l'embedding en incluant toutes les métadonnées
        (similaire à FCT_6_embedder.py)
        
        Args:
            entry: Dictionnaire contenant les données d'une entrée
            
        Returns:
            Texte formaté pour l'embedding
        """
        text_parts = []
        
        # Document principal
        if entry.get('document'):
            text_parts.append(f"Document: {entry['document']}")
        
        # Introduction (pour la première entrée)
        if entry.get('introduction'):
            text_parts.append(f"Introduction: {entry['introduction']}")
        
        # Informations hiérarchiques
        if entry.get('chapitre'):
            text_parts.append(f"Chapitre {entry['chapitre']}")
        if entry.get('nom_chapitre'):
            text_parts.append(f": {entry['nom_chapitre']}")
            
        if entry.get('partie'):
            text_parts.append(f"\nPartie {entry['partie']}")
        if entry.get('nom_partie'):
            text_parts.append(f": {entry['nom_partie']}")
            
        if entry.get('sous_partie'):
            text_parts.append(f"\nSous-partie {entry['sous_partie']}")
        if entry.get('nom_sous_partie'):
            text_parts.append(f": {entry['nom_sous_partie']}")
            
        # Contenu principal
        if entry.get('contenu'):
            text_parts.append(f"\n\nContenu: {entry['contenu']}")
        
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
    
    def create_metadata(self, entry: Dict[str, Any]) -> Dict[str, Any]:
        """
        Crée les métadonnées à stocker avec le vecteur
        
        Args:
            entry: Dictionnaire contenant les données d'une entrée
            
        Returns:
            Dictionnaire des métadonnées
        """
        metadata = {
            'document': entry.get('document', ''),
            'introduction': entry.get('introduction', ''),
            'chapitre': entry.get('chapitre', ''),
            'nom_chapitre': entry.get('nom_chapitre', ''),
            'partie': entry.get('partie', ''),
            'nom_partie': entry.get('nom_partie', ''),
            'sous_partie': entry.get('sous_partie', ''),
            'nom_sous_partie': entry.get('nom_sous_partie', ''),
            'contenu': entry.get('contenu', '')
        }
        return metadata
    
    def embed_and_upload_ns(self, json_file_path: str):
        """
        Lit le fichier JSON, crée les embeddings et les upload vers Qdrant
        
        Args:
            json_file_path: Chemin vers le fichier JSON contenant les notes de service
        """
        # Lecture du fichier JSON
        with open(json_file_path, 'r', encoding='utf-8') as file:
            entries = json.load(file)
        
        logger.info(f"Chargement de {len(entries)} entrées depuis {json_file_path}")
        
        # 1. Créer/recréer la collection
        logger.info("🗑️ Création de la nouvelle collection...")
        self.create_collection()
        
        # 2. Traiter les entrées
        points = []
        
        for i, entry in enumerate(entries):
            try:
                # Préparation du texte pour l'embedding (avec métadonnées)
                text_for_embedding = self.prepare_text_for_embedding(entry)
                
                # Création de l'embedding avec Voyage AI
                embedding = self.get_voyage_embedding(text_for_embedding)
                
                # Création des métadonnées
                metadata = self.create_metadata(entry)
                
                # Création du point pour Qdrant
                point = PointStruct(
                    id=str(uuid.uuid4()),
                    vector=embedding,
                    payload=metadata
                )
                points.append(point)
                
                # Log du progrès
                section_info = ""
                if entry.get('nom_chapitre'):
                    section_info += f"Chapitre {entry.get('chapitre', '')}: {entry.get('nom_chapitre', '')}"
                if entry.get('nom_partie'):
                    section_info += f" - Partie {entry.get('partie', '')}: {entry.get('nom_partie', '')}"
                if entry.get('nom_sous_partie'):
                    section_info += f" - {entry.get('nom_sous_partie', '')}"
                
                logger.info(f"Entrée {i + 1}/{len(entries)} traitée: {section_info or 'Introduction'}")
                
            except Exception as e:
                logger.error(f"Erreur lors du traitement de l'entrée {i + 1}: {e}")
                continue
        
        # 3. Upload vers Qdrant
        if points:
            try:
                self.client.upsert(
                    collection_name=self.collection_name,
                    points=points
                )
                logger.info(f"✅ Notes de service uploadées avec succès ({len(points)} entrées)")
            except Exception as e:
                logger.error(f"❌ Erreur lors de l'upload: {e}")
                raise
        
        # Statistiques finales
        logger.info(f"Cache hits: {self.cache_hits}, Cache misses: {self.cache_misses}")
    
    def search_ns(self, query: str, limit: int = 5) -> List[Dict]:
        """
        Recherche dans les notes de service
        
        Args:
            query: Texte de la requête
            limit: Nombre de résultats à retourner
            
        Returns:
            Liste des résultats avec scores et métadonnées
        """
        # Création de l'embedding pour la requête
        query_embedding = self.get_voyage_embedding(query)
        
        # Recherche dans Qdrant
        search_results = self.client.search(
            collection_name=self.collection_name,
            query_vector=query_embedding,
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
    Fonction principale pour exécuter le processus d'embedding des notes de service
    """
    # Configuration
    json_file_path = "/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/FCT/JSON/NS.json"
    qdrant_url = "http://13.39.82.37:6333"
    collection_name = "FCT_Annexes"
    
    # Initialisation de l'embedder
    embedder = NSEmbedder(
        qdrant_url=qdrant_url,
        collection_name=collection_name
    )
    
    # Vérification de la connexion Qdrant
    logger.info("🔍 Vérification de la connexion à Qdrant...")
    if not embedder.check_qdrant_connection():
        logger.error("💥 Arrêt du programme: impossible de se connecter à Qdrant")
        return
    
    try:
        # Embedding et upload des notes de service
        embedder.embed_and_upload_ns(json_file_path)
        
        # Test de recherche
        print("\n=== Test de recherche dans les notes de service ===")
        query = "taxe professionnelle exonérations"
        results = embedder.search_ns(query, limit=3)
        
        print(f"Résultats pour la requête: '{query}'")
        for i, result in enumerate(results, 1):
            print(f"\n{i}. Score: {result['score']:.4f}")
            if result['metadata']['nom_chapitre']:
                print(f"   Chapitre: {result['metadata']['chapitre']} - {result['metadata']['nom_chapitre']}")
            if result['metadata']['nom_partie']:
                print(f"   Partie: {result['metadata']['partie']} - {result['metadata']['nom_partie']}")
            if result['metadata']['nom_sous_partie']:
                print(f"   Sous-partie: {result['metadata']['sous_partie']} - {result['metadata']['nom_sous_partie']}")
            print(f"   Contenu: {result['metadata']['contenu'][:200]}...")
        
    except Exception as e:
        logger.error(f"Erreur lors de l'exécution: {e}")
        raise

if __name__ == "__main__":
    main()