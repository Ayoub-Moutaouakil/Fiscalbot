import json
import qdrant_client
from qdrant_client.models import PointStruct, VectorParams, Distance
import tiktoken
import uuid
import re
import google.generativeai as genai
import os
import logging
import time
import numpy as np
from datetime import datetime
import matplotlib.pyplot as plt
from collections import defaultdict
from tqdm import tqdm
from typing import List, Dict, Set, Tuple
import voyageai  # 🌟 Import Voyage

# Configuration du logging avancé
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f"embedding_process_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# 🌟 Configuration Voyage
VOYAGE_API_KEY = "pa-gPu9JZffTtb0O57mU8ZNtCzWBrQ7dDRy_7M_f6Cr8br"
voyage_client = voyageai.Client(api_key=VOYAGE_API_KEY)

# 🌟 Configuration Gemini uniquement
GEMINI_API_KEY = "AIzaSyDmG5LqJhaAthC8GrgjE9eIdHcWSNQJTmE"
genai.configure(api_key=GEMINI_API_KEY)

# 🔹 Connexion à Qdrant
QDRANT_HOST = "13.39.82.37"
QDRANT_PORT = 6333

# 🌟 Configuration de la dimension des embeddings pour Voyage
EMBEDDING_DIM = 1024  # Voyage-law-2 utilise 1024 dimensions

# 🌟 Système de synonymes fiscaux (GARDÉ CAR TOUJOURS UTILE)
class FiscalSynonymManager:
    """Gestionnaire de synonymes pour améliorer la recherche sémantique"""
    
    def __init__(self):
        # Dictionnaire de synonymes fiscaux génériques
        self.synonyms = {
            # Produits alimentaires
            "poisson": ["produits de la pêche", "produits maritimes", "produits de mer", 
                       "poissons frais", "poisson congelé", "produits halieutiques"],
            "viande": ["viandes fraîches", "produits carnés", "viande bovine", "viande ovine",
                      "viande caprine", "viande de volaille", "produits d'abattoir"],
            "légumes": ["produits maraîchers", "légumes frais", "produits végétaux",
                       "légumineuses", "tubercules", "produits horticoles"],
            "fruits": ["fruits frais", "produits fruitiers", "agrumes", "fruits secs"],
            "lait": ["produits laitiers", "laitage", "produits dérivés du lait"],
            
            # Termes fiscaux
            "exonération": ["exonéré", "exemption", "franchise", "dispense", "non assujetti"],
            "impôt": ["taxe", "imposition", "contribution", "prélèvement", "redevance"],
            "société": ["entreprise", "compagnie", "firme", "personne morale", "entité"],
            "revenu": ["rémunération", "gain", "bénéfice", "profit", "recette"],
            "charge": ["dépense", "frais", "coût", "débours"],
            "plafond": ["limite", "seuil", "maximum", "montant maximal"],
            "indemnité": ["allocation", "compensation", "dédommagement", "prime"],
            
            # Secteurs d'activité
            "industrie": ["industriel", "manufacture", "production", "transformation"],
            "plastique": ["matière plastique", "polymère", "PVC", "polyéthylène", 
                         "polypropylène", "matériaux plastiques", "industrie plastique"],
            "agriculture": ["agricole", "exploitation agricole", "activité agricole", "farming"],
            "commerce": ["commercial", "négoce", "vente", "distribution"],
            "service": ["prestation", "prestataire", "activité de service"],
            
            # Professions médicales et paramédicales
            "kinésithérapeute": ["kinésithérapie", "masseur-kinésithérapeute", "kiné", 
                                "rééducation fonctionnelle", "physiothérapeute"],
            "médecin": ["docteur", "praticien", "médecine", "médical", "clinicien"],
            "infirmier": ["infirmière", "soins infirmiers", "personnel soignant"],
            
            # Types d'impôts
            "TVA": ["taxe sur la valeur ajoutée", "T.V.A", "tva"],
            "IS": ["impôt sur les sociétés", "I.S", "impôt sociétés"],
            "IR": ["impôt sur le revenu", "I.R", "impôt revenu"],
            
            # Termes juridiques
            "assujetti": ["redevable", "contribuable", "imposable", "soumis à"],
            "déclaration": ["déclaratif", "déclarer", "déclaration fiscale"],
            "cotisation": ["contribution", "quote-part", "participation"],
            
            # Termes spécifiques
            "base": ["assiette", "base imposable", "base d'imposition"],
            "minimum": ["minimal", "minimale", "cotisation minimale"],
            "véhicule": ["voiture", "automobile", "transport de personnes"],
            "amortissement": ["dotation aux amortissements", "dépréciation", "amortir"],
            "crédit-bail": ["leasing", "location avec option d'achat", "LOA"]
        }
        
        # Créer un index inversé pour recherche rapide
        self.inverse_index = {}
        for main_term, synonyms in self.synonyms.items():
            for synonym in synonyms:
                self.inverse_index[synonym.lower()] = main_term
            self.inverse_index[main_term.lower()] = main_term
    
    def expand_query(self, query: str) -> str:
        """Enrichit une requête avec des synonymes pertinents"""
        query_lower = query.lower()
        expanded_terms = []
        
        # Chercher les termes qui ont des synonymes
        for term, synonyms in self.synonyms.items():
            if term.lower() in query_lower:
                # Ajouter les synonymes pertinents
                for synonym in synonyms[:3]:  # Limiter à 3 synonymes pour ne pas diluer
                    if synonym.lower() not in query_lower:
                        expanded_terms.append(synonym)
        
        # Chercher dans l'index inversé
        words = query_lower.split()
        for word in words:
            if word in self.inverse_index:
                main_term = self.inverse_index[word]
                if main_term in self.synonyms:
                    for synonym in self.synonyms[main_term][:2]:
                        if synonym.lower() not in query_lower and synonym not in expanded_terms:
                            expanded_terms.append(synonym)
        
        # Construire la requête enrichie
        if expanded_terms:
            expanded_query = f"{query} {' '.join(expanded_terms)}"
            logger.info(f"🔄 Requête enrichie: '{query}' → '{expanded_query}'")
            return expanded_query
        
        return query
    
    def get_all_variants(self, term: str) -> List[str]:
        """Retourne toutes les variantes d'un terme"""
        term_lower = term.lower()
        variants = [term]
        
        # Si c'est un terme principal
        if term_lower in self.synonyms:
            variants.extend(self.synonyms[term_lower])
        
        # Si c'est un synonyme
        if term_lower in self.inverse_index:
            main_term = self.inverse_index[term_lower]
            variants.append(main_term)
            variants.extend(self.synonyms.get(main_term, []))
        
        # Supprimer les doublons et retourner
        return list(set(variants))

# 🌟 Extracteur de mots-clés amélioré (GARDÉ CAR TOUJOURS UTILE)
class EnhancedKeywordExtractor:
    """Extracteur de mots-clés amélioré avec détection de concepts fiscaux"""
    
    def __init__(self):
        # Patterns pour identifier les concepts fiscaux importants
        self.fiscal_patterns = {
            "taux": r"(\d+(?:,\d+)?(?:\s*%|pour cent))",
            "montant": r"(\d+(?:\.\d{3})*(?:,\d+)?\s*(?:DH|dirhams?|MAD))",
            "délai": r"(\d+\s*(?:jours?|mois|années?))",
            "seuil": r"(?:seuil|plafond|limite)\s*(?:de\s*)?(\d+(?:\.\d{3})*(?:,\d+)?\s*(?:DH|dirhams?|MAD)?)",
            "article_reference": r"(?:article|art\.?)\s*(\d+(?:-[IVX]+)?(?:\s*(?:bis|ter|quater))?)",
        }
        
        # Termes techniques importants à extraire
        self.important_terms = {
            "fiscalité": ["exonération", "assujettissement", "imposition", "déduction", 
                         "abattement", "crédit d'impôt", "réduction", "dégrèvement"],
            "procédure": ["déclaration", "contrôle", "vérification", "recouvrement",
                         "réclamation", "contentieux", "prescription", "notification"],
            "entités": ["société", "entreprise", "établissement", "filiale", "succursale",
                       "association", "coopérative", "groupement"],
            "opérations": ["cession", "acquisition", "fusion", "scission", "apport",
                          "distribution", "liquidation", "transformation"],
            "revenus": ["salaire", "traitement", "indemnité", "allocation", "prime",
                       "avantage", "rémunération", "honoraires", "commission"]
        }
    
    def extract_enhanced_keywords(self, content: str, context: str = "") -> Dict[str, List[str]]:
        """Extrait des mots-clés enrichis avec catégorisation"""
        keywords = {
            "concepts_fiscaux": [],
            "montants": [],
            "taux": [],
            "délais": [],
            "références": [],
            "termes_techniques": [],
            "entités": []
        }
        
        content_lower = content.lower()
        
        # 1. Extraire les patterns fiscaux
        for pattern_name, pattern in self.fiscal_patterns.items():
            matches = re.findall(pattern, content, re.IGNORECASE)
            if matches:
                if pattern_name == "taux":
                    keywords["taux"].extend(matches[:3])
                elif pattern_name == "montant" or pattern_name == "seuil":
                    keywords["montants"].extend(matches[:3])
                elif pattern_name == "délai":
                    keywords["délais"].extend(matches[:2])
                elif pattern_name == "article_reference":
                    keywords["références"].extend(matches[:5])
        
        # 2. Extraire les termes techniques
        for category, terms in self.important_terms.items():
            for term in terms:
                if term in content_lower:
                    if category == "entités":
                        keywords["entités"].append(term)
                    else:
                        keywords["termes_techniques"].append(term)
        
        # 3. Extraire les concepts fiscaux spécifiques
        # Rechercher les activités ou secteurs spécifiques
        secteurs = re.findall(r"(?:activité|secteur|industrie)\s+(?:de\s+)?(\w+(?:\s+\w+)?)", 
                             content_lower)
        if secteurs:
            keywords["concepts_fiscaux"].extend(secteurs[:3])
        
        # 4. Détecter les professions spécifiques
        professions = ["kinésithérapeute", "médecin", "architecte", "avocat", "expert-comptable",
                      "notaire", "huissier", "commissaire aux comptes", "conseiller fiscal"]
        for profession in professions:
            if profession in content_lower:
                keywords["concepts_fiscaux"].append(profession)
        
        return keywords
    
    def generate_searchable_keywords(self, keywords_dict: Dict[str, List[str]]) -> List[str]:
        """Génère une liste de mots-clés optimisée pour la recherche"""
        all_keywords = []
        
        # Prioriser certains types de mots-clés
        priority_order = ["concepts_fiscaux", "montants", "taux", "termes_techniques", 
                         "entités", "délais", "références"]
        
        for category in priority_order:
            if category in keywords_dict:
                all_keywords.extend(keywords_dict[category])
        
        # Supprimer les doublons tout en préservant l'ordre
        seen = set()
        unique_keywords = []
        for kw in all_keywords:
            if kw.lower() not in seen:
                seen.add(kw.lower())
                unique_keywords.append(kw)
        
        # Limiter à 15 mots-clés maximum
        return unique_keywords[:15]

# Initialiser les gestionnaires
synonym_manager = FiscalSynonymManager()
keyword_extractor = EnhancedKeywordExtractor()

class QdrantManager:
    """Gestionnaire avancé pour Qdrant avec mécanismes de résilience"""
    
    def __init__(self, host, port, max_retries=5, retry_delay=3):
        self.host = host
        self.port = port
        self.max_retries = max_retries
        self.retry_delay = retry_delay
        self.client = None
        self.connect()
    
    def connect(self):
        """Établit une connexion à Qdrant avec mécanisme de retry"""
        for attempt in range(self.max_retries):
            try:
                self.client = qdrant_client.QdrantClient(host=self.host, port=self.port)
                logger.info(f"✅ Connexion à Qdrant établie avec succès")
                return self.client
            except Exception as e:
                logger.warning(f"⚠️ Tentative {attempt+1}/{self.max_retries} de connexion à Qdrant échouée: {str(e)}")
                if attempt < self.max_retries - 1:
                    time.sleep(self.retry_delay * (attempt + 1))
        
        logger.error(f"❌ Impossible de se connecter à Qdrant après {self.max_retries} tentatives")
        raise ConnectionError(f"Impossible de se connecter à Qdrant ({self.host}:{self.port})")
    
    def create_collection(self, collection_name, vector_size=EMBEDDING_DIM, distance=Distance.COSINE, recreate=False):
        """Crée ou recrée une collection dans Qdrant avec la dimension configurée"""
        try:
            # Vérifier si la collection existe déjà
            collections = self.client.get_collections().collections
            collection_exists = any(c.name == collection_name for c in collections)
            
            if collection_exists:
                if recreate:
                    logger.info(f"🔄 Suppression de la collection existante {collection_name}")
                    self.client.delete_collection(collection_name)
                else:
                    logger.info(f"✅ La collection {collection_name} existe déjà")
                    return
            
            # Créer la collection avec la dimension spécifiée
            self.client.create_collection(
                collection_name=collection_name,
                vectors_config=VectorParams(size=vector_size, distance=distance)
            )
            logger.info(f"✅ Collection {collection_name} créée avec succès (dimension: {vector_size})")
        except Exception as e:
            logger.error(f"❌ Erreur lors de la création de la collection {collection_name}: {str(e)}")
            raise
    
    def upsert_batch(self, collection_name, points, batch_size=50, show_progress=True):
        """Insère un lot de points avec mécanisme de retry et barre de progression"""
        if not points:
            logger.warning("⚠️ Aucun point à insérer")
            return 0, []
        
        total_points = len(points)
        total_batches = (total_points + batch_size - 1) // batch_size
        
        # Créer une barre de progression si demandé
        progress_bar = tqdm(total=total_batches, desc="Insertion des données") if show_progress else None
        
        success_count = 0
        failed_batches = []
        
        # Traitement par lots
        for i in range(0, total_points, batch_size):
            batch = points[i:i + batch_size]
            batch_num = i // batch_size + 1
            
            # Tentatives multiples pour chaque lot
            for attempt in range(self.max_retries):
                try:
                    self.client.upsert(collection_name=collection_name, points=batch)
                    success_count += len(batch)
                    
                    if progress_bar:
                        progress_bar.update(1)
                    else:
                        logger.info(f"✅ Lot {batch_num}/{total_batches} indexé ({len(batch)} documents)")
                    
                    break  # Sortir de la boucle en cas de succès
                except Exception as e:
                    error_msg = str(e)
                    logger.warning(f"⚠️ Erreur lors de l'insertion du lot {batch_num}: {error_msg} (tentative {attempt+1}/{self.max_retries})")
                    
                    # Si c'est la dernière tentative, marquer comme échec
                    if attempt == self.max_retries - 1:
                        logger.error(f"❌ Échec de l'insertion du lot {batch_num} après {self.max_retries} tentatives")
                        failed_batches.append((batch_num, batch))
                    else:
                        # Sinon, attendre et réessayer
                        time.sleep(self.retry_delay * (attempt + 1))
        
        if progress_bar:
            progress_bar.close()
        
        # Rapport final
        logger.info(f"✅ Indexation terminée: {success_count}/{total_points} points indexés avec succès")
        if failed_batches:
            logger.warning(f"⚠️ {len(failed_batches)} lots n'ont pas pu être indexés. Voir le fichier de log pour plus de détails.")
        
        return success_count, failed_batches

# Initialiser la connexion à Qdrant
qdrant = QdrantManager(QDRANT_HOST, QDRANT_PORT)

# 🔹 Configuration du tokenizer et des limites
tokenizer = tiktoken.encoding_for_model("text-embedding-3-large")

# 🌟 Augmentation de la limite de tokens pour Voyage
TOKEN_LIMIT = 6000  # Augmenté pour Voyage-law-2
TOKEN_MARGIN = 200  # Marge augmentée aussi

# 🌟 Configuration des modèles - Seulement Gemini 2.0
KEYWORD_MODEL = "gemini-2.0-flash"

# 🔹 Configuration des limites d'API
MAX_RETRIES = 3
RETRY_DELAY = 5

# 🔹 Gestionnaire de taux de requête API
class RateLimit:
    """Gestionnaire de taux de requête API amélioré avec limiteurs spécifiques par modèle"""
    
    def __init__(self):
        self.timestamps = defaultdict(list)
        self.limits = {
            "default": (15, 0.1),
            "gemini-2.0-flash": (25, 0.05),
            "voyage": (30, 0.05)
        }
    
    def check_and_wait(self, model_name):
        """Vérifie si on peut faire une requête, sinon attend le temps nécessaire"""
        current_time = time.time()
        
        # Déterminer les limites pour ce modèle
        rpm, min_delay = self.limits.get(model_name, self.limits["default"])
        
        # Supprimer les timestamps plus vieux qu'une minute
        self.timestamps[model_name] = [ts for ts in self.timestamps[model_name] if current_time - ts < 60]
        
        # Vérifier le délai minimum entre les requêtes
        if self.timestamps[model_name] and (current_time - self.timestamps[model_name][-1] < min_delay):
            wait_time = min_delay - (current_time - self.timestamps[model_name][-1])
            time.sleep(wait_time)
            current_time = time.time()
        
        # Si on a atteint la limite pour ce modèle, calculer le temps d'attente
        if len(self.timestamps[model_name]) >= rpm:
            # Trouver le timestamp le plus ancien et calculer quand il aura 60 secondes
            oldest = min(self.timestamps[model_name])
            wait_time = oldest + 60 - current_time
            
            if wait_time > 0:
                logger.debug(f"⏱️ Limite API atteinte pour {model_name}, attente de {wait_time:.2f} secondes...")
                time.sleep(wait_time + 0.1)  # Ajouter une petite marge
                current_time = time.time()
        
        # Ajouter le timestamp actuel à la liste
        self.timestamps[model_name].append(current_time)

# Créer les gestionnaires de limite
rate_limiter = RateLimit()

# 🔹 Classes et fonctions pour l'embedding et le traitement du texte
class EmbeddingManager:
    """Gestionnaire d'embeddings avec cache, résilience et gestion des grands textes"""
    
    def __init__(self, cache_size=500):
        self.model = "voyage-law-2"  # 🌟 Utilise Voyage
        self.cache_size = cache_size
        self.max_tokens = 16000  # 🌟 Voyage supporte 16k tokens
        self.vector_dim = EMBEDDING_DIM
        self.cache = {}
        self.cache_hits = 0
        self.cache_misses = 0
        self.failures = 0
        self.truncations = 0
        self.gemini_summaries = 0  # 🌟 Remplace gpt_summaries
        self.total_requests = 0
    
    def get_embedding(self, text, input_type="document"):
        """Génère un embedding en enrichissant le texte avec des synonymes"""
        if not text or not text.strip():
            return [0.0] * self.vector_dim
        
        self.total_requests += 1
        
        # 🌟 IMPORTANT: Enrichir le texte avec des synonymes avant l'embedding
        enriched_text = synonym_manager.expand_query(text)
        
        # Calculer un hash du texte enrichi pour le cache
        normalized_text = re.sub(r'\s+', ' ', enriched_text).strip()
        text_hash = hash(normalized_text)
        
        # Vérifier le cache
        if text_hash in self.cache:
            self.cache_hits += 1
            return self.cache[text_hash]
        
        self.cache_misses += 1
        
        # Vérifier la longueur du texte
        token_count = len(tokenizer.encode(normalized_text))
        
        # Stratégie selon la longueur du texte
        if token_count <= self.max_tokens:
            embedding = self._get_embedding_with_voyage(normalized_text, input_type)
        else:
            try:
                logger.warning(f"⚠️ Texte trop long ({token_count} tokens) - Troncature intelligente")
                truncated_text = self.truncate_text(normalized_text, self.max_tokens)
                self.truncations += 1
                embedding = self._get_embedding_with_voyage(truncated_text, input_type)
            except Exception as e:
                logger.warning(f"⚠️ Troncature insuffisante, tentative de résumé avec Gemini")
                try:
                    summary = self._generate_summary_with_gemini(normalized_text)
                    embedding = self._get_embedding_with_voyage(summary, input_type)
                    self.gemini_summaries += 1
                except Exception as e2:
                    logger.error(f"❌ Échec de toutes les tentatives d'embedding: {str(e2)}")
                    embedding = [0.0] * self.vector_dim
                    self.failures += 1
        
        # Mettre en cache l'embedding réussi
        if len(self.cache) >= self.cache_size:
            if self.cache:
                # Supprimer le premier élément du cache
                first_key = next(iter(self.cache))
                del self.cache[first_key]
        
        self.cache[text_hash] = embedding
        return embedding
    
    def _get_embedding_with_voyage(self, text, input_type="document", max_retries=3):
        """🌟 Utilise Voyage pour générer les embeddings"""
        for attempt in range(max_retries):
            try:
                rate_limiter.check_and_wait("voyage")
                
                # 🌟 Utiliser Voyage-law-2
                result = voyage_client.embed(
                    [text], 
                    model="voyage-law-2",
                    input_type=input_type  # "document" ou "query"
                )
                
                embedding = result.embeddings[0]
                
                if len(embedding) != self.vector_dim:
                    logger.info(f"ℹ️ Dimension d'embedding: {len(embedding)}")
                
                return embedding
                
            except Exception as e:
                if attempt == max_retries - 1:
                    raise e
                
                logger.warning(f"⚠️ Erreur d'embedding avec Voyage: {e} (tentative {attempt+1}/{max_retries})")
                time.sleep(RETRY_DELAY * (attempt + 1))
    
    def truncate_text(self, text, max_tokens):
        """Tronque intelligemment un texte pour respecter la limite de tokens"""
        tokens = tokenizer.encode(text)
        
        if len(tokens) <= max_tokens:
            return text
        
        beginning_ratio = 0.6
        beginning_tokens = int(max_tokens * beginning_ratio)
        ending_tokens = max_tokens - beginning_tokens
        
        beginning = tokenizer.decode(tokens[:beginning_tokens])
        ending = tokenizer.decode(tokens[-ending_tokens:])
        
        truncated_text = beginning + "\n[...TEXTE TRONQUÉ POUR EMBEDDING...]\n" + ending
        
        return truncated_text
    
    def _generate_summary_with_gemini(self, text, max_summary_length=4000):
        """🌟 Utilise Gemini 2.0 pour générer un résumé d'un texte trop long"""
        max_gemini_tokens = 30000  # Gemini 2.0 peut gérer plus de tokens
        if len(tokenizer.encode(text)) > max_gemini_tokens:
            text = self.truncate_text(text, max_gemini_tokens)
        
        try:
            rate_limiter.check_and_wait(KEYWORD_MODEL)
            
            prompt = f"""
Voici un texte juridique fiscal. 
Crée un résumé factuel et complet de ce texte en {max_summary_length} tokens maximum.
Le résumé doit préserver toutes les informations essentielles: 
- Numéros d'articles
- Taux et montants spécifiques
- Conditions d'application
- Exceptions importantes
- Références à d'autres articles

Voici le texte à résumer:
{text}
            """
            
            generation_config = {
                "temperature": 0.1,
                "top_p": 1,
                "top_k": 1,
                "max_output_tokens": max_summary_length,
            }
            
            model = genai.GenerativeModel(KEYWORD_MODEL)
            response = model.generate_content(prompt, generation_config=generation_config)
            
            summary = response.text.strip()
            logger.info(f"✅ Résumé généré avec Gemini: {len(tokenizer.encode(summary))} tokens")
            
            return summary
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de la génération du résumé avec Gemini: {str(e)}")
            return self.truncate_text(text, max_summary_length)
    
    def get_stats(self):
        """Retourne les statistiques d'utilisation du cache"""
        if self.total_requests == 0:
            hit_rate = 0
        else:
            hit_rate = self.cache_hits / self.total_requests * 100
        
        return {
            "total_requests": self.total_requests,
            "cache_hits": self.cache_hits,
            "cache_misses": self.cache_misses,
            "failures": self.failures,
            "truncations": self.truncations,
            "gemini_summaries": self.gemini_summaries,  # 🌟 Changé
            "vector_dimension": self.vector_dim,
            "hit_rate": hit_rate,
            "cache_size": len(self.cache),
            "max_cache_size": self.cache_size
        }

class TextProcessor:
    """Classe pour le traitement de texte et l'extraction d'informations"""
    
    @staticmethod
    def extract_article_references(content):
        """Extrait les références à d'autres articles du CGI - version améliorée"""
        if not content:
            return []
            
        references = []
        
        patterns = [
            r'article[s]?\s+(\d+(?:-[IVX]+)?(?:\s*(?:bis|ter|quater))?)',
            r'article[s]?\s+(\d+(?:-[IVX]+)?(?:\s*(?:bis|ter|quater))?)\s*(?:et|,)\s*(\d+(?:-[IVX]+)?(?:\s*(?:bis|ter|quater))?)',
            r'aux?\s+article[s]?\s+(\d+(?:-[IVX]+)?(?:\s*(?:bis|ter|quater))?)',
            r'article[s]?\s+(\d+)\s*(?:à|au)\s*(\d+)',
            r"[Ll]'(?:article|articles)\s+(\d+(?:-\w+)?(?:\s*(?:bis|ter|quater))?)"
        ]
        
        content_lower = content.lower()
        
        if "article premier" in content_lower or "l'article premier" in content_lower:
            references.append("premier")
        
        for pattern in patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                groups = match.groups()
                for group in groups:
                    if group:
                        ref = re.sub(r'\s+', '', group).strip()
                        parts = ref.split('-')
                        if len(parts) > 1:
                            roman_part = re.sub(r'([ivx]+)', lambda m: m.group(1).upper(), parts[1])
                            ref = f"{parts[0]}-{roman_part}"
                        
                        references.append(ref)
        
        range_pattern = r'article[s]?\s+(\d+)\s*(?:à|au)\s*(\d+)'
        for match in re.finditer(range_pattern, content, re.IGNORECASE):
            try:
                start = int(match.group(1))
                end = int(match.group(2))
                if start < end and end - start <= 20:
                    references.extend([str(i) for i in range(start, end + 1)])
            except (ValueError, IndexError):
                pass
        
        # Normaliser les références d'articles (ex: "10(I-F-1°-b)" → "10")
        unique_refs = []
        for ref in references:
            # Si c'est un format complexe comme 10(I-F-1°-b), garder les deux versions
            if '(' in ref:
                base_num = ref.split('(')[0]
                if base_num not in unique_refs:
                    unique_refs.append(base_num)
            if ref not in unique_refs:
                unique_refs.append(ref)
        
        return unique_refs
    
    @staticmethod
    def extract_section_structure(text):
        """Extrait la structure de sections du texte en identifiant les titres et sous-titres"""
        sections = []
        current_section = ""
        current_title = ""
        
        lines = text.split('\n')
        for line in lines:
            stripped = line.strip()
            if stripped and (
                    stripped.isupper() or
                    stripped.startswith('I.') or 
                    stripped.startswith('II.') or
                    stripped.startswith('III.') or
                    re.match(r'^[A-Z]\s*[).-]', stripped) or
                    re.match(r'^\d+[).-]', stripped)
                ):
                if current_section:
                    sections.append((current_title, current_section))
                
                current_title = stripped
                current_section = stripped + "\n"
            else:
                current_section += line + "\n"
        
        if current_section:
            sections.append((current_title, current_section))
        
        return sections
    
    @staticmethod
    def split_article_text(article_num, contenu, metadata, token_limit=TOKEN_LIMIT):
        """Découpe le contenu d'un article en plusieurs parties en respectant la structure"""
        if not contenu:
            return []
            
        full_text = metadata + "\n" + contenu
        num_tokens = len(tokenizer.encode(full_text))
        
        if num_tokens <= token_limit:
            return [(full_text, num_tokens, 0, 1)]
        
        sections = TextProcessor.extract_section_structure(contenu)
        
        if len(sections) <= 1:
            return TextProcessor._split_by_paragraphs(article_num, contenu, metadata, token_limit)
        
        chunks = []
        current_chunk = metadata + "\n"
        current_tokens = len(tokenizer.encode(current_chunk))
        current_sections = []
        
        for title, section_text in sections:
            section_tokens = len(tokenizer.encode(section_text))
            
            if section_tokens > token_limit - len(tokenizer.encode(metadata)):
                if current_sections:
                    chunks.append((current_chunk, current_tokens, len(chunks), 0))
                
                sub_chunks = TextProcessor._split_by_paragraphs(
                    article_num, 
                    section_text, 
                    metadata + f"\nSection: {title}\n", 
                    token_limit
                )
                chunks.extend(sub_chunks)
                
                current_chunk = metadata + "\n"
                current_tokens = len(tokenizer.encode(current_chunk))
                current_sections = []
                continue
            
            if current_tokens + section_tokens > token_limit:
                chunks.append((current_chunk, current_tokens, len(chunks), 0))
                current_chunk = metadata + "\n" + section_text
                current_tokens = len(tokenizer.encode(current_chunk))
                current_sections = [title]
            else:
                current_chunk += section_text
                current_tokens += section_tokens
                current_sections.append(title)
        
        if current_sections:
            chunks.append((current_chunk, current_tokens, len(chunks), 0))
        
        total_chunks = len(chunks)
        return [(text, tokens, idx, total_chunks) for text, tokens, idx, _ in chunks]
    
    @staticmethod
    def _split_by_paragraphs(article_num, contenu, metadata, token_limit):
        """Découpe le texte en chunks en respectant les limites de paragraphes"""
        paragraphes = [p for p in re.split(r'\n\s*\n', contenu) if p.strip()]
        
        chunks = []
        current_chunk = metadata + "\n"
        current_tokens = len(tokenizer.encode(current_chunk))
        
        for para in paragraphes:
            para_text = para.strip() + "\n\n"
            para_tokens = len(tokenizer.encode(para_text))
            
            if para_tokens > token_limit - len(tokenizer.encode(metadata)):
                if current_tokens > len(tokenizer.encode(metadata + "\n")):
                    chunks.append((current_chunk, current_tokens, len(chunks), 0))
                
                phrases = re.split(r'(?<=[.!?])\s+', para_text)
                phrase_chunk = metadata + "\n"
                phrase_tokens = len(tokenizer.encode(phrase_chunk))
                
                for phrase in phrases:
                    if not phrase.strip():
                        continue
                        
                    phrase_text = phrase.strip() + " "
                    phrase_token_count = len(tokenizer.encode(phrase_text))
                    
                    if phrase_tokens + phrase_token_count > token_limit:
                        chunks.append((phrase_chunk, phrase_tokens, len(chunks), 0))
                        phrase_chunk = metadata + "\n" + phrase_text
                        phrase_tokens = len(tokenizer.encode(phrase_chunk))
                    else:
                        phrase_chunk += phrase_text
                        phrase_tokens += phrase_token_count
                
                if phrase_tokens > len(tokenizer.encode(metadata + "\n")):
                    chunks.append((phrase_chunk, phrase_tokens, len(chunks), 0))
                
                current_chunk = metadata + "\n"
                current_tokens = len(tokenizer.encode(current_chunk))
                continue
            
            if current_tokens + para_tokens > token_limit:
                chunks.append((current_chunk, current_tokens, len(chunks), 0))
                current_chunk = metadata + "\n" + para_text
                current_tokens = len(tokenizer.encode(current_chunk))
            else:
                current_chunk += para_text
                current_tokens += para_tokens
        
        if current_tokens > len(tokenizer.encode(metadata + "\n")):
            chunks.append((current_chunk, current_tokens, len(chunks), 0))
        
        total_chunks = len(chunks)
        return [(text, tokens, idx, total_chunks) for text, tokens, idx, _ in chunks]

class AIModelProcessor:
    """Classe pour gérer les interactions avec Gemini"""
    
    @staticmethod
    def get_gemini_completion(prompt, temperature=0):
        """🌟 Utilise Gemini 2.0 pour générer une complétion"""
        try:
            rate_limiter.check_and_wait(KEYWORD_MODEL)
            
            generation_config = {
                "temperature": temperature,
                "top_p": 1,
                "top_k": 1,
                "max_output_tokens": 50,
            }
            
            model = genai.GenerativeModel(KEYWORD_MODEL)
            response = model.generate_content(prompt, generation_config=generation_config)
            
            return response.text.strip()
            
        except Exception as e:
            logger.warning(f"⚠️ Erreur avec Gemini: {e}")
            raise e
    
    @staticmethod
    def extract_keywords(content, context=""):
        """Extrait les mots-clés pertinents avec l'extracteur amélioré et Gemini"""
        if not content or not content.strip():
            return ["texte_vide"]
        
        # Utiliser l'extracteur amélioré
        enhanced_keywords_dict = keyword_extractor.extract_enhanced_keywords(content, context)
        searchable_keywords = keyword_extractor.generate_searchable_keywords(enhanced_keywords_dict)
        
        # Si pas assez de mots-clés extraits, utiliser Gemini
        if len(searchable_keywords) < 5:
            content_sample = content[:3000] + "..." if len(content) > 3000 else content
            
            prompt = f"""
Tu es un expert fiscal marocain spécialisé dans le Code Général des Impôts (CGI).
Voici le contenu:

{content_sample}

TÂCHE: Extraire 5 à 10 mots-clés ou phrases-clés spécifiques qui représentent les concepts fiscaux essentiels.

CONSIGNES IMPORTANTES:
- Sélectionne des termes techniques fiscaux précis et spécifiques
- Évite les termes génériques comme "impôt", "taxe", "CGI"
- Préfère des termes comme "transfert d'immobilisations", "société mère", "plus-value", etc.
- S'il y a des taux ou des montants spécifiques, inclus-les (ex: "taux de 20%", "seuil de 100 000 DH")
- Inclus les secteurs ou activités spécifiques mentionnés
- Priorise les concepts clés que quelqu'un voudrait rechercher

Réponds UNIQUEMENT avec les mots-clés séparés par des virgules, sans aucune explication.
"""
            
            try:
                # 🌟 Utiliser uniquement Gemini 2.0
                for attempt in range(MAX_RETRIES):
                    try:
                        logger.info(f"🔄 Extraction mots-clés avec Gemini (tentative {attempt+1})")
                        response_text = AIModelProcessor.get_gemini_completion(prompt)
                        break
                    except Exception as e:
                        if attempt == MAX_RETRIES - 1:
                            raise e
                        logger.warning(f"⚠️ Erreur avec Gemini: {e} (tentative {attempt+1}/{MAX_RETRIES})")
                        time.sleep(RETRY_DELAY * (attempt + 1))
                
                ai_keywords = [kw.strip() for kw in response_text.split(',') if kw.strip()]
                
                # Combiner avec les mots-clés déjà extraits
                all_keywords = searchable_keywords + ai_keywords
                
                # Supprimer les doublons
                seen = set()
                unique_keywords = []
                for kw in all_keywords:
                    if kw.lower() not in seen and len(kw) > 2:
                        seen.add(kw.lower())
                        unique_keywords.append(kw)
                
                return unique_keywords[:15]
                
            except Exception as e:
                logger.error(f"❌ Erreur lors de l'extraction des mots-clés par Gemini: {e}")
        
        return searchable_keywords if searchable_keywords else ["fiscal", "cgi"]

# 🔹 Classe pour le traitement du CGI
class CGIProcessor:
    """Classe pour le traitement des articles du CGI"""
    
    def __init__(self, data, collection_names):
        """Initialise le processeur avec les données du CGI"""
        self.data = data
        self.embedding_manager = EmbeddingManager(cache_size=500)
        self.collection_names = collection_names
        
        self.stats = {
            "total_articles": len(data),
            "processed_articles": 0,
            "split_articles": [],
            "skipped_articles": [],
            "gemini_summaries": 0,  # 🌟 Changé
            "time_started": datetime.now(),
            "tokens_total": 0,
            "tokens_avg": 0,
            "sections_count": 0
        }
        
        self.points_main = []
        self.points_parent = []
        self.points_sections = []
        
        # Dictionnaire des mots-clés enrichis par article
        self.article_keywords = {}
    
    def process_all_articles(self):
        """Traite tous les articles du CGI"""
        logger.info(f"🔄 Début du traitement de {len(self.data)} articles CGI...")
        
        self._prepare_collections()
        
        for i, item in enumerate(self.data):
            try:
                self._process_article(item)
                self.stats["processed_articles"] += 1
                
                if (i + 1) % 10 == 0 or i == len(self.data) - 1:
                    logger.info(f"✅ Progression CGI: {i+1}/{len(self.data)} articles traités ({(i+1)/len(self.data)*100:.1f}%)")
                    
            except Exception as e:
                logger.error(f"❌ Erreur lors du traitement de l'article {item.get('article', 'inconnu')}: {str(e)}")
                self.stats["skipped_articles"].append((item.get('article', 'inconnu'), str(e)))
        
        self._index_all_points()
        self._save_article_keywords()
        
        logger.info(f"✅ Traitement CGI terminé! {self.stats['processed_articles']}/{len(self.data)} articles traités avec succès.")
    
    def _prepare_collections(self):
        """Prépare les collections Qdrant nécessaires"""
        try:
            for name, collection_name in self.collection_names.items():
                logger.info(f"🔄 Préparation de la collection {collection_name}...")
                qdrant.create_collection(collection_name, vector_size=EMBEDDING_DIM, recreate=True)
            
            logger.info("✅ Collections CGI préparées avec succès")
        except Exception as e:
            logger.error(f"❌ Erreur lors de la préparation des collections: {str(e)}")
            raise
    
    def _process_article(self, item):
        """Traite un article individuel du CGI avec extraction de mots-clés améliorée"""
        article_id = str(uuid.uuid4())
        article_num = item["article"]
        contenu = item.get("contenu", "")
        
        if not contenu or not contenu.strip():
            logger.warning(f"⚠️ Article {article_num}: contenu vide, ignoré")
            self.stats["skipped_articles"].append((article_num, "contenu vide"))
            return
        
        livre = item.get("livre", "Inconnu")
        nom_livre = item.get("nom-livre", "Inconnu")
        partie = item.get("partie", "Inconnue")
        nom_partie = item.get("nom-partie", "Inconnue")
        titre = item.get("titre", "Inconnu")
        nom_titre = item.get("nom-titre", "Inconnu")
        chapitre = item.get("chapitre", "Inconnu")
        nom_chapitre = item.get("nom-chapitre", "Inconnu")
        nom_article = item.get("nom-article", "Inconnu")
        
        metadata = f"""
Livre : {livre} - {nom_livre}
Partie : {partie} - {nom_partie}
Titre : {titre} - {nom_titre}
Chapitre : {chapitre} - {nom_chapitre}
Article {article_num} : {nom_article}
"""
        
        refs = TextProcessor.extract_article_references(contenu)
        logger.info(f"📑 Article {article_num}: {len(refs)} références trouvées")
        
        # Extraction de mots-clés améliorée
        try:
            keywords = AIModelProcessor.extract_keywords(contenu, f"Article {article_num}")
            
            # Enrichir avec des synonymes
            enriched_keywords = []
            for kw in keywords:
                enriched_keywords.append(kw)
                # Ajouter des variantes si disponibles
                variants = synonym_manager.get_all_variants(kw)
                for variant in variants[:2]:  # Limiter les variantes
                    if variant not in enriched_keywords:
                        enriched_keywords.append(variant)
            
            # Stocker les mots-clés enrichis
            self.article_keywords[article_num] = enriched_keywords
            
            logger.info(f"🔑 Article {article_num}: {len(keywords)} mots-clés extraits, {len(enriched_keywords)} après enrichissement")
        except Exception as e:
            logger.warning(f"⚠️ Erreur lors de l'extraction des mots-clés pour l'article {article_num}: {e}")
            keywords = ["erreur_extraction_mots_clés"]
            enriched_keywords = keywords
        
        full_text = metadata + "\n" + contenu
        num_tokens = len(tokenizer.encode(full_text))
        self.stats["tokens_total"] += num_tokens
        
        needs_splitting = num_tokens > TOKEN_LIMIT
        
        base_payload = {
            "livre": livre,
            "nom_livre": nom_livre,
            "partie": partie,
            "nom_partie": nom_partie,
            "titre": titre,
            "nom_titre": nom_titre,
            "chapitre": chapitre,
            "nom_chapitre": nom_chapitre,
            "article": article_num,
            "nom_article": nom_article,
            "tokens": num_tokens,
            "references": refs,
            "keywords": keywords,  # Mots-clés originaux
            "enriched_keywords": enriched_keywords,  # Mots-clés enrichis avec synonymes
            "article_id": article_id,
            "type": "cgi"  # Marqueur pour identifier que c'est un article CGI
        }
        
        # Gestion des articles très longs
        if num_tokens > 8000:
            parent_text = self._create_article_summary(article_num, contenu, nom_article)
            parent_text_with_meta = metadata + "\n" + parent_text
            parent_vector = self.embedding_manager.get_embedding(parent_text_with_meta, "document")
            
            parent_payload = base_payload.copy()
            parent_payload.update({
                "contenu": contenu,
                "is_split": needs_splitting,
                "is_summarized_for_embedding": True,
                "summary": parent_text
            })
        else:
            parent_vector = self.embedding_manager.get_embedding(full_text, "document")
            
            parent_payload = base_payload.copy()
            parent_payload.update({
                "contenu": contenu,
                "is_split": needs_splitting,
                "is_summarized_for_embedding": False
            })
        
        parent_point = PointStruct(
            id=article_id,
            vector=parent_vector,
            payload=parent_payload
        )
        
        self.points_parent.append(parent_point)
        
        # Traitement des articles selon leur taille
        if needs_splitting:
            chunks = TextProcessor.split_article_text(article_num, contenu, metadata, TOKEN_LIMIT)
            
            if not chunks:
                logger.warning(f"⚠️ Article {article_num}: impossible de découper le contenu, ignoré")
                self.stats["skipped_articles"].append((article_num, "découpage impossible"))
                return
            
            for chunk_text, chunk_tokens, chunk_idx, total_chunks in chunks:
                part_info = f"Partie {chunk_idx+1}/{total_chunks}"
                
                chunk_id = str(uuid.uuid4())
                
                vector_chunk = self.embedding_manager.get_embedding(chunk_text, "document")
                
                chunk_refs = TextProcessor.extract_article_references(chunk_text)
                
                try:
                    chunk_keywords = AIModelProcessor.extract_keywords(chunk_text, f"Article {article_num} {part_info}")
                    # Enrichir les mots-clés du chunk
                    chunk_enriched_keywords = []
                    for kw in chunk_keywords:
                        chunk_enriched_keywords.append(kw)
                        variants = synonym_manager.get_all_variants(kw)
                        for variant in variants[:1]:  # Moins de variantes pour les chunks
                            if variant not in chunk_enriched_keywords:
                                chunk_enriched_keywords.append(variant)
                except Exception as e:
                    logger.warning(f"⚠️ Erreur lors de l'extraction des mots-clés pour l'article {article_num} {part_info}: {e}")
                    chunk_keywords = keywords
                    chunk_enriched_keywords = enriched_keywords
                
                chunk_point = PointStruct(
                    id=chunk_id,
                    vector=vector_chunk,
                    payload={
                        **base_payload,
                        "nom_article": f"{nom_article} ({part_info})",
                        "contenu": chunk_text,
                        "tokens": chunk_tokens,
                        "references": chunk_refs,
                        "keywords": chunk_keywords,
                        "enriched_keywords": chunk_enriched_keywords,
                        "is_split": True,
                        "split_part": chunk_idx + 1,
                        "total_parts": total_chunks,
                        "parent_id": article_id,
                    }
                )
                
                self.points_main.append(chunk_point)
                self.stats["split_articles"].append((article_num, chunk_idx + 1, total_chunks, chunk_tokens))
            
            logger.info(f"🔄 Article {article_num} découpé en {len(chunks)} parties")
            
        else:
            main_point = PointStruct(
                id=article_id,
                vector=parent_vector,
                payload={
                    **base_payload,
                    "contenu": contenu,
                    "is_split": False,
                }
            )
            
            self.points_main.append(main_point)
        
        # Extraction des sections
        try:
            sections = TextProcessor.extract_section_structure(contenu)
            
            for i, (section_title, section_text) in enumerate(sections):
                if len(section_text.strip()) < 50:
                    continue
                    
                section_id = str(uuid.uuid4())
                
                section_metadata = f"""
{metadata}
Section: {section_title}
"""
                
                section_full_text = section_metadata + "\n" + section_text
                
                vector_section = self.embedding_manager.get_embedding(section_full_text, "document")
                
                section_refs = TextProcessor.extract_article_references(section_text)
                
                # Extraire des mots-clés spécifiques à la section
                section_keywords = keyword_extractor.generate_searchable_keywords(
                    keyword_extractor.extract_enhanced_keywords(section_text, f"Article {article_num} - Section")
                )
                
                section_point = PointStruct(
                    id=section_id,
                    vector=vector_section,
                    payload={
                        **base_payload,
                        "section_title": section_title,
                        "contenu": section_text,
                        "tokens": len(tokenizer.encode(section_full_text)),
                        "references": section_refs,
                        "keywords": section_keywords,
                        "type": "section",
                        "parent_id": article_id,
                        "section_index": i
                    }
                )
                
                self.points_sections.append(section_point)
                self.stats["sections_count"] += 1
                
        except Exception as e:
            logger.warning(f"⚠️ Erreur lors de l'extraction des sections pour l'article {article_num}: {e}")
    
    def _create_article_summary(self, article_num, contenu, nom_article):
        """🌟 Crée un résumé de l'article avec Gemini pour l'embedding parent"""
        token_count = len(tokenizer.encode(contenu))
        
        if token_count > 15000:
            try:
                prompt = f"""
Ceci est l'article {article_num} du Code Général des Impôts marocain, intitulé "{nom_article}".

Génère un résumé détaillé de ce texte juridique en 4000 tokens maximum, qui préserve:
- Tous les taux et montants
- Toutes les conditions spécifiques
- Toutes les références à d'autres articles
- Tous les cas particuliers et exceptions
- La structure logique du texte original

Voici le texte à résumer (texte tronqué si très long):
{contenu[:25000] + "..." if len(contenu) > 25000 else contenu}
"""
                
                # 🌟 Utiliser Gemini 2.0 au lieu de GPT
                rate_limiter.check_and_wait(KEYWORD_MODEL)
                
                generation_config = {
                    "temperature": 0.1,
                    "top_p": 1,
                    "top_k": 1,
                    "max_output_tokens": 4000,
                }
                
                model = genai.GenerativeModel(KEYWORD_MODEL)
                response = model.generate_content(prompt, generation_config=generation_config)
                
                summary = response.text.strip()
                
                final_summary = f"RÉSUMÉ GÉNÉRÉ DE L'ARTICLE {article_num}:\n\n{summary}\n\n[Article complet disponible dans les données complètes]"
                
                self.stats["gemini_summaries"] += 1
                
                logger.info(f"✅ Article {article_num}: Résumé généré avec Gemini ({len(tokenizer.encode(final_summary))} tokens)")
                return final_summary
                
            except Exception as e:
                logger.warning(f"⚠️ Erreur lors de la génération du résumé pour l'article {article_num}: {str(e)}")
        
        if token_count > 16000:
            start = contenu[:4000]
            
            middle_segments = []
            total_segments = 3
            for i in range(total_segments):
                segment_start = int((i + 1) * len(contenu) / (total_segments + 2))
                segment_end = segment_start + 1000
                if segment_end > len(contenu):
                    segment_end = len(contenu)
                middle_segments.append(contenu[segment_start:segment_end])
            
            middle = "\n\n[...]\n\n".join(middle_segments)
            end = contenu[-4000:]
            
            summary = f"{start}\n\n[...CONTENU TRONQUÉ...]\n\n{middle}\n\n[...CONTENU TRONQUÉ...]\n\n{end}"
        else:
            start = contenu[:6000]
            end = contenu[-4000:]
            summary = f"{start}\n\n[...CONTENU TRONQUÉ...]\n\n{end}"
        
        return summary
    
    def _index_all_points(self):
        """Indexe tous les points dans leurs collections respectives"""
        logger.info(f"🔄 Indexation de {len(self.points_main)} articles principaux CGI...")
        success_main, failed_main = qdrant.upsert_batch(
            self.collection_names["main"], 
            self.points_main,
            show_progress=True
        )
        
        logger.info(f"🔄 Indexation de {len(self.points_parent)} articles parents CGI...")
        success_parent, failed_parent = qdrant.upsert_batch(
            self.collection_names["parent"], 
            self.points_parent,
            show_progress=True
        )
        
        logger.info(f"🔄 Indexation de {len(self.points_sections)} sections CGI...")
        success_sections, failed_sections = qdrant.upsert_batch(
            self.collection_names["sections"], 
            self.points_sections,
            show_progress=True
        )
        
        logger.info(f"""
✅ Indexation CGI terminée:
- Collection principale: {success_main}/{len(self.points_main)} points indexés
- Collection parents: {success_parent}/{len(self.points_parent)} points indexés
- Collection sections: {success_sections}/{len(self.points_sections)} points indexés
""")
    
    def _save_article_keywords(self):
        """Enregistre les mots-clés enrichis des articles"""
        try:
            if not os.path.exists("resultats"):
                os.makedirs("resultats")
            
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            
            # Sauvegarder les mots-clés enrichis
            keywords_file = f"resultats/CGI_2025_keywords_enriched_{timestamp}.json"
            with open(keywords_file, "w", encoding="utf-8") as f:
                json.dump(self.article_keywords, f, ensure_ascii=False, indent=2)
            
            logger.info(f"✅ Mots-clés CGI enregistrés dans {keywords_file}")
            
            # Enregistrer les statistiques
            stats_file = f"resultats/statistiques_cgi_{timestamp}.json"
            with open(stats_file, "w", encoding="utf-8") as f:
                serializable_stats = {k: (v.isoformat() if isinstance(v, datetime) else v) for k, v in self.stats.items()}
                json.dump(serializable_stats, f, ensure_ascii=False, indent=2)
            
            logger.info(f"✅ Statistiques CGI enregistrées dans {stats_file}")
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de l'enregistrement des résultats CGI: {str(e)}")
    
    def get_stats(self):
        """Retourne les statistiques de traitement"""
        return self.stats

# 🔹 Classe pour le traitement de l'annexe
class AnnexeProcessor:
    """Classe pour le traitement des documents annexes"""
    
    def __init__(self, data, collection_name):
        """Initialise le processeur avec les données de l'annexe"""
        self.data = data
        self.embedding_manager = EmbeddingManager(cache_size=300)
        self.collection_name = collection_name
        
        self.stats = {
            "total_documents": len(data),
            "processed_documents": 0,
            "skipped_documents": [],
            "time_started": datetime.now(),
            "tokens_total": 0,
            "tokens_avg": 0
        }
        
        self.points = []
        self.document_keywords = {}
    
    def process_all_documents(self):
        """Traite tous les documents de l'annexe"""
        logger.info(f"🔄 Début du traitement de {len(self.data)} documents annexes...")
        
        self._prepare_collection()
        
        for i, item in enumerate(self.data):
            try:
                self._process_document(item, i)
                self.stats["processed_documents"] += 1
                
                if (i + 1) % 10 == 0 or i == len(self.data) - 1:
                    logger.info(f"✅ Progression Annexe: {i+1}/{len(self.data)} documents traités ({(i+1)/len(self.data)*100:.1f}%)")
                    
            except Exception as e:
                logger.error(f"❌ Erreur lors du traitement du document {i}: {str(e)}")
                self.stats["skipped_documents"].append((i, str(e)))
        
        self._index_all_points()
        self._save_document_keywords()
        
        logger.info(f"✅ Traitement Annexe terminé! {self.stats['processed_documents']}/{len(self.data)} documents traités avec succès.")
    
    def _prepare_collection(self):
        """Prépare la collection Qdrant pour l'annexe"""
        try:
            logger.info(f"🔄 Préparation de la collection {self.collection_name}...")
            qdrant.create_collection(self.collection_name, vector_size=EMBEDDING_DIM, recreate=True)
            logger.info("✅ Collection Annexe préparée avec succès")
        except Exception as e:
            logger.error(f"❌ Erreur lors de la préparation de la collection annexe: {str(e)}")
            raise
    
    def _process_document(self, item, doc_index):
        """Traite un document annexe individuel"""
        doc_id = str(uuid.uuid4())
        
        # Extraire les informations du document
        titre = item.get("titre", "")
        contenu = item.get("contenu", "")
        source = item.get("source", "")
        type_doc = item.get("type", "")
        articles_lies = item.get("article", [])  # Liste des articles CGI liés
        
        if not contenu or not contenu.strip():
            logger.warning(f"⚠️ Document {doc_index}: contenu vide, ignoré")
            self.stats["skipped_documents"].append((doc_index, "contenu vide"))
            return
        
        # Déterminer le type de document et extraire les infos
        doc_info = self._extract_document_info(type_doc, titre, contenu)
        
        # Créer le texte pour l'embedding enrichi avec synonymes
        text_parts = [
            f"Type de document: {doc_info['type']}",
            f"Numéro: {doc_info['numero']}",
            f"Date: {doc_info['date']}",
            f"Objet: {titre}",
            f"Articles CGI concernés: {', '.join(str(art) for art in articles_lies)}",
            f"Contenu: {contenu}"
        ]
        
        full_text = "\n".join(text_parts)
        
        # Vérifier la longueur
        token_count = len(tokenizer.encode(full_text))
        if token_count > 8000:
            logger.warning(f"⚠️ Document {doc_index}: trop long ({token_count} tokens), troncature")
            content_tokens = tokenizer.encode(contenu)
            truncated_content = tokenizer.decode(content_tokens[:7000])
            text_parts[-1] = f"Contenu: {truncated_content}... [TRONQUÉ]"
            full_text = "\n".join(text_parts)
            token_count = len(tokenizer.encode(full_text))
        
        # Extraire les mots-clés avec enrichissement
        try:
            keywords = AIModelProcessor.extract_keywords(contenu, titre)
            
            # Enrichir avec des synonymes
            enriched_keywords = []
            for kw in keywords:
                enriched_keywords.append(kw)
                variants = synonym_manager.get_all_variants(kw)
                for variant in variants[:2]:
                    if variant not in enriched_keywords:
                        enriched_keywords.append(variant)
            
            # Ajouter les numéros d'articles comme mots-clés
            for art in articles_lies:
                art_str = str(art)
                if art_str not in enriched_keywords:
                    enriched_keywords.append(f"article {art_str}")
            
            self.document_keywords[doc_id] = enriched_keywords
            
            logger.info(f"🔑 Document {doc_index}: {len(keywords)} mots-clés extraits, {len(enriched_keywords)} après enrichissement")
        except Exception as e:
            logger.warning(f"⚠️ Erreur lors de l'extraction des mots-clés pour le document {doc_index}: {e}")
            keywords = []
            enriched_keywords = []
        
        # Générer l'embedding
        vector = self.embedding_manager.get_embedding(full_text, "document")
        
        # Créer le point Qdrant
        point = PointStruct(
            id=doc_id,
            vector=vector,
            payload={
                "type": doc_info["type"],
                "numero": doc_info["numero"],
                "date": doc_info["date"],
                "objet": titre,
                "contenu": contenu,
                "articles_lies": articles_lies,  # IMPORTANT: Articles CGI liés
                "text_for_search": full_text,
                "keywords": keywords,
                "enriched_keywords": enriched_keywords,
                "token_count": token_count,
                "doc_index": doc_index,
                "source": source,
                "type_original": type_doc,
                "created_at": datetime.now().isoformat()
            }
        )
        
        self.points.append(point)
        self.stats["tokens_total"] += token_count
        
        logger.info(f"✅ Document {doc_index} traité: {doc_info['type']} n°{doc_info['numero']} ({doc_info['date']}) - Articles: {articles_lies}")
    
    def _extract_document_info(self, type_original, titre, contenu):
        """Extrait les informations structurées du document"""
        doc_info = {
            "type": "document",
            "numero": "",
            "date": ""
        }
        
        # Analyser le type original
        if "Note Circulaire" in type_original:
            doc_info["type"] = "note_circulaire"
            # Extraire le numéro
            numero_match = re.search(r'n°\s*(\d+)', type_original)
            if numero_match:
                doc_info["numero"] = numero_match.group(1)
        elif "décret" in type_original.lower():
            doc_info["type"] = "décret"
            # Extraire le numéro du décret
            numero_match = re.search(r'(\d+-\d+-\d+)', contenu + titre)
            if numero_match:
                doc_info["numero"] = numero_match.group(1)
        elif "note_de_service" in type_original.lower():
            doc_info["type"] = "note_service"
            doc_info["numero"] = "DGI"
        elif "circulaire" in type_original.lower():
            doc_info["type"] = "circulaire"
            numero_match = re.search(r'n°\s*(\d+)', type_original)
            if numero_match:
                doc_info["numero"] = numero_match.group(1)
        
        # Extraire la date
        for year in range(2025, 2015, -1):
            if str(year) in type_original or str(year) in titre or str(year) in contenu[:200]:
                doc_info["date"] = str(year)
                break
        
        return doc_info
    
    def _index_all_points(self):
        """Indexe tous les points dans la collection annexe"""
        if self.points:
            logger.info(f"🔄 Indexation de {len(self.points)} documents annexes...")
            
            success, failed = qdrant.upsert_batch(
                self.collection_name,
                self.points,
                batch_size=10,
                show_progress=True
            )
            
            logger.info(f"✅ Indexation Annexe terminée: {success}/{len(self.points)} documents indexés")
            
            # Vérification finale
            try:
                collection_info = qdrant.client.get_collection(self.collection_name)
                logger.info(f"✅ Collection {self.collection_name}: {collection_info.points_count} documents indexés")
            except Exception as e:
                logger.error(f"❌ Erreur vérification collection annexe: {str(e)}")
    
    def _save_document_keywords(self):
        """Enregistre les mots-clés des documents annexes"""
        try:
            if not os.path.exists("resultats"):
                os.makedirs("resultats")
            
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            
            # Sauvegarder les mots-clés
            keywords_file = f"resultats/Annexe_keywords_enriched_{timestamp}.json"
            with open(keywords_file, "w", encoding="utf-8") as f:
                json.dump(self.document_keywords, f, ensure_ascii=False, indent=2)
            
            logger.info(f"✅ Mots-clés Annexe enregistrés dans {keywords_file}")
            
            # Enregistrer les statistiques
            if self.stats["processed_documents"] > 0:
                self.stats["tokens_avg"] = self.stats["tokens_total"] / self.stats["processed_documents"]
            
            stats_file = f"resultats/statistiques_annexe_{timestamp}.json"
            with open(stats_file, "w", encoding="utf-8") as f:
                serializable_stats = {k: (v.isoformat() if isinstance(v, datetime) else v) for k, v in self.stats.items()}
                json.dump(serializable_stats, f, ensure_ascii=False, indent=2)
            
            logger.info(f"✅ Statistiques Annexe enregistrées dans {stats_file}")
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de l'enregistrement des résultats annexe: {str(e)}")
    
    def get_stats(self):
        """Retourne les statistiques de traitement"""
        return self.stats

# 🔹 Fonction principale unifiée
def main():
    """Fonction principale du script unifié CGI + Annexe"""
    logger.info("🚀 Démarrage du processus d'embedding unifié CGI + Annexe avec Voyage-law-2...")
    
    # Traiter le CGI
    try:
        logger.info("\n" + "="*60)
        logger.info("📚 PHASE 1: TRAITEMENT DU CGI")
        logger.info("="*60)
        
        with open("cgi_2025_finetune_fixed.json", "r", encoding="utf-8") as f:
            cgi_data = json.load(f)
        
        logger.info(f"✅ Données CGI chargées: {len(cgi_data)} articles trouvés")
        
        cgi_processor = CGIProcessor(cgi_data, {
            "main": "cgi_mainvoyage",
            "parent": "cgi_article_parentvoyage",
            "sections": "cgi_sectionsvoyage"
        })
        
        cgi_processor.process_all_articles()
        cgi_stats = cgi_processor.get_stats()
        
    except Exception as e:
        logger.error(f"❌ Erreur lors du traitement du CGI: {str(e)}")
        return
    
    # Traiter l'annexe
    try:
        logger.info("\n" + "="*60)
        logger.info("📋 PHASE 2: TRAITEMENT DE L'ANNEXE")
        logger.info("="*60)
        
        with open("notecirculaire_fixed_cleaned_analyzed.json", "r", encoding="utf-8") as f:
            annexe_data = json.load(f)
        
        logger.info(f"✅ Données Annexe chargées: {len(annexe_data)} documents trouvés")
        
        annexe_processor = AnnexeProcessor(annexe_data, "cgi_annexevoyage")
        annexe_processor.process_all_documents()
        annexe_stats = annexe_processor.get_stats()
        
    except Exception as e:
        logger.error(f"❌ Erreur lors du traitement de l'annexe: {str(e)}")
        return
    
    # Afficher le rapport final
    logger.info("\n" + "="*60)
    logger.info("📊 RAPPORT FINAL")
    logger.info("="*60)
    
    logger.info(f"""
🔹 CGI:
- Articles traités: {cgi_stats["processed_articles"]}/{cgi_stats["total_articles"]}
- Articles découpés: {len(cgi_stats["split_articles"])}
- Sections extraites: {cgi_stats["sections_count"]}
- Temps d'exécution: {((datetime.now() - cgi_stats["time_started"]).total_seconds() / 60):.1f} minutes

🔹 ANNEXE:
- Documents traités: {annexe_stats["processed_documents"]}/{annexe_stats["total_documents"]}
- Tokens moyens: {annexe_stats.get("tokens_avg", 0):.1f}
- Temps d'exécution: {((datetime.now() - annexe_stats["time_started"]).total_seconds() / 60):.1f} minutes

✅ Traitement terminé avec succès!
""")
    
    # Afficher les statistiques d'embedding
    embedding_stats = cgi_processor.embedding_manager.get_stats()
    logger.info(f"""
🔹 Performance du système d'embedding (Voyage-law-2):
- Requêtes totales: {embedding_stats["total_requests"]}
- Taux de cache: {embedding_stats["hit_rate"]:.1f}%
- Textes tronqués: {embedding_stats["truncations"]}
- Résumés Gemini: {embedding_stats["gemini_summaries"]}
- Dimension des vecteurs: {embedding_stats["vector_dimension"]}
""")

if __name__ == "__main__":
    main()