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

class CategorisationProcessor:
    """Processeur optimisé pour l'embedding des documents de catégorisation avec enrichissement contextuel"""
    
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
    
    def process_categorisation_entry(self, entry_data, doc_index):
        """Traite une entrée de catégorisation avec enrichissement contextuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les infos de base avec gestion des variables optionnelles
        document = entry_data.get("document", "")
        introduction = entry_data.get("introduction", "")
        chapitre = entry_data.get("chapitre", "")
        nom_chapitre = entry_data.get("nom_chapitre", "")
        partie = entry_data.get("partie", "")
        nom_partie = entry_data.get("nom_partie", "")
        sous_partie = entry_data.get("sous_partie", "")
        nom_sous_partie = entry_data.get("nom_sous_partie", "")
        contenu = entry_data.get("contenu", "")
        
        # Déterminer le type de document
        doc_type = "categorisation_commune" if "COMMUNE" in document else "categorisation_dgi"
        
        # Vérifier qu'il y a du contenu à traiter
        main_content = contenu or introduction
        if not main_content or not main_content.strip():
            logger.warning(f"Entrée {doc_index} vide, ignorée")
            return None
        
        # Extraire les informations détaillées du document
        doc_info = self._extract_document_info(document, doc_type)
        
        # ENRICHISSEMENT CONTEXTUEL SPÉCIFIQUE
        enriched_text_parts = []
        
        # 1. Métadonnées structurées
        enriched_text_parts.append(f"Type de document: {doc_type}")
        enriched_text_parts.append(f"Document: {document}")
        enriched_text_parts.append(f"Thème: {doc_info['theme']}")
        enriched_text_parts.append(f"Administrations: {doc_info['administrations']}")
        
        # 2. Structure hiérarchique (seulement si présente)
        if chapitre and nom_chapitre:
            enriched_text_parts.append(f"Chapitre: {chapitre} - {nom_chapitre}")
        elif chapitre:
            enriched_text_parts.append(f"Chapitre: {chapitre}")
        elif nom_chapitre:
            enriched_text_parts.append(f"Chapitre: {nom_chapitre}")
            
        if partie and nom_partie:
            enriched_text_parts.append(f"Partie: {partie} - {nom_partie}")
        elif partie:
            enriched_text_parts.append(f"Partie: {partie}")
        elif nom_partie:
            enriched_text_parts.append(f"Partie: {nom_partie}")
            
        if sous_partie and nom_sous_partie:
            enriched_text_parts.append(f"Sous-partie: {sous_partie} - {nom_sous_partie}")
        elif sous_partie:
            enriched_text_parts.append(f"Sous-partie: {sous_partie}")
        elif nom_sous_partie:
            enriched_text_parts.append(f"Sous-partie: {nom_sous_partie}")
        
        # 3. Extraction et enrichissement des concepts clés
        key_concepts = self._extract_key_concepts(main_content, doc_type)
        if key_concepts:
            enriched_text_parts.append(f"Concepts clés: {', '.join(key_concepts)}")
        
        # 4. Enrichissement spécifique par type
        type_enrichment = self._get_type_enrichment(main_content, doc_type)
        if type_enrichment:
            enriched_text_parts.extend(type_enrichment)
        
        # 5. Références légales
        legal_refs = self._extract_legal_references(main_content)
        if legal_refs:
            enriched_text_parts.append(f"Références légales: {', '.join(legal_refs)}")
        
        # 6. Contenu principal
        if introduction:
            enriched_text_parts.append(f"Introduction: {introduction}")
        if contenu:
            enriched_text_parts.append(f"Contenu: {contenu}")
        
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
        search_keywords = self._generate_search_keywords(document, main_content, doc_info)
        
        # Créer le point Qdrant avec gestion des valeurs nulles
        point = PointStruct(
            id=doc_id,
            vector=embedding,
            payload={
                # Infos de base (toujours présentes, même si vides)
                "type": doc_type,
                "document": document,
                "introduction": introduction,
                "chapitre": chapitre,
                "nom_chapitre": nom_chapitre,
                "partie": partie,
                "nom_partie": nom_partie,
                "sous_partie": sous_partie,
                "nom_sous_partie": nom_sous_partie,
                "contenu": contenu,
                
                # Métadonnées extraites
                "theme": doc_info["theme"],
                "administrations": doc_info["administrations"],
                "procedure_type": doc_info["procedure_type"],
                
                # Métadonnées enrichies
                "search_keywords": search_keywords,
                "key_concepts": key_concepts,
                "legal_references": legal_refs,
                "enriched_text": enriched_text,
                
                # Flags spécifiques
                "has_audit": "audit" in main_content.lower(),
                "has_commission": "commission" in main_content.lower(),
                "has_oea": "oea" in main_content.lower(),
                "has_tva": "tva" in main_content.lower() or "taxe sur la valeur ajoutée" in main_content.lower(),
                "has_dossier": "dossier" in main_content.lower(),
                "has_eligibilite": "éligibilité" in main_content.lower() or "éligible" in main_content.lower(),
                "has_convention": "convention" in main_content.lower(),
                "has_renouvellement": "renouvellement" in main_content.lower(),
                "has_delai": bool(re.search(r'\d+\s+(?:jours?|mois|années?)', main_content.lower())),
                
                # Flags de structure (pour indiquer la présence des variables)
                "has_chapitre": bool(chapitre or nom_chapitre),
                "has_partie": bool(partie or nom_partie),
                "has_sous_partie": bool(sous_partie or nom_sous_partie),
                "has_introduction": bool(introduction),
                "has_contenu": bool(contenu),
                
                # Métadonnées techniques
                "doc_index": doc_index,
                "indexed_at": datetime.now().isoformat()
            }
        )
        
        return point
    
    def _extract_document_info(self, document, doc_type):
        """Extraction des informations du document"""
        doc_info = {
            "theme": "",
            "administrations": "",
            "procedure_type": ""
        }
        
        if doc_type == "categorisation_commune":
            doc_info["theme"] = "Catégorisation commune DGI-ADII"
            doc_info["administrations"] = "DGI, ADII"
            doc_info["procedure_type"] = "Procédure commune"
        else:
            doc_info["theme"] = "Catégorisation DGI"
            doc_info["administrations"] = "DGI"
            doc_info["procedure_type"] = "Procédure DGI"
        
        return doc_info
    
    def _extract_key_concepts(self, contenu, doc_type):
        """Extrait les concepts clés du contenu"""
        concepts = []
        contenu_lower = contenu.lower()
        
        # Concepts communs
        common_concepts = {
            "entreprise": r"entreprise",
            "statut": r"statut",
            "critères": r"critères?",
            "éligibilité": r"éligibilité|éligible",
            "audit": r"audit",
            "commission": r"commission",
            "rapport": r"rapport",
            "évaluation": r"évaluation",
            "convention": r"convention",
            "facilités": r"facilités?",
            "obligations": r"obligations?",
            "conformité": r"conformité",
            "transparence": r"transparence",
            "solvabilité": r"solvabilité"
        }
        
        # Concepts spécifiques selon le type
        if doc_type == "categorisation_commune":
            specific_concepts = {
                "OEA": r"oea",
                "douane": r"douane|douaniers?",
                "commerce international": r"commerce\s+international",
                "sécurité": r"sécurité",
                "sûreté": r"sûreté",
                "chaîne logistique": r"chaîne\s+logistique"
            }
        else:
            specific_concepts = {
                "contribuable": r"contribuable",
                "TVA": r"tva|taxe\s+sur\s+la\s+valeur\s+ajoutée",
                "remboursement": r"remboursement",
                "contentieux": r"contentieux",
                "guichet dédié": r"guichet.*dédié",
                "interlocuteur privilégié": r"interlocuteur.*privilégié"
            }
        
        # Combiner tous les concepts
        all_concepts = {**common_concepts, **specific_concepts}
        
        for concept, pattern in all_concepts.items():
            if re.search(pattern, contenu_lower):
                concepts.append(concept)
        
        # Extraire les délais
        delais = re.findall(r'\d+\s+(?:jours?|mois|années?)', contenu_lower)
        concepts.extend([f"délai: {delai}" for delai in delais[:3]])
        
        # Extraire les classes
        classes = re.findall(r'classe\s+["\']?([ab])["\']?', contenu_lower)
        concepts.extend([f"classe {classe.upper()}" for classe in classes])
        
        return list(set(concepts))[:15]
    
    def _get_type_enrichment(self, contenu, doc_type):
        """Enrichissement spécifique par type de document"""
        enrichment = []
        contenu_lower = contenu.lower()
        
        if doc_type == "categorisation_commune":
            enrichment.extend([
                "Secteur: commerce international, douane, fiscalité",
                "Statuts: OEA-simplifications douanières, contribuable catégorisé",
                "Bénéfices: facilités douanières et fiscales combinées"
            ])
            
            if "audit" in contenu_lower:
                enrichment.append("Processus: audit externe obligatoire")
            if "commission mixte" in contenu_lower:
                enrichment.append("Gouvernance: commission mixte DGI-ADII")
                
        else:
            enrichment.extend([
                "Secteur: fiscalité, administration fiscale",
                "Statut: contribuable catégorisé DGI",
                "Bénéfices: facilités fiscales, remboursement TVA"
            ])
            
            if "remboursement" in contenu_lower:
                enrichment.append("Avantage: remboursement TVA sans contrôle")
            if "guichet" in contenu_lower:
                enrichment.append("Service: guichet dédié")
        
        return enrichment
    
    def _extract_legal_references(self, contenu):
        """Extrait les références légales"""
        references = []
        
        # Code Général des Impôts
        cgi_refs = re.findall(r'code\s+général\s+des\s+impôts', contenu, re.IGNORECASE)
        if cgi_refs:
            references.append("Code Général des Impôts")
        
        # Articles
        article_refs = re.findall(r'article\s+(\d+(?:-\d+)?)', contenu, re.IGNORECASE)
        references.extend([f"Article {ref}" for ref in article_refs])
        
        # Annexes
        annexe_refs = re.findall(r'annexe\s+(\d+)', contenu, re.IGNORECASE)
        references.extend([f"Annexe {ref}" for ref in annexe_refs])
        
        # Lois
        law_refs = re.findall(r'loi\s+n°\s*([\d-]+)', contenu, re.IGNORECASE)
        references.extend([f"Loi {ref}" for ref in law_refs])
        
        return list(set(references))[:10]
    
    def _generate_search_keywords(self, document, contenu, doc_info):
        """Génère des mots-clés optimisés pour la recherche"""
        keywords = []
        
        # Type de document
        if "COMMUNE" in document:
            keywords.extend(["catégorisation", "commune", "dgi", "adii", "oea"])
        else:
            keywords.extend(["catégorisation", "dgi", "contribuable", "fiscal"])
        
        # Thème
        keywords.append(doc_info['theme'].lower())
        
        # Termes spécialisés
        specialized_terms = [
            "entreprise", "statut", "audit", "commission", "éligibilité",
            "convention", "facilités", "avantages", "critères", "évaluation",
            "rapport", "dossier", "demande", "procédure", "renouvellement",
            "classe", "transparence", "conformité", "solvabilité"
        ]
        
        for term in specialized_terms:
            if term in contenu.lower():
                keywords.append(term)
        
        return list(set(keywords))[:20]
    
    def process_all_entries(self, entries):
        """Traite toutes les entrées de catégorisation"""
        logger.info(f"Traitement de {len(entries)} entrées de catégorisation...")
        
        # Créer la collection seulement si elle n'existe pas
        self.create_collection_if_not_exists()
        
        # Traiter chaque entrée
        for i, entry in enumerate(tqdm(entries, desc="Traitement des catégorisations")):
            point = self.process_categorisation_entry(entry, i)
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
    """Script principal pour indexer les catégorisations"""
    logger.info("🚀 Démarrage de l'indexation des catégorisations")
    
    # Charger les données
    with open("/Users/ayoub/Documents/GitHub/FB-Ahmed/annexes/CGI/JSON/categorisation.json", "r", encoding="utf-8") as f:
        categorisation_data = json.load(f)
    
    logger.info(f"✅ {len(categorisation_data)} entrées chargées")
    
    # Créer le processeur
    processor = CategorisationProcessor()
    
    # Traiter toutes les entrées
    count = processor.process_all_entries(categorisation_data)
    
    logger.info(f"✅ Indexation terminée: {count} nouvelles entrées ajoutées")
    
    # Sauvegarder les stats
    stats = {
        "total_entries": len(categorisation_data),
        "new_indexed_entries": count,
        "collection_name": processor.collection_name,
        "timestamp": datetime.now().isoformat()
    }
    
    with open("categorisation_indexing_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2, ensure_ascii=False)
    
    logger.info("✅ Stats sauvegardées dans categorisation_indexing_stats.json")

if __name__ == "__main__":
    main()