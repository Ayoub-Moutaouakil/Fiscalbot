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

class NoteServiceProcessor:
    """Processeur pour l'embedding des notes de service avec enrichissement contextuel"""
    
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
        except Exception:
            # Créer la collection si elle n'existe pas
            self.qdrant_client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
            logger.info(f"Collection {self.collection_name} créée")
    
    def process_note_service_document(self, doc, doc_index):
        """Traite un document note de service avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos spécifiques aux notes de service
        document_type = doc.get("document", "")
        objet = doc.get("objet", "")
        contenu = doc.get("contenu", "")
        
        if not contenu or not contenu.strip():
            logger.warning(f"Document {doc_index} vide, ignoré")
            return None
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE AUX NOTES DE SERVICE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {document_type}")
        enriched_text_parts.append(f"Objet: {objet}")
        
        # 2. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts_ns(contenu, objet)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 3. Enrichissement spécifique par contenu
        enrichment_flags = self._analyze_content_flags(contenu, objet)
        
        # Ajout d'enrichissements contextuels spécifiques
        if enrichment_flags['has_moyens_paiement']:
            enriched_text_parts.append("Sujet: moyens de paiement admis, article 193 CGI, transactions commerciales")
            enriched_text_parts.append("Montant seuil: 20 000 dirhams, chèques barrés, virements bancaires")
            
        if enrichment_flags['has_logement_social']:
            enriched_text_parts.append("Sujet: logement social, exonération TVA, superficie couverte")
            enriched_text_parts.append("Critères: 50-80 m², prix maximum 250 000 DH, parties communes 10%")
            
        if enrichment_flags['has_tva']:
            enriched_text_parts.append("Impôt: TVA, taxe sur la valeur ajoutée")
            
        if enrichment_flags['has_cgi_articles']:
            articles = self._extract_cgi_articles(contenu)
            if articles:
                enriched_text_parts.append(f"Articles CGI: {', '.join(articles)}")
        
        # 4. Contenu principal
        enriched_text_parts.append(f"Contenu complet: {contenu}")
        
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
            logger.error(f"Erreur embedding doc {doc_index}: {e}")
            return None
        
        # Générer des mots-clés de recherche
        search_keywords = self._generate_search_keywords_ns(objet, contenu)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base spécifiques aux notes de service
                "type": "note_service",
                "document": document_type,
                "objet": objet,
                "contenu": contenu,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "enriched_text": enriched_text,
                
                # Flags spécifiques aux notes de service
                "has_moyens_paiement": enrichment_flags['has_moyens_paiement'],
                "has_logement_social": enrichment_flags['has_logement_social'],
                "has_tva": enrichment_flags['has_tva'],
                "has_cgi_articles": enrichment_flags['has_cgi_articles'],
                "has_superficie": enrichment_flags['has_superficie'],
                "has_exoneration": enrichment_flags['has_exoneration'],
                "has_sanctions": enrichment_flags['has_sanctions'],
                
                # Métadonnées
                "doc_index": doc_index,
                "source": "ns.json",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_key_concepts_ns(self, contenu, objet):
        """Extrait les concepts clés spécifiques aux notes de service"""
        concepts = []
        contenu_lower = contenu.lower()
        objet_lower = objet.lower()
        
        # Patterns de concepts importants pour les notes de service
        concept_patterns = {
            "moyens de paiement": r"moyens?\s+de\s+paiement",
            "article 193 CGI": r"article\s+193",
            "chèques barrés": r"chèques?\s+barrés?",
            "virements bancaires": r"virements?\s+bancaires?",
            "logement social": r"logement\s+social",
            "exonération TVA": r"exonération.*tva",
            "superficie couverte": r"superficie\s+couverte",
            "parties communes": r"parties?\s+communes?",
            "20 000 dirhams": r"20\s*000\s*dirhams?",
            "250 000 dirhams": r"250\s*000\s*dirhams?",
            "sanctions fiscales": r"sanctions?|amende",
            "transactions commerciales": r"transactions?\s+commerciales?"
        }
        
        # Chercher dans le contenu et l'objet
        full_text = f"{objet_lower} {contenu_lower}"
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, full_text):
                concepts.append(concept)
        
        # Extraire les montants
        amounts = re.findall(r'\d+(?:\s*\d+)*\s*(?:dirhams?|dh|mad)', full_text)
        concepts.extend(amounts[:3])
        
        # Extraire les pourcentages
        percentages = re.findall(r'\d+\s*%', full_text)
        concepts.extend(percentages[:2])
        
        return list(set(concepts))[:15]
    
    def _analyze_content_flags(self, contenu, objet):
        """Analyse le contenu pour définir des flags thématiques"""
        contenu_lower = contenu.lower()
        objet_lower = objet.lower()
        full_text = f"{objet_lower} {contenu_lower}"
        
        return {
            'has_moyens_paiement': bool(re.search(r"moyens?\s+de\s+paiement|article\s+193", full_text)),
            'has_logement_social': bool(re.search(r"logement\s+social|superficie\s+couverte", full_text)),
            'has_tva': bool(re.search(r"\btva\b|taxe\s+sur\s+la\s+valeur\s+ajoutée", full_text)),
            'has_cgi_articles': bool(re.search(r"article\s+\d+", full_text)),
            'has_superficie': bool(re.search(r"superficie|m²|mètres?\s+carrés?", full_text)),
            'has_exoneration': bool(re.search(r"exonération|exonéré", full_text)),
            'has_sanctions': bool(re.search(r"sanctions?|amende|infractions?", full_text))
        }
    
    def _extract_cgi_articles(self, contenu):
        """Extrait les références aux articles du CGI"""
        articles = re.findall(r"article\s+(\d+(?:-[IVX]+)?)", contenu, re.IGNORECASE)
        return list(set(articles))[:5]
    
    def _generate_search_keywords_ns(self, objet, contenu):
        """Génère des mots-clés optimisés pour la recherche des notes de service"""
        keywords = []
        
        # Mots de l'objet
        objet_words = [w for w in objet.lower().split() if len(w) > 3]
        keywords.extend(objet_words[:5])
        
        # Type de document
        keywords.extend(["note", "service", "note_service"])
        
        # Termes fiscaux importants spécifiques aux notes de service
        fiscal_terms = [
            "paiement", "transaction", "chèque", "virement", "bancaire",
            "logement", "social", "superficie", "tva", "exonération",
            "cgi", "article", "sanction", "amende", "infraction",
            "parties", "communes", "couverte", "dirhams"
        ]
        
        full_text = f"{objet} {contenu}".lower()
        for term in fiscal_terms:
            if term in full_text:
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_documents(self, documents):
        """Traite tous les documents notes de service"""
        logger.info(f"Traitement de {len(documents)} notes de service...")
        
        # S'assurer que la collection existe (sans la supprimer)
        self.ensure_collection_exists()
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des notes de service")):
            point = self.process_note_service_document(doc, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Indexation de {len(self.points)} documents...")
            
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
    """Script principal pour indexer les notes de service"""
    logger.info("🚀 Démarrage de l'indexation des notes de service")
    
    # Charger les données depuis ns.json
    json_path = "JSON/ns.json"
    if not os.path.exists(json_path):
        json_path = "../JSON/ns.json"  # Chemin alternatif
    if not os.path.exists(json_path):
        json_path = "/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/ns.json"  # Chemin absolu
    
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            ns_data = json.load(f)
    except FileNotFoundError:
        logger.error(f"Fichier {json_path} non trouvé")
        return
    
    logger.info(f"✅ {len(ns_data)} notes de service chargées")
    
    # Créer le processeur
    processor = NoteServiceProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_documents(ns_data)
    
    logger.info(f"✅ Indexation terminée: {count} notes de service traitées")
    
    # Sauvegarder les stats
    stats = {
        "total_documents": len(ns_data),
        "indexed_documents": count,
        "collection_name": processor.collection_name,
        "document_type": "note_service",
        "timestamp": datetime.now().isoformat()
    }
    
    with open("ns_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans ns_indexing_stats.json")

if __name__ == "__main__":
    main()