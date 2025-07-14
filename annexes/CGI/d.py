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

class DemandProcessor:
    """Processeur pour l'embedding des demandes d'éclaircissement avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"  # Même collection que annexevoyagev2
        self.points = []
        
    def create_collection_if_not_exists(self):
        """Crée la collection seulement si elle n'existe pas déjà"""
        try:
            # Vérifier si la collection existe
            collections = self.qdrant_client.get_collections()
            collection_exists = any(col.name == self.collection_name for col in collections.collections)
            
            if not collection_exists:
                # Créer la nouvelle collection
                self.qdrant_client.create_collection(
                    collection_name=self.collection_name,
                    vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
                )
                logger.info(f"Collection {self.collection_name} créée")
            else:
                logger.info(f"Collection {self.collection_name} existe déjà")
        except Exception as e:
            logger.error(f"Erreur création/vérification collection: {e}")
            raise
    
    def process_demand_document(self, doc, doc_index):
        """Traite un document de demande avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos
        document = doc.get("document", "")
        objet = doc.get("objet", "")
        reponse = doc.get("reponse", "")
        
        if not reponse or not reponse.strip():
            logger.warning(f"Document {doc_index} sans réponse, ignoré")
            return None
        
        # Déterminer le type de document et enrichir
        doc_info = self._extract_enhanced_info(document, objet, reponse)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {doc_info['type']}")
        enriched_text_parts.append(f"Titre: {document}")
        enriched_text_parts.append(f"Objet de la demande: {objet}")
        
        # 2. Articles CGI liés (extraction depuis la réponse)
        articles_lies = self._extract_articles_from_response(reponse)
        if articles_lies:
            enriched_text_parts.append(f"Articles CGI liés: {', '.join(f'article {a}' for a in articles_lies)}")
        
        # 3. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(document, objet, reponse)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Enrichissement spécifique par sujet
        if "tva" in document.lower() or "tva" in objet.lower():
            enriched_text_parts.append("Sujet: TVA, taxe sur la valeur ajoutée")
            if "exonération" in reponse.lower():
                enriched_text_parts.append("Type: exonération TVA")
            if "location" in objet.lower():
                enriched_text_parts.append("Domaine: location de locaux professionnels")
        
        if "cfc" in document.lower() or "casablanca finance city" in reponse.lower():
            enriched_text_parts.append("Sujet: Casablanca Finance City, statut CFC")
            enriched_text_parts.append("Domaine: impôt sur le revenu, revenus salariaux")
        
        if "délais de paiement" in objet.lower():
            enriched_text_parts.append("Sujet: délais de paiement, loi 69-21")
            enriched_text_parts.append("Domaine: code de commerce, relations commerciales")
        
        # 5. Contenu principal
        enriched_text_parts.append(f"Demande complète: {objet}")
        enriched_text_parts.append(f"Réponse administrative complète: {reponse}")
        
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
        search_keywords = self._generate_search_keywords(document, objet, reponse)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": doc_info["type"],
                "numero": doc_info["numero"],
                "date": doc_info["date"],
                "objet": objet,
                "contenu": reponse,  # La réponse comme contenu principal
                "articles_lies": articles_lies,
                
                # Spécifique aux demandes
                "document": document,
                "demande": objet,
                "reponse_administration": reponse,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "enriched_text": enriched_text,  # Garder pour debug
                
                # Flags spécifiques
                "has_tva": "tva" in document.lower() or "tva" in objet.lower() or "tva" in reponse.lower(),
                "has_exoneration": "exonération" in reponse.lower() or "exonéré" in reponse.lower(),
                "has_cfc": "cfc" in document.lower() or "casablanca finance city" in reponse.lower(),
                "has_location": "location" in objet.lower() or "location" in reponse.lower(),
                "has_delais_paiement": "délais de paiement" in objet.lower(),
                "has_lait_poudre": "lait en poudre" in objet.lower(),
                
                # Métadonnées
                "doc_index": doc_index,
                "source": "demandes_eclaircissement",
                "type_original": "demande_eclaircissement",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_enhanced_info(self, document, objet, reponse):
        """Extraction améliorée des informations du document"""
        doc_info = {
            "type": "demande_eclaircissement",
            "numero": "",
            "date": ""
        }
        
        # Extraire la date depuis la réponse
        date_patterns = [
            r'(\d{1,2}\s+(?:janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+\d{4})',
            r'(\d{1,2}/\d{1,2}/\d{4})',
            r'(\d{4})'
        ]
        
        for pattern in date_patterns:
            match = re.search(pattern, reponse, re.IGNORECASE)
            if match:
                doc_info["date"] = match.group(1)
                break
        
        # Extraire un numéro de référence si présent
        numero_match = re.search(r'n°\s*(\d+)', document + " " + objet)
        if numero_match:
            doc_info["numero"] = numero_match.group(1)
        
        return doc_info
    
    def _extract_articles_from_response(self, reponse):
        """Extrait les articles CGI mentionnés dans la réponse"""
        articles = []
        
        # Patterns pour détecter les articles
        patterns = [
            r'article\s+(\d+(?:-[IVX]+)?)',
            r'art\.?\s*(\d+(?:-[IVX]+)?)',
            r'(\d+(?:-[IVX]+)?)\s*du\s+(?:CGI|Code\s+Général\s+des\s+Impôts)'
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, reponse, re.IGNORECASE)
            articles.extend(matches)
        
        return list(set(articles))[:5]  # Max 5 articles uniques
    
    def _extract_key_concepts(self, document, objet, reponse):
        """Extrait les concepts clés du document complet"""
        concepts = []
        full_text = f"{document} {objet} {reponse}".lower()
        
        # Patterns de concepts importants
        concept_patterns = {
            "exonération TVA": r"exonération.*tva",
            "location professionnelle": r"location.*professionnel",
            "statut CFC": r"statut.*cfc|casablanca\s+finance\s+city",
            "délais de paiement": r"délais?\s+de\s+paiement",
            "lait en poudre": r"lait\s+en\s+poudre",
            "taux libératoire": r"taux\s+libératoire",
            "période de 5 ans": r"période.*5\s+ans",
            "droit à déduction": r"droit\s+à\s+déduction",
            "code de commerce": r"code\s+de\s+commerce",
            "loi 69-21": r"loi\s+n?°?\s*69-21"
        }
        
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
    
    def _generate_search_keywords(self, document, objet, reponse):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Mots du titre du document
        doc_words = [w for w in document.lower().split() if len(w) > 3]
        keywords.extend(doc_words[:5])
        
        # Mots de l'objet
        objet_words = [w for w in objet.lower().split() if len(w) > 3]
        keywords.extend(objet_words[:5])
        
        # Type de document
        keywords.append("demande_eclaircissement")
        
        # Termes fiscaux importants
        fiscal_terms = [
            "tva", "exonération", "location", "professionnel", "cfc",
            "délais", "paiement", "lait", "poudre", "statut",
            "impôt", "revenus", "salariaux", "code", "commerce"
        ]
        
        full_text = f"{document} {objet} {reponse}".lower()
        for term in fiscal_terms:
            if term in full_text:
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_documents(self, documents):
        """Traite tous les documents de demandes"""
        logger.info(f"Traitement de {len(documents)} documents de demandes...")
        
        # Vérifier/créer la collection
        self.create_collection_if_not_exists()
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des demandes")):
            point = self.process_demand_document(doc, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Ajout de {len(self.points)} documents à la collection existante...")
            
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
    """Script principal pour indexer les demandes d'éclaircissement"""
    logger.info("🚀 Démarrage de l'indexation des demandes d'éclaircissement")
    
    # Charger les données
    with open("annexes/CGI/JSON/d.json", "r", encoding="utf-8") as f:
        demand_data = json.load(f)
    
    logger.info(f"✅ {len(demand_data)} documents chargés")
    
    # Créer le processeur
    processor = DemandProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_documents(demand_data)
    
    logger.info(f"✅ Indexation terminée: {count} documents traités")
    
    # Sauvegarder les stats
    stats = {
        "total_documents": len(demand_data),
        "indexed_documents": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat(),
        "source_file": "annexes/CGI/JSON/d.json"
    }
    
    with open("d_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans d_indexing_stats.json")

if __name__ == "__main__":
    main()