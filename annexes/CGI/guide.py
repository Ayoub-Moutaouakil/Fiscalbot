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

class GuideProcessor:
    """Processeur optimisé pour l'embedding des guides avec enrichissement contextuel"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client.QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
        self.collection_name = "cgi_annexe_optimized"
        self.points = []
        
    def ensure_collection_exists(self):
        """Vérifie que la collection existe, la crée si nécessaire"""
        try:
            # Vérifier si la collection existe
            collection_info = self.qdrant_client.get_collection(self.collection_name)
            logger.info(f"Collection {self.collection_name} existe déjà avec {collection_info.points_count} points")
        except:
            # La collection n'existe pas, on la crée
            self.qdrant_client.create_collection(
                collection_name=self.collection_name,
                vectors_config=VectorParams(size=EMBEDDING_DIM, distance=Distance.COSINE)
            )
            logger.info(f"Collection {self.collection_name} créée")
    
    def process_guide_entry(self, entry_data, doc_index):
        """Traite une entrée de guide avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos de base
        document = entry_data.get("document", "")
        objet = entry_data.get("objet", "")
        contenu = entry_data.get("contenu", "")
        
        # Extraire les infos structurées spécifiques aux guides
        chapitre = entry_data.get("chapitre", "")
        nom_chapitre = entry_data.get("nom_chapitre", "")
        partie = entry_data.get("partie", "")
        nom_partie = entry_data.get("nom_partie", "")
        sous_partie = entry_data.get("sous_partie", "")
        nom_sous_partie = entry_data.get("nom_sous_partie", "")
        introduction = entry_data.get("introduction", "")
        
        # Utiliser l'introduction si le contenu est vide
        main_content = contenu if contenu else introduction
        
        if not main_content or not main_content.strip():
            logger.warning(f"Entrée {doc_index} vide, ignorée")
            return None
        
        # Extraire les informations détaillées du document
        doc_info = self._extract_document_info(document)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE AUX GUIDES
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: guide fiscal")
        enriched_text_parts.append(f"Guide: {doc_info['titre']}")
        enriched_text_parts.append(f"Régime fiscal: {doc_info['regime']}")
        enriched_text_parts.append(f"Thème principal: {doc_info['theme']}")
        
        # 2. Structure hiérarchique
        if chapitre:
            enriched_text_parts.append(f"Chapitre: {chapitre} - {nom_chapitre}")
        if partie:
            enriched_text_parts.append(f"Partie: {partie} - {nom_partie}")
        if sous_partie:
            enriched_text_parts.append(f"Sous-partie: {sous_partie} - {nom_sous_partie}")
        if objet:
            enriched_text_parts.append(f"Objet: {objet}")
        
        # 3. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(main_content, doc_info['regime'])
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Enrichissement spécifique par régime
        regime_enrichment = self._get_regime_enrichment(main_content, doc_info['regime'])
        if regime_enrichment:
            enriched_text_parts.extend(regime_enrichment)
        
        # 5. Références légales
        legal_refs = self._extract_legal_references(main_content)
        if legal_refs:
            enriched_text_parts.append(f"Références légales: {', '.join(legal_refs)}")
        
        # 6. Contenu principal
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
            logger.error(f"Erreur embedding entrée {doc_index}: {e}")
            return None
        
        # Extraire des métadonnées supplémentaires pour la recherche
        search_keywords = self._generate_search_keywords(document, main_content, doc_info, objet)
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base
                "type": "guide",
                "document": document,
                "objet": objet,
                "contenu": main_content,
                
                # Structure hiérarchique
                "chapitre": chapitre,
                "nom_chapitre": nom_chapitre,
                "partie": partie,
                "nom_partie": nom_partie,
                "sous_partie": sous_partie,
                "nom_sous_partie": nom_sous_partie,
                "introduction": introduction,
                
                # Métadonnées extraites
                "titre_guide": doc_info["titre"],
                "regime_fiscal": doc_info["regime"],
                "theme": doc_info["theme"],
                "categorie": doc_info["categorie"],
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "legal_references": legal_refs,
                "enriched_text": enriched_text,  # Garder pour debug
                
                # Flags spécifiques aux guides
                "has_auto_entrepreneur": "auto-entrepreneur" in main_content.lower(),
                "has_cpu": "cpu" in main_content.lower() or "contribution professionnelle unique" in main_content.lower(),
                "has_montant": bool(re.search(r'\d+.*dirhams?', main_content.lower())),
                "has_pourcentage": bool(re.search(r'\d+\s*%', main_content)),
                "has_seuil": "seuil" in main_content.lower(),
                "has_exoneration": "exonération" in main_content.lower(),
                "has_declaration": "déclaration" in main_content.lower(),
                "has_barid_al_maghrib": "barid al-maghrib" in main_content.lower(),
                
                # Métadonnées techniques
                "doc_index": doc_index,
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_document_info(self, document):
        """Extraction des informations du document guide"""
        doc_info = {
            "titre": "",
            "regime": "",
            "theme": "",
            "categorie": ""
        }
        
        document_lower = document.lower()
        
        # Extraire le titre
        if "guide -" in document_lower:
            doc_info["titre"] = document.split("Guide - ")[1].strip()
        elif "guide pratique" in document_lower:
            doc_info["titre"] = document.strip()
        
        # Déterminer le régime fiscal
        if "auto-entrepreneur" in document_lower:
            doc_info["regime"] = "Auto-entrepreneur"
            doc_info["theme"] = "Régime fiscal simplifié"
            doc_info["categorie"] = "Micro-entreprise"
        elif "cpu" in document_lower or "contribution professionnelle unique" in document_lower:
            doc_info["regime"] = "CPU"
            doc_info["theme"] = "Contribution professionnelle unique"
            doc_info["categorie"] = "Régime forfaitaire"
        else:
            doc_info["regime"] = "Général"
            doc_info["theme"] = "Réglementation fiscale"
            doc_info["categorie"] = "Guide général"
        
        return doc_info
    
    def _extract_key_concepts(self, contenu, regime):
        """Extrait les concepts clés du contenu selon le régime"""
        concepts = []
        contenu_lower = contenu.lower()
        
        # Concepts communs
        common_concepts = {
            "chiffre d'affaires": r"chiffre\s+d[''']affaires?",
            "déclaration": r"déclaration",
            "impôt sur le revenu": r"impôt\s+sur\s+le\s+revenu",
            "exonération": r"exonération",
            "seuil": r"seuil",
            "taux": r"taux",
        }
        
        # Concepts spécifiques par régime
        if regime == "Auto-entrepreneur":
            specific_concepts = {
                "RNAE": r"rnae|registre\s+national",
                "Barid Al-Maghrib": r"barid\s+al[\-\s]maghrib",
                "ICE": r"ice|identifiant\s+commun",
                "versement trimestriel": r"trimestriel",
                "radiation": r"radiation",
            }
        elif regime == "CPU":
            specific_concepts = {
                "contribution professionnelle unique": r"contribution\s+professionnelle\s+unique",
                "bénéfice forfaitaire": r"bénéfice\s+forfaitaire",
                "coefficient": r"coefficient",
                "droit complémentaire": r"droit\s+complémentaire",
                "assurance maladie": r"assurance\s+maladie",
            }
        else:
            specific_concepts = {}
        
        # Combiner tous les concepts
        all_concepts = {**common_concepts, **specific_concepts}
        
        for concept, pattern in all_concepts.items():
            if re.search(pattern, contenu_lower):
                concepts.append(concept)
        
        # Extraire les montants
        amounts = re.findall(r'\d+(?:[\s.]\d+)*\s*(?:dirhams?|dh)', contenu_lower)
        concepts.extend([f"montant: {amt}" for amt in amounts[:3]])
        
        # Extraire les pourcentages
        percentages = re.findall(r'\d+\s*%', contenu)
        concepts.extend([f"taux: {pct}" for pct in percentages[:2]])
        
        return list(set(concepts))[:15]
    
    def _get_regime_enrichment(self, contenu, regime):
        """Enrichissement spécifique par régime fiscal"""
        enrichment = []
        contenu_lower = contenu.lower()
        
        if regime == "Auto-entrepreneur":
            enrichment.extend([
                "Secteur: micro-entreprise, auto-emploi, simplification fiscale",
                "Organisme: Barid Al-Maghrib, RNAE",
                "Avantages: dispense comptabilité, exonération TP"
            ])
        elif regime == "CPU":
            enrichment.extend([
                "Secteur: contribution unique, régime forfaitaire",
                "Composantes: IR + TP + TSC + couverture sociale",
                "Transition: remplacement bénéfice forfaitaire"
            ])
        
        return enrichment
    
    def _extract_legal_references(self, contenu):
        """Extrait les références légales"""
        references = []
        
        # Articles du CGI
        cgi_refs = re.findall(r'article\s+(\d+(?:[\-\.]\w+)*)', contenu, re.IGNORECASE)
        references.extend([f"CGI art. {ref}" for ref in cgi_refs])
        
        # Lois de finances
        lf_refs = re.findall(r'loi\s+de\s+finances\s+n°\s*([\d\-\.]+)', contenu, re.IGNORECASE)
        references.extend([f"LF {ref}" for ref in lf_refs])
        
        # Lois générales
        law_refs = re.findall(r'loi\s+n°\s*([\d\-\.]+)', contenu, re.IGNORECASE)
        references.extend([f"Loi {ref}" for ref in law_refs])
        
        # Décrets
        decree_refs = re.findall(r'décret\s+n°\s*([\d\-\.]+)', contenu, re.IGNORECASE)
        references.extend([f"Décret {ref}" for ref in decree_refs])
        
        # Dahirs
        dahir_refs = re.findall(r'dahir\s+n°\s*([\d\-\.]+)', contenu, re.IGNORECASE)
        references.extend([f"Dahir {ref}" for ref in dahir_refs])
        
        return list(set(references))[:10]
    
    def _generate_search_keywords(self, document, contenu, doc_info, objet):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Mots du titre/objet
        if objet:
            objet_words = [w for w in objet.lower().split() if len(w) > 3]
            keywords.extend(objet_words[:5])
        
        # Type et régime
        keywords.extend(["guide", doc_info['regime'].lower(), doc_info['theme'].lower()])
        
        # Termes spécialisés selon le régime
        if doc_info['regime'] == "Auto-entrepreneur":
            specialized_terms = [
                "auto-entrepreneur", "rnae", "barid", "ice", "trimestriel", 
                "radiation", "inscription", "statut", "exonération", "dispense"
            ]
        elif doc_info['regime'] == "CPU":
            specialized_terms = [
                "cpu", "contribution", "professionnelle", "unique", "forfaitaire",
                "coefficient", "complémentaire", "assurance", "maladie", "transition"
            ]
        else:
            specialized_terms = [
                "fiscal", "impôt", "taxe", "déclaration", "régime", "contribuable"
            ]
        
        for term in specialized_terms:
            if term in contenu.lower():
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_guides(self, guides):
        """Traite toutes les entrées de guides"""
        logger.info(f"Traitement de {len(guides)} entrées de guides...")
        
        # S'assurer que la collection existe
        self.ensure_collection_exists()
        
        # Traiter chaque entrée
        for i, guide in enumerate(tqdm(guides, desc="Traitement des guides")):
            point = self.process_guide_entry(guide, i)
            if point:
                self.points.append(point)
        
        # Indexer tous les points
        if self.points:
            logger.info(f"Ajout de {len(self.points)} nouvelles entrées...")
            
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
            logger.info(f"✅ Collection mise à jour avec {collection_info.points_count} entrées au total")
        
        return len(self.points)

def main():
    """Script principal pour indexer les guides"""
    logger.info("🚀 Démarrage de l'indexation des guides")
    
    # Charger les données
    with open("/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/guide.json", "r", encoding="utf-8") as f:
        guide_data = json.load(f)
    
    logger.info(f"✅ {len(guide_data)} entrées chargées")
    
    # Créer le processeur
    processor = GuideProcessor()
    
    # Traiter toutes les entrées
    count = processor.process_all_guides(guide_data)
    
    logger.info(f"✅ Indexation terminée: {count} nouvelles entrées ajoutées")
    
    # Sauvegarder les stats
    stats = {
        "total_entries": len(guide_data),
        "new_indexed_entries": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("guide_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans guide_indexing_stats.json")

if __name__ == "__main__":
    main()