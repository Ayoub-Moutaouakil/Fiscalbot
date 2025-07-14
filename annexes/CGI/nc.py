import json
import qdrant_client
from qdrant_client.models import PointStruct
import voyageai
import uuid
import re
import logging
from datetime import datetime
from tqdm import tqdm

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

class NCProcessor:
    """Processeur pour l'embedding des notes circulaires avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"
        self.points = []
        
    def process_nc_document(self, doc, doc_index):
        """Traite un document de note circulaire avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos de base
        document_title = doc.get("document", "")
        introduction = doc.get("introduction", "")
        chapitre = doc.get("chapitre", "")
        nom_chapitre = doc.get("nom_chapitre", "")
        partie = doc.get("partie", "")
        nom_partie = doc.get("nom_partie", "")
        sous_partie = doc.get("sous_partie", "")
        nom_sous_partie = doc.get("nom_sous_partie", "")
        contenu = doc.get("contenu", "")
        
        # Construire le contenu principal
        content_parts = []
        if introduction:
            content_parts.append(f"Introduction: {introduction}")
        if nom_chapitre:
            content_parts.append(f"Chapitre {chapitre}: {nom_chapitre}")
        if nom_partie:
            content_parts.append(f"Partie {partie}: {nom_partie}")
        if nom_sous_partie:
            content_parts.append(f"Sous-partie {sous_partie}: {nom_sous_partie}")
        if contenu:
            content_parts.append(f"Contenu: {contenu}")
        
        main_content = "\n\n".join(content_parts)
        
        if not main_content.strip():
            logger.warning(f"Document {doc_index} vide, ignoré")
            return None
        
        # Déterminer le type de document
        doc_info = self._extract_nc_info(document_title, main_content)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {doc_info['type']}")
        enriched_text_parts.append(f"Titre: {document_title}")
        if chapitre:
            enriched_text_parts.append(f"Structure: Chapitre {chapitre}")
        if partie:
            enriched_text_parts.append(f"Section: Partie {partie}")
        if sous_partie:
            enriched_text_parts.append(f"Sous-section: {sous_partie}")
        
        # 2. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts_nc(main_content)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 3. Enrichissement spécifique par type de document
        if "retenue à la source" in document_title.lower():
            enriched_text_parts.append("Sujet: retenue à la source, rémunérations tiers, État collectivités territoriales")
            enriched_text_parts.append("Domaine: IS impôt sociétés, IR impôt revenu, honoraires commissions courtages")
            if "5%" in main_content or "10%" in main_content:
                enriched_text_parts.append("Taux: retenue 5% personnes morales, 10% personnes physiques")
        
        if "établissements de crédit" in document_title.lower():
            enriched_text_parts.append("Secteur: banques, établissements crédit, sociétés financement")
            enriched_text_parts.append("Domaine: provisions créances douteuses, arrangements amiable, agios réservés")
            enriched_text_parts.append("Sujets: crédit-bail, TVA commission changes, prêts logement personnel")
        
        # 4. Contenu principal enrichi
        enriched_text_parts.append(f"Contenu complet: {main_content}")
        
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
        search_keywords = self._generate_search_keywords_nc(document_title, main_content)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": "note_circulaire",
                "document_type": doc_info["type"],
                "document_title": document_title,
                "introduction": introduction,
                "chapitre": chapitre,
                "nom_chapitre": nom_chapitre,
                "partie": partie,
                "nom_partie": nom_partie,
                "sous_partie": sous_partie,
                "nom_sous_partie": nom_sous_partie,
                "contenu": contenu,
                "main_content": main_content,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "enriched_text": enriched_text,
                
                # Flags spécifiques
                "has_retenue_source": "retenue à la source" in document_title.lower(),
                "has_etablissements_credit": "établissements de crédit" in document_title.lower(),
                "has_taux_5": "5%" in main_content,
                "has_taux_10": "10%" in main_content,
                "has_is": "impôt sur les sociétés" in main_content.lower() or " is " in main_content.lower(),
                "has_ir": "impôt sur le revenu" in main_content.lower() or " ir " in main_content.lower(),
                "has_tva": "tva" in main_content.lower() or "taxe sur la valeur ajoutée" in main_content.lower(),
                "has_provisions": "provision" in main_content.lower(),
                "has_credit_bail": "crédit-bail" in main_content.lower(),
                "has_honoraires": "honoraires" in main_content.lower(),
                "has_commissions": "commission" in main_content.lower(),
                
                # Métadonnées
                "doc_index": doc_index,
                "source": "nc.json",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_nc_info(self, document_title, content):
        """Extraction des informations spécifiques aux notes circulaires"""
        doc_info = {
            "type": "note_circulaire"
        }
        
        title_lower = document_title.lower()
        if "circulaire conjointe" in title_lower:
            doc_info["type"] = "circulaire_conjointe"
        elif "note circulaire" in title_lower:
            doc_info["type"] = "note_circulaire"
        
        return doc_info
    
    def _extract_key_concepts_nc(self, content):
        """Extrait les concepts clés spécifiques aux notes circulaires"""
        concepts = []
        content_lower = content.lower()
        
        # Patterns de concepts importants pour les NC
        concept_patterns = {
            "retenue à la source": r"retenue\s+à\s+la\s+source",
            "rémunérations tiers": r"rémunérations?\s+.*tiers",
            "impôt sociétés": r"impôt\s+sur\s+les\s+sociétés",
            "impôt revenu": r"impôt\s+sur\s+le\s+revenu",
            "honoraires": r"honoraires?",
            "commissions": r"commissions?",
            "courtages": r"courtages?",
            "établissements crédit": r"établissements?\s+de\s+crédit",
            "provisions créances": r"provisions?\s+.*créances?",
            "crédit-bail": r"crédit-bail",
            "TVA": r"\btva\b|taxe\s+sur\s+la\s+valeur\s+ajoutée",
            "personnes morales": r"personnes?\s+morales?",
            "personnes physiques": r"personnes?\s+physiques?",
            "régime RNR": r"régime\s+.*rnr|résultat\s+net\s+réel",
            "régime RNS": r"régime\s+.*rns|résultat\s+net\s+simplifié",
        }
        
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, content_lower):
                concepts.append(concept)
        
        # Extraire les taux
        taux = re.findall(r'\d+\s*%', content_lower)
        concepts.extend([f"taux {t}" for t in taux[:3]])
        
        # Extraire les montants
        amounts = re.findall(r'\d+(?:\s*\d+)*\s*(?:dirhams?|dh|mad)', content_lower)
        concepts.extend(amounts[:2])
        
        # Extraire les articles CGI
        articles = re.findall(r'article\s+\d+(?:[\s-]\w+)*', content_lower)
        concepts.extend(articles[:3])
        
        return list(set(concepts))[:20]
    
    def _generate_search_keywords_nc(self, document_title, content):
        """Génère des mots-clés optimisés pour la recherche des NC"""
        keywords = []
        
        # Mots du titre
        title_words = [w for w in document_title.lower().split() if len(w) > 3]
        keywords.extend(title_words[:8])
        
        # Type de document
        keywords.extend(["note", "circulaire", "conjointe"])
        
        # Termes fiscaux importants spécifiques aux NC
        fiscal_terms = [
            "retenue", "source", "rémunérations", "tiers", "honoraires", "commissions",
            "courtages", "établissements", "crédit", "banques", "provisions", "créances",
            "crédit-bail", "tva", "changes", "prêts", "logement", "personnel",
            "impôt", "sociétés", "revenu", "personnes", "morales", "physiques"
        ]
        
        for term in fiscal_terms:
            if term in content.lower():
                keywords.append(term)
        
        return list(set(keywords))[:25]
    
    def process_all_nc_documents(self, documents):
        """Traite tous les documents de notes circulaires"""
        logger.info(f"Traitement de {len(documents)} documents de notes circulaires...")
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des NC")):
            point = self.process_nc_document(doc, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points dans la collection existante
        if self.points:
            logger.info(f"Indexation de {len(self.points)} documents NC...")
            
            # Indexer par batch
            batch_size = 20
            for i in range(0, len(self.points), batch_size):
                batch = self.points[i:i+batch_size]
                try:
                    self.qdrant_client.upsert(
                        collection_name=self.collection_name,
                        points=batch
                    )
                    logger.info(f"Batch NC {i//batch_size + 1} indexé")
                except Exception as e:
                    logger.error(f"Erreur indexation batch NC: {e}")
            
            # Vérifier
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} documents au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les notes circulaires"""
    logger.info("🚀 Démarrage de l'indexation des notes circulaires")
    
    # Charger les données NC
    with open("annexes/CGI/JSON/nc.json", "r", encoding="utf-8") as f:
        nc_data = json.load(f)
    
    logger.info(f"✅ {len(nc_data)} documents NC chargés")
    
    # Créer le processeur
    processor = NCProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_nc_documents(nc_data)
    
    logger.info(f"✅ Indexation NC terminée: {count} documents traités")
    
    # Sauvegarder les stats
    stats = {
        "total_nc_documents": len(nc_data),
        "indexed_nc_documents": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("nc_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats NC sauvegardées dans nc_indexing_stats.json")

if __name__ == "__main__":
    main()