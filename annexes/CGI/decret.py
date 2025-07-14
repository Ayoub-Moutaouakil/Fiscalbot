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

class DecretProcessor:
    """Processeur pour l'embedding des décrets avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"  # Même collection que annnexevoyagev2
        self.points = []
        
    def process_decret_document(self, doc, doc_index):
        """Traite un document décret avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos spécifiques aux décrets
        document = doc.get("document", "")
        article = doc.get("article", "")
        contenu = doc.get("contenu", "")
        
        if not contenu or not contenu.strip():
            logger.warning(f"Document {doc_index} vide, ignoré")
            return None
        
        # Extraire les informations enrichies du décret
        doc_info = self._extract_enhanced_info(document, article, contenu)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE AUX DÉCRETS
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {doc_info['type']}")
        enriched_text_parts.append(f"Numéro: {doc_info['numero']}")
        enriched_text_parts.append(f"Date: {doc_info['date']}")
        enriched_text_parts.append(f"Article: {article}")
        enriched_text_parts.append(f"Objet: {doc_info['objet']}")
        
        # 2. Articles CGI liés (extraction automatique)
        articles_cgi = self._extract_articles_cgi(contenu)
        if articles_cgi:
            enriched_text_parts.append(f"Articles CGI liés: {', '.join(f'article {a}' for a in articles_cgi)}")
        
        # 3. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(contenu)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Enrichissement spécifique par sujet
        sujets = self._extract_sujets(document, contenu)
        if sujets:
            enriched_text_parts.append(f"Sujets: {', '.join(sujets)}")
        
        # 5. Enrichissement contextuel pour les décrets spécifiques
        if "fusion" in document.lower() and "stock" in document.lower():
            enriched_text_parts.append("Contexte: fusion-absorption, évaluation des stocks, société absorbée, société absorbante")
            enriched_text_parts.append("Procédure: modalités d'évaluation, prix de revient initial, valeur d'origine")
            
        if "bénéfice forfaitaire" in document.lower():
            enriched_text_parts.append("Contexte: régime fiscal, bénéfice forfaitaire, professions exclues")
            enriched_text_parts.append("Professions: libérales, commerciales, artisanales, exclusions du forfait")
        
        # 6. Contenu principal
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
        search_keywords = self._generate_search_keywords(document, contenu, doc_info['type'])
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base spécifiques aux décrets
                "type": doc_info["type"],
                "numero": doc_info["numero"],
                "date": doc_info["date"],
                "document": document,
                "article": article,
                "contenu": contenu,
                "objet": doc_info["objet"],
                
                # Articles CGI liés
                "articles_lies": articles_cgi,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "sujets": sujets,
                "enriched_text": enriched_text,
                
                # Flags spécifiques aux décrets
                "has_fusion": "fusion" in document.lower() or "fusion" in contenu.lower(),
                "has_stock": "stock" in document.lower() or "stock" in contenu.lower(),
                "has_benefice_forfaitaire": "bénéfice forfaitaire" in document.lower() or "forfaitaire" in contenu.lower(),
                "has_professions_exclues": "professions" in document.lower() and "exclues" in document.lower(),
                "has_evaluation": "évaluation" in contenu.lower(),
                "has_modalites": "modalités" in contenu.lower(),
                
                # Métadonnées techniques
                "doc_index": doc_index,
                "source_file": "annexes/CGI/JSON/decret.json",
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_enhanced_info(self, document, article, contenu):
        """Extraction améliorée des informations du décret"""
        doc_info = {
            "type": "decret",
            "numero": "",
            "date": "",
            "objet": ""
        }
        
        # Extraire le numéro du décret
        numero_match = re.search(r'n°\s*(\d+-\d+-\d+)', document)
        if numero_match:
            doc_info["numero"] = numero_match.group(1)
        
        # Extraire la date
        date_match = re.search(r'\((\d+\s+\w+\s+\d+)\)', document)
        if date_match:
            doc_info["date"] = date_match.group(1)
        
        # Extraire l'objet (après "relatif")
        objet_match = re.search(r'relatif\s+(.+?)(?:\.|$)', document, re.IGNORECASE)
        if objet_match:
            doc_info["objet"] = objet_match.group(1).strip()
        
        return doc_info
    
    def _extract_articles_cgi(self, contenu):
        """Extrait les références aux articles du CGI"""
        articles = []
        
        # Patterns pour détecter les articles CGI
        patterns = [
            r'article\s+(\d+(?:-[IVX]+)?)',
            r'l\'article\s+(\d+(?:-[IVX]+)?)',
            r'articles?\s+(\d+(?:-[IVX]+)?(?:\s+et\s+\d+(?:-[IVX]+)?)*)',
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, contenu, re.IGNORECASE)
            for match in matches:
                if 'et' in match:
                    # Gérer les cas "article 20 et 162"
                    nums = re.findall(r'\d+(?:-[IVX]+)?', match)
                    articles.extend(nums)
                else:
                    articles.append(match)
        
        return list(set(articles))[:10]  # Maximum 10 articles
    
    def _extract_key_concepts(self, contenu):
        """Extrait les concepts clés du contenu"""
        concepts = []
        contenu_lower = contenu.lower()
        
        # Concepts spécifiques aux décrets
        concept_patterns = {
            "fusion-absorption": r"fusion|absorption|société\s+absorbée|société\s+absorbante",
            "évaluation stocks": r"évaluation.*stock|modalités.*évaluation",
            "prix de revient": r"prix\s+de\s+revient|valeur\s+d'origine",
            "bénéfice forfaitaire": r"bénéfice\s+forfaitaire|régime\s+forfaitaire",
            "professions exclues": r"professions.*exclues|activités.*exclues",
            "état détaillé": r"état\s+détaillé|état\s+de\s+suivi",
            "convention fusion": r"convention\s+de\s+fusion",
            "déclaration résultat": r"déclaration.*résultat\s+fiscal",
            "prix du marché": r"prix\s+du\s+marché",
            "note explicative": r"note\s+explicative"
        }
        
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, contenu_lower):
                concepts.append(concept)
        
        # Extraire les professions mentionnées
        professions = [
            "architectes", "avocats", "médecins", "pharmaciens", "notaires",
            "experts-comptables", "ingénieurs", "vétérinaires", "dentistes",
            "hôteliers", "promoteurs immobiliers", "agents d'affaires"
        ]
        
        for profession in professions:
            if profession in contenu_lower:
                concepts.append(profession)
        
        return list(set(concepts))[:15]
    
    def _extract_sujets(self, document, contenu):
        """Extrait les sujets principaux du décret"""
        sujets = []
        
        # Sujets basés sur le titre du document
        if "fusion" in document.lower():
            sujets.extend(["fusion-absorption", "restructuration", "évaluation patrimoniale"])
        
        if "forfaitaire" in document.lower():
            sujets.extend(["régime fiscal", "professions libérales", "exclusions fiscales"])
        
        # Sujets basés sur le contenu
        if "stock" in contenu.lower():
            sujets.append("gestion des stocks")
        
        if "convention" in contenu.lower():
            sujets.append("procédures administratives")
        
        return list(set(sujets))
    
    def _generate_search_keywords(self, document, contenu, doc_type):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Mots du titre du document
        doc_words = [w for w in document.lower().split() if len(w) > 3]
        keywords.extend(doc_words[:10])
        
        # Type de document
        keywords.append(doc_type)
        keywords.append("décret")
        
        # Termes fiscaux et juridiques importants
        fiscal_terms = [
            "fusion", "absorption", "stock", "évaluation", "forfaitaire",
            "professions", "exclues", "modalités", "convention", "société",
            "prix", "revient", "marché", "état", "détaillé", "suivi",
            "déclaration", "résultat", "fiscal", "bulletin", "officiel"
        ]
        
        for term in fiscal_terms:
            if term in contenu.lower() or term in document.lower():
                keywords.append(term)
        
        return list(set(keywords))[:25]
    
    def process_all_documents(self, documents):
        """Traite tous les documents décrets"""
        logger.info(f"Traitement de {len(documents)} documents décrets...")
        
        # Vérifier que la collection existe (ne pas la supprimer)
        try:
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"Collection {self.collection_name} trouvée avec {collection_info.points_count} documents existants")
        except Exception as e:
            logger.error(f"Erreur: Collection {self.collection_name} non trouvée: {e}")
            logger.info("Création de la collection...")
            self.qdrant_client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
        
        # Traiter chaque document
        for i, doc in enumerate(tqdm(documents, desc="Traitement des décrets")):
            point = self.process_decret_document(doc, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Ajout de {len(self.points)} nouveaux documents à la collection...")
            
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
            
            # Vérifier le résultat final
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} documents au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les décrets"""
    logger.info("🚀 Démarrage de l'indexation des décrets")
    
    # Charger les données
    with open("annexes/CGI/JSON/decret.json", "r", encoding="utf-8") as f:
        decret_data = json.load(f)
    
    logger.info(f"✅ {len(decret_data)} documents décrets chargés")
    
    # Créer le processeur
    processor = DecretProcessor()
    
    # Traiter tous les documents
    count = processor.process_all_documents(decret_data)
    
    logger.info(f"✅ Indexation terminée: {count} nouveaux documents décrets ajoutés")
    
    # Sauvegarder les stats
    stats = {
        "total_documents": len(decret_data),
        "indexed_documents": count,
        "collection_name": processor.collection_name,
        "source_file": "annexes/CGI/JSON/decret.json",
        "timestamp": datetime.now().isoformat()
    }
    
    with open("decret_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans decret_indexing_stats.json")

if __name__ == "__main__":
    main()