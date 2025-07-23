"""
API FastAPI pour FiscalBot 3.0 - Assistant Fiscal CGI Excellence
Architecture moderne avec DynamoDB + synchronisation PostgreSQL pour dashboard Streamlit
"""

from fastapi import FastAPI, HTTPException, Depends, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
import uuid
import json
import re
import asyncio
from concurrent.futures import ThreadPoolExecutor
import logging

# Imports pour les services externes
import boto3
from boto3.dynamodb.conditions import Key
import qdrant_client
from qdrant_client.models import Filter, FieldCondition, MatchValue, MatchAny, MatchText
import google.generativeai as genai
import voyageai
import psycopg2
from psycopg2.extras import RealDictCursor

# Configuration des logs
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configuration des API
GEMINI_API_KEY = "AIzaSyDmG5LqJhaAthC8GrgjE9eIdHcWSNQJTmE"
VOYAGE_API_KEY = "pa-gPu9JZffTtb0O57mU8ZNtCzWBrQ7dDRy_7M_f6Cr8br"

# Initialisation des clients
genai.configure(api_key=GEMINI_API_KEY)
voyage_client = voyageai.Client(api_key=VOYAGE_API_KEY)
qdrant_client_main = qdrant_client.QdrantClient(host="13.39.82.37", port=6333)

# Configuration DynamoDB
dynamodb = boto3.resource("dynamodb", region_name="eu-west-3")
conversations_table = dynamodb.Table("fiscal-bot-conversations-v3")

# Configuration FastAPI
app = FastAPI(
    title="FiscalBot 3.0 API",
    description="API REST pour assistant fiscal CGI Excellence avec DynamoDB et synchronisation PostgreSQL",
    version="3.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # À restreindre en production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ===== MODÈLES PYDANTIC =====

class MessageRole(str):
    """Rôles des messages dans une conversation"""
    USER = "user"
    ASSISTANT = "assistant"

class Message(BaseModel):
    """Modèle pour un message dans une conversation"""
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    conversation_id: str
    role: MessageRole
    content: str
    timestamp: datetime = Field(default_factory=datetime.now)
    metadata: Optional[Dict[str, Any]] = None

class Conversation(BaseModel):
    """Modèle pour une conversation"""
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)
    title: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None

class CreateConversationRequest(BaseModel):
    """Requête pour créer une nouvelle conversation"""
    user_id: str
    title: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None

class SendMessageRequest(BaseModel):
    """Requête pour envoyer un message"""
    content: str
    metadata: Optional[Dict[str, Any]] = None

class ConversationResponse(BaseModel):
    """Réponse complète d'une conversation avec messages"""
    conversation: Conversation
    messages: List[Message]

class SearchRequest(BaseModel):
    """Requête de recherche dans les documents"""
    query: str
    limit: Optional[int] = 10
    threshold: Optional[float] = 0.08

class SearchResult(BaseModel):
    """Résultat de recherche"""
    content: str
    score: float
    metadata: Dict[str, Any]

class FeedbackRequest(BaseModel):
    """Requête de feedback utilisateur"""
    message_id: str
    feedback_type: str  # "positive", "negative", "neutral"
    comment: Optional[str] = None

# ===== GESTIONNAIRE DYNAMODB =====

class DynamoDBManager:
    """Gestionnaire DynamoDB pour les conversations"""
    
    def __init__(self):
        self.table = conversations_table
    
    async def create_conversation(self, request: CreateConversationRequest) -> Conversation:
        """Crée une nouvelle conversation dans DynamoDB"""
        conversation = Conversation(
            user_id=request.user_id,
            title=request.title,
            metadata=request.metadata
        )
        
        # Stocker les métadonnées de la conversation
        self.table.put_item(
            Item={
                "PK": f"CONV#{conversation.id}",
                "SK": "META",
                "conversation_id": conversation.id,
                "user_id": conversation.user_id,
                "title": conversation.title,
                "created_at": conversation.created_at.isoformat(),
                "updated_at": conversation.updated_at.isoformat(),
                "metadata": conversation.metadata or {}
            }
        )
        
        return conversation
    
    async def get_conversation(self, conversation_id: str) -> Optional[ConversationResponse]:
        """Récupère une conversation avec ses messages depuis DynamoDB"""
        try:
            # Récupérer tous les items de la conversation
            response = self.table.query(
                KeyConditionExpression=Key("PK").eq(f"CONV#{conversation_id}"),
                ScanIndexForward=True  # Tri par SK croissant
            )
            
            items = response.get("Items", [])
            if not items:
                return None
            
            # Séparer métadonnées et messages
            conversation_meta = None
            messages = []
            
            for item in items:
                if item["SK"] == "META":
                    conversation_meta = item
                elif item["SK"].startswith("MSG#"):
                    messages.append(Message(
                        id=item.get("message_id"),
                        conversation_id=conversation_id,
                        role=item.get("role"),
                        content=item.get("content"),
                        timestamp=datetime.fromisoformat(item.get("timestamp")),
                        metadata=item.get("metadata")
                    ))
            
            if not conversation_meta:
                return None
            
            conversation = Conversation(
                id=conversation_id,
                user_id=conversation_meta.get("user_id"),
                title=conversation_meta.get("title"),
                created_at=datetime.fromisoformat(conversation_meta.get("created_at")),
                updated_at=datetime.fromisoformat(conversation_meta.get("updated_at")),
                metadata=conversation_meta.get("metadata")
            )
            
            return ConversationResponse(conversation=conversation, messages=messages)
            
        except Exception as e:
            logger.error(f"Erreur récupération conversation DynamoDB: {str(e)}")
            return None
    
    async def save_message(self, message: Message) -> Message:
        """Sauvegarde un message dans DynamoDB"""
        try:
            # Générer une clé de tri basée sur le timestamp pour l'ordre
            timestamp_key = message.timestamp.strftime("%Y%m%d%H%M%S%f")
            
            self.table.put_item(
                Item={
                    "PK": f"CONV#{message.conversation_id}",
                    "SK": f"MSG#{timestamp_key}",
                    "message_id": message.id,
                    "role": message.role,
                    "content": message.content,
                    "timestamp": message.timestamp.isoformat(),
                    "metadata": message.metadata or {}
                }
            )
            
            # Mettre à jour le timestamp de la conversation
            self.table.update_item(
                Key={
                    "PK": f"CONV#{message.conversation_id}",
                    "SK": "META"
                },
                UpdateExpression="SET updated_at = :timestamp",
                ExpressionAttributeValues={
                    ":timestamp": datetime.now().isoformat()
                }
            )
            
            return message
            
        except Exception as e:
            logger.error(f"Erreur sauvegarde message DynamoDB: {str(e)}")
            raise
    
    async def delete_conversation(self, conversation_id: str) -> bool:
        """Supprime une conversation et ses messages de DynamoDB"""
        try:
            # Récupérer tous les items à supprimer
            response = self.table.query(
                KeyConditionExpression=Key("PK").eq(f"CONV#{conversation_id}")
            )
            
            items = response.get("Items", [])
            if not items:
                return False
            
            # Supprimer tous les items
            with self.table.batch_writer() as batch:
                for item in items:
                    batch.delete_item(
                        Key={
                            "PK": item["PK"],
                            "SK": item["SK"]
                        }
                    )
            
            return True
            
        except Exception as e:
            logger.error(f"Erreur suppression conversation DynamoDB: {str(e)}")
            return False

# ===== GESTIONNAIRE POSTGRESQL (POUR STREAMLIT DASHBOARD) =====

class PostgreSQLSyncManager:
    """Gestionnaire de synchronisation avec PostgreSQL pour le dashboard Streamlit"""
    
    def __init__(self):
        self.connection_params = {
            "host": "aws-0-eu-west-3.pooler.supabase.com",
            "port": "6543",
            "database": "postgres",
            "user": "postgres.hhgbwbmfmkpzumlvwsfi",
            "password": "8-fJh4+&qh73uHK"
        }
    
    def get_connection(self):
        """Obtient une connexion à PostgreSQL"""
        return psycopg2.connect(**self.connection_params)
    
    async def sync_conversation_to_streamlit(self, user_question: str, ai_response: str, 
                                           articles_found: List[str], search_method: str = "api_v3",
                                           execution_time: float = 0.0):
        """Synchronise une conversation vers la base Streamlit (format legacy)"""
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    # Insérer dans le format attendu par Streamlit
                    cur.execute("""
                        INSERT INTO conversations (
                            question, response, articles, search_method, 
                            execution_time, model_used, timestamp
                        ) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        RETURNING id
                    """, (
                        user_question,
                        ai_response,
                        json.dumps(articles_found),  # Articles trouvés en JSON
                        search_method,
                        execution_time,
                        "gemini-2.0-flash-exp",
                        datetime.now()
                    ))
                    
                    conversation_id = cur.fetchone()[0]
                    conn.commit()
                    
                    logger.info(f"Conversation synchronisée vers Streamlit: {conversation_id}")
                    return conversation_id
                    
        except Exception as e:
            logger.error(f"Erreur synchronisation PostgreSQL: {str(e)}")
            return None
    
    async def save_feedback(self, feedback: FeedbackRequest) -> bool:
        """Sauvegarde un feedback (optionnel pour compatibilité)"""
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    # Note: Le feedback sera lié indirectement via le contenu du message
                    # Car la structure legacy ne supporte pas les message_id
                    cur.execute("""
                        INSERT INTO conversations (
                            question, response, articles, feedback_type, feedback_comment,
                            search_method, model_used, timestamp
                        ) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    """, (
                        f"FEEDBACK: {feedback.message_id}",
                        f"Feedback reçu: {feedback.feedback_type}",
                        json.dumps([]),
                        feedback.feedback_type,
                        feedback.comment,
                        "feedback_api",
                        "system",
                        datetime.now()
                    ))
                    conn.commit()
                    return True
        except Exception as e:
            logger.error(f"Erreur sauvegarde feedback: {str(e)}")
            return False

# ===== GESTIONNAIRE DE SYNONYMES FISCAUX =====

class FiscalSynonymManager:
    """Gestionnaire de synonymes pour améliorer la recherche sémantique"""
    
    def __init__(self):
        self.synonyms = {
            # Produits alimentaires
            "poisson": ["produits de la pêche", "produits maritimes", "produits de mer", 
                       "poissons frais", "poisson congelé", "produits halieutiques"],
            "viande": ["viandes fraîches", "produits carnés", "viande bovine", "viande ovine",
                      "viande caprine", "viande de volaille", "produits d'abattoir"],
            "légumes": ["produits maraîchers", "légumes frais", "produits végétaux",
                       "légumineuses", "tubercules", "produits horticoles"],
            
            # Termes fiscaux
            "exonération": ["exonéré", "exemption", "franchise", "dispense", "non assujetti"],
            "impôt": ["taxe", "imposition", "contribution", "prélèvement", "redevance"],
            "société": ["entreprise", "compagnie", "firme", "personne morale", "entité"],
            "revenu": ["rémunération", "gain", "bénéfice", "profit", "recette"],
            
            # Types d'impôts
            "TVA": ["taxe sur la valeur ajoutée", "T.V.A", "tva"],
            "IS": ["impôt sur les sociétés", "I.S", "impôt sociétés"],
            "IR": ["impôt sur le revenu", "I.R", "impôt revenu"],
            
            # Secteurs d'activité
            "plastique": ["matière plastique", "polymère", "PVC", "polyéthylène", 
                         "polypropylène", "matériaux plastiques", "industrie plastique"],
            "kinésithérapeute": ["kinésithérapie", "masseur-kinésithérapeute", "kiné", 
                                "rééducation fonctionnelle", "physiothérapeute"],
        }
        
        # Index inversé pour recherche rapide
        self.inverse_index = {}
        for main_term, synonyms in self.synonyms.items():
            for synonym in synonyms:
                self.inverse_index[synonym.lower()] = main_term
            self.inverse_index[main_term.lower()] = main_term
    
    def expand_query(self, query: str) -> str:
        """Enrichit une requête avec des synonymes pertinents"""
        query_lower = query.lower()
        expanded_terms = []
        
        for term, synonyms in self.synonyms.items():
            if term.lower() in query_lower:
                for synonym in synonyms[:3]:  # Limiter à 3 synonymes
                    if synonym.lower() not in query_lower:
                        expanded_terms.append(synonym)
        
        if expanded_terms:
            return f"{query} {' '.join(expanded_terms)}"
        return query

# ===== MOTEUR DE RECHERCHE FISCAL =====

class FiscalSearchEngine:
    """Moteur de recherche sémantique pour les documents fiscaux"""
    
    def __init__(self):
        self.qdrant_client = qdrant_client_main
        self.synonym_manager = FiscalSynonymManager()
        
        # Collections Qdrant
        self.collections = {
            "main": "cgi_mainvoyage",
            "parent": "cgi_article_parentvoyage", 
            "sections": "cgi_sectionsvoyage",
            "annexe": "cgi_annexe_optimized"
        }
        
        # Configuration de recherche
        self.config = {
            "main_search_threshold": 0.08,
            "semantic_search_limit": 12,
            "annexe_score_threshold": 0.05,
            "annexe_search_limit": 20
        }
    
    async def search_cgi_articles(self, query: str, limit: int = 12) -> List[Dict[str, Any]]:
        """Recherche dans les articles CGI principaux"""
        try:
            # Enrichir la requête avec des synonymes
            expanded_query = self.synonym_manager.expand_query(query)
            
            # Générer l'embedding de la requête
            embedding_response = voyage_client.embed(
                texts=[expanded_query], 
                model="voyage-3", 
                input_type="query"
            )
            query_embedding = embedding_response.embeddings[0]
            
            # Recherche dans la collection principale
            search_results = self.qdrant_client.search(
                collection_name=self.collections["main"],
                query_vector=query_embedding,
                limit=limit,
                score_threshold=self.config["main_search_threshold"]
            )
            
            results = []
            for result in search_results:
                results.append({
                    "content": result.payload.get("content", ""),
                    "score": result.score,
                    "article": result.payload.get("article", ""),
                    "partie": result.payload.get("partie", ""),
                    "metadata": result.payload
                })
            
            return results
            
        except Exception as e:
            logger.error(f"Erreur lors de la recherche CGI: {str(e)}")
            return []
    
    async def search_annexes(self, query: str, limit: int = 20) -> List[Dict[str, Any]]:
        """Recherche dans les documents annexes"""
        try:
            expanded_query = self.synonym_manager.expand_query(query)
            
            embedding_response = voyage_client.embed(
                texts=[expanded_query], 
                model="voyage-3", 
                input_type="query"
            )
            query_embedding = embedding_response.embeddings[0]
            
            search_results = self.qdrant_client.search(
                collection_name=self.collections["annexe"],
                query_vector=query_embedding,
                limit=limit,
                score_threshold=self.config["annexe_score_threshold"]
            )
            
            results = []
            for result in search_results:
                results.append({
                    "content": result.payload.get("content", ""),
                    "score": result.score,
                    "document_type": result.payload.get("document_type", ""),
                    "metadata": result.payload
                })
            
            return results
            
        except Exception as e:
            logger.error(f"Erreur lors de la recherche annexes: {str(e)}")
            return []

# ===== GÉNÉRATEUR DE RÉPONSES AVEC GEMINI CHAT =====

class FiscalResponseGenerator:
    """Générateur de réponses fiscales utilisant l'API Chat de Gemini"""
    
    def __init__(self):
        self.model = genai.GenerativeModel('gemini-2.0-flash-exp')
        self.search_engine = FiscalSearchEngine()
        self.postgres_sync = PostgreSQLSyncManager()
    
    def _build_system_prompt(self) -> str:
        """Construit le prompt système pour l'assistant fiscal"""
        return """Tu es AhmedTax 3.0, un assistant fiscal expert spécialisé dans le Code Général des Impôts marocain 2025.

RÈGLES IMPORTANTES :
1. Réponds UNIQUEMENT aux questions fiscales liées au CGI marocain
2. Utilise les documents fournis comme source principale
3. Sois précis, concis et professionnel
4. Cite les articles CGI pertinents quand possible
5. Si tu ne trouves pas d'information, dis-le clairement
6. Utilise des emojis appropriés pour structurer tes réponses

STRUCTURE DE RÉPONSE :
📋 **Réponse directe**
📖 **Articles CGI concernés** (si applicable)
💡 **Précisions pratiques** (si nécessaire)

Réponds toujours en français et reste dans le domaine fiscal marocain."""
    
    async def generate_response(self, query: str, conversation_history: List[Message]) -> tuple[str, List[str], float]:
        """Génère une réponse basée sur la requête et l'historique"""
        start_time = datetime.now()
        
        try:
            # Rechercher dans les documents CGI et annexes
            cgi_results = await self.search_engine.search_cgi_articles(query)
            annexe_results = await self.search_engine.search_annexes(query)
            
            # Extraire les articles trouvés pour la synchronisation
            articles_found = []
            for result in cgi_results:
                if result.get("article"):
                    articles_found.append(result["article"])
            
            # Construire le contexte documentaire
            context = self._build_context(cgi_results, annexe_results)
            
            # Préparer l'historique pour Gemini Chat
            chat_history = self._prepare_chat_history(conversation_history)
            
            # Créer une session de chat
            chat = self.model.start_chat(history=chat_history)
            
            # Construire le prompt avec contexte
            prompt = f"""CONTEXTE DOCUMENTAIRE :
{context}

QUESTION UTILISATEUR : {query}

Réponds en utilisant le contexte fourni et en respectant les règles établies."""
            
            # Générer la réponse
            response = chat.send_message(
                prompt,
                generation_config=genai.types.GenerationConfig(
                    temperature=0.1,
                    max_output_tokens=2500,
                    top_p=0.9
                )
            )
            
            # Calculer le temps d'exécution
            execution_time = (datetime.now() - start_time).total_seconds()
            
            # Synchroniser avec PostgreSQL pour le dashboard Streamlit
            await self.postgres_sync.sync_conversation_to_streamlit(
                user_question=query,
                ai_response=response.text,
                articles_found=articles_found,
                search_method="api_v3_dynamodb",
                execution_time=execution_time
            )
            
            return response.text, articles_found, execution_time
            
        except Exception as e:
            logger.error(f"Erreur lors de la génération de réponse: {str(e)}")
            return "Je rencontre une difficulté technique. Pouvez-vous reformuler votre question ?", [], 0.0
    
    def _build_context(self, cgi_results: List[Dict], annexe_results: List[Dict]) -> str:
        """Construit le contexte documentaire pour Gemini"""
        context_parts = []
        
        if cgi_results:
            context_parts.append("=== ARTICLES CGI ===")
            for result in cgi_results[:5]:  # Limiter à 5 résultats
                article = result.get("article", "")
                content = result.get("content", "")[:500]  # Limiter la taille
                context_parts.append(f"Article {article}: {content}")
        
        if annexe_results:
            context_parts.append("\n=== DOCUMENTS ANNEXES ===")
            for result in annexe_results[:3]:  # Limiter à 3 résultats
                doc_type = result.get("document_type", "")
                content = result.get("content", "")[:400]
                context_parts.append(f"{doc_type}: {content}")
        
        return "\n".join(context_parts)
    
    def _prepare_chat_history(self, messages: List[Message]) -> List[Dict]:
        """Prépare l'historique pour l'API Chat de Gemini"""
        history = []
        
        # Ajouter le message système
        history.append({
            "role": "user",
            "parts": [self._build_system_prompt()]
        })
        history.append({
            "role": "model", 
            "parts": ["Compris. Je suis prêt à répondre aux questions fiscales."]
        })
        
        # Ajouter les messages de conversation (exclure le dernier message utilisateur)
        for message in messages[:-1]:  # Exclure le dernier message
            if message.role == MessageRole.USER:
                history.append({
                    "role": "user",
                    "parts": [message.content]
                })
            elif message.role == MessageRole.ASSISTANT:
                history.append({
                    "role": "model",
                    "parts": [message.content]
                })
        
        return history

# ===== INSTANCES GLOBALES =====

dynamodb_manager = DynamoDBManager()
postgres_sync = PostgreSQLSyncManager()
response_generator = FiscalResponseGenerator()

# ===== ENDPOINTS API =====

@app.post("/conversations", response_model=Conversation)
async def create_conversation(request: CreateConversationRequest):
    """Crée une nouvelle conversation dans DynamoDB"""
    try:
        conversation = await dynamodb_manager.create_conversation(request)
        return conversation
    except Exception as e:
        logger.error(f"Erreur création conversation: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors de la création de la conversation")

@app.post("/conversations/{conversation_id}/messages", response_model=Message)
async def send_message(conversation_id: str, request: SendMessageRequest):
    """Envoie un message utilisateur et retourne la réponse de l'IA"""
    try:
        # Vérifier que la conversation existe
        conversation_data = await dynamodb_manager.get_conversation(conversation_id)
        if not conversation_data:
            raise HTTPException(status_code=404, detail="Conversation non trouvée")
        
        # Sauvegarder le message utilisateur
        user_message = Message(
            conversation_id=conversation_id,
            role=MessageRole.USER,
            content=request.content,
            metadata=request.metadata
        )
        await dynamodb_manager.save_message(user_message)
        
        # Récupérer l'historique complet pour la génération
        updated_conversation = await dynamodb_manager.get_conversation(conversation_id)
        
        # Générer la réponse de l'assistant
        ai_response, articles_found, execution_time = await response_generator.generate_response(
            request.content, 
            updated_conversation.messages
        )
        
        # Sauvegarder la réponse de l'assistant
        assistant_message = Message(
            conversation_id=conversation_id,
            role=MessageRole.ASSISTANT,
            content=ai_response,
            metadata={
                "model": "gemini-2.0-flash-exp",
                "articles_found": articles_found,
                "execution_time": execution_time
            }
        )
        await dynamodb_manager.save_message(assistant_message)
        
        return assistant_message
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Erreur envoi message: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors du traitement du message")

@app.get("/conversations/{conversation_id}", response_model=ConversationResponse)
async def get_conversation(conversation_id: str):
    """Récupère une conversation complète avec ses messages depuis DynamoDB"""
    try:
        conversation_data = await dynamodb_manager.get_conversation(conversation_id)
        if not conversation_data:
            raise HTTPException(status_code=404, detail="Conversation non trouvée")
        return conversation_data
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Erreur récupération conversation: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors de la récupération")

@app.delete("/conversations/{conversation_id}")
async def delete_conversation(conversation_id: str):
    """Supprime une conversation et tous ses messages de DynamoDB"""
    try:
        deleted = await dynamodb_manager.delete_conversation(conversation_id)
        if not deleted:
            raise HTTPException(status_code=404, detail="Conversation non trouvée")
        return {"message": "Conversation supprimée avec succès"}
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Erreur suppression conversation: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors de la suppression")

@app.post("/search", response_model=List[SearchResult])
async def search_documents(request: SearchRequest):
    """Recherche dans les documents fiscaux (endpoint optionnel)"""
    try:
        search_engine = FiscalSearchEngine()
        
        # Rechercher dans les deux collections
        cgi_results = await search_engine.search_cgi_articles(request.query, request.limit)
        annexe_results = await search_engine.search_annexes(request.query, request.limit)
        
        # Combiner et trier les résultats
        all_results = []
        
        for result in cgi_results:
            all_results.append(SearchResult(
                content=result["content"],
                score=result["score"],
                metadata=result["metadata"]
            ))
        
        for result in annexe_results:
            all_results.append(SearchResult(
                content=result["content"],
                score=result["score"],
                metadata=result["metadata"]
            ))
        
        # Trier par score décroissant
        all_results.sort(key=lambda x: x.score, reverse=True)
        
        return all_results[:request.limit]
        
    except Exception as e:
        logger.error(f"Erreur recherche documents: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors de la recherche")

@app.post("/feedback")
async def submit_feedback(request: FeedbackRequest):
    """Soumet un feedback utilisateur sur une réponse (endpoint optionnel)"""
    try:
        success = await postgres_sync.save_feedback(request)
        if success:
            return {"message": "Feedback enregistré avec succès"}
        else:
            raise HTTPException(status_code=500, detail="Erreur lors de l'enregistrement")
    except Exception as e:
        logger.error(f"Erreur feedback: {str(e)}")
        raise HTTPException(status_code=500, detail="Erreur lors de l'enregistrement du feedback")

@app.get("/health")
async def health_check():
    """Endpoint de vérification de santé de l'API"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "3.0.0",
        "storage": {
            "primary": "DynamoDB",
            "sync": "PostgreSQL"
        }
    }

@app.get("/")
async def root():
    """Endpoint racine avec informations sur l'API"""
    return {
        "name": "FiscalBot 3.0 API",
        "description": "API REST pour assistant fiscal CGI Excellence avec DynamoDB",
        "version": "3.0.0",
        "docs": "/docs",
        "health": "/health",
        "storage": {
            "conversations": "DynamoDB (eu-west-3)",
            "dashboard_sync": "PostgreSQL"
        }
    }

# ===== POINT D'ENTRÉE =====

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "fiscal-bot-api:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )