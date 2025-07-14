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

class FAQProcessor:
    """Processeur pour l'embedding des FAQ avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"  # Même collection que annexevoyagev2
        self.points = []
        
    def process_faq_entry(self, entry, entry_index):
        """Traite une entrée FAQ avec enrichissement contextuel"""
        entry_id = str(uuid.uuid4())
        
        # Extraire les infos
        document = entry.get("document", "")
        question = entry.get("question", "")
        reponse = entry.get("reponse", "")
        
        if not question or not reponse or not question.strip() or not reponse.strip():
            logger.warning(f"Entrée FAQ {entry_index} incomplète, ignorée")
            return None
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE POUR FAQ
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: FAQ")
        enriched_text_parts.append(f"Document source: {document}")
        enriched_text_parts.append(f"Question: {question}")
        
        # 2. Extraction des concepts clés de la question et réponse
        key_concepts = self._extract_faq_concepts(question, reponse)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 3. Détection des articles CGI mentionnés
        articles_cgi = self._extract_articles_cgi(reponse)
        if articles_cgi:
            enriched_text_parts.append(f"Articles CGI mentionnés: {', '.join(articles_cgi)}")
        
        # 4. Enrichissement spécifique APP (Accord Préalable Prix de Transfert)
        if "APP" in document or "prix de transfert" in document.lower():
            enriched_text_parts.append("Sujet: Accord Préalable en matière de Prix de Transfert")
            enriched_text_parts.append("Domaine: prix de transfert, transactions transfrontalières, entreprises associées")
            
            # Concepts spécifiques APP
            if "bilatéral" in reponse.lower() or "multilatéral" in reponse.lower():
                enriched_text_parts.append("Type APP: accord bilatéral ou multilatéral")
            if "garantie" in reponse.lower():
                enriched_text_parts.append("Aspect: garanties et sécurité juridique")
            if "révision" in reponse.lower() or "annulation" in reponse.lower():
                enriched_text_parts.append("Aspect: révision et annulation d'accord")
            if "contrôle" in reponse.lower():
                enriched_text_parts.append("Aspect: contrôle fiscal et procédures")
        
        # 5. Contenu principal
        enriched_text_parts.append(f"Réponse complète: {reponse}")
        
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
            logger.error(f"Erreur embedding entrée FAQ {entry_index}: {e}")
            return None
        
        # Extraire des métadonnées supplémentaires pour la recherche
        search_keywords = self._generate_faq_keywords(document, question, reponse)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=entry_id,
            vector=embedding,
            payload={
                # Infos de base FAQ
                "type": "faq",
                "document_source": document,
                "question": question,
                "reponse": reponse,
                "contenu": f"Q: {question}\n\nR: {reponse}",  # Format unifié
                
                # Articles CGI détectés
                "articles_lies": articles_cgi,
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "enriched_text": enriched_text,
                
                # Flags spécifiques FAQ APP
                "has_app": "APP" in document or "prix de transfert" in document.lower(),
                "has_bilateral": "bilatéral" in reponse.lower() or "multilatéral" in reponse.lower(),
                "has_garantie": "garantie" in reponse.lower(),
                "has_controle": "contrôle" in reponse.lower(),
                "has_revision": "révision" in reponse.lower() or "annulation" in reponse.lower(),
                "has_expertise": "expert" in reponse.lower(),
                "has_confidentialite": "confidentialité" in reponse.lower(),
                
                # Métadonnées
                "entry_index": entry_index,
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_faq_concepts(self, question, reponse):
        """Extrait les concepts clés de la question et réponse FAQ"""
        concepts = []
        text_combined = f"{question} {reponse}".lower()
        
        # Patterns de concepts importants pour APP
        concept_patterns = {
            "accord préalable": r"accord\s+préalable",
            "prix de transfert": r"prix\s+de\s+transfert",
            "entreprises associées": r"entreprises?\s+associées?",
            "transactions transfrontalières": r"transactions?\s+transfrontalières?",
            "APP bilatéral": r"app\s+bilatéral",
            "APP multilatéral": r"app\s+multilatéral",
            "double imposition": r"double\s+(?:ou\s+multiple\s+)?imposition",
            "méthode détermination": r"méthode\s+de\s+détermination",
            "contrôle fiscal": r"contrôle\s+fiscal",
            "procédure rectification": r"procédure\s+de\s+rectification",
            "convention fiscale": r"convention\s+fiscale",
            "administration fiscale": r"administration\s+fiscale",
            "expertise externe": r"expert(?:ise)?\s+externe",
            "confidentialité": r"confidentialité",
            "4 ans maximum": r"(?:4\s+ans|quatre\s+ans)"
        }
        
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, text_combined):
                concepts.append(concept)
        
        # Extraire les durées
        durations = re.findall(r'\d+\s+(?:ans?|années?|mois)', text_combined)
        concepts.extend(durations[:2])
        
        return list(set(concepts))[:15]
    
    def _extract_articles_cgi(self, text):
        """Extrait les références aux articles du CGI"""
        articles = []
        
        # Patterns pour articles CGI
        patterns = [
            r'article\s+(\d+(?:\s+bis|\s+ter)?)',
            r'articles?\s+(\d+(?:\s+bis|\s+ter)?)(?:\s+(?:ou|et)\s+(\d+(?:\s+bis|\s+ter)?))?',
            r'(\d+(?:\s+bis|\s+ter)?)\s+du\s+(?:code\s+général\s+des\s+impôts|cgi)'
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, text.lower())
            for match in matches:
                if isinstance(match, tuple):
                    articles.extend([m for m in match if m])
                else:
                    articles.append(match)
        
        # Nettoyer et formater
        cleaned_articles = []
        for article in articles:
            article = article.strip()
            if article and article not in cleaned_articles:
                cleaned_articles.append(f"article {article}")
        
        return cleaned_articles[:5]
    
    def _generate_faq_keywords(self, document, question, reponse):
        """Génère des mots-clés optimisés pour la recherche FAQ"""
        keywords = []
        
        # Mots de la question (les plus importants)
        question_words = [w for w in question.lower().split() if len(w) > 3]
        keywords.extend(question_words[:8])
        
        # Type de document
        keywords.append("faq")
        keywords.append("app")
        
        # Termes fiscaux importants
        fiscal_terms = [
            "accord", "préalable", "prix", "transfert", "app", "bilatéral", 
            "multilatéral", "garantie", "contrôle", "fiscal", "révision", 
            "annulation", "expertise", "confidentialité", "entreprise", 
            "associée", "transaction", "transfrontalière", "imposition",
            "méthode", "détermination", "convention", "administration"
        ]
        
        text_combined = f"{question} {reponse}".lower()
        for term in fiscal_terms:
            if term in text_combined:
                keywords.append(term)
        
        return list(set(keywords))[:25]
    
    def process_all_faq_entries(self, faq_data):
        """Traite toutes les entrées FAQ"""
        logger.info(f"Traitement de {len(faq_data)} entrées FAQ...")
        
        # Vérifier que la collection existe
        try:
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"Collection {self.collection_name} trouvée avec {collection_info.points_count} documents existants")
        except Exception as e:
            logger.error(f"Collection {self.collection_name} non trouvée: {e}")
            raise
        
        # Traiter chaque entrée FAQ
        for i, entry in enumerate(tqdm(faq_data, desc="Traitement des FAQ")):
            point = self.process_faq_entry(entry, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points (AJOUT à la collection existante)
        if self.points:
            logger.info(f"Ajout de {len(self.points)} entrées FAQ à la collection existante...")
            
            # Indexer par batch
            batch_size = 20
            for i in range(0, len(self.points), batch_size):
                batch = self.points[i:i+batch_size]
                try:
                    self.qdrant_client.upsert(
                        collection_name=self.collection_name,
                        points=batch
                    )
                    logger.info(f"Batch FAQ {i//batch_size + 1} indexé")
                except Exception as e:
                    logger.error(f"Erreur indexation batch FAQ: {e}")
            
            # Vérifier le résultat final
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} documents au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les FAQ"""
    logger.info("🚀 Démarrage de l'indexation des FAQ")
    
    # Charger les données FAQ
    faq_file = "/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/faq.json"
    with open(faq_file, "r", encoding="utf-8") as f:
        faq_data = json.load(f)
    
    logger.info(f"✅ {len(faq_data)} entrées FAQ chargées")
    
    # Créer le processeur
    processor = FAQProcessor()
    
    # Traiter toutes les entrées FAQ
    count = processor.process_all_faq_entries(faq_data)
    
    logger.info(f"✅ Indexation FAQ terminée: {count} entrées traitées")
    
    # Sauvegarder les stats
    stats = {
        "total_faq_entries": len(faq_data),
        "indexed_faq_entries": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("faq_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats FAQ sauvegardées dans faq_indexing_stats.json")

if __name__ == "__main__":
    main()