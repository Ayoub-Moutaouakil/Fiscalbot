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

class ArreteProcessor:
    """Processeur optimisé pour l'embedding des arrêtés avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"
        self.points = []
        
    def create_collection_if_not_exists(self):
        """Crée la collection seulement si elle n'existe pas déjà"""
        try:
            # Vérifier si la collection existe
            try:
                collection_info = self.qdrant_client.get_collection(self.collection_name)
                logger.info(f"Collection {self.collection_name} existe déjà avec {collection_info.points_count} points")
                return
            except:
                # La collection n'existe pas, on la crée
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
    
    def process_arrete_article(self, article_data, doc_index):
        """Traite un article d'arrêté avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos
        document = article_data.get("document", "")
        article = article_data.get("article", "")
        contenu = article_data.get("contenu", "")
        type_doc = article_data.get("type", "arrete")
        
        if not contenu or not contenu.strip():
            logger.warning(f"Article {doc_index} vide, ignoré")
            return None
        
        # Extraire les informations détaillées du document
        doc_info = self._extract_document_info(document)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {type_doc}")
        enriched_text_parts.append(f"Numéro d'arrêté: {doc_info['numero']}")
        enriched_text_parts.append(f"Date: {doc_info['date']}")
        enriched_text_parts.append(f"Ministère: {doc_info['ministere']}")
        enriched_text_parts.append(f"Objet: {doc_info['objet']}")
        enriched_text_parts.append(f"Article: {article}")
        
        # 2. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(contenu, doc_info['objet'])
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 3. Enrichissement spécifique par thème
        theme_enrichment = self._get_theme_enrichment(contenu, doc_info['objet'])
        if theme_enrichment:
            enriched_text_parts.extend(theme_enrichment)
        
        # 4. Références légales
        legal_refs = self._extract_legal_references(contenu)
        if legal_refs:
            enriched_text_parts.append(f"Références légales: {', '.join(legal_refs)}")
        
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
            logger.error(f"Erreur embedding article {doc_index}: {e}")
            return None
        
        # Extraire des métadonnées supplémentaires pour la recherche
        search_keywords = self._generate_search_keywords(document, contenu, doc_info)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": type_doc,
                "document": document,
                "article": article,
                "contenu": contenu,
                
                # Métadonnées extraites
                "numero_arrete": doc_info["numero"],
                "date_arrete": doc_info["date"],
                "ministere": doc_info["ministere"],
                "objet": doc_info["objet"],
                "theme": doc_info["theme"],
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "legal_references": legal_refs,
                "enriched_text": enriched_text,  # Garder pour debug
                
                # Flags spécifiques
                "has_plan_epargne": "plan d'épargne" in contenu.lower(),
                "has_education": "éducation" in contenu.lower() or "études" in contenu.lower(),
                "has_actions": "actions" in contenu.lower() and "plan" in contenu.lower(),
                "has_normalisation": "normalisation" in contenu.lower() or "certification" in contenu.lower(),
                "has_montant": bool(re.search(r'\d+.*dirhams?', contenu.lower())),
                "has_pourcentage": bool(re.search(r'\d+\s*%', contenu)),
                
                # Métadonnées techniques
                "doc_index": doc_index,
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_document_info(self, document):
        """Extraction des informations du document"""
        doc_info = {
            "numero": "",
            "date": "",
            "ministere": "",
            "objet": "",
            "theme": ""
        }
        
        # Extraire le numéro
        numero_match = re.search(r'n°\s*([\d-]+)', document)
        if numero_match:
            doc_info["numero"] = numero_match.group(1)
        
        # Extraire la date
        date_match = re.search(r'(\d{1,2}\s+\w+\s+\d{4})', document)
        if date_match:
            doc_info["date"] = date_match.group(1)
        
        # Extraire le ministère
        if "ministre de l'économie et des finances" in document.lower():
            doc_info["ministere"] = "Économie et Finances"
        elif "ministre de l'industrie" in document.lower():
            doc_info["ministere"] = "Industrie, Commerce et Nouvelles Technologies"
        
        # Extraire l'objet
        objet_match = re.search(r'relatif\s+(?:au|à\s+la|à\s+l\'|aux)\s+(.+?)(?:\.|$)', document, re.IGNORECASE)
        if objet_match:
            doc_info["objet"] = objet_match.group(1).strip()
        
        # Déterminer le thème
        objet_lower = doc_info["objet"].lower()
        if "épargne" in objet_lower:
            if "éducation" in objet_lower:
                doc_info["theme"] = "Plan d'épargne éducation"
            elif "actions" in objet_lower:
                doc_info["theme"] = "Plan d'épargne en actions"
            else:
                doc_info["theme"] = "Épargne"
        elif "normalisation" in objet_lower or "certification" in objet_lower:
            doc_info["theme"] = "Normalisation et certification"
        else:
            doc_info["theme"] = "Réglementation générale"
        
        return doc_info
    
    def _extract_key_concepts(self, contenu, objet):
        """Extrait les concepts clés du contenu"""
        concepts = []
        contenu_lower = contenu.lower()
        objet_lower = objet.lower()
        
        # Concepts liés aux plans d'épargne
        if "épargne" in objet_lower:
            concept_patterns = {
                "versements périodiques": r"versements?\s+périodiques?",
                "dépôt initial": r"dépôt\s+initial",
                "période conservation": r"période.*conserv",
                "exonération fiscale": r"exonération",
                "retrait anticipé": r"retrait.*avant",
                "clôture plan": r"clôture.*plan",
            }
        else:
            concept_patterns = {
                "désignation membres": r"désign.*membres?",
                "conseil supérieur": r"conseil\s+supérieur",
                "durée mandat": r"durée.*\d+\s+ans?",
                "représentants": r"représentants?",
            }
        
        for concept, pattern in concept_patterns.items():
            if re.search(pattern, contenu_lower):
                concepts.append(concept)
        
        # Extraire les montants
        amounts = re.findall(r'\d+(?:[\s.]\d+)*\s*(?:dirhams?|dh)', contenu_lower)
        concepts.extend([f"montant: {amt}" for amt in amounts[:3]])
        
        # Extraire les pourcentages
        percentages = re.findall(r'\d+\s*%', contenu)
        concepts.extend([f"taux: {pct}" for pct in percentages[:2]])
        
        # Extraire les durées
        durations = re.findall(r'\d+\s+(?:ans?|années?|mois)', contenu_lower)
        concepts.extend([f"durée: {dur}" for dur in durations[:2]])
        
        return list(set(concepts))[:15]
    
    def _get_theme_enrichment(self, contenu, objet):
        """Enrichissement spécifique par thème"""
        enrichment = []
        contenu_lower = contenu.lower()
        objet_lower = objet.lower()
        
        if "épargne éducation" in objet_lower:
            enrichment.extend([
                "Secteur: épargne, éducation, financement études",
                "Bénéficiaires: enfants à charge, étudiants",
                "Établissements: banques, assurances"
            ])
        elif "épargne en actions" in objet_lower:
            enrichment.extend([
                "Secteur: épargne, investissement, bourse",
                "Instruments: actions, certificats d'investissement, OPCVM",
                "Marché: bourse des valeurs du Maroc"
            ])
        elif "normalisation" in objet_lower:
            enrichment.extend([
                "Secteur: normalisation, certification, accréditation",
                "Organisme: CSNCA",
                "Gouvernance: conseil supérieur"
            ])
        
        return enrichment
    
    def _extract_legal_references(self, contenu):
        """Extrait les références légales"""
        references = []
        
        # Articles du CGI
        cgi_refs = re.findall(r'article\s+(\d+(?:-\d+)?)', contenu, re.IGNORECASE)
        references.extend([f"CGI art. {ref}" for ref in cgi_refs])
        
        # Lois
        law_refs = re.findall(r'loi\s+n°\s*([\d-]+)', contenu, re.IGNORECASE)
        references.extend([f"Loi {ref}" for ref in law_refs])
        
        # Décrets
        decree_refs = re.findall(r'décret\s+n°\s*([\d-]+)', contenu, re.IGNORECASE)
        references.extend([f"Décret {ref}" for ref in decree_refs])
        
        return list(set(references))[:10]
    
    def _generate_search_keywords(self, document, contenu, doc_info):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Mots du titre/objet
        objet_words = [w for w in doc_info['objet'].lower().split() if len(w) > 3]
        keywords.extend(objet_words[:5])
        
        # Type et thème
        keywords.extend(["arrêté", doc_info['theme'].lower()])
        
        # Ministère
        if doc_info['ministere']:
            keywords.append(doc_info['ministere'].lower())
        
        # Termes spécialisés
        specialized_terms = [
            "épargne", "éducation", "actions", "plan", "versement", "retrait",
            "exonération", "normalisation", "certification", "conseil", "membres",
            "banque", "assurance", "bourse", "valeurs", "dirhams"
        ]
        
        for term in specialized_terms:
            if term in contenu.lower():
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_articles(self, articles):
        """Traite tous les articles d'arrêtés"""
        logger.info(f"Traitement de {len(articles)} articles d'arrêtés...")
        
        # Créer la collection seulement si elle n'existe pas
        self.create_collection_if_not_exists()
        
        # Traiter chaque article
        for i, article in enumerate(tqdm(articles, desc="Traitement des arrêtés")):
            point = self.process_arrete_article(article, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Ajout de {len(self.points)} nouveaux articles...")
            
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
            
            # Vérifier le total final
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} articles au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les arrêtés"""
    logger.info("🚀 Démarrage de l'indexation des arrêtés")
    
    # Charger les données
    with open("/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/arrete.json", "r", encoding="utf-8") as f:
        arrete_data = json.load(f)
    
    logger.info(f"✅ {len(arrete_data)} articles chargés")
    
    # Créer le processeur
    processor = ArreteProcessor()
    
    # Traiter tous les articles
    count = processor.process_all_articles(arrete_data)
    
    logger.info(f"✅ Indexation terminée: {count} nouveaux articles ajoutés")
    
    # Sauvegarder les stats
    stats = {
        "total_articles": len(arrete_data),
        "new_indexed_articles": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("arrete_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans arrete_indexing_stats.json")

if __name__ == "__main__":
    main()