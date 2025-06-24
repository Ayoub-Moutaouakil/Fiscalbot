import streamlit as st
import qdrant_client
from qdrant_client.models import Filter, FieldCondition, MatchValue, MatchAny
import google.generativeai as genai
from datetime import datetime, timedelta
import re
from concurrent.futures import ThreadPoolExecutor
from typing import List, Dict, Any, Optional, Tuple
import json
import voyageai
import psycopg2
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Configuration de la page
st.set_page_config(
    page_title="FISCALBOT 3.0 - Assistant Fiscal CGI Excellence",
    page_icon="🏆",
    layout="wide"
)

GEMINI_API_KEY = "AIzaSyDmG5LqJhaAthC8GrgjE9eIdHcWSNQJTmE"
VOYAGE_API_KEY = "pa-gPu9JZffTtb0O57mU8ZNtCzWBrQ7dDRy_7M_f6Cr8br"

genai.configure(api_key=GEMINI_API_KEY)
voyage_client = voyageai.Client(api_key=VOYAGE_API_KEY)
qdrant_client_main = qdrant_client.QdrantClient(host="13.39.82.37", port=6333)

# ===== CLASSE DATABASE COMPLÈTE =====
class Database:
    def __init__(self):
        self.conn = None
        self.cur = None
        self.connect()
        self.create_tables()
    
    def connect(self):
        try:
            self.conn = psycopg2.connect(
                host="aws-0-eu-west-3.pooler.supabase.com",
                port="6543",
                database="postgres",
                user="postgres.hhgbwbmfmkpzumlvwsfi",
                password="8-fJh4+&qh73uHK"
            )
            self.cur = self.conn.cursor()
            return True
        except Exception as e:
            st.error(f"Erreur de connexion à la base de données: {str(e)}")
            return False
    
    def create_tables(self):
        try:
            self.cur.execute("""
            CREATE TABLE IF NOT EXISTS conversations (
                id SERIAL PRIMARY KEY,
                question TEXT NOT NULL,
                response TEXT NOT NULL,
                articles JSONB,
                feedback_type VARCHAR(20),
                feedback_comment TEXT,
                search_method VARCHAR(50),
                semantic_score FLOAT,
                query_complexity FLOAT,
                execution_time FLOAT,
                model_used VARCHAR(50),
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """)
            
            self.conn.commit()
            return True
        except Exception as e:
            st.error(f"Erreur lors de la création des tables: {str(e)}")
            return False
    
    def save_conversation(self, question, response, articles, search_method=None, 
                         semantic_score=None, query_complexity=None, execution_time=None,
                         model_used=None, feedback_type=None, feedback_comment=None):
        try:
            articles_json = json.dumps(articles)
            
            self.cur.execute("""
            INSERT INTO conversations (
                question, response, articles, search_method, semantic_score, 
                query_complexity, execution_time, model_used, feedback_type, feedback_comment
            ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING id
            """, (
                question, response, articles_json, search_method, semantic_score,
                query_complexity, execution_time, model_used, feedback_type, feedback_comment
            ))
            
            conversation_id = self.cur.fetchone()[0]
            self.conn.commit()
            return conversation_id
        except Exception as e:
            st.error(f"Erreur lors de l'enregistrement de la conversation: {str(e)}")
            return None
    
    def update_feedback(self, conversation_id, feedback_type, feedback_comment):
        try:
            self.cur.execute("""
            UPDATE conversations 
            SET feedback_type = %s, feedback_comment = %s 
            WHERE id = %s
            """, (feedback_type, feedback_comment, conversation_id))
            self.conn.commit()
            return True
        except Exception as e:
            st.error(f"Erreur lors de la mise à jour du feedback: {str(e)}")
            return False
    
    def get_feedback_stats(self):
        try:
            if self.conn.closed or self.cur.closed:
                self.connect()
                
            self.cur.execute("""
            SELECT 
                COALESCE(feedback_type, 'sans_feedback') as type,
                COUNT(*) as count
            FROM conversations
            GROUP BY feedback_type
            """)
            
            results = self.cur.fetchall()
            return results
        except Exception as e:
            st.error(f"Erreur lors de la récupération des statistiques de feedback: {str(e)}")
            return []

    def is_connected(self):
        try:
            if self.conn and not self.conn.closed:
                self.cur.execute("SELECT 1")
                return True
            return False
        except:
            return False

    def get_conversation_history(self, feedback_type="all", limit=10, offset=0):
        """Récupère l'historique des conversations avec filtrage par type de feedback"""
        try:
            query = """
            SELECT 
                id,
                question,
                response,
                feedback_type,
                feedback_comment,
                timestamp
            FROM conversations
            """
            
            params = []
            
            # Ajouter la condition de filtrage si nécessaire
            if feedback_type != "all":
                if feedback_type is None:
                    query += " WHERE feedback_type IS NULL"
                else:
                    query += " WHERE feedback_type = %s"
                    params.append(feedback_type)
                    
            query += " ORDER BY timestamp DESC LIMIT %s OFFSET %s"
            params.extend([limit, offset])
            
            self.cur.execute(query, params)
            
            results = self.cur.fetchall()
            return results
        except Exception as e:
            st.error(f"Erreur lors de la récupération de l'historique: {str(e)}")
            return []
    
    def close(self):
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()

# Initialiser la base de données
@st.cache_resource
def get_database():
    db = Database()
    if db.conn is None or db.cur is None or db.conn.closed:
        db.connect()
    return db

db = get_database()

# 🌟 Système de synonymes fiscaux intégré
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
                         "polypropylène", "matériaux plastiques", "industrie plastique",
                         "industrie du plastique", "produits en plastique"],
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
            "crédit-bail": ["leasing", "location avec option d'achat", "LOA"],
            "représentation": ["indemnité de représentation", "frais de représentation", "prime de représentation"]
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

# Initialiser le gestionnaire de synonymes
synonym_manager = FiscalSynonymManager()


class FiscalBotExcellence:
    """Chatbot fiscal d'excellence avec recherche optimisée et expertise CGI maximale"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client_main
        self.synonym_manager = synonym_manager
        self.db = db  # Utiliser la base de données
        
        # Collections avec noms corrects - ANNEXE OPTIMISÉE
        self.collections = {
            "main": "cgi_mainvoyage",
            "parent": "cgi_article_parentvoyage", 
            "sections": "cgi_sectionsvoyage",
            "annexe": "cgi_annexe_optimized"  # 🔄 NOUVELLE COLLECTION OPTIMISÉE
        }
        
        # Configuration optimisée pour l'excellence
        self.config = {
            "annexe_score_threshold": 0.05,  # Seuil TRÈS BAS pour capturer plus d'annexes
            "annexe_search_limit": 20,       # Plus de résultats pour mieux filtrer
            "main_search_threshold": 0.08,   # Seuil très bas pour ne rien manquer
            "semantic_search_limit": 12,     # Plus de résultats sémantiques
            "section_search_limit": 5        # Recherche dans les sections aussi
        }
        
        # Logs de debug
        self.debug_logs = []
        
        # Système d'intelligence conversationnelle
        self.conversation_patterns = {
            "greetings": [
                "bonjour", "bonsoir", "salut", "hello", "hey", "coucou", "bonne journée"
            ],
            "presentation_request": [
                "présente toi", "qui es tu", "que fais tu", "présentation", "qui êtes vous"
            ],
            "help_request": [
                "aide", "help", "comment ça marche", "utilisation", "guide", "comment faire"
            ],
            "goodbye": [
                "au revoir", "bye", "à bientôt", "merci", "bonne journée", "salut"
            ]
        }
        
        # Contexte de conversation optimisé
        self.conversation_context = {
            "last_question": "",
            "last_response": "",
            "last_articles": [],
            "last_search_results": [],
            "waiting_for_clarification": False,
            "context_articles": [],
            "context_topic": "",
            "user_name": None,
            "conversation_started": False,
            "search_history": []  # Historique des recherches pour amélioration continue
        }
    
    def log_debug(self, message: str):
        """Ajoute un message aux logs de debug avec timestamp"""
        timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        self.debug_logs.append(f"[{timestamp}] {message}")
    
    def clear_debug_logs(self):
        """Efface les logs de debug"""
        self.debug_logs = []
    
    def get_debug_logs(self) -> List[str]:
        """Retourne les logs de debug"""
        return self.debug_logs
    
    # Détection d'intention conversationnelle
    def detect_conversation_intent(self, query: str) -> str:
        """Détecte l'intention conversationnelle de l'utilisateur"""
        query_lower = query.lower().strip()
        
        # Extraction du nom si présent
        name_patterns = [
            r"je suis ([a-zA-ZÀ-ÿ\s]+)",
            r"je m'appelle ([a-zA-ZÀ-ÿ\s]+)",
            r"mon nom est ([a-zA-ZÀ-ÿ\s]+)"
        ]
        
        for pattern in name_patterns:
            match = re.search(pattern, query_lower)
            if match:
                self.conversation_context["user_name"] = match.group(1).strip().title()
        
        # NOUVEAU: Détecter les nombres simples comme articles
        # Si la requête ne contient qu'un ou plusieurs nombres
        if re.match(r'^[\d\s,]+$', query.strip()):
            return "fiscal_question"
        
        # IMPORTANT: Vérifier d'abord si c'est une question fiscale
        fiscal_keywords = [
            "impôt", "taxe", "tva", "ir", "is", "cgi", "article", "exonération", 
            "déduction", "société", "revenus", "bénéfices", "déclaration", "poisson",
            "viande", "légumes", "fruits", "agriculture", "export", "import",
            "plafond", "indemnité", "revenu", "charge", "fiscal", "contribuable",
            "assujetti", "redevable", "cotisation", "base imposable", "plastiqu",
            "industrie", "exonéré", "sociétés", "kinésithérapeute", "médecin",
            "minimum", "minimale", "assiette", "véhicule", "voiture", "amortissement",
            "crédit-bail", "leasing", "transport", "représentation"
        ]
        
        if any(keyword in query_lower for keyword in fiscal_keywords):
            return "fiscal_question"
        
        # Ensuite seulement, vérifier les intentions conversationnelles
        for intent, patterns in self.conversation_patterns.items():
            if intent == "presentation_request":
                if any(f"{pattern}" in query_lower and 
                       not any(fiscal in query_lower for fiscal in ["indemnité", "représentation", "impôt"]) 
                       for pattern in patterns):
                    return intent
            else:
                if any(pattern in query_lower for pattern in patterns):
                    return intent
        
        # Questions courtes qui pourraient être des clarifications
        if len(query.split()) <= 5 and self.conversation_context["waiting_for_clarification"]:
            return "clarification"
        
        return "general_question"
    
    # Réponses conversationnelles intelligentes
    def generate_conversational_response(self, query: str, intent: str) -> str:
        """Génère des réponses conversationnelles intelligentes"""
        
        user_name = self.conversation_context.get("user_name", "")
        name_part = f" {user_name}" if user_name else ""
        
        if intent == "greetings":
            if not self.conversation_context["conversation_started"]:
                self.conversation_context["conversation_started"] = True
                return f"""Bonjour{name_part} ! 👋

Je suis **AhmedTax 3.0**, votre assistant fiscal d'excellence spécialisé dans le Code Général des Impôts marocain 2025.

🏆 **Version Excellence avec :**
• Recherche sémantique enrichie par synonymes
• Accès complet aux articles CGI et documents annexes
• Réponses directes sans répétitions inutiles
• Détection intelligente des concepts fiscaux

🎯 **Je peux vous aider avec :**
• Impôt sur les Sociétés (IS)
• Impôt sur le Revenu (IR) 
• Taxe sur la Valeur Ajoutée (TVA)
• Cotisation minimale et bases d'imposition
• Exonérations et régimes fiscaux
• Amortissements et véhicules de transport

💡 **Exemples de questions :**
• "Le poisson frais est-il soumis à la TVA ?"
• "Quelle est la base de la cotisation minimale ?"
• "Quel est le nouveau plafond d'amortissement des véhicules ?"
• "Les kinésithérapeutes sont-ils exonérés de TVA ?"
• "10-III" pour voir la partie III de l'article 10
• "144" pour consulter l'article 144

Comment puis-je vous assister aujourd'hui ?"""
            else:
                return f"Rebonjour{name_part} ! Comment puis-je vous aider avec vos questions fiscales ?"
        
        elif intent == "presentation_request":
            return f"""Je suis **AhmedTax 3.0**, votre expert fiscal numérique d'excellence ! 🇲🇦

📚 **Ma spécialité :**
Assistant IA de dernière génération spécialisé dans le Code Général des Impôts marocain (édition 2025), avec accès complet aux textes d'application, circulaires et notes.




🔍 **Recherche intelligente :**
Je trouve automatiquement les variantes de vos termes : "véhicule" → "voiture", "automobile" ; "crédit-bail" → "leasing", etc.

Que souhaitez-vous savoir sur la fiscalité marocaine ?"""
        
        elif intent == "help_request":
            return f"""🆘 **Guide d'utilisation Excellence de FiscalBot{name_part}**

**Types de questions optimales :**

🎯 **Questions générales :**
• "Qu'est-ce que la cotisation minimale ?"
• "Comment fonctionne l'amortissement des véhicules ?"
• "Quelles sont les exonérations de TVA ?"

📖 **Consultation d'articles :**
• "Article 10 du CGI"
• "Article 144 sur la cotisation minimale"
• "Article premier"
• "10-III" pour la partie III de l'article 10
• Juste "144" ou "10" pour consulter directement

🔍 **Questions spécifiques :**
• "Le poisson frais est-il soumis à la TVA ?" 
• "Quel est le nouveau plafond d'amortissement des véhicules en 2025 ?"
• "Une entreprise de plastique bénéficie-t-elle d'exonérations ?"
• "Les kinésithérapeutes sont-ils exonérés de TVA ?"

🚀 **Fonctionnalités avancées :**
• **Recherche enrichie** : Je trouve automatiquement les synonymes
• **Documents liés** : Je récupère les circulaires et notes liées aux articles
• **Contexte intelligent** : Je comprends les questions de suivi
• **Analyse croisée** : Je combine CGI et textes d'application

💡 **Conseils pour l'excellence :**
✅ Utilisez des termes naturels (voiture, leasing, etc.)
✅ Posez des questions directes et claires
✅ N'hésitez pas à demander des précisions
✅ Exploitez les questions de suivi

🔄 **Exemple de conversation :**
1. "Amortissement des voitures ?"
2. "Et pour le crédit-bail ?"
3. "Montrez-moi la circulaire"

Prêt pour une expérience fiscale d'excellence ? Posez votre question !"""
        
        elif intent == "goodbye":
            return f"""Au revoir{name_part} ! 👋

J'espère avoir pu vous apporter une assistance fiscale d'excellence. 

🔖 **Points clés à retenir :**
• Les informations fournies sont basées sur le CGI 2025 et ses textes d'application
• Consultez toujours un expert-comptable pour valider vos décisions
• Les circulaires et notes peuvent apporter des précisions importantes
• Gardez une trace de nos échanges pour vos dossiers

Merci d'avoir utilisé AhmedTax 3.0 - Votre partenaire fiscal d'excellence ! 🇲🇦

À bientôt pour de nouvelles questions fiscales !"""
        
        else:
            return None
    
    # Méthode d'embedding optimisée SANS CACHE
    def get_embedding(self, text):
        """Génère un embedding avec Voyage Law-2 et enrichissement par synonymes"""
        # Enrichir le texte avec des synonymes
        enriched_text = self.synonym_manager.expand_query(text)
        
        # Utiliser Voyage Law-2 directement sans cache
        result = voyage_client.embed(
            [enriched_text], 
            model="voyage-law-2",
            input_type="query"  # Important: "query" pour les recherches utilisateur
        )
        
        embedding = result.embeddings[0]
        return embedding
    
    # Extraction d'articles AMÉLIORÉE avec gestion des formats complexes
    def _extract_articles_from_query(self, query):
        """Extrait les numéros d'articles mentionnés dans la question"""
        articles = []
        
        # NOUVEAU: Détecter les nombres simples comme articles
        # Si la requête ne contient que des nombres
        simple_numbers = re.findall(r'\b\d+\b', query)
        if re.match(r'^[\d\s,]+$', query.strip()):
            # C'est juste des nombres, les traiter comme des articles
            articles.extend(simple_numbers)
            self.log_debug(f"Nombres simples détectés comme articles: {simple_numbers}")
            return articles
        
        # Patterns améliorés pour gérer tous les formats
        patterns = [
            # NOUVEAU: Format avec parties romaines (Article 10-III)
            r'article\s+(\d+)\s*-\s*([IVX]+)',
            r'art\.?\s*(\d+)\s*-\s*([IVX]+)',
            r'(\d+)\s*-\s*([IVX]+)',
            # Format complexe: 10(I-F-1°-b)
            r'article\s+(\d+\s*\([^)]+\))',
            r'art\.?\s*(\d+\s*\([^)]+\))',
            # Formats standards
            r'article\s+(\d+)',
            r'art\.?\s*(\d+)',
            r"l'article\s+(\d+)",
            r'articles?\s+(\d+)',
            r'art\s+(\d+)',
            r'(\d+)\s*(?:du\s+)?(?:cgi|code)',
            r'(?:selon|conformément|aux?\s+termes?\s+de)\s+l\'?article\s+(\d+)',
            r'article\s+(premier)',
        ]
        
        query_lower = query.lower()
        
        # Traiter les formats avec parties romaines
        for pattern in patterns[:3]:
            matches = re.findall(pattern, query_lower)
            for match in matches:
                if isinstance(match, tuple) and len(match) == 2:
                    # Format Article 10-III
                    article_num = match[0]
                    roman_part = match[1].upper()
                    normalized = f"{article_num}-{roman_part}"
                    if normalized not in articles:
                        articles.append(normalized)
                    # Ajouter aussi le numéro de base
                    if article_num not in articles:
                        articles.append(article_num)
        
        # Traiter les autres formats
        for pattern in patterns[3:]:
            matches = re.findall(pattern, query_lower)
            for match in matches:
                if match:
                    # Normaliser le format
                    normalized = match.replace(" ", "")
                    if normalized not in articles:
                        articles.append(normalized)
                    
                    # Si format complexe, extraire aussi le numéro de base
                    if '(' in normalized:
                        base_num = normalized.split('(')[0]
                        if base_num not in articles:
                            articles.append(base_num)
        
        if articles:
            self.log_debug(f"Articles extraits de '{query}': {articles}")
        
        return articles
    
    # RECHERCHE CGI EXCELLENCE avec gestion des parties d'articles
    def search_cgi_articles(self, query, limit=8):
        """Recherche CGI d'excellence avec recherche dans toutes les collections"""
        
        all_results = {}
        
        # 1. Recherche directe par articles mentionnés (priorité absolue)
        query_articles = self._extract_articles_from_query(query)
        
        if query_articles:
            self.log_debug(f"🎯 Articles détectés: {query_articles}")
            
            for article_num in query_articles:
                try:
                    # Gérer les formats avec parties romaines (10-III)
                    if '-' in article_num and any(char in article_num for char in 'IVX'):
                        base_article = article_num.split('-')[0]
                        roman_part = article_num.split('-')[1]
                        
                        # Rechercher d'abord l'article de base
                        filter_condition = Filter(
                            must=[
                                FieldCondition(
                                    key="article",
                                    match=MatchValue(value=base_article)
                                )
                            ]
                        )
                        
                        # Rechercher dans toutes les collections CGI
                        for collection_name in ["main", "parent", "sections"]:
                            if collection_name in self.collections:
                                try:
                                    results = self.qdrant_client.search(
                                        collection_name=self.collections[collection_name],
                                        query_vector=[0.0] * 1024,  # Voyage-law-2 uses 1024 dimensions
                                        query_filter=filter_condition,
                                        limit=10  # Plus de résultats pour trouver la bonne partie
                                    )
                                    
                                    for result in results:
                                        content = result.payload.get("contenu", "")
                                        # Vérifier si la partie romaine est dans le contenu
                                        if roman_part in content.upper() or f"-{roman_part}" in content.upper():
                                            # Score très élevé pour match exact avec partie
                                            all_results[result.id] = (result, 1.0, collection_name, roman_part)
                                            self.log_debug(f"✅ Article {article_num} partie {roman_part} trouvé")
                                        else:
                                            # Ajouter quand même mais avec score plus bas
                                            all_results[result.id] = (result, 0.95, collection_name, None)
                                    
                                except Exception as e:
                                    self.log_debug(f"❌ Erreur {collection_name}: {str(e)}")
                                    continue
                    else:
                        # Recherche normale pour les articles sans parties
                        filter_condition = Filter(
                            must=[
                                FieldCondition(
                                    key="article",
                                    match=MatchValue(value=article_num)
                                )
                            ]
                        )
                        
                        # Rechercher dans toutes les collections CGI
                        for collection_name in ["main", "parent", "sections"]:
                            if collection_name in self.collections:
                                try:
                                    results = self.qdrant_client.search(
                                        collection_name=self.collections[collection_name],
                                        query_vector=[0.0] * 1024,  # Voyage-law-2 uses 1024 dimensions
                                        query_filter=filter_condition,
                                        limit=5
                                    )
                                    
                                    for result in results:
                                        # Score très élevé pour match exact d'article
                                        all_results[result.id] = (result, 0.99, collection_name, None)
                                    
                                    if results and collection_name != "sections":
                                        self.log_debug(f"✅ Article {article_num} trouvé dans {collection_name}")
                                        break
                                except Exception as e:
                                    self.log_debug(f"❌ Erreur {collection_name}: {str(e)}")
                                    continue
                    
                except Exception as e:
                    self.log_debug(f"❌ Erreur article {article_num}: {str(e)}")
        
        # 2. Recherche sémantique enrichie avec synonymes dans toutes les collections
        if len(all_results) < limit:
            try:
                # Enrichir la requête avec des synonymes
                enriched_query = self.synonym_manager.expand_query(query)
                self.log_debug(f"🔄 Requête enrichie: {enriched_query}")
                
                query_vector = self.get_embedding(enriched_query)
                
                # Rechercher dans chaque collection avec des limites différentes
                search_configs = [
                    ("main", limit),
                    ("parent", limit),
                    ("sections", self.config["section_search_limit"])
                ]
                
                for collection_name, collection_limit in search_configs:
                    if collection_name in self.collections:
                        try:
                            remaining_limit = limit - len(all_results)
                            if remaining_limit <= 0:
                                break
                                
                            semantic_results = self.qdrant_client.search(
                                collection_name=self.collections[collection_name],
                                query_vector=query_vector,
                                limit=min(collection_limit, remaining_limit * 2)
                            )
                            
                            # Analyse intelligente des résultats
                            for result in semantic_results:
                                payload = result.payload
                                content = payload.get("contenu", "").lower()
                                keywords = payload.get("enriched_keywords", payload.get("keywords", []))
                                
                                # Calcul du score avec bonus pour matches de synonymes
                                bonus_score = 0
                                query_words = query.lower().split()
                                
                                for word in query_words:
                                    # Vérifier les variantes du mot
                                    variants = self.synonym_manager.get_all_variants(word)
                                    for variant in variants:
                                        if variant.lower() in content:
                                            bonus_score += 0.05
                                        # Bonus supplémentaire si dans les mots-clés enrichis
                                        if any(variant.lower() in kw.lower() for kw in keywords):
                                            bonus_score += 0.1
                                
                                # Bonus si c'est une section pertinente
                                if collection_name == "sections" and payload.get("type") == "section":
                                    section_title = payload.get("section_title", "").lower()
                                    if any(word in section_title for word in query_words):
                                        bonus_score += 0.15
                                
                                adjusted_score = result.score + bonus_score
                                
                                # Seuil adaptatif selon la collection
                                threshold = self.config["main_search_threshold"]
                                if collection_name == "sections":
                                    threshold *= 0.8  # Plus permissif pour les sections
                                
                                if adjusted_score >= threshold:
                                    if result.id not in all_results or adjusted_score > all_results[result.id][1]:
                                        all_results[result.id] = (result, adjusted_score, collection_name, None)
                                
                        except Exception as e:
                            self.log_debug(f"❌ Erreur sémantique {collection_name}: {str(e)}")
                
            except Exception as e:
                self.log_debug(f"❌ Erreur embedding: {str(e)}")
        
        # 3. Boost des résultats basé sur la pertinence contextuelle
        if self.conversation_context["last_articles"]:
            for article_id, (result, score, collection, part) in all_results.items():
                article_num = result.payload.get("article", "")
                if article_num in self.conversation_context["last_articles"]:
                    # Boost pour continuité contextuelle
                    all_results[article_id] = (result, score + 0.1, collection, part)
        
        # Trier et retourner les meilleurs résultats
        sorted_results = sorted(all_results.values(), key=lambda x: x[1], reverse=True)
        
        # Diversifier les résultats (pas trop du même article)
        final_results = []
        articles_seen = {}
        
        for result_data in sorted_results[:limit * 2]:
            result = result_data[0]
            score = result_data[1]
            collection = result_data[2]
            part = result_data[3] if len(result_data) > 3 else None
            
            article_num = result.payload.get("article", "")
            
            # Limiter à 3 résultats max par article
            if article_num not in articles_seen:
                articles_seen[article_num] = 0
            
            if articles_seen[article_num] < 3:
                # Ajouter l'info de la partie si elle existe
                if part:
                    result.payload["requested_part"] = part
                
                final_results.append(result)
                articles_seen[article_num] += 1
                
            if len(final_results) >= limit:
                break
        
        self.log_debug(f"🎯 {len(final_results)} résultats trouvés (recherche excellence)")
        
        # Sauvegarder pour le contexte
        self.conversation_context["last_search_results"] = final_results
        
        return final_results
    
    def extract_article_numbers(self, search_results):
        """Extrait les numéros d'articles des résultats de recherche"""
        articles = []
        for result in search_results:
            article_num = result.payload.get("article", "")
            if article_num and article_num not in articles:
                articles.append(article_num)
        return articles
    
    # Génération de réponse EXCELLENCE avec gestion des parties d'articles
    def generate_cgi_response_excellence(self, query, cgi_results, use_context=False):
        """Génère une réponse d'excellence basée sur le CGI sans phrases répétitives"""
        
        if not cgi_results:
            query_articles = self._extract_articles_from_query(query)
            if query_articles:
                articles_text = ", ".join(query_articles)
                return f"""❌ **Article(s) {articles_text} non trouvé(s) dans la base CGI**

💡 **Suggestions pour une recherche optimale :**
• Vérifiez le numéro d'article (format: 10, 144, premier, 10-III)
• L'article pourrait être abrogé ou renuméroté
• Essayez une recherche thématique (ex: "cotisation minimale", "amortissement véhicules")
• Utilisez des synonymes (voiture → véhicule, leasing → crédit-bail)

🔍 **Recherches alternatives suggérées :**
• Par type d'impôt: "TVA poisson", "IS plastique"
• Par concept: "plafond indemnité", "base cotisation"
• Par profession: "kinésithérapeute exonération"
"""
            else:
                return f"""❌ **Aucune disposition trouvée pour : "{query}"**

🔍 **Optimisez votre recherche avec :**
• **Mots-clés fiscaux** : TVA, IS, IR, exonération, cotisation, amortissement
• **Termes naturels** : voiture (au lieu de véhicule), leasing (au lieu de crédit-bail)
• **Questions précises** : "Plafond amortissement voitures 2025"
• **Articles spécifiques** : "Article 10", "Article 144", "10-III"

💡 **Exemples de questions efficaces :**
• "Le poisson frais est-il soumis à la TVA ?"
• "Nouveau plafond amortissement véhicules ?"
• "Base de calcul cotisation minimale ?"
• "Kinésithérapeutes exonération TVA ?"

Je suis optimisé pour comprendre le langage naturel et les synonymes !"""
        
        # Construire le contexte CGI enrichi
        cgi_context = ""
        articles_found = set()
        
        for i, result in enumerate(cgi_results):
            metadata = result.payload
            article_num = metadata.get("article", "N/A")
            article_name = metadata.get("nom_article", "Sans titre")
            content = metadata.get("contenu", "")
            requested_part = metadata.get("requested_part", None)
            
            # Si une partie spécifique est demandée, essayer de l'extraire
            if requested_part:
                # Chercher la partie dans le contenu
                part_pattern = f"{requested_part}[.\-\s]"
                part_match = re.search(part_pattern, content, re.IGNORECASE)
                if part_match:
                    # Extraire à partir de cette partie jusqu'à la prochaine partie ou fin
                    start_pos = part_match.start()
                    # Chercher la prochaine partie romaine
                    next_part_pattern = r'[IVX]+[.\-\s]'
                    next_match = re.search(next_part_pattern, content[start_pos+len(part_match.group(0)):])
                    if next_match:
                        end_pos = start_pos + len(part_match.group(0)) + next_match.start()
                        content = content[start_pos:end_pos]
                    else:
                        content = content[start_pos:]
                    cgi_context += f"\n--- ARTICLE {article_num} - PARTIE {requested_part} ---\n"
                else:
                    cgi_context += f"\n--- ARTICLE {article_num} (partie {requested_part} demandée) ---\n"
            # Pour les sections, inclure le titre de section
            elif metadata.get("type") == "section":
                section_title = metadata.get("section_title", "")
                cgi_context += f"\n--- ARTICLE {article_num} - SECTION: {section_title} ---\n"
            else:
                cgi_context += f"\n--- ARTICLE {article_num} ---\n"
            
            cgi_context += f"Titre: {article_name}\n"
            cgi_context += f"Contenu: {content}\n"
            
            articles_found.add(article_num)
        
        # NOUVELLE LOGIQUE: Si l'article 19 est trouvé, récupérer automatiquement l'article 247 partie 4
        if "19" in articles_found:
            self.log_debug("🔄 Article 19 détecté - Récupération automatique de l'article 247 partie 4")
            try:
                # Rechercher l'article 247 avec split_part = 4
                filter_condition = Filter(
                    must=[
                        FieldCondition(
                            key="article",
                            match=MatchValue(value="247")
                        ),
                        FieldCondition(
                            key="split_part",
                            match=MatchValue(value=4)
                        )
                    ]
                )
                
                # Rechercher dans toutes les collections CGI
                for collection_name in ["main", "parent", "sections"]:
                    if collection_name in self.collections:
                        try:
                            results_247 = self.qdrant_client.search(
                                collection_name=self.collections[collection_name],
                                query_vector=[0.0] * 1024,
                                query_filter=filter_condition,
                                limit=1
                            )
                            
                            if results_247:
                                result_247 = results_247[0]
                                metadata_247 = result_247.payload
                                article_num_247 = metadata_247.get("article", "247")
                                article_name_247 = metadata_247.get("nom_article", "Dispositions transitoires")
                                content_247 = metadata_247.get("contenu", "")
                                
                                # Ajouter l'article 247 partie 4 au contexte
                                cgi_context += f"\n--- ARTICLE {article_num_247} - PARTIE 4 (Taux transitoires IS 2025) ---\n"
                                cgi_context += f"Titre: {article_name_247}\n"
                                cgi_context += f"Contenu: {content_247}\n"
                                
                                articles_found.add(article_num_247)
                                self.log_debug("✅ Article 247 partie 4 ajouté automatiquement au contexte")
                                break
                                
                        except Exception as e:
                            self.log_debug(f"❌ Erreur recherche article 247 partie 4 dans {collection_name}: {str(e)}")
                            continue
                            
            except Exception as e:
                self.log_debug(f"❌ Erreur lors de la récupération automatique de l'article 247 partie 4: {str(e)}")
        
        # NOUVELLE LOGIQUE: Si l'article 133 est trouvé, récupérer automatiquement toutes les parties de l'article 129
        if "133" in articles_found:
            self.log_debug("🔄 Article 133 détecté - Récupération automatique de toutes les parties de l'article 129")
            try:
                # Rechercher toutes les parties de l'article 129 (I, II, III, IV, V)
                filter_condition_129 = Filter(
                    must=[
                        FieldCondition(
                            key="article",
                            match=MatchValue(value="129")
                        )
                    ]
                )
                
                # Rechercher dans toutes les collections CGI
                for collection_name in ["main", "parent", "sections"]:
                    if collection_name in self.collections:
                        try:
                            results_129 = self.qdrant_client.search(
                                collection_name=self.collections[collection_name],
                                query_vector=[0.0] * 1024,
                                query_filter=filter_condition_129,
                                limit=10  # Récupérer plusieurs parties
                            )
                            
                            if results_129:
                                for result_129 in results_129:
                                    metadata_129 = result_129.payload
                                    article_num_129 = metadata_129.get("article", "129")
                                    article_name_129 = metadata_129.get("nom_article", "Exonérations")
                                    content_129 = metadata_129.get("contenu", "")
                                    partie_article = metadata_129.get("partie_article", "")
                                    
                                    # Éviter les doublons
                                    if article_num_129 not in articles_found:
                                        # Ajouter l'article 129 au contexte
                                        partie_info = f" - PARTIE {partie_article}" if partie_article else ""
                                        cgi_context += f"\n--- ARTICLE {article_num_129}{partie_info} (Exonérations droits d'enregistrement) ---\n"
                                        cgi_context += f"Titre: {article_name_129}\n"
                                        cgi_context += f"Contenu: {content_129}\n"
                                        
                                        articles_found.add(article_num_129)
                                        self.log_debug(f"✅ Article 129{partie_info} ajouté automatiquement au contexte")
                                
                                break  # Sortir après avoir trouvé dans une collection
                                
                        except Exception as e:
                            self.log_debug(f"❌ Erreur recherche article 129 dans {collection_name}: {str(e)}")
                            continue
                            
            except Exception as e:
                self.log_debug(f"❌ Erreur lors de la récupération automatique de l'article 129: {str(e)}")
        
        # Sauvegarder les articles trouvés pour le contexte
        self.conversation_context["last_articles"] = list(articles_found)
        
        # Prompt EXCELLENCE sans répétitions
        if use_context and self.conversation_context["waiting_for_clarification"]:
            main_prompt = f"""Tu es AhmedTax 3.0, expert fiscal marocain d'excellence spécialisé dans le CGI 2025.

CONTEXTE DE CONVERSATION:
- Question précédente: {self.conversation_context['last_question']}
- Articles consultés: {', '.join(self.conversation_context['context_articles'])}
- Clarification demandée sur: {self.conversation_context.get('context_topic', 'aspect non précisé')}

L'utilisateur apporte des précisions.

RÈGLES D'EXCELLENCE:
1. Utilise le contexte pour affiner ta réponse
2. Cite TOUJOURS les articles avec leurs dispositions exactes
3. Structure ta réponse de manière claire et progressive
4. Anticipe les questions de suivi possibles

Question/clarification: "{query}"

Extraits du CGI:
{cgi_context}"""
        else:
                main_prompt = f"""Tu es AhmedTax, un expert fiscal marocain spécialisé dans le Code Général des Impôts (CGI) 2025.

            RÈGLES PRINCIPALES:
            1. Réponds UNIQUEMENT en te basant sur les extraits du CGI fournis dans le contexte.
            2. Ne fais JAMAIS de suppositions sur des informations non présentes dans le contexte.
            3. Cite TOUJOURS les numéros d'articles précis sur lesquels tu t'appuies.
            4. Pour ta PREMIÈRE réponse seulement, commence par "Votre question porte sur [sujet fiscal précis]."
            5. Respecte STRICTEMENT les taux et dispositions mentionnés dans les articles, surtout les plus récents (2025).
            6. Si un article donne une définition ou une exclusion explicite, elle doit figurer dans ta réponse.
            7. IGNORE COMPLÈTEMENT les dispositions abrogées - ne les mentionne jamais dans tes réponses.
            8. Si une énumération dépasse 10 éléments, regroupe-les par catégories logiques (ex: "organismes sociaux", "fondations", "agences de développement").


            STRUCTURE DE RÉPONSE:
            - Première ligne: identification du sujet fiscal (uniquement première réponse)
            - Corps: explication claire et rigoureuse avec citation explicite des articles
            - Si nécessaire: demande précise d'informations complémentaires

            N'UTILISE JAMAIS de formules comme "je ne sais pas" ou "je n'ai pas assez d'informations".
            Si le contexte est insuffisant, demande des précisions ciblées.

            L'utilisateur pose la question suivante : "{query}"

            Extraits du CGI:
            {cgi_context}"""
                    

                    
        try:
            model = genai.GenerativeModel("gemini-2.0-flash")
            response = model.generate_content(
                main_prompt,
                generation_config={
                    "temperature": 0.1,  # Plus factuel
                    "top_p": 0.95,
                    "max_output_tokens": 2500,
                }
            )
            
            fct_response = response.text
            
            # NOUVELLE FONCTIONNALITÉ : Recherche dans les annexes FCT
            self.log_debug("🔍 Recherche complémentaire dans les annexes FCT...")
            annexe_results = self.search_fct_annexes(query, limit=self.config["annexe_search_limit"])
            
            # Ajouter les précisions des annexes si pertinentes
            final_response = self.add_annexe_to_fct_response(fct_response, annexe_results, query)
            
            return final_response
            
        except Exception as e:
            return f"❌ Erreur lors de la génération de la réponse: {str(e)}"
    
    # Méthodes de contexte optimisées
    def _is_clarification_request(self, response: str) -> bool:
        """Détecte si la réponse demande une clarification"""
        clarification_indicators = [
            "pourriez-vous préciser",
            "pouvez-vous préciser", 
            "quelle est votre situation",
            "dans quel contexte",
            "souhaitez-vous connaître",
            "de quel type",
            "pour quelle activité"
        ]
        
        response_lower = response.lower()
        return any(indicator in response_lower for indicator in clarification_indicators)
    
    def _extract_topic_from_response(self, response: str) -> str:
        """Extrait le sujet principal de la réponse pour le contexte"""
        # Chercher les concepts clés dans la réponse
        topics = []
        
        fiscal_concepts = {
            "cotisation minimale": ["cotisation minimale", "article 144", "base de calcul"],
            "amortissement véhicules": ["amortissement", "véhicule", "400 000", "transport de personnes"],
            "TVA": ["TVA", "taxe sur la valeur ajoutée", "taux"],
            "exonération": ["exonération", "exonéré", "franchise"],
            "indemnité": ["indemnité", "plafond", "allocation"],
            "représentation": ["représentation", "indemnité de représentation", "frais de représentation"]
        }
        
        response_lower = response.lower()
        for concept, keywords in fiscal_concepts.items():
            if any(kw in response_lower for kw in keywords):
                topics.append(concept)
        
        return topics[0] if topics else "disposition fiscale"
    
    def _update_context(self, question: str, response: str, articles: List[str]):
        """Met à jour le contexte de conversation avec plus d'intelligence"""
        self.conversation_context.update({
            "last_question": question,
            "last_response": response[:500],  # Premiers 500 caractères
            "waiting_for_clarification": self._is_clarification_request(response),
            "context_articles": articles,
            "context_topic": self._extract_topic_from_response(response)
        })
        
        # Ajouter à l'historique de recherche
        self.conversation_context["search_history"].append({
            "query": question,
            "articles": articles,
            "timestamp": datetime.now()
        })
        
        # Limiter l'historique à 10 dernières recherches
        if len(self.conversation_context["search_history"]) > 3:
            self.conversation_context["search_history"].pop(0)
    
    def _clear_context(self):
        """Efface le contexte de conversation"""
        self.conversation_context.update({
            "last_question": "",
            "last_response": "",
            "last_articles": [],
            "last_search_results": [],
            "waiting_for_clarification": False,
            "context_articles": [],
            "context_topic": "",
            "search_history": []
        })
    
    # RECHERCHE ANNEXE HYBRIDE - Textuelle + Sémantique
    def search_annexe_excellence(self, article_numbers, query, cgi_response=""):
        """Recherche hybride dans l'annexe - textuelle directe + sémantique"""
        if not query:
            return []
        
        try:
            all_results = {}
            query_lower = query.lower()
            
            # 1. RECHERCHE TEXTUELLE DIRECTE - Pour les cas spécifiques
            self.log_debug(f"🔍 Recherche annexe hybride pour: {query[:100]}")
            
            # Définir les patterns de recherche directe
            direct_search_patterns = {
        # Pour l'industrie (chaussures, plastique, etc.)
        "industrie": {
            "keywords": ["plastique", "chaussures", "fabrication", "industrie", "activités industrielles"],
            "doc_types": ["décret"],
            "content_patterns": [
                r"industrie\s+du\s+plastique",
                r"industrie\s+de\s+la\s+chaussure",
                r"fabrication\s+de\s+chaussures",
                r"activités\s+industrielles\s+exonérées",
                r"liste\s+des\s+activités"
            ]
        },
        # Pour les indemnités
        "indemnité": {
            "keywords": ["indemnité", "plafond", "représentation", "caisse"],
            "doc_types": ["note_service", "note_circulaire"],
            "content_patterns": [
                r"indemnité\s+de\s+(?:représentation|caisse).*?(\d+\s*%|\d+\s*dirhams?)",
                r"plafond.*?(\d+\s*%|\d+\s*dirhams?)",
                r"exonération.*?plafonné.*?(\d+\s*%)"
            ]
        }
    }
            
            # Détecter le type de recherche
            search_type = None
            for stype, config in direct_search_patterns.items():
                if any(kw in query_lower for kw in config["keywords"]):
                    search_type = stype
                    break
            
            # 2. RECHERCHE TEXTUELLE SI PATTERN DÉTECTÉ - Nouvelle collection optimisée
            if search_type:
                config = direct_search_patterns[search_type]
                self.log_debug(f"   Type détecté: {search_type}")
                
                # Utiliser les flags de la collection optimisée
                if search_type == "plastique":
                    # Recherche par filtre sur has_plastique
                    filter_condition = Filter(
                        must=[
                            FieldCondition(
                                key="has_plastique",
                                match=MatchValue(value=True)
                            )
                        ]
                    )
                elif search_type == "représentation":
                    # Recherche par filtre sur has_representation
                    filter_condition = Filter(
                        must=[
                            FieldCondition(
                                key="has_representation", 
                                match=MatchValue(value=True)
                            )
                        ]
                    )
                elif search_type == "industrie" and "chaussures" in query_lower:
                    # Recherche par filtre sur has_chaussures
                    filter_condition = Filter(
                        must=[
                            FieldCondition(
                                key="has_chaussures",
                                match=MatchValue(value=True)
                            )
                        ]
                    )
                else:
                    # Recherche par type de document
                    filter_condition = Filter(
                        must=[
                            FieldCondition(
                                key="type",
                                match=MatchAny(any=config["doc_types"])
                            )
                        ]
                    )
                
                try:
                    # Recherche avec filtre
                    filtered_results = self.qdrant_client.search(
                        collection_name=self.collections["annexe"],
                        query_vector=[0.0] * 1024,  # Vecteur vide car on utilise le filtre
                        query_filter=filter_condition,
                        limit=10
                    )
                    
                    # Analyser chaque résultat filtré
                    for result in filtered_results:
                        payload = result.payload
                        content = payload.get("contenu", "").lower()
                        score = 0.5  # Score de base pour filtre
                        
                        # Vérifier les patterns de contenu pour confirmer
                        for pattern in config["content_patterns"]:
                            if re.search(pattern, content, re.IGNORECASE):
                                score += 0.3
                                self.log_debug(f"   ✅ Pattern trouvé dans {payload.get('type')}")
                                
                                # Extraire des infos spécifiques
                                if search_type == "représentation":
                                    plafond_match = re.search(pattern, content, re.IGNORECASE)
                                    if plafond_match and plafond_match.group(1):
                                        self.log_debug(f"   💰 Plafond trouvé: {plafond_match.group(1)}")
                                        score += 0.2
                                break
                        
                        # Bonus pour articles liés
                        if article_numbers:
                            articles_lies = payload.get("articles_lies", [])
                            if any(str(art) in [str(a) for a in articles_lies] for art in article_numbers):
                                score += 0.2
                                self.log_debug(f"   📎 Articles liés correspondants")
                        
                        if score > 0.5:
                            all_results[result.id] = (result, score, "filter")
                            
                except Exception as e:
                    self.log_debug(f"❌ Erreur recherche filtrée: {str(e)}")
            
            # 3. RECHERCHE SÉMANTIQUE COMPLÉMENTAIRE
            try:
                # Construire une requête enrichie pour la recherche sémantique
                enriched_query = query
                
                # Ajouter des termes spécifiques selon le contexte
                if "plastique" in query_lower:
                    enriched_query += " industrie du plastique matière plastique fabrication produits plastiques activités industrielles exonérées décret"
                elif "représentation" in query_lower:
                    enriched_query += " indemnité représentation plafond 10% salaire base note service"
                
                # Ajouter les articles
                if article_numbers:
                    enriched_query += f" article {' '.join(str(a) for a in article_numbers[:3])}"
                
                # Enrichir avec les synonymes
                enriched_query = self.synonym_manager.expand_query(enriched_query)
                
                self.log_debug(f"🔍 Recherche sémantique complémentaire")
                
                # Recherche sémantique
                query_vector = self.get_embedding(enriched_query)
                
                semantic_results = self.qdrant_client.search(
                    collection_name=self.collections["annexe"],
                    query_vector=query_vector,
                    limit=10
                )
                
                # Ajouter les résultats sémantiques non trouvés par la recherche textuelle
                for result in semantic_results:
                    if result.id not in all_results:
                        # Analyser la pertinence
                        payload = result.payload
                        content = payload.get("contenu", "").lower()
                        
                        # Bonus si le contenu contient des termes clés
                        bonus = 0
                        if search_type == "plastique" and ("plastique" in content or payload.get("has_plastique")):
                            bonus = 0.2
                        elif search_type == "représentation" and ("représentation" in content or "10%" in content or payload.get("has_representation")):
                            bonus = 0.2
                        
                        adjusted_score = result.score + bonus
                        
                        if adjusted_score >= 0.1:  # Seuil très bas
                            all_results[result.id] = (result, adjusted_score, "semantic")
                
            except Exception as e:
                self.log_debug(f"❌ Erreur recherche sémantique: {str(e)}")
            
            # 4. TRIER ET RETOURNER LES MEILLEURS RÉSULTATS
            if all_results:
                # Trier par score
                sorted_results = sorted(all_results.values(), key=lambda x: x[1], reverse=True)
                
                # Prendre les 3 meilleurs
                final_results = []
                for result_data in sorted_results[:3]:
                    result = result_data[0]
                    score = result_data[1]
                    method = result_data[2]
                    
                    self.log_debug(f"   📄 Résultat: {result.payload.get('type')} - Score: {score:.3f} - Méthode: {method}")
                    
                    final_results.append(result)
                
                self.log_debug(f"📚 {len(final_results)} annexes trouvées")
                return final_results
            
            # 5. SI AUCUN RÉSULTAT AVEC LA RECHERCHE HYBRIDE, FALLBACK SÉMANTIQUE PURE
            self.log_debug("⚠️ Aucun résultat hybride, fallback sémantique")
            
            # Recherche sémantique pure avec seuil très bas
            query_vector = self.get_embedding(query)
            fallback_results = self.qdrant_client.search(
                collection_name=self.collections["annexe"],
                query_vector=query_vector,
                limit=3
            )
            
            return [r for r in fallback_results if r.score >= 0.05]
            
        except Exception as e:
            self.log_debug(f"❌ Erreur générale recherche annexe: {str(e)}")
            return []
    
    def _extract_key_concepts_advanced(self, text):
        """Extraction avancée des concepts clés pour enrichir la recherche"""
        concepts = []
        
        # Concepts fiscaux importants élargis
        fiscal_concepts = {
            "amortissement": ["amortissement", "dotation", "dépréciation", "400 000", "300 000"],
            "véhicule": ["véhicule", "voiture", "automobile", "transport de personnes"],
            "crédit-bail": ["crédit-bail", "leasing", "location", "redevance"],
            "cotisation": ["cotisation minimale", "base", "assiette", "article 144"],
            "indemnité": ["indemnité", "plafond", "exonération", "allocation"],
            "TVA": ["TVA", "taxe valeur ajoutée", "taux", "exonération"],
            "représentation": ["représentation", "indemnité de représentation", "10%"],
            "plastique": ["plastique", "industrie du plastique", "matière plastique"],
            "industrie": ["industrie", "industriel", "activités industrielles", "sociétés industrielles"],
            "exonération": ["exonération", "exonéré", "cinq premiers exercices", "temporaire"]
        }
        
        text_lower = text.lower()
        
        # Chercher les concepts présents
        for concept, keywords in fiscal_concepts.items():
            if any(kw in text_lower for kw in keywords):
                concepts.extend(keywords[:3])  # Prendre les 3 premiers mots-clés
        
        # Extraire les montants importants
        amounts = re.findall(r'\d+(?:\s*\d+)*\s*(?:dirhams?|dh|mad)', text_lower)
        concepts.extend(amounts[:3])
        
        # Extraire les pourcentages
        percentages = re.findall(r'\d+(?:,\d+)?\s*%', text_lower)
        concepts.extend(percentages[:2])
        
        # Extraire les références réglementaires
        if "voie réglementaire" in text_lower or "décret" in text_lower:
            concepts.append("décret")
        if "note de service" in text_lower:
            concepts.append("note de service")
        if "circulaire" in text_lower:
            concepts.append("circulaire")
        
        return list(set(concepts))[:15]  # Maximum 15 concepts uniques
    
    def process_annexes_unified(self, query, cgi_response, annexe_results):
        """Traite TOUTES les annexes et génère une réponse constructive qui explique les changements"""
        
        if not annexe_results:
            return ""
        
        # 1. Construire le contexte de TOUTES les annexes avec le contenu COMPLET
        annexe_context = ""
        annexes_info = []
        
        for i, result in enumerate(annexe_results[:5]):  # Max 5 annexes
            payload = result.payload
            type_doc = payload.get("type", "Document")
            numero = payload.get("numero", "")
            date = payload.get("date", "")
            objet = payload.get("objet", "")
            contenu = payload.get("contenu", "")
            articles_lies = payload.get("articles_lies", [])
            
            # Construire le nom réel du document
            nom_document = ""
            if type_doc and numero:
                nom_document = f"{type_doc} n° {numero}"
            elif type_doc:
                nom_document = type_doc
            elif numero:
                nom_document = f"Document n° {numero}"
            else:
                nom_document = f"Document {objet[:50]}..." if objet else f"Document sans titre"
            
            # Ajouter au contexte global avec le nom réel
            annexe_context += f"\n\n--- {nom_document.upper()} ---\n"
            if date:
                annexe_context += f"Date: {date}\n"
            if objet:
                annexe_context += f"Objet: {objet}\n"
            if articles_lies:
                annexe_context += f"Articles liés: {', '.join(str(a) for a in articles_lies)}\n"
            
            # INCLURE LE CONTENU COMPLET au lieu des extractions ciblées
            annexe_context += f"Contenu complet:\n{contenu}\n"
        
        # 2. NOUVEAU PROMPT pour vérifier la pertinence et générer une réponse constructive
        unified_prompt = f"""Tu es AhmedTax, expert fiscal marocain. Tu dois analyser les documents d'application pour déterminer s'ils apportent des précisions pertinentes à la réponse CGI.

QUESTION DE L'UTILISATEUR: "{query}"

RÉPONSE CGI DÉJÀ FOURNIE:
{cgi_response}

DOCUMENTS D'APPLICATION À ANALYSER:
{annexe_context}

INSTRUCTIONS IMPORTANTES:

1. **VÉRIFICATION DE PERTINENCE** : Analyse d'abord si les documents d'application apportent des précisions utiles et pertinentes à la question posée et à la réponse CGI.

2. **SI LES DOCUMENTS NE SONT PAS PERTINENTS** (hors sujet, pas de précisions utiles, informations déjà couvertes par le CGI) :
   - Réponds EXACTEMENT : "Aucune précisions à apporter"
   - Ne génère aucune autre réponse

3. **SI LES DOCUMENTS SONT PERTINENTS** :
   - EXTRAIT les informations spécifiques qui complètent ou précisent la réponse CGI
   - GÉNÈRE une réponse constructive qui EXPLIQUE concrètement ce qui change ou se précise
   - CITE les documents par leur nom réel (ex: "Note circulaire n° 736", "Décret n° 2-17-743") et NON par "document 1", "document 2"
   - INTÈGRE les informations trouvées dans une explication fluide et pratique
   - DONNE des réponses définitives basées sur les documents trouvés

STRUCTURE DE LA RÉPONSE (si pertinente):
- Identifier ce qui était imprécis dans la réponse CGI
- Expliquer concrètement ce que les documents d'application apportent comme précisions
- Citer les documents par leur nom réel
- Donner la réponse finale claire et pratique

EXEMPLES de réponses constructives attendues:

Pour une question sur les activités industrielles exonérées:
"La réponse CGI mentionnait que les activités industrielles exonérées sont 'fixées par voie réglementaire' sans donner la liste. Le décret n° 2-17-743 du 19 juin 2018 permet maintenant de répondre précisément : OUI, votre société de fabrication de chaussures peut bénéficier de l'exonération car l'industrie de la chaussure figure explicitement au point X de la liste des activités industrielles exonérées."

Pour une question sur les plafonds d'indemnités:
"La réponse CGI indiquait que les indemnités doivent être justifiées sans préciser le plafond. La note de service DGI n° 123 apporte la précision manquante : le plafond de l'indemnité de caisse admise en exonération est fixé à 500 dirhams par mois selon cette note de service."

TON ET STYLE:
- Réponse fluide et naturelle, pas de format de citation
- Explication claire de ce qui change par rapport à la réponse CGI
- Réponse définitive et pratique pour l'utilisateur
- Éviter les formules comme "il faut consulter" - donner directement la réponse
- Citer les documents par leur nom réel, jamais par "document 1", "document 2"

ANALYSE maintenant si les documents apportent des précisions pertinentes et réponds en conséquence."""

        try:
            model = genai.GenerativeModel("gemini-2.0-flash")
            response = model.generate_content(
                unified_prompt,
                generation_config={
                    "temperature": 0.1,  # Plus déterministe pour la vérification de pertinence
                    "max_output_tokens": 1200,
                }
            )
            
            annexe_response = response.text.strip()
            
            # Vérifier seulement si la réponse est vide
            if not annexe_response:
                return ""
            
            # Retourner la réponse constructive avec un séparateur clair
            return f"\n\n**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D'APPLICATION :**\n\n{annexe_response}"
                
        except Exception as e:
            self.log_debug(f"❌ Erreur traitement unifié annexes: {str(e)}")
            return ""


    def add_annexe_to_response_excellence(self, cgi_response, annexe_results, query):
            """Ajoute les informations d'annexe en utilisant le traitement unifié"""
            if not annexe_results:
                return cgi_response
            
            # Utiliser le nouveau traitement unifié avec TOUS les résultats (jusqu'à 5)
            annexe_info = self.process_annexes_unified(query, cgi_response, annexe_results)
            
            if annexe_info:
                return cgi_response + annexe_info
            else:
                return cgi_response
        
    def _extract_annexe_info_excellence(self, query, cgi_response, payload):
        """Extraction d'excellence des informations pertinentes de l'annexe"""
        try:
            type_doc = payload.get("type", "Document")
            numero = payload.get("numero", "")
            date = payload.get("date", "")
            objet = payload.get("objet", "")
            contenu = payload.get("contenu", "")
            articles_lies = payload.get("articles_lies", [])
            
            # Formater l'en-tête selon le type
            doc_headers = {
                "note_circulaire": (f"**Note circulaire n° {numero}** ({date})", "📑"),
                "décret": (f"**Décret n° {numero}** ({date})", "📜"),
                "note_service": (f"**Note de service** ({date})", "📝"),
            }
            
            doc_header, doc_icon = doc_headers.get(type_doc, (f"**{type_doc.title()}**", "📄"))
            
            # Si articles liés, les mentionner
            if articles_lies:
                doc_header += f" - Articles {', '.join(str(a) for a in articles_lies[:3])}"
            
            # Traitement spécifique selon le contenu
            query_lower = query.lower()
            
            # 1. INDUSTRIE DU PLASTIQUE - EXTRACTION CIBLÉE
            if "plastique" in query_lower and (type_doc == "décret" or payload.get("has_plastique")):
                # Chercher spécifiquement dans la liste des activités
                # D'après l'exemple, l'industrie du plastique est au point 8 ou 10
                
                # Pattern pour trouver la section des industries chimiques
                sections_patterns = [
                    r"8[-–]\s*Industrie\s+chimique(.*?)(?=\d+[-–]|$)",
                    r"10[-–]\s*Industrie\s+des\s+produits\s+en\s+caoutchouc\s+et\s+en\s+plastique(.*?)(?=\d+[-–]|$)"
                ]
                
                for pattern in sections_patterns:
                    match = re.search(pattern, contenu, re.IGNORECASE | re.DOTALL)
                    if match:
                        section_content = match.group(0)
                        # Vérifier si l'industrie du plastique est mentionnée
                        if "plastique" in section_content.lower():
                            # Extraire juste cette section
                            formatted_response = f"\n{doc_icon} {doc_header}:\n"
                            formatted_response += "✅ **L'industrie du plastique figure dans la liste des activités industrielles exonérées**\n\n"
                            
                            # Nettoyer et formater la section
                            lines = section_content.split('\n')
                            relevant_lines = []
                            for line in lines:
                                line = line.strip()
                                if line and not line.isspace():
                                    # Ajouter un tiret si ce n'est pas un titre de section
                                    if not re.match(r'^\d+[-–]', line):
                                        line = f"– {line}"
                                    relevant_lines.append(line)
                            
                            # Afficher uniquement les lignes pertinentes
                            formatted_response += "\n".join(relevant_lines[:5])  # Limiter à 5 lignes
                            
                            formatted_response += "\n\n💡 *Cette activité peut bénéficier de l'exonération totale d'IS pendant les 5 premiers exercices (Article 6 II-B-4°)*"
                            
                            return formatted_response
                
                # Si pas trouvé avec les patterns de section, chercher directement
                plastic_patterns = [
                    r"[-–]\s*Industrie\s+du\s+plastique",
                    r"[-–]\s*Industrie\s+des?\s+produits\s+en\s+plastique"
                ]
                
                for pattern in plastic_patterns:
                    match = re.search(pattern, contenu, re.IGNORECASE)
                    if match:
                        formatted_response = f"\n{doc_icon} {doc_header}:\n"
                        formatted_response += "✅ **L'industrie du plastique figure dans la liste des activités industrielles exonérées**\n\n"
                        
                        # Extraire un contexte minimal autour
                        start = max(0, match.start() - 50)
                        end = min(len(contenu), match.end() + 100)
                        context = contenu[start:end].strip()
                        
                        # Nettoyer le contexte
                        if not context.startswith('–'):
                            context = "..." + context
                        if not context.endswith('.'):
                            context = context + "..."
                        
                        formatted_response += f"*{context}*\n\n"
                        formatted_response += "💡 *Cette activité peut bénéficier de l'exonération totale d'IS pendant les 5 premiers exercices (Article 6 II-B-4°)*"
                        
                        return formatted_response
            
            # 2. INDEMNITÉ DE REPRÉSENTATION
            elif "représentation" in query_lower and (type_doc == "note_service" or payload.get("has_representation")):
                # Chercher le plafond
                plafond_patterns = [
                    r"indemnité\s+de\s+représentation.*?plafonnée?\s*à?\s*(\d+\s*%)",
                    r"représentation.*?(\d+\s*%)\s*du\s+salaire",
                    r"l'exonération\s+est\s+plafonnée\s+à\s+(\d+\s*%)"
                ]
                
                plafond = None
                for pattern in plafond_patterns:
                    match = re.search(pattern, contenu, re.IGNORECASE | re.DOTALL)
                    if match:
                        plafond = match.group(1)
                        break
                
                if plafond:
                    # Chercher les bénéficiaires
                    beneficiaires = []
                    
                    # Extraire la section sur les bénéficiaires
                    ben_match = re.search(r"bénéficiaires\s+doivent.*?:(.*?)(?:prime|indemnité|\Z)", contenu, re.IGNORECASE | re.DOTALL)
                    if ben_match:
                        ben_text = ben_match.group(1)
                        
                        # Parser les bénéficiaires
                        if "président directeur général" in ben_text.lower():
                            beneficiaires.append("Président Directeur Général (PDG)")
                        if "directeur général" in ben_text.lower():
                            beneficiaires.append("Directeur Général")
                        if "directeur" in ben_text.lower() and "département" in ben_text.lower():
                            beneficiaires.append("Directeurs de départements (Commercial, Financier, RH, etc.)")
                        if "gérant" in ben_text.lower():
                            beneficiaires.append("Gérant salarié avec pouvoirs de direction")
                    
                    formatted_response = f"\n{doc_icon} {doc_header}:\n"
                    formatted_response += f"📊 **Plafond d'exonération de l'indemnité de représentation : {plafond} du salaire de base**\n"
                    
                    if beneficiaires:
                        formatted_response += "\n👥 **Bénéficiaires éligibles :**\n"
                        for ben in beneficiaires:
                            formatted_response += f"• {ben}\n"
                    else:
                        formatted_response += "\n*Réservée aux cadres dirigeants disposant de pouvoirs de direction et de gestion*"
                    
                    return formatted_response
            
            # 3. APPROCHE GÉNÉRALE AMÉLIORÉE pour les autres cas
            # Pour les autres cas, utiliser une approche plus concise
            extraction_prompt = f"""Analyse ce document fiscal et extrais UNIQUEMENT l'information essentielle qui complète la réponse CGI.

QUESTION: "{query}"
TYPE: {type_doc}

RÈGLES STRICTES:
1. Maximum 2-3 phrases
2. Uniquement les éléments pratiques (taux, montants, conditions)
3. Si le document cite une liste, extraire SEULEMENT l'élément pertinent
4. NE PAS reproduire de longues sections du document

DOCUMENT (extrait):
{objet}
{contenu[:1500]}

Réponds "NON_PERTINENT" si aucune info utile."""

            model = genai.GenerativeModel("gemini-2.0-flash")
            response = model.generate_content(
                extraction_prompt,
                generation_config={
                    "temperature": 0.1,
                    "max_output_tokens": 300,
                }
            )
            
            extracted_info = response.text.strip()
            
            if "NON_PERTINENT" in extracted_info or len(extracted_info) < 20:
                return ""
            
            return f"\n{doc_icon} {doc_header}:\n{extracted_info}"
            
        except Exception as e:
            self.log_debug(f"Erreur extraction annexe: {str(e)}")
            return ""
    
    # MÉTHODE PRINCIPALE D'EXCELLENCE
    def process_query_excellence(self, query, messages_history=None):
        """Traite une requête avec excellence maximale"""
        start_time = datetime.now()
        self.clear_debug_logs()
        
        self.log_debug(f"🚀 TRAITEMENT EXCELLENCE: '{query}'")
        
        # Détection d'intention
        intent = self.detect_conversation_intent(query)
        self.log_debug(f"🧠 Intention: {intent}")
        
        # Traitement conversationnel
        if intent in ["greetings", "presentation_request", "help_request", "goodbye"]:
            conversational_response = self.generate_conversational_response(query, intent)
            execution_time = (datetime.now() - start_time).total_seconds()
            
            return {
                "response": conversational_response,
                "cgi_articles": 0,
                "annexe_docs": 0,
                "articles_found": [],
                "execution_time": execution_time,
                "debug_logs": self.get_debug_logs(),
                "context_used": False,
                "intent": intent,
                "search_method": "conversational"
            }
        
        # Traitement des questions fiscales
        original_query = query
        use_context = False
        
        # Vérification du contexte
        if (self.conversation_context["waiting_for_clarification"] and 
            intent == "clarification"):
            use_context = True
            self.log_debug("🔗 Utilisation du contexte de conversation")
        
        # RECHERCHE CGI EXCELLENCE
        cgi_results = self.search_cgi_articles(query, limit=8)
        
        # Génération de la réponse CGI
        cgi_response = self.generate_cgi_response_excellence(query, cgi_results, use_context=use_context)
        
        # Extraction des articles
        cgi_article_numbers = self.extract_article_numbers(cgi_results)
        query_article_numbers = self._extract_articles_from_query(original_query)
        
        # Combiner tous les articles trouvés
        all_article_numbers = list(set(query_article_numbers + cgi_article_numbers))[:6]
        
        # RECHERCHE ANNEXE AMÉLIORÉE - TOUJOURS EFFECTUÉE
        annexe_results = []
        # Supprimer la condition de longueur pour toujours effectuer la recherche annexe
        annexe_results = self.search_annexe_excellence(
            all_article_numbers, original_query, cgi_response
        )
        
        # Réponse finale
        final_response = self.add_annexe_to_response_excellence(
            cgi_response, annexe_results, original_query
        )
        
        # Mise à jour du contexte
        self._update_context(original_query, final_response, all_article_numbers)
        
        execution_time = (datetime.now() - start_time).total_seconds()
        
        # Préparer les articles pour la base de données
        articles_info = []
        for result in cgi_results:
            article_info = {
                "article": result.payload.get("article", "N/A"),
                "nom_article": result.payload.get("nom_article", "Sans titre"),
                "tags": result.payload.get("tags", [])
            }
            articles_info.append(article_info)
        
        # Enregistrer dans la base de données
        conversation_id = None
        if self.db:
            conversation_id = self.db.save_conversation(
                question=query,
                response=final_response,
                articles=articles_info,
                search_method="excellence_hybrid",
                semantic_score=cgi_results[0].score if cgi_results else 0.0,
                query_complexity=0.5,  # Estimation simple
                execution_time=execution_time,
                model_used="gemini-2.0-flash"
            )
        
        # Statistiques détaillées
        stats = {
            "response": final_response,
            "cgi_articles": len(cgi_results),
            "annexe_docs": len(annexe_results),
            "articles_found": all_article_numbers,
            "execution_time": execution_time,
            "debug_logs": self.get_debug_logs(),
            "context_used": use_context,
            "intent": intent,
            "search_method": "excellence_hybrid",
            "collections_searched": ["main", "parent", "sections", "annexe"],
            "enrichment_used": True,
            "conversation_id": conversation_id
        }
        
        return stats


class TerritorialFiscalBot:
    """Chatbot spécialisé dans la fiscalité des collectivités territoriales"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client_main
        self.synonym_manager = synonym_manager
        self.db = db
        
        # Collections pour les collectivités territoriales
        self.collections = {
            "main": "FCT",
            "annexe": "FCT_Annexes"  # Nouvelle collection pour les annexes FCT
        }
        
        # Configuration optimisée
        self.config = {
            "search_threshold": 0.08,
            "search_limit": 12,
            "annexe_score_threshold": 0.05,  # Seuil très bas pour capturer plus d'annexes
            "annexe_search_limit": 10       # Limite pour les annexes
        }
        
        # Logs de debug
        self.debug_logs = []
        
        # Système d'intelligence conversationnelle
        self.conversation_patterns = {
            "greetings": [
                "bonjour", "bonsoir", "salut", "hello", "hey", "coucou", "bonne journée"
            ],
            "presentation_request": [
                "présente toi", "qui es tu", "que fais tu", "présentation", "qui êtes vous"
            ],
            "help_request": [
                "aide", "help", "comment ça marche", "utilisation", "guide", "comment faire"
            ],
            "goodbye": [
                "au revoir", "bye", "à bientôt", "merci", "bonne journée", "salut"
            ]
        }
        
        # Contexte de conversation
        self.conversation_context = {
            "last_question": "",
            "last_response": "",
            "last_articles": [],
            "waiting_for_clarification": False,
            "context_articles": [],
            "context_topic": "",
            "user_name": None,
            "conversation_started": False,
            "search_history": []
        }
    
    def _clear_context(self):
        """Efface le contexte de conversation"""
        self.conversation_context = {
            "last_question": "",
            "last_response": "",
            "last_articles": [],
            "waiting_for_clarification": False,
            "context_articles": [],
            "context_topic": "",
            "user_name": self.conversation_context.get("user_name"),  # Garder le nom
            "conversation_started": False,
            "search_history": []
        }
    
    def log_debug(self, message: str):
        """Ajoute un message aux logs de debug avec timestamp"""
        timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        self.debug_logs.append(f"[{timestamp}] {message}")
    
    def clear_debug_logs(self):
        """Efface les logs de debug"""
        self.debug_logs = []
    
    def get_debug_logs(self) -> List[str]:
        """Retourne les logs de debug"""
        return self.debug_logs
    
    def detect_conversation_intent(self, query: str) -> str:
        """Détecte l'intention conversationnelle de l'utilisateur"""
        query_lower = query.lower().strip()
        
        # Extraction du nom si présent
        name_patterns = [
            r"je suis ([a-zA-ZÀ-ÿ\s]+)",
            r"je m'appelle ([a-zA-ZÀ-ÿ\s]+)",
            r"mon nom est ([a-zA-ZÀ-ÿ\s]+)"
        ]
        
        for pattern in name_patterns:
            match = re.search(pattern, query_lower)
            if match:
                self.conversation_context["user_name"] = match.group(1).strip().title()
        
        # Vérifier d'abord si c'est une question fiscale territoriale
        territorial_keywords = [
            "commune", "communal", "préfecture", "province", "région", "régional",
            "collectivité", "territorial", "taxe communale", "taxe régionale",
            "redevance", "contribution", "budget", "finances locales", "fiscalité locale",
            "impôt local", "taxe locale", "bénéficiaire", "affectation", "répartition"
        ]
        
        if any(keyword in query_lower for keyword in territorial_keywords):
            return "fiscal_question"
        
        # Ensuite vérifier les intentions conversationnelles
        for intent, patterns in self.conversation_patterns.items():
            if any(pattern in query_lower for pattern in patterns):
                return intent
        
        return "general_question"
    
    def generate_conversational_response(self, query: str, intent: str) -> str:
        """Génère des réponses conversationnelles intelligentes"""
        
        user_name = self.conversation_context.get("user_name", "")
        name_part = f" {user_name}" if user_name else ""
        
        if intent == "greetings":
            if not self.conversation_context["conversation_started"]:
                self.conversation_context["conversation_started"] = True
                return f"""Bonjour{name_part} ! 👋

Je suis votre **Expert en Fiscalité des Collectivités Territoriales**, spécialisé dans les taxes et contributions des communes, préfectures, provinces et régions du Maroc.

🏛️ **Ma spécialité :**
• Taxes communales et leurs bénéficiaires
• Impôts des préfectures et provinces
• Contributions régionales
• Répartition et affectation des recettes fiscales
• Fiscalité locale et territoriale

💡 **Exemples de questions :**
• "Quelles taxes bénéficient aux communes ?"
• "Comment sont réparties les recettes de la TVA ?"
• "Quels impôts alimentent le budget régional ?"
• "Qui bénéficie de la taxe sur les véhicules ?"

Comment puis-je vous aider avec la fiscalité territoriale ?"""
            else:
                return f"Rebonjour{name_part} ! Comment puis-je vous aider avec vos questions sur la fiscalité des collectivités territoriales ?"
        
        elif intent == "presentation_request":
            return f"""Je suis votre **Expert en Fiscalité des Collectivités Territoriales** ! 🏛️

📚 **Ma spécialité :**
Assistant IA spécialisé dans la fiscalité locale marocaine, avec une expertise approfondie sur :

🏘️ **Niveau communal :**
• Taxes et redevances communales
• Budget et ressources des communes
• Fiscalité locale urbaine et rurale

🏢 **Niveau préfectoral/provincial :**
• Impôts des préfectures et provinces
• Répartition des recettes fiscales
• Contributions territoriales

🌍 **Niveau régional :**
• Fiscalité régionale
• Affectation des ressources aux régions
• Développement territorial

Que souhaitez-vous savoir sur la fiscalité des collectivités territoriales ?"""
        
        elif intent == "help_request":
            return """🆘 **Guide d'utilisation - Expert Fiscalité Territoriale**

**Types de questions que je traite :**
• Répartition des taxes entre collectivités
• Bénéficiaires des différents impôts
• Budget et ressources des communes/régions
• Fiscalité locale et territoriale

**Exemples de formulations efficaces :**
• "Qui bénéficie de [nom de la taxe] ?"
• "Comment est répartie [nom de l'impôt] ?"
• "Quelles sont les ressources fiscales des [communes/régions] ?"
• "Quel pourcentage de [taxe] va aux [collectivités] ?"

**Conseils pour de meilleures réponses :**
✅ Soyez spécifique sur la collectivité (commune, région, etc.)
✅ Mentionnez le type de taxe ou d'impôt
✅ Précisez si vous cherchez des pourcentages ou montants

Posez votre question sur la fiscalité territoriale !"""
        
        elif intent == "goodbye":
            return f"Au revoir{name_part} ! 👋 N'hésitez pas à revenir pour toute question sur la fiscalité des collectivités territoriales. Bonne journée !"
        
        return "Je suis là pour répondre à vos questions sur la fiscalité des collectivités territoriales. Comment puis-je vous aider ?"
    
    def search_fct_documents(self, query: str, limit: int = 12):
        """Recherche dans la collection FCT"""
        try:
            # Enrichir la requête avec des synonymes
            enriched_query = self.synonym_manager.expand_query(query)
            self.log_debug(f"🔍 Requête enrichie: {enriched_query}")
            
            # Générer l'embedding avec Voyage
            embedding_response = voyage_client.embed(
                texts=[enriched_query],
                model="voyage-law-2"
            )
            query_vector = embedding_response.embeddings[0]
            
            # Recherche dans Qdrant
            search_results = self.qdrant_client.search(
                collection_name=self.collections["main"],
                query_vector=query_vector,
                limit=limit,
                score_threshold=self.config["search_threshold"]
            )
            
            self.log_debug(f"✅ Trouvé {len(search_results)} documents FCT")
            return search_results
            
        except Exception as e:
            self.log_debug(f"❌ Erreur recherche FCT: {str(e)}")
            return []
    
    def search_fct_annexes(self, query: str, limit: int = 10):
        """Recherche dans les annexes FCT (collection FCT_Annexes)"""
        try:
            # Enrichir la requête avec des synonymes
            enriched_query = self.synonym_manager.expand_query(query)
            self.log_debug(f"🔍 Recherche annexes FCT: {enriched_query}")
            
            # Générer l'embedding avec Voyage
            embedding_response = voyage_client.embed(
                texts=[enriched_query],
                model="voyage-law-2"
            )
            query_vector = embedding_response.embeddings[0]
            
            # Recherche dans Qdrant
            search_results = self.qdrant_client.search(
                collection_name=self.collections["annexe"],
                query_vector=query_vector,
                limit=limit,
                score_threshold=self.config["annexe_score_threshold"]
            )
            
            self.log_debug(f"✅ Trouvé {len(search_results)} annexes FCT")
            return search_results
            
        except Exception as e:
            self.log_debug(f"❌ Erreur recherche annexes FCT: {str(e)}")
            return []
    
    def process_fct_annexes(self, query, fct_response, annexe_results):
        """Traite les annexes FCT et génère une réponse constructive"""
        
        if not annexe_results:
            return ""
        
        # Construire le contexte des annexes
        annexe_context = ""
        for i, result in enumerate(annexe_results):
            metadata = result.payload
            document = metadata.get("document", "Document")
            chapitre = metadata.get("chapitre", "")
            nom_chapitre = metadata.get("nom_chapitre", "")
            partie = metadata.get("partie", "")
            nom_partie = metadata.get("nom_partie", "")
            contenu = metadata.get("contenu", "")
            
            annexe_context += f"\n--- DOCUMENT {i+1} ---\n"
            annexe_context += f"Source: {document}\n"
            if chapitre:
                annexe_context += f"Chapitre: {chapitre}\n"
            if nom_chapitre:
                annexe_context += f"Nom chapitre: {nom_chapitre}\n"
            if partie:
                annexe_context += f"Partie: {partie}\n"
            if nom_partie:
                annexe_context += f"Nom partie: {nom_partie}\n"
            annexe_context += f"Contenu: {contenu}\n"
        
        # Prompt unifié pour traiter les annexes FCT
        unified_prompt = f"""Tu es un expert en fiscalité des collectivités territoriales marocaines.

CONTEXTE:
L'utilisateur a posé une question sur la fiscalité territoriale et a reçu une réponse basée sur les textes principaux.
Tu dois maintenant analyser si les documents d'application (notes de service, circulaires) apportent des précisions utiles.

QUESTION UTILISATEUR: "{query}"

RÉPONSE PRINCIPALE DÉJÀ FOURNIE:
{fct_response}

DOCUMENTS D'APPLICATION TROUVÉS:
{annexe_context}

INSTRUCTIONS:

1. **VÉRIFICATION DE PERTINENCE** : Analyse d'abord si les documents d'application apportent des précisions utiles et pertinentes à la question posée et à la réponse principale.

2. **SI LES DOCUMENTS NE SONT PAS PERTINENTS** (hors sujet, pas de précisions utiles, informations déjà couvertes) :
   - Réponds EXACTEMENT : "Aucune précisions à apporter"
   - Ne génère aucune autre réponse

3. **SI LES DOCUMENTS SONT PERTINENTS** :
   - EXTRAIT les informations spécifiques qui complètent ou précisent la réponse principale
   - GÉNÈRE une réponse constructive qui EXPLIQUE concrètement ce qui change ou se précise
   - CITE les documents par leur nom réel (ex: "Note de service - Loi n° 47-06") et NON par "document 1", "document 2"
   - INTÈGRE les informations trouvées dans une explication fluide et pratique
   - DONNE des réponses définitives basées sur les documents trouvés

STRUCTURE DE LA RÉPONSE (si pertinente):
- Identifier ce qui était imprécis dans la réponse principale
- Expliquer concrètement ce que les documents d'application apportent comme précisions
- Citer les documents par leur nom réel
- Donner la réponse finale claire et pratique

TON ET STYLE:
- Réponse fluide et naturelle, pas de format de citation
- Explication claire de ce qui change par rapport à la réponse principale
- Réponse définitive et pratique pour l'utilisateur
- Éviter les formules comme "il faut consulter" - donner directement la réponse
- Citer les documents par leur nom réel, jamais par "document 1", "document 2"

ANALYSE maintenant si les documents apportent des précisions pertinentes et réponds en conséquence."""
        
        try:
            model = genai.GenerativeModel("gemini-2.0-flash")
            response = model.generate_content(
                unified_prompt,
                generation_config={
                    "temperature": 0.1,
                    "max_output_tokens": 1200,
                }
            )
            
            annexe_response = response.text.strip()
            
            # Vérifier seulement si la réponse est vide
            if not annexe_response:
                return ""
            
            # Retourner la réponse constructive avec un séparateur clair
            return f"\n\n**📋 PRÉCISIONS APPORTÉES PAR LES TEXTES D'APPLICATION :**\n\n{annexe_response}"
                
        except Exception as e:
            self.log_debug(f"❌ Erreur traitement annexes FCT: {str(e)}")
            return ""
    
    def add_annexe_to_fct_response(self, fct_response, annexe_results, query):
        """Ajoute les informations d'annexe FCT à la réponse principale"""
        if not annexe_results:
            return fct_response
        
        # Utiliser le traitement unifié avec les résultats d'annexes
        annexe_info = self.process_fct_annexes(query, fct_response, annexe_results)
        
        if annexe_info:
            return fct_response + annexe_info
        else:
            return fct_response
    
    def generate_fct_response(self, query: str, fct_results, use_context=False):
        """Génère une réponse basée sur les documents FCT"""
        
        if not fct_results:
            return f"""❌ **Aucune information trouvée pour : "{query}"**

🔍 **Optimisez votre recherche avec :**
• **Termes territoriaux** : commune, préfecture, province, région
• **Types de taxes** : TVA, IS, IR, taxe professionnelle
• **Concepts clés** : bénéficiaire, répartition, affectation, budget
• **Questions précises** : "Qui bénéficie de la TVA ?", "Répartition IR communes"

💡 **Exemples de questions efficaces :**
• "Quelles taxes alimentent le budget communal ?"
• "Comment est répartie la TVA entre collectivités ?"
• "Qui bénéficie de l'impôt sur les sociétés ?"
• "Quel pourcentage de l'IR va aux régions ?"

Je suis spécialisé dans la fiscalité des collectivités territoriales marocaines !"""
        
        # Construire le contexte FCT
        fct_context = ""
        articles_found = set()
        
        for i, result in enumerate(fct_results):
            metadata = result.payload
            article_num = metadata.get("article", "N/A")
            article_name = metadata.get("nom_article", "Sans titre")
            content = metadata.get("contenu", "")
            partie = metadata.get("partie", "")
            titre = metadata.get("titre", "")
            chapitre = metadata.get("chapitre", "")
            section = metadata.get("section", "")
            
            fct_context += f"\n--- ARTICLE {article_num} ---\n"
            if partie:
                fct_context += f"Partie: {partie}\n"
            if titre:
                fct_context += f"Titre: {titre}\n"
            if chapitre:
                fct_context += f"Chapitre: {chapitre}\n"
            if section:
                fct_context += f"Section: {section}\n"
            fct_context += f"Article: {article_name}\n"
            fct_context += f"Contenu: {content}\n"
            
            articles_found.add(article_num)
        
        # Sauvegarder les articles trouvés
        self.conversation_context["last_articles"] = list(articles_found)
        
        # Prompt spécialisé pour les collectivités territoriales
        if use_context and self.conversation_context["waiting_for_clarification"]:
            main_prompt = f"""Tu es un expert en fiscalité des collectivités territoriales marocaines.

CONTEXTE DE CONVERSATION:
- Question précédente: {self.conversation_context['last_question']}
- Articles consultés: {', '.join(self.conversation_context['context_articles'])}
- Clarification demandée sur: {self.conversation_context.get('context_topic', 'aspect non précisé')}

L'utilisateur apporte des précisions.

RÈGLES D'EXCELLENCE:
1. Utilise le contexte pour affiner ta réponse
2. Cite TOUJOURS les articles avec leurs dispositions exactes
3. Structure ta réponse de manière claire et progressive
4. Anticipe les questions de suivi possibles

Question/clarification: "{query}"

Extraits des textes sur les collectivités territoriales:
{fct_context}"""
        else:
            main_prompt = f"""Tu es un expert en fiscalité des collectivités territoriales marocaines, spécialisé dans la répartition des taxes et impôts entre communes, préfectures, provinces et régions.

RÈGLES PRINCIPALES:
1. Réponds UNIQUEMENT en te basant sur les extraits fournis dans le contexte.
2. Ne fais JAMAIS de suppositions sur des informations non présentes dans le contexte.
3. Cite TOUJOURS les numéros d'articles précis sur lesquels tu t'appuies.
4. Pour ta PREMIÈRE réponse seulement, commence par "Votre question porte sur [sujet fiscal territorial précis]."
5. Respecte STRICTEMENT les pourcentages et répartitions mentionnés dans les articles.
6. Si un article donne une définition ou une répartition explicite, elle doit figurer dans ta réponse.
7. Mets l'accent sur les bénéficiaires (communes, préfectures, provinces, régions) et les pourcentages d'affectation.
8. Si une énumération dépasse 10 éléments, regroupe-les par type de collectivité.

STRUCTURE DE RÉPONSE:
- Première ligne: identification du sujet fiscal territorial (uniquement première réponse)
- Corps: explication claire avec citation explicite des articles et pourcentages
- Si nécessaire: demande précise d'informations complémentaires

N'UTILISE JAMAIS de formules comme "je ne sais pas" ou "je n'ai pas assez d'informations".
Si le contexte est insuffisant, demande des précisions ciblées.

L'utilisateur pose la question suivante : "{query}"

Extraits des textes sur les collectivités territoriales:
{fct_context}"""
        
        try:
            model = genai.GenerativeModel("gemini-2.0-flash")
            response = model.generate_content(
                main_prompt,
                generation_config={
                    "temperature": 0.1,
                    "top_p": 0.95,
                    "max_output_tokens": 2500,
                }
            )
            
            return response.text
            
        except Exception as e:
            return f"❌ Erreur lors de la génération de la réponse: {str(e)}"
    
    def _is_clarification_request(self, response: str) -> bool:
        """Détecte si la réponse demande une clarification"""
        clarification_indicators = [
            "pourriez-vous préciser",
            "pouvez-vous préciser", 
            "quelle collectivité",
            "dans quel contexte",
            "souhaitez-vous connaître",
            "de quel type",
            "pour quelle collectivité"
        ]
        
        response_lower = response.lower()
        return any(indicator in response_lower for indicator in clarification_indicators)
    
    def _extract_topic_from_response(self, response: str) -> str:
        """Extrait le sujet principal de la réponse pour le contexte"""
        topics = []
        
        territorial_concepts = {
            "répartition TVA": ["tva", "taxe sur la valeur ajoutée", "répartition"],
            "budget communal": ["commune", "communal", "budget"],
            "fiscalité régionale": ["région", "régional", "fiscalité"],
            "taxes préfectorales": ["préfecture", "province", "taxes"],
            "collectivités territoriales": ["collectivité", "territorial", "local"]
        }
        
        response_lower = response.lower()
        for concept, keywords in territorial_concepts.items():
            if any(kw in response_lower for kw in keywords):
                topics.append(concept)
        
        return topics[0] if topics else "fiscalité territoriale"
    
    def _update_context(self, question: str, response: str, articles: List[str]):
        """Met à jour le contexte de conversation"""
        self.conversation_context.update({
            "last_question": question,
            "last_response": response[:500],
            "waiting_for_clarification": self._is_clarification_request(response),
            "context_articles": articles,
            "context_topic": self._extract_topic_from_response(response)
        })
        
        # Ajouter à l'historique de recherche
        search_entry = {
            "query": question,
            "articles": articles,
            "timestamp": datetime.now()
        }
        self.conversation_context["search_history"].append(search_entry)
        
        # Garder seulement les 10 dernières recherches
        if len(self.conversation_context["search_history"]) > 10:
            self.conversation_context["search_history"] = self.conversation_context["search_history"][-10:]
    
    def process_query_excellence(self, query, messages_history=None):
        """Traite une requête avec excellence maximale pour les collectivités territoriales"""
        start_time = datetime.now()
        self.clear_debug_logs()
        
        self.log_debug(f"🚀 TRAITEMENT FCT: '{query}'")
        
        # Détection d'intention
        intent = self.detect_conversation_intent(query)
        self.log_debug(f"🧠 Intention: {intent}")
        
        # Traitement conversationnel
        if intent in ["greetings", "presentation_request", "help_request", "goodbye"]:
            conversational_response = self.generate_conversational_response(query, intent)
            execution_time = (datetime.now() - start_time).total_seconds()
            
            return {
                "response": conversational_response,
                "fct_articles": 0,
                "articles_found": [],
                "execution_time": execution_time,
                "debug_logs": self.get_debug_logs(),
                "context_used": False,
                "intent": intent,
                "search_method": "conversational"
            }
        
        # Traitement des questions fiscales territoriales
        original_query = query
        use_context = False
        
        # Vérification du contexte
        if (self.conversation_context["waiting_for_clarification"] and 
            intent == "clarification"):
            use_context = True
            self.log_debug("🔗 Utilisation du contexte de conversation")
        
        # RECHERCHE FCT
        fct_results = self.search_fct_documents(query, limit=12)
        
        # Génération de la réponse FCT
        fct_response = self.generate_fct_response(query, fct_results, use_context=use_context)
        
        # Extraction des articles
        articles_found = []
        for result in fct_results:
            article_num = result.payload.get("article", "N/A")
            if article_num != "N/A":
                articles_found.append(article_num)
        
        # Mise à jour du contexte
        self._update_context(original_query, fct_response, articles_found)
        
        execution_time = (datetime.now() - start_time).total_seconds()
        
        # Préparer les articles pour la base de données
        articles_info = []
        for result in fct_results:
            article_info = {
                "article": result.payload.get("article", "N/A"),
                "nom_article": result.payload.get("nom_article", "Sans titre"),
                "partie": result.payload.get("partie", ""),
                "titre": result.payload.get("titre", ""),
                "chapitre": result.payload.get("chapitre", ""),
                "section": result.payload.get("section", "")
            }
            articles_info.append(article_info)
        
        # Enregistrer dans la base de données
        conversation_id = None
        if self.db:
            conversation_id = self.db.save_conversation(
                question=query,
                response=fct_response,
                articles=articles_info,
                search_method="fct_territorial",
                semantic_score=fct_results[0].score if fct_results else 0.0,
                query_complexity=len(query.split()),
                execution_time=execution_time,
                model_used="voyage-law-2"
            )
        
        return {
            "response": fct_response,
            "fct_articles": len(fct_results),
            "articles_found": articles_found,
            "execution_time": execution_time,
            "debug_logs": self.get_debug_logs(),
            "context_used": use_context,
            "intent": intent,
            "search_method": "fct_territorial",
            "conversation_id": conversation_id
        }


# ===== FONCTIONS DU TABLEAU DE BORD SIMPLIFIÉES =====
def create_feedback_distribution_chart(db):
    """Crée un graphique montrant la répartition des types de feedback avec pourcentages"""
    try:
        # Récupérer toutes les conversations avec leur feedback
        db.cur.execute("""
        SELECT 
            CASE 
                WHEN feedback_type IS NULL THEN 'sans_feedback'
                ELSE feedback_type
            END as feedback,
            COUNT(*) as count
        FROM conversations
        GROUP BY feedback
        """)
        
        results = db.cur.fetchall()
        
        # Créer un DataFrame
        df = pd.DataFrame(results, columns=['feedback', 'count'])
        
        # Mapper pour des noms plus conviviaux
        feedback_mapping = {
            'positive': '✅ Positif',
            'negative': '❌ Négatif',
            'refresh': '🔄 À reformuler',
            'sans_feedback': '⚪ Sans feedback'
        }
        df['feedback_display'] = df['feedback'].map(lambda x: feedback_mapping.get(x, x))
        
        # Calculer les totaux et pourcentages
        total = df['count'].sum()
        df['percentage'] = df['count'] / total * 100
        
        # Définir les couleurs
        colors = {
            '✅ Positif': '#28a745',
            '❌ Négatif': '#dc3545',
            '🔄 À reformuler': '#17a2b8',
            '⚪ Sans feedback': '#6c757d'
        }
        
        # Créer un donut chart
        fig = go.Figure(data=[go.Pie(
            labels=df['feedback_display'],
            values=df['count'],
            hole=.4,  # Pour créer un donut au lieu d'un pie
            marker=dict(colors=[colors.get(x, '#999999') for x in df['feedback_display']]),
            textinfo='label+percent',
            hoverinfo='label+value+percent',
            textposition='outside',
            pull=[0.05 if x != '⚪ Sans feedback' else 0 for x in df['feedback_display']]  # Mettre en évidence les feedbacks
        )])
        
        fig.update_layout(
            title="Répartition des Types de Feedback",
            showlegend=False,
            annotations=[dict(text=f'Total: {total}', x=0.5, y=0.5, font_size=15, showarrow=False)],
            height=400
        )
        
        return fig
    except Exception as e:
        st.error(f"Erreur lors de la création du graphique de distribution des feedbacks: {str(e)}")
        return go.Figure().update_layout(title="Erreur lors du chargement des données")


# Interface Streamlit d'Excellence
def main():
    st.title("🏆 FISCALBOT 3.0 - Excellence Fiscale CGI")
    st.subheader("✨ Intelligence maximale + Recherche unifiée + Expertise complète")
    
    # Initialiser le bot
    @st.cache_resource
    def get_fiscal_bot():
        return FiscalBotExcellence()
    def get_territorial_bot():
        return TerritorialFiscalBot()
    
    bot = get_fiscal_bot()
    territorial_bot = get_territorial_bot()
    
    # Initialiser l'historique
    if "messages" not in st.session_state:
        st.session_state.messages = [
            {
                "role": "assistant", 
                "content": """🏆 **Bienvenue dans FiscalBot 3.0 - Excellence !**


Comment puis-je vous apporter une assistance d'excellence ?"""
            }
        ]
    
    # Dictionnaire pour stocker les IDs de conversation
    if "conversation_ids" not in st.session_state:
        st.session_state.conversation_ids = {}
    
    # Ajouter un état pour le commentaire
    if "feedback_mode" not in st.session_state:
        st.session_state.feedback_mode = None
        
    if "message_index" not in st.session_state:
        st.session_state.message_index = -1
    
    # Fonction pour activer le mode feedback
    def activate_feedback(button_type, msg_index):
        st.session_state.feedback_mode = button_type
        st.session_state.message_index = msg_index
        st.rerun()
    
    # Fonction pour enregistrer le feedback
    def save_feedback(feedback_type, feedback_comment, msg_index):
        if msg_index in st.session_state.conversation_ids:
            conversation_id = st.session_state.conversation_ids[msg_index]
            success = db.update_feedback(
                conversation_id=conversation_id,
                feedback_type=feedback_type,
                feedback_comment=feedback_comment
            )
            return success
        return False
    
    # Mode d'affichage
    app_mode = st.sidebar.radio("Mode d'affichage", ["💬 Assistant Fiscal", "📊 Tableau de Bord", "🏛️ Expert Fiscalité des collectivités territoriales"])
    
    # Sidebar optimisée
    with st.sidebar:
        st.subheader("🔗 Tableau de Bord Excellence")
        
        # Choisir le bot selon le mode
        current_bot = bot if app_mode == "💬 Assistant Fiscal" else territorial_bot if app_mode == "🏛️ Expert Fiscalité des collectivités territoriales" else bot
        
        # Informations utilisateur
        if current_bot.conversation_context.get("user_name"):
            st.success(f"👤 Utilisateur: {current_bot.conversation_context['user_name']}")
        
        # Contexte de conversation
        if current_bot.conversation_context["waiting_for_clarification"]:
            st.warning("⏳ Clarification attendue")
            st.write(f"**Sujet:** {current_bot.conversation_context.get('context_topic', 'Non défini')}")
            
            if current_bot.conversation_context["context_articles"]:
                st.write("**Articles en contexte:**")
                st.write(", ".join(current_bot.conversation_context["context_articles"]))
        else:
            if app_mode == "🏛️ Expert Fiscalité des collectivités territoriales":
                st.info("🏛️ Prêt pour vos questions territoriales")
            else:
                st.info("💬 Prêt pour toute question")
        
        # Historique de recherche
        if current_bot.conversation_context.get("search_history"):
            with st.expander("📜 Historique récent", expanded=False):
                for search in current_bot.conversation_context["search_history"][-3:]:
                    st.write(f"• {search['query'][:50]}...")
                    st.caption(f"Articles: {', '.join(search['articles'][:3])}")
        
        # Bouton nouvelle conversation
        if st.button("🔄 Nouvelle Conversation"):
            if app_mode == "🏛️ Expert Fiscalité des collectivités territoriales":
                # Réinitialiser pour le mode territorial
                if "territorial_messages" not in st.session_state:
                    st.session_state.territorial_messages = []
                st.session_state.territorial_messages = [
                    {"role": "assistant", "content": "Bonjour ! Je suis votre expert en fiscalité des collectivités territoriales. Comment puis-je vous aider ?"}
                ]
                territorial_bot._clear_context()
            else:
                # Réinitialiser pour le mode CGI
                st.session_state.messages = [st.session_state.messages[0]]
                bot._clear_context()
            
            st.session_state.conversation_ids = {}
            st.rerun()
    
    if app_mode == "💬 Assistant Fiscal":
        # Zone de chat principale
        for i, message in enumerate(st.session_state.messages):
            with st.chat_message(message["role"]):
                st.markdown(message["content"])
                
                # Ajouter les boutons de feedback après chaque réponse de l'assistant
                if message["role"] == "assistant" and i > 0:  # Ne pas ajouter pour le message d'accueil
                    col1, col2, col3, col4 = st.columns([1, 1, 1, 10])
                    with col1:
                        st.button("🔄", key=f"refresh_{i}", on_click=activate_feedback, args=("refresh", i))
                    with col2:
                        st.button("❌", key=f"negative_{i}", on_click=activate_feedback, args=("negative", i))
                    with col3:
                        st.button("✅", key=f"positive_{i}", on_click=activate_feedback, args=("positive", i))
        
        # Afficher la zone de commentaire si un bouton a été cliqué
        if st.session_state.feedback_mode:
            button_type = st.session_state.feedback_mode
            msg_index = st.session_state.message_index
            
            feedback_titles = {
                "refresh": "💬 Commentaire pour reformuler la réponse",
                "negative": "💬 Commentaire sur ce qui n'a pas fonctionné",
                "positive": "💬 Commentaire positif"
            }
            
            feedback_placeholders = {
                "refresh": "Expliquez comment vous souhaitez que la réponse soit reformulée...",
                "negative": "Expliquez ce qui n'a pas fonctionné dans cette réponse...",
                "positive": "Partagez ce que vous avez apprécié dans cette réponse..."
            }
            
            st.subheader(feedback_titles[button_type])
            feedback = st.text_area("Votre commentaire (optionnel):", placeholder=feedback_placeholders[button_type])
            
            col1, col2 = st.columns([1, 10])
            with col1:
                if st.button("Envoyer"):
                    # Enregistrer le feedback dans la base de données
                    success = save_feedback(button_type, feedback, msg_index)
                    
                    if success:
                        st.success("✅ Merci pour votre commentaire! Il a été enregistré avec succès.")
                    else:
                        st.warning("⚠️ Le commentaire n'a pas pu être enregistré. Veuillez réessayer.")
                    
                    # Désactiver le mode feedback après un court délai
                    import time
                    time.sleep(1.5)  # Attendre 1.5 secondes pour que l'utilisateur puisse voir le message
                    
                    st.session_state.feedback_mode = None
                    st.session_state.message_index = -1
                    st.rerun()
            
            with col2:
                if st.button("Annuler"):
                    # Désactiver le mode feedback
                    st.session_state.feedback_mode = None
                    st.session_state.message_index = -1
                    st.rerun()
        
        # Zone de saisie
        if prompt := st.chat_input("💬 Posez votre question fiscale..."):
            # Ajouter le message utilisateur
            st.session_state.messages.append({"role": "user", "content": prompt})
            with st.chat_message("user"):
                st.markdown(prompt)
            
            # Traiter la question
            with st.chat_message("assistant"):
                message_placeholder = st.empty()
                
                # Message d'attente intelligent
                if len(prompt.split()) <= 3:
                    message_placeholder.markdown("💭 Analyse de votre message...")
                else:
                    # Détecter le type de recherche
                    if any(word in prompt.lower() for word in ["article", "art."]) or re.match(r'^[\d\s,-]+$', prompt):
                        message_placeholder.markdown(f"📖 Recherche de l'article demandé...")
                    elif any(word in prompt.lower() for word in ["véhicule", "voiture", "amortissement"]):
                        message_placeholder.markdown(f"🚗 Recherche sur l'amortissement des véhicules...")
                    elif any(word in prompt.lower() for word in ["cotisation", "minimale"]):
                        message_placeholder.markdown(f"💰 Recherche sur la cotisation minimale...")
                    elif any(word in prompt.lower() for word in ["plastique", "industrie"]):
                        message_placeholder.markdown(f"🏭 Recherche sur les industries et exonérations...")
                    elif any(word in prompt.lower() for word in ["indemnité", "représentation"]):
                        message_placeholder.markdown(f"💼 Recherche sur les indemnités...")
                    else:
                        message_placeholder.markdown(f"🔍 Recherche d'excellence dans toute la base fiscale...")
                
                with st.spinner("Traitement en cours..."):
                    result = bot.process_query_excellence(prompt, st.session_state.messages)
                
                # Afficher la réponse
                response = result["response"]
                message_placeholder.markdown(response)
                
                # Ajouter au chat
                st.session_state.messages.append({"role": "assistant", "content": response})
                
                # Sauvegarder l'ID de conversation
                if result.get("conversation_id"):
                    msg_index = len(st.session_state.messages) - 1
                    st.session_state.conversation_ids[msg_index] = result["conversation_id"]
                
                # Ajouter les boutons de feedback pour cette nouvelle réponse
                col1, col2, col3, col4 = st.columns([1, 1, 1, 10])
                msg_index = len(st.session_state.messages) - 1
                with col1:
                    st.button("🔄", key=f"refresh_{msg_index}", on_click=activate_feedback, args=("refresh", msg_index))
                with col2:
                    st.button("❌", key=f"negative_{msg_index}", on_click=activate_feedback, args=("negative", msg_index))
                with col3:
                    st.button("✅", key=f"positive_{msg_index}", on_click=activate_feedback, args=("positive", msg_index))
                
                # Métriques détaillées
                intent = result.get("intent", "unknown")
                
                if intent in ["fiscal_question", "general_question"]:
                    with st.expander("📊 Analyse détaillée de la recherche", expanded=False):
                        # Première ligne de métriques
                        col1, col2, col3, col4 = st.columns(4)
                        
                        with col1:
                            st.metric("Articles CGI", result["cgi_articles"])
                        
                        with col2:
                            if "annexe_docs" in result:
                                st.metric("Documents annexe", result["annexe_docs"])
                            else:
                                st.metric("Annexes FCT", result.get("fct_annexes", 0))
                        
                        with col3:
                            st.metric("Temps", f"{result['execution_time']:.2f}s")
                        
                        with col4:
                            st.metric("Articles trouvés", len(result["articles_found"]))
                        
                        # Deuxième ligne - Performance
                        col1, col2, col3 = st.columns(3)
                        
                        with col1:
                            st.metric("Recherche", "Hybride")
                        
                        with col2:
                            context_text = "Avec contexte" if result.get("context_used") else "Sans contexte"
                            st.metric("Mode", context_text)
                        
                        with col3:
                            collections = len(result.get("collections_searched", []))
                            st.metric("Collections", collections)
                        
                        # Informations détaillées
                        st.success(f"🏆 Méthode: {result.get('search_method', 'standard')}")
                        
                        if result.get("enrichment_used"):
                            st.info("✅ Enrichissement par synonymes actif")
                        
                        if result["articles_found"]:
                            st.write("**Articles consultés:**")
                            articles_display = ", ".join(result["articles_found"][:10])
                            if len(result["articles_found"]) > 10:
                                articles_display += f" (+{len(result['articles_found'])-10} autres)"
                            st.write(articles_display)
                        
                        # Collections recherchées
                        if result.get("collections_searched"):
                            st.write("**Collections analysées:**")
                            st.write(" • ".join(result["collections_searched"]))
                        
                        # Logs techniques (optionnel)
                        if st.checkbox("🔧 Logs techniques détaillés", key=f"debug_{len(st.session_state.messages)}"):
                            st.write("**Logs de recherche:**")
                            for log in result["debug_logs"][-20:]:  # Derniers 20 logs
                                if "✅" in log:
                                    st.success(log)
                                elif "❌" in log:
                                    st.error(log)
                                elif "🔄" in log:
                                    st.info(log)
                                else:
                                    st.text(log)
                
                elif intent in ["greetings", "presentation_request", "help_request"]:
                    with st.expander("ℹ️ Interaction conversationnelle", expanded=False):
                        st.success(f"Type: {intent}")
                        st.info(f"Méthode: {result.get('search_method')}")
                        st.info(f"Temps: {result['execution_time']:.3f}s")
                        
                        # Afficher les capacités du système
                        st.write("**Capacités actives:**")
                        st.write("• Recherche unifiée CGI + Annexes")
                        st.write("• Enrichissement par synonymes")
                        st.write("• Détection de contexte avancée")
                        st.write("• Zéro répétition garantie")
                        st.write("• Support des articles complexes (10-III)")
                        st.write("• Collection annexe optimisée")
    
    elif app_mode == "📊 Tableau de Bord":
        st.title("📊 FISCALBOT - Tableau de Bord")
        st.subheader("Analyse des Données et Statistiques")
        
        # Récupérer les données
        feedback_stats = db.get_feedback_stats()
        
        # Calculer les KPIs
        if feedback_stats:
            total_conversations = sum(count for _, count in feedback_stats)
            positive_count = next((count for type, count in feedback_stats if type == 'positive'), 0)
            negative_count = next((count for type, count in feedback_stats if type == 'negative'), 0)
            refresh_count = next((count for type, count in feedback_stats if type == 'refresh'), 0)
        else:
            total_conversations = 0
            positive_count = 0
            negative_count = 0
            refresh_count = 0
        
        # Afficher les KPIs dans des colonnes
        col1, col2, col3, col4 = st.columns(4)
        
        with col1:
            st.metric(label="Total des Conversations", value=total_conversations)
        
        with col2:
            positive_percent = (positive_count / total_conversations * 100) if total_conversations > 0 else 0
            st.metric(label="✅ Feedbacks Positifs", value=f"{positive_count} ({positive_percent:.1f}%)")
        
        with col3:
            negative_percent = (negative_count / total_conversations * 100) if total_conversations > 0 else 0
            st.metric(label="❌ Feedbacks Négatifs", value=f"{negative_count} ({negative_percent:.1f}%)")
        
        with col4:
            refresh_percent = (refresh_count / total_conversations * 100) if total_conversations > 0 else 0
            st.metric(label="🔄 À Reformuler", value=f"{refresh_count} ({refresh_percent:.1f}%)")
        
        # Graphique de distribution des feedbacks
        st.subheader("📊 Répartition des Feedbacks")
        
        if feedback_stats:
            feedback_fig = create_feedback_distribution_chart(db)
            st.plotly_chart(feedback_fig, use_container_width=True)
        else:
            st.info("Aucune donnée de feedback disponible.")
        
        # Historique des conversations
        st.subheader("💬 Historique Complet des Conversations")
        
        # Ajouter un filtre pour le type de feedback
        col1, col2 = st.columns([1, 2])
        
        with col1:
            feedback_filter = st.selectbox(
                "Filtrer par type de feedback :",
                ["Tous", "✅ Positif", "❌ Négatif", "🔄 À reformuler", "⚪ Sans feedback"],
                key="history_feedback_filter"
            )
        
        # Nombre initial de conversations à afficher
        if "history_limit" not in st.session_state:
            st.session_state.history_limit = 10
        
        # Mapper la sélection aux valeurs de la base de données
        feedback_map = {
            "✅ Positif": "positive",
            "❌ Négatif": "negative", 
            "🔄 À reformuler": "refresh",
            "⚪ Sans feedback": None,
            "Tous": "all"
        }
        
        reverse_feedback_map = {
            "positive": "✅ Positif",
            "negative": "❌ Négatif",
            "refresh": "🔄 À reformuler",
            None: "⚪ Sans feedback"
        }
        
        selected_feedback = feedback_map[feedback_filter]
        
        # Récupérer les conversations avec le filtre sélectionné
        filtered_history = db.get_conversation_history(
            feedback_type=selected_feedback, 
            limit=st.session_state.history_limit
        )
        
        if filtered_history:
            # Afficher un compteur du nombre de conversations
            st.write(f"**Affichage de {len(filtered_history)} conversation(s)**")
            
            # Afficher les conversations dans des expanders
            for i, (conv_id, question, response, feedback_type, feedback_comment, timestamp) in enumerate(filtered_history):
                # Formater l'horodatage
                formatted_time = timestamp.strftime("%d/%m/%Y à %H:%M")
                
                # Déterminer l'icône de feedback
                feedback_icon = "⚪"
                if feedback_type == 'positive':
                    feedback_icon = "✅"
                elif feedback_type == 'negative':
                    feedback_icon = "❌"
                elif feedback_type == 'refresh':
                    feedback_icon = "🔄"
                
                # Créer un expander pour chaque conversation
                with st.expander(f"{feedback_icon} Conversation #{conv_id} - {formatted_time}"):
                    st.markdown("**Question:**")
                    st.markdown(question)
                    
                    st.markdown("**Réponse:**")
                    st.markdown(response)
                    
                    if feedback_comment:
                        st.markdown("**Commentaire:**")
                        st.markdown(f"_{feedback_comment}_")
                    
                    # Section actions administrateur
                    st.markdown("---")
                    st.markdown("### ⚙️ Actions administrateur")
                    
                    # Utiliser des colonnes pour structurer les actions
                    update_col1, update_col2 = st.columns(2)
                    
                    with update_col1:
                        # Déterminer l'option actuelle 
                        current_feedback_option = reverse_feedback_map.get(feedback_type, "⚪ Sans feedback")
                        
                        # Fixer l'index correct
                        options = ["✅ Positif", "❌ Négatif", "🔄 À reformuler", "⚪ Sans feedback"]
                        default_index = options.index(current_feedback_option) if current_feedback_option in options else 3  # Default to "Sans feedback"
                        
                        new_feedback = st.selectbox(
                            "Modifier le feedback:",
                            options,
                            index=default_index,
                            key=f"update_feedback_{conv_id}"
                        )
                    
                    with update_col2:
                        new_comment = st.text_area(
                            "Modifier le commentaire:",
                            value=feedback_comment if feedback_comment else "",
                            key=f"update_comment_{conv_id}"
                        )
                    
                    if st.button("Mettre à jour", key=f"update_button_{conv_id}"):
                        # Mettre à jour le feedback dans la base de données
                        updated_type = feedback_map[new_feedback]
                        success = db.update_feedback(conv_id, updated_type, new_comment)
                        if success:
                            st.success("Feedback mis à jour avec succès!")
                            st.rerun()
                        else:
                            st.error("Erreur lors de la mise à jour du feedback.")
            
            # Ajouter un bouton "Charger plus"
            if len(filtered_history) == st.session_state.history_limit:
                if st.button("Charger plus de conversations"):
                    st.session_state.history_limit += 10
                    st.rerun()
        else:
            st.info(f"Aucune conversation {feedback_filter.lower()} disponible dans l'historique.")
    
    elif app_mode == "🏛️ Expert Fiscalité des collectivités territoriales":
        st.title("🏛️ Expert Fiscalité des collectivités territoriales")
        st.subheader("Assistant spécialisé pour les communes, préfectures et régions")
        
        # Initialiser les messages pour cet onglet si nécessaire
        if "territorial_messages" not in st.session_state:
            st.session_state.territorial_messages = [
                {"role": "assistant", "content": """🏛️ **Bienvenue dans l'Expert Fiscalité des Collectivités Territoriales !**

Je suis spécialisé dans la fiscalité locale marocaine :
• Taxes et contributions communales
• Impôts des préfectures et provinces
• Fiscalité régionale
• Répartition des recettes fiscales

Comment puis-je vous aider avec la fiscalité territoriale ?"""}
            ]
        
        # Dictionnaire pour stocker les IDs de conversation territoriales
        if "territorial_conversation_ids" not in st.session_state:
            st.session_state.territorial_conversation_ids = {}
        
        # Ajouter un état pour le feedback territorial
        if "territorial_feedback_mode" not in st.session_state:
            st.session_state.territorial_feedback_mode = None
            
        if "territorial_message_index" not in st.session_state:
            st.session_state.territorial_message_index = -1
        
        # Fonction pour activer le mode feedback territorial
        def activate_territorial_feedback(button_type, msg_index):
            st.session_state.territorial_feedback_mode = button_type
            st.session_state.territorial_message_index = msg_index
            st.rerun()
        
        # Fonction pour enregistrer le feedback territorial
        def save_territorial_feedback(feedback_type, feedback_comment, msg_index):
            if msg_index in st.session_state.territorial_conversation_ids:
                conversation_id = st.session_state.territorial_conversation_ids[msg_index]
                success = db.update_feedback(
                    conversation_id=conversation_id,
                    feedback_type=feedback_type,
                    feedback_comment=feedback_comment
                )
                return success
            return False
        
        # Zone de chat principale
        for i, message in enumerate(st.session_state.territorial_messages):
            with st.chat_message(message["role"]):
                st.markdown(message["content"])
                
                # Ajouter les boutons de feedback après chaque réponse de l'assistant
                if message["role"] == "assistant" and i > 0:  # Ne pas ajouter pour le message d'accueil
                    col1, col2, col3, col4 = st.columns([1, 1, 1, 10])
                    with col1:
                        st.button("🔄", key=f"territorial_refresh_{i}", on_click=activate_territorial_feedback, args=("refresh", i))
                    with col2:
                        st.button("❌", key=f"territorial_negative_{i}", on_click=activate_territorial_feedback, args=("negative", i))
                    with col3:
                        st.button("✅", key=f"territorial_positive_{i}", on_click=activate_territorial_feedback, args=("positive", i))
        
        # Afficher la zone de commentaire si un bouton a été cliqué
        if st.session_state.territorial_feedback_mode:
            button_type = st.session_state.territorial_feedback_mode
            msg_index = st.session_state.territorial_message_index
            
            feedback_titles = {
                "refresh": "💬 Commentaire pour reformuler la réponse",
                "negative": "💬 Commentaire sur ce qui n'a pas fonctionné",
                "positive": "💬 Commentaire positif"
            }
            
            feedback_placeholders = {
                "refresh": "Expliquez comment vous souhaitez que la réponse soit reformulée...",
                "negative": "Expliquez ce qui n'a pas fonctionné dans cette réponse...",
                "positive": "Partagez ce que vous avez apprécié dans cette réponse..."
            }
            
            st.subheader(feedback_titles[button_type])
            feedback = st.text_area("Votre commentaire (optionnel):", placeholder=feedback_placeholders[button_type], key="territorial_feedback_text")
            
            col1, col2 = st.columns([1, 10])
            with col1:
                if st.button("Envoyer", key="territorial_send_feedback"):
                    # Enregistrer le feedback dans la base de données
                    success = save_territorial_feedback(button_type, feedback, msg_index)
                    
                    if success:
                        st.success("✅ Merci pour votre commentaire! Il a été enregistré avec succès.")
                    else:
                        st.warning("⚠️ Le commentaire n'a pas pu être enregistré. Veuillez réessayer.")
                    
                    # Désactiver le mode feedback après un court délai
                    import time
                    time.sleep(1.5)  # Attendre 1.5 secondes pour que l'utilisateur puisse voir le message
                    
                    st.session_state.territorial_feedback_mode = None
                    st.session_state.territorial_message_index = -1
                    st.rerun()
            
            with col2:
                if st.button("Annuler", key="territorial_cancel_feedback"):
                    # Désactiver le mode feedback
                    st.session_state.territorial_feedback_mode = None
                    st.session_state.territorial_message_index = -1
                    st.rerun()
        
        # Zone de saisie
        if prompt := st.chat_input("💬 Posez votre question sur la fiscalité territoriale..."):
            # Ajouter le message utilisateur
            st.session_state.territorial_messages.append({"role": "user", "content": prompt})
            with st.chat_message("user"):
                st.markdown(prompt)
            
            # Traiter la question
            with st.chat_message("assistant"):
                message_placeholder = st.empty()
                
                # Message d'attente intelligent
                if any(word in prompt.lower() for word in ["commune", "communal", "municipal"]):
                    message_placeholder.markdown(f"🏘️ Recherche sur la fiscalité communale...")
                elif any(word in prompt.lower() for word in ["région", "régional"]):
                    message_placeholder.markdown(f"🌍 Recherche sur la fiscalité régionale...")
                elif any(word in prompt.lower() for word in ["préfecture", "province"]):
                    message_placeholder.markdown(f"🏢 Recherche sur la fiscalité préfectorale/provinciale...")
                elif any(word in prompt.lower() for word in ["répartition", "bénéficiaire"]):
                    message_placeholder.markdown(f"📊 Recherche sur la répartition des taxes...")
                else:
                    message_placeholder.markdown(f"🔍 Recherche dans la fiscalité territoriale...")
                
                with st.spinner("Traitement en cours..."):
                    result = territorial_bot.process_query_excellence(prompt, st.session_state.territorial_messages)
                
                # Afficher la réponse
                response = result["response"]
                message_placeholder.markdown(response)
                
                # Ajouter au chat
                st.session_state.territorial_messages.append({"role": "assistant", "content": response})
                
                # Sauvegarder l'ID de conversation
                if result.get("conversation_id"):
                    msg_index = len(st.session_state.territorial_messages) - 1
                    st.session_state.territorial_conversation_ids[msg_index] = result["conversation_id"]
                
                # Ajouter les boutons de feedback pour cette nouvelle réponse
                col1, col2, col3, col4 = st.columns([1, 1, 1, 10])
                msg_index = len(st.session_state.territorial_messages) - 1
                with col1:
                    st.button("🔄", key=f"territorial_refresh_{msg_index}", on_click=activate_territorial_feedback, args=("refresh", msg_index))
                with col2:
                    st.button("❌", key=f"territorial_negative_{msg_index}", on_click=activate_territorial_feedback, args=("negative", msg_index))
                with col3:
                    st.button("✅", key=f"territorial_positive_{msg_index}", on_click=activate_territorial_feedback, args=("positive", msg_index))
                
                # Métriques détaillées
                intent = result.get("intent", "unknown")
                
                if intent in ["fiscal_question", "general_question"]:
                    with st.expander("📊 Analyse détaillée de la recherche territoriale", expanded=False):
                        # Première ligne de métriques
                        col1, col2, col3, col4 = st.columns(4)
                        
                        with col1:
                            st.metric("Articles FCT", result["fct_articles"])
                        
                        with col2:
                            st.metric("Temps", f"{result['execution_time']:.2f}s")
                        
                        with col3:
                            st.metric("Articles trouvés", len(result["articles_found"]))
                        
                        with col4:
                            context_text = "Avec contexte" if result.get("context_used") else "Sans contexte"
                            st.metric("Mode", context_text)
                        
                        # Informations détaillées
                        st.success(f"🏛️ Méthode: {result.get('search_method', 'fct_territorial')}")
                        
                        if result["articles_found"]:
                            st.write("**Articles consultés:**")
                            articles_display = ", ".join(result["articles_found"][:10])
                            if len(result["articles_found"]) > 10:
                                articles_display += f" (+{len(result['articles_found'])-10} autres)"
                            st.write(articles_display)
                        
                        # Logs techniques (optionnel)
                        if st.checkbox("🔧 Logs techniques détaillés", key=f"territorial_debug_{len(st.session_state.territorial_messages)}"):
                            st.write("**Logs de recherche:**")
                            for log in result["debug_logs"][-20:]:  # Derniers 20 logs
                                if "✅" in log:
                                    st.success(log)
                                elif "❌" in log:
                                    st.error(log)
                                elif "🔄" in log:
                                    st.info(log)
                                else:
                                    st.text(log)
                
                elif intent in ["greetings", "presentation_request", "help_request"]:
                    with st.expander("ℹ️ Interaction conversationnelle territoriale", expanded=False):
                        st.success(f"Type: {intent}")
                        st.info(f"Méthode: {result.get('search_method')}")
                        st.info(f"Temps: {result['execution_time']:.3f}s")
                        
                        # Afficher les capacités du système territorial
                        st.write("**Capacités actives:**")
                        st.write("• Recherche dans la collection FCT")
                        st.write("• Enrichissement par synonymes territoriaux")
                        st.write("• Détection de contexte territorial")
                        st.write("• Spécialisation communes/préfectures/régions")
                        st.write("• Analyse des répartitions fiscales")

if __name__ == "__main__":
    main()