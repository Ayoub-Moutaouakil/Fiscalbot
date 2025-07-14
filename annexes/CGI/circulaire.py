import json
import qdrant_client
from qdrant_client.models import PointStruct, VectorParams, Distance
import voyageai
import uuid
import re
import logging
from datetime import datetime
from tqdm import tqdm
import os

# Configuration
VOYAGE_API_KEY = "pa-gPu9JZffTtb0O57mU8ZNtCzWBrQ7dDRy_7M_f6Cr8br"
voyage_client = voyageai.Client(api_key=VOYAGE_API_KEY)

QDRANT_HOST = "13.39.82.37"
QDRANT_PORT = 6333
EMBEDDING_DIM = 1024

# Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class CirculaireProcessor:
    """Processeur pour l'embedding des circulaires avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"  # Même collection que annexevoyagev2
        self.points = []
        
    def ensure_collection_exists(self):
        """Vérifie que la collection existe, la crée si nécessaire"""
        try:
            # Vérifier si la collection existe
            self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"Collection {self.collection_name} existe déjà")
        except:
            # Créer la collection si elle n'existe pas
            self.qdrant_client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
            logger.info(f"Collection {self.collection_name} créée")
    
    def process_circulaire_document(self, doc, doc_index):
        """Traite un document circulaire avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos de base
        document_title = doc.get("document", "")
        
        # Déterminer le type de document
        if "ACCORDS PREALABLES" in document_title:
            return self._process_app_document(doc, doc_index, doc_id)
        elif "BATIMENT ET DES TRAVAUX PUBLICS" in document_title:
            return self._process_btp_document(doc, doc_index, doc_id)
        else:
            logger.warning(f"Type de document non reconnu: {document_title}")
            return None
    
    def _process_app_document(self, doc, doc_index, doc_id):
        """Traite un document APP (Accords Préalables Prix de Transfert)"""
        document_title = doc.get("document", "")
        preambule = doc.get("preambule", "")
        chapitre = doc.get("chapitre", "")
        nom_chapitre = doc.get("nom_chapitre", "")
        partie = doc.get("partie", "")
        nom_partie = doc.get("nom_partie", "")
        sous_partie = doc.get("sous_partie", "")
        nom_sous_partie = doc.get("nom_sous_partie", "")
        contenu = doc.get("contenu", "")
        
        # Construire le contenu principal
        main_content = preambule if preambule else contenu
        
        if not main_content or not main_content.strip():
            logger.warning(f"Document APP {doc_index} vide, ignoré")
            return None
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE APP
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: circulaire APP")
        enriched_text_parts.append(f"Sujet: Accords préalables en matière de prix de transfert")
        enriched_text_parts.append(f"Document: {document_title}")
        
        # 2. Structure hiérarchique
        if chapitre:
            enriched_text_parts.append(f"Chapitre: {chapitre} - {nom_chapitre}")
        if partie:
            enriched_text_parts.append(f"Partie: {partie} - {nom_partie}")
        if sous_partie:
            enriched_text_parts.append(f"Sous-partie: {sous_partie} - {nom_sous_partie}")
        
        # 3. Concepts clés APP
        key_concepts = self._extract_app_concepts(main_content)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Articles CGI mentionnés
        articles_cgi = self._extract_articles_cgi(main_content)
        if articles_cgi:
            enriched_text_parts.append(f"Articles CGI: {', '.join(articles_cgi)}")
        
        # 5. Contenu principal
        enriched_text_parts.append(f"Contenu: {main_content}")
        
        # Créer le texte enrichi final
        enriched_text = "\n\n".join(enriched_text_parts)
        
        # Générer l'embedding
        try:
            result = voyage_client.embed(
                [enriched_text], 
                model="voyage-law-2",
                input_type="document"
            )
            embedding = result.embeddings[0]
        except Exception as e:
            logger.error(f"Erreur embedding APP doc {doc_index}: {e}")
            return None
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": "circulaire_app",
                "document": document_title,
                "chapitre": chapitre,
                "nom_chapitre": nom_chapitre,
                "partie": partie,
                "nom_partie": nom_partie,
                "sous_partie": sous_partie,
                "nom_sous_partie": nom_sous_partie,
                "contenu": main_content,
                "preambule": preambule,
                
                # Métadonnées enrichies
                "key_concepts": key_concepts,
                "articles_cgi": articles_cgi,
                "enriched_text": enriched_text,
                
                # Flags spécifiques
                "has_prix_transfert": "prix de transfert" in main_content.lower(),
                "has_app": "app" in main_content.lower() or "accord préalable" in main_content.lower(),
                "has_entreprises_associees": "entreprises associées" in main_content.lower(),
                "has_administration": "administration" in main_content.lower(),
                
                # Métadonnées
                "doc_index": doc_index,
                "source": "circulaire.json",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _process_btp_document(self, doc, doc_index, doc_id):
        """Traite un document BTP (Bâtiment et Travaux Publics)"""
        document_title = doc.get("document", "")
        introduction = doc.get("introduction", "")
        partie = doc.get("partie", "")
        nom_partie = doc.get("nom_partie", "")
        probleme = doc.get("probleme", "")
        solution = doc.get("solution", "")
        exemple = doc.get("exemple", "")
        
        # Construire le contenu principal
        main_content_parts = []
        if introduction:
            main_content_parts.append(f"Introduction: {introduction}")
        if probleme:
            main_content_parts.append(f"Problème: {probleme}")
        if solution:
            main_content_parts.append(f"Solution: {solution}")
        if exemple:
            main_content_parts.append(f"Exemple: {exemple}")
        
        main_content = "\n\n".join(main_content_parts)
        
        if not main_content or not main_content.strip():
            logger.warning(f"Document BTP {doc_index} vide, ignoré")
            return None
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE BTP
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: note circulaire BTP")
        enriched_text_parts.append(f"Secteur: Bâtiment et Travaux Publics")
        enriched_text_parts.append(f"Document: {document_title}")
        
        # 2. Structure
        if partie:
            enriched_text_parts.append(f"Partie: {partie} - {nom_partie}")
        
        # 3. Concepts clés BTP
        key_concepts = self._extract_btp_concepts(main_content)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Articles de loi mentionnés
        articles_loi = self._extract_articles_loi(main_content)
        if articles_loi:
            enriched_text_parts.append(f"Articles de loi: {', '.join(articles_loi)}")
        
        # 5. Contenu principal
        enriched_text_parts.append(f"Contenu: {main_content}")
        
        # Créer le texte enrichi final
        enriched_text = "\n\n".join(enriched_text_parts)
        
        # Générer l'embedding
        try:
            result = voyage_client.embed(
                [enriched_text], 
                model="voyage-law-2",
                input_type="document"
            )
            embedding = result.embeddings[0]
        except Exception as e:
            logger.error(f"Erreur embedding BTP doc {doc_index}: {e}")
            return None
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": "note_circulaire_btp",
                "document": document_title,
                "partie": partie,
                "nom_partie": nom_partie,
                "introduction": introduction,
                "probleme": probleme,
                "solution": solution,
                "exemple": exemple,
                "contenu": main_content,
                
                # Métadonnées enrichies
                "key_concepts": key_concepts,
                "articles_loi": articles_loi,
                "enriched_text": enriched_text,
                
                # Flags spécifiques
                "has_btp": True,
                "has_chiffre_affaires": "chiffre d'affaires" in main_content.lower(),
                "has_travaux_cours": "travaux en cours" in main_content.lower() or "tec" in main_content.lower(),
                "has_approvisionnement": "approvisionnement" in main_content.lower(),
                "has_decompte": "décompte" in main_content.lower(),
                
                # Métadonnées
                "doc_index": doc_index,
                "source": "circulaire.json",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_app_concepts(self, content):
        """Extrait les concepts clés spécifiques aux APP"""
        concepts = []
        content_lower = content.lower()
        
        app_patterns = {
            "prix de transfert": r"prix\s+de\s+transfert",
            "accord préalable": r"accord\s+préalable",
            "entreprises associées": r"entreprises?\s+associées?",
            "administration fiscale": r"administration\s+fiscale",
            "méthode de détermination": r"méthode\s+de\s+détermination",
            "pleine concurrence": r"pleine\s+concurrence",
            "transactions contrôlées": r"transactions?\s+contrôlées?",
            "analyse fonctionnelle": r"analyse\s+fonctionnelle",
            "actifs incorporels": r"actifs?\s+incorporels?",
            "comparables": r"comparables?",
        }
        
        for concept, pattern in app_patterns.items():
            if re.search(pattern, content_lower):
                concepts.append(concept)
        
        return concepts[:10]
    
    def _extract_btp_concepts(self, content):
        """Extrait les concepts clés spécifiques au BTP"""
        concepts = []
        content_lower = content.lower()
        
        btp_patterns = {
            "chiffre d'affaires": r"chiffre\s+d[''']affaires?",
            "travaux en cours": r"travaux\s+en\s+cours",
            "TEC": r"\bt\.?e\.?c\b",
            "approvisionnement": r"approvisionnements?",
            "décompte": r"décomptes?",
            "attachement": r"attachements?",
            "situation des travaux": r"situation\s+des\s+travaux",
            "révision des prix": r"révision\s+des\s+prix",
            "bois de coffrage": r"bois\s+de\s+coffrage",
            "frais de chantier": r"frais\s+de\s+chantier",
            "prix de revient": r"prix\s+de\s+revient",
            "CCAG": r"c\.?c\.?a\.?g\b",
        }
        
        for concept, pattern in btp_patterns.items():
            if re.search(pattern, content_lower):
                concepts.append(concept)
        
        return concepts[:10]
    
    def _extract_articles_cgi(self, content):
        """Extrait les références aux articles du CGI"""
        articles = []
        
        # Patterns pour articles CGI
        patterns = [
            r"article\s+(\d+(?:\s+bis|\s+ter)?)\s+du\s+c\.?g\.?i",
            r"articles?\s+(\d+(?:\s+bis|\s+ter)?(?:\s+(?:ou|et)\s+\d+(?:\s+bis|\s+ter)?)*)",
        ]
        
        for pattern in patterns:
            matches = re.finditer(pattern, content.lower())
            for match in matches:
                articles.append(f"article {match.group(1)} CGI")
        
        return list(set(articles))[:5]
    
    def _extract_articles_loi(self, content):
        """Extrait les références aux articles de loi"""
        articles = []
        
        # Patterns pour articles de loi
        patterns = [
            r"article\s+(\d+)\s+de\s+la\s+loi\s+n°\s*([\d.-]+)",
            r"loi\s+n°\s*([\d.-]+)",
            r"décret\s+n°\s*([\d.-]+)",
        ]
        
        for pattern in patterns:
            matches = re.finditer(pattern, content.lower())
            for match in matches:
                if "article" in pattern:
                    articles.append(f"article {match.group(1)} loi {match.group(2)}")
                else:
                    articles.append(f"loi/décret {match.group(1)}")
        
        return list(set(articles))[:5]
    
    def process_all_documents(self, documents):
        """Traite tous les documents circulaires"""
        logger.info(f"Traitement de {len(documents)} documents circulaires...")
        
        # S'assurer que la collection existe
        self.ensure_collection_exists()
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des circulaires")):
            point = self.process_circulaire_document(doc, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Ajout de {len(self.points)} documents à la collection...")
            
            # Indexer par batch
            batch_size = 20
            for i in range(0, len(self.points), batch_size):
                batch = self.points[i:i+batch_size]
                try:
                    self.qdrant_client.upsert(
                        collection_name=self.collection_name,
                        points=batch
                    )
                    logger.info(f"Batch {i//batch_size + 1} indexé")
                except Exception as e:
                    logger.error(f"Erreur indexation batch: {e}")
            
            # Vérifier
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} documents au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les circulaires"""
    logger.info("🚀 Démarrage de l'indexation des circulaires")
    
    # Charger les données
    circulaire_file = "/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/circulaire.json"
    with open(circulaire_file, "r", encoding="utf-8") as f:
        circulaire_data = json.load(f)
    
    logger.info(f"✅ {len(circulaire_data)} documents chargés")
    
    # Créer le processeur
    processor = CirculaireProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_documents(circulaire_data)
    
    logger.info(f"✅ Indexation terminée: {count} documents traités")
    
    # Sauvegarder les stats
    stats = {
        "total_documents": len(circulaire_data),
        "indexed_documents": count,
        "collection_name": processor.collection_name,
        "source_file": "circulaire.json",
        "timestamp": datetime.now().isoformat()
    }
    
    with open("circulaire_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans circulaire_indexing_stats.json")

if __name__ == "__main__":
    main()