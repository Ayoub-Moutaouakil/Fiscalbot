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

class OptimizedAnnexeProcessor:
    """Processeur optimisé pour l'embedding des annexes avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"
        self.points = []
        
    def create_collection(self):
        """Crée la collection optimisée pour les annexes"""
        try:
            # Supprimer si existe
            try:
                self.qdrant_client.delete_collection(self.collection_name)
                logger.info(f"Collection {self.collection_name} supprimée")
            except:
                pass
            
            # Créer la nouvelle collection
            self.qdrant_client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
            logger.info(f"Collection {self.collection_name} créée")
        except Exception as e:
            logger.error(f"Erreur création collection: {e}")
            raise
    
    def process_annexe_document(self, doc, doc_index):
        """Traite un document annexe avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos
        titre = doc.get("titre", "")
        contenu = doc.get("contenu", "")
        source = doc.get("source", "")
        type_doc = doc.get("type", "")
        articles_lies = doc.get("article", [])
        
        if not contenu or not contenu.strip():
            logger.warning(f"Document {doc_index} vide, ignoré")
            return None
        
        # Déterminer le type de document et enrichir
        doc_info = self._extract_enhanced_info(type_doc, titre, contenu)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {doc_info['type']}")
        enriched_text_parts.append(f"Numéro: {doc_info['numero']}")
        enriched_text_parts.append(f"Date: {doc_info['date']}")
        enriched_text_parts.append(f"Objet: {titre}")
        
        # 2. Articles CGI liés (TRÈS IMPORTANT)
        if articles_lies:
            enriched_text_parts.append(f"Articles CGI liés: {', '.join(f'article {a}' for a in articles_lies)}")
        
        # 3. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(contenu)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Enrichissement spécifique par type
        if "plastique" in contenu.lower():
            enriched_text_parts.append("Secteur: industrie du plastique, matières plastiques, produits en plastique")
            enriched_text_parts.append("Exonération: activités industrielles exonérées IS")
        
        if "représentation" in contenu.lower() and "10%" in contenu:
            enriched_text_parts.append("Indemnité: indemnité de représentation")
            enriched_text_parts.append("Plafond: 10% du salaire de base")
            enriched_text_parts.append("Bénéficiaires: cadres dirigeants, directeurs")
        
        # 5. Contenu principal
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
        
        # Extraire des métadonnées supplémentaires pour la recherche
        search_keywords = self._generate_search_keywords(titre, contenu, doc_info['type'])
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": doc_info["type"],
                "numero": doc_info["numero"],
                "date": doc_info["date"],
                "objet": titre,
                "contenu": contenu,
                "articles_lies": articles_lies,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "enriched_text": enriched_text,  # Garder pour debug
                
                # Flags spécifiques
                "has_plastique": "plastique" in contenu.lower(),
                "has_chaussures": "chaussures" in contenu.lower() or "industrie de chaussures" in contenu.lower(),
                "has_representation": "représentation" in contenu.lower() and "10%" in contenu,
                "has_exoneration": "exonération" in contenu.lower() or "exonéré" in contenu.lower(),
                
                # Métadonnées
                "doc_index": doc_index,
                "source": source,
                "type_original": type_doc,
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_enhanced_info(self, type_original, titre, contenu):
        """Extraction améliorée des informations du document"""
        doc_info = {
            "type": "document",
            "numero": "",
            "date": ""
        }
        
        # Déterminer le type
        type_lower = type_original.lower()
        if "note circulaire" in type_lower:
            doc_info["type"] = "note_circulaire"
            numero_match = re.search(r'n°\s*(\d+)', type_original)
            if numero_match:
                doc_info["numero"] = numero_match.group(1)
        elif "décret" in type_lower:
            doc_info["type"] = "décret"
            # Chercher dans le contenu aussi
            numero_match = re.search(r'décret\s+n°\s*([\d-]+)', contenu[:500], re.IGNORECASE)
            if numero_match:
                doc_info["numero"] = numero_match.group(1)
        elif "note" in type_lower and "service" in type_lower:
            doc_info["type"] = "note_service"
            doc_info["numero"] = "DGI"
        
        # Extraire la date
        for year in range(2025, 2015, -1):
            if str(year) in type_original or str(year) in titre or str(year) in contenu[:200]:
                doc_info["date"] = str(year)
                break
        
        return doc_info
    
    def _extract_key_concepts(self, contenu):
        """Extrait les concepts clés du contenu"""
        concepts = []
        contenu_lower = contenu.lower()
        
        # Patterns de concepts importants
        concept_patterns = {
            "exonération IS": r"exonération.*impôt.*sociétés",
            "activités industrielles": r"activités?\s+industrielles?",
            "indemnité représentation": r"indemnité\s+de\s+représentation",
            "plafond 10%": r"(\d+\s*%)\s*du\s+salaire",
            "industrie plastique": r"industrie\s+(?:du\s+)?plastique",
            "cinq exercices": r"cinq.*exercices?\s+consécutifs?",
            "note service": r"note\s+de\s+service",
            "décret": r"décret\s+n°",
        }
        
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, contenu_lower):
                concepts.append(concept)
        
        # Extraire les montants
        amounts = re.findall(r'\d+(?:\s*\d+)*\s*(?:dirhams?|dh|mad)', contenu_lower)
        concepts.extend(amounts[:3])
        
        # Extraire les pourcentages
        percentages = re.findall(r'\d+\s*%', contenu_lower)
        concepts.extend(percentages[:2])
        
        return list(set(concepts))[:15]
    
    def _generate_search_keywords(self, titre, contenu, doc_type):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Mots du titre
        titre_words = [w for w in titre.lower().split() if len(w) > 3]
        keywords.extend(titre_words[:5])
        
        # Type de document
        keywords.append(doc_type)
        
        # Termes fiscaux importants
        fiscal_terms = [
            "exonération", "indemnité", "plafond", "plastique", "industrie",
            "représentation", "activités", "sociétés", "impôt", "décret",
            "circulaire", "note", "service"
        ]
        
        for term in fiscal_terms:
            if term in contenu.lower():
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_documents(self, documents):
        """Traite tous les documents annexes"""
        logger.info(f"Traitement de {len(documents)} documents annexes...")
        
        # Créer la collection
        self.create_collection()
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des annexes")):
            point = self.process_annexe_document(doc, i)
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
            logger.info(f"✅ Collection créée avec {collection_info.points_count} documents")
        
        return len(self.points)

def main():
    """Script principal pour ré-indexer les annexes"""
    logger.info("🚀 Démarrage de l'indexation optimisée des annexes")
    
    # Charger les données
    with open("notecirculaire_fixed_cleaned_analyzed.json", "r", encoding="utf-8") as f:
        annexe_data = json.load(f)
    
    logger.info(f"✅ {len(annexe_data)} documents chargés")
    
    # Créer le processeur
    processor = OptimizedAnnexeProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_documents(annexe_data)
    
    logger.info(f"✅ Indexation terminée: {count} documents traités")
    
    # Sauvegarder les stats
    stats = {
        "total_documents": len(annexe_data),
        "indexed_documents": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("annexe_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans annexe_indexing_stats.json")

if __name__ == "__main__":
    main()
