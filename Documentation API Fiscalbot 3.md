
# 📚 FiscalBot 3.0 API - Documentation

## 🌟 Vue d'ensemble

FiscalBot 3.0 API est une API REST moderne construite avec FastAPI pour fournir un assistant fiscal intelligent spécialisé dans le Code Général des Impôts marocain 2025. L'API utilise l'architecture RAG (Retrieval-Augmented Generation) avec des conversations multi-tours gérées nativement par l'API Chat de Gemini.

### Caractéristiques principales
- 🤖 **IA conversationnelle** : Conversations multi-tours comme ChatGPT
- 📖 **Expertise fiscale** : Spécialisé dans le CGI marocain 2025
- 🔍 **Recherche sémantique** : Moteur de recherche vectorielle avec Qdrant
- 💾 **Persistance** : Stockage des conversations en PostgreSQL
- ⚡ **Performance** : Architecture asynchrone avec FastAPI
- 🛡️ **Validation** : Modèles Pydantic pour la sécurité des données

---

## 🚀 Démarrage rapide

### Installation

```bash
# Cloner le projet
git clone <repository-url>
cd FB-Ahmed

# Installer les dépendances
pip install fastapi uvicorn psycopg2-binary qdrant-client google-generativeai voyageai pydantic

# Lancer le serveur
python fiscal-bot-api.py
```

### Accès à l'API

- URL de base : `http://localhost:8000`
- Documentation interactive : `http://localhost:8000/docs`
- Documentation ReDoc : `http://localhost:8000/redoc`

---

## 📋 Endpoints

### 1. Gestion des conversations

#### POST /conversations
Crée une nouvelle conversation.

**Corps de la requête :**
```json
{
  "user_id": "string",
  "title": "string (optionnel)",
  "metadata": {}
}
```

**Réponse :**
```json
{
  "id": "uuid",
  "user_id": "string",
  "created_at": "2024-01-01T10:00:00Z",
  "updated_at": "2024-01-01T10:00:00Z",
  "title": "string",
  "metadata": {}
}
```

**Exemple cURL :**
```bash
curl -X POST "http://localhost:8000/conversations" \
  -H "Content-Type: application/json" \
  -d '{ "user_id": "user123", "title": "Questions sur la TVA" }'
```

---

#### POST /conversations/{conversation_id}/messages
Envoie un message utilisateur et retourne la réponse de l'IA.

**Corps de la requête :**
```json
{
  "content": "string",
  "metadata": {}
}
```

**Réponse :**
```json
{
  "id": "uuid",
  "conversation_id": "uuid",
  "role": "assistant",
  "content": "Réponse de l'IA...",
  "timestamp": "2024-01-01T10:00:00Z",
  "metadata": {
    "model": "gemini-2.0-flash-exp"
  }
}
```

---

#### GET /conversations/{conversation_id}
Récupère une conversation complète avec tous ses messages.

**Réponse :**
```json
{
  "conversation": {
    "id": "uuid",
    "user_id": "string",
    "created_at": "2024-01-01T10:00:00Z",
    "updated_at": "2024-01-01T10:00:00Z",
    "title": "string",
    "metadata": {}
  },
  "messages": [
    {
      "id": "uuid",
      "conversation_id": "uuid",
      "role": "user",
      "content": "Message utilisateur",
      "timestamp": "2024-01-01T10:00:00Z",
      "metadata": null
    },
    {
      "id": "uuid",
      "conversation_id": "uuid",
      "role": "assistant",
      "content": "Réponse de l'IA",
      "timestamp": "2024-01-01T10:00:00Z",
      "metadata": {
        "model": "gemini-2.0-flash-exp"
      }
    }
  ]
}
```

---

#### DELETE /conversations/{conversation_id}
Supprime une conversation et tous ses messages.

**Réponse :**
```json
{
  "message": "Conversation supprimée avec succès"
}
```

---

### 2. Recherche de documents

#### POST /search
Recherche dans les documents fiscaux (CGI et annexes).

**Corps de la requête :**
```json
{
  "query": "string",
  "limit": 10,
  "threshold": 0.08
}
```

**Réponse :**
```json
[
  {
    "content": "Contenu du document...",
    "score": 0.95,
    "metadata": {
      "article": "144",
      "partie": "II",
      "document_type": "cgi_article"
    }
  }
]
```

---

### 3. Feedback utilisateur

#### POST /feedback
Soumet un feedback utilisateur sur une réponse.

**Corps de la requête :**
```json
{
  "message_id": "uuid",
  "feedback_type": "positive|negative|neutral",
  "comment": "string (optionnel)"
}
```

**Réponse :**
```json
{
  "message": "Feedback enregistré avec succès"
}
```

---

### 4. Utilitaires

#### GET /health
Vérification de santé de l'API.

**Réponse :**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T10:00:00Z",
  "version": "3.0.0"
}
```

#### GET /
Informations sur l'API.

**Réponse :**
```json
{
  "name": "FiscalBot 3.0 API",
  "description": "API REST pour assistant fiscal CGI Excellence",
  "version": "3.0.0",
  "docs": "/docs",
  "health": "/health"
}
```

---

## 🔧 Modèles de données

### Conversation
```ts
{
  id: string;
  user_id: string;
  created_at: datetime;
  updated_at: datetime;
  title?: string;
  metadata?: object;
}
```

### Message
```ts
{
  id: string;
  conversation_id: string;
  role: "user" | "assistant";
  content: string;
  timestamp: datetime;
  metadata?: object;
}
```

### SearchResult
```ts
{
  content: string;
  score: number;
  metadata: object;
}
```

---

## 💡 Exemples d'utilisation

Voir section complète dans la documentation originale (conversation complète, en JS/Python).

---

## ⚙️ Configuration

Variables d’environnement : GEMINI_API_KEY, VOYAGE_API_KEY, DB credentials, Qdrant host/port.

Collections Qdrant utilisées :
- `cgi_mainvoyage`
- `cgi_article_parentvoyage`
- `cgi_sectionsvoyage`
- `cgi_annexe_optimized`

---

## 🚨 Gestion d'erreurs

Exemples :
```json
{ "detail": "Conversation non trouvée" }
```
```json
{
  "detail": [
    {
      "loc": ["body", "user_id"],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

---

## 🔒 Sécurité et bonnes pratiques

- CORS
- Authentification JWT (à venir)
- Rate limiting
- HTTPS en prod
- Externalisation des secrets

---

## 📊 Monitoring et logs

Logs : création, suppression, erreurs IA, erreurs DB.

---

## 🔄 Évolutions futures

- Authentification JWT
- Rate limiting
- Streaming des réponses
- Support multilingue
- Analytics
- Redis cache
- Webhooks

---

## 📞 Support

- `/docs` pour Swagger
- `/health` pour état de l’API
