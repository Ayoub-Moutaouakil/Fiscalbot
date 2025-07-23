from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from uuid import uuid4
import boto3
import openai
import numpy as np
import re
import json
import qdrant_client
from mangum import Mangum
import uvicorn

# --- CONFIG ---
openai.api_key = "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"
dynamodb = boto3.resource("dynamodb", region_name="eu-west-3")
table = dynamodb.Table("fiscal-bot-chats")

# --- Qdrant Client ---
client = qdrant_client.QdrantClient(host="13.39.82.37", port=6333)

# --- FASTAPI INIT ---
app = FastAPI()

# --- Pydantic Models ---
class MessageInput(BaseModel):
    message: str

# --- Embedding + Similarity Search via Qdrant ---
def get_embedding(text, model="text-embedding-3-large"):
    response = openai.Embedding.create(input=text, model=model)
    return response["data"][0]["embedding"]

def search_similar_articles(query, top_k=5):
    article_match = re.search(r"(?:l['']?)?article\s+(\w+)", query.lower())
    query_embedding = get_embedding(query)

    results = client.search(
        collection_name="cgi_2025",
        query_vector=query_embedding,
        limit=top_k
    )

    if article_match:
        article_num = article_match.group(1).lower()
        exact_matches = [res for res in results if str(res.payload.get("article", "")).lower() == article_num]
        if exact_matches:
            return exact_matches

    return results

def format_article_context(article):
    metadata = article.payload
    return f"""
Livre: {metadata.get('livre', 'N/A')}
Nom du livre: {metadata.get('nom_livre', 'N/A')}
Partie: {metadata.get('partie', 'N/A')}
Nom de partie: {metadata.get('nom_partie', 'N/A')}
Titre: {metadata.get('titre', 'N/A')}
Nom du titre: {metadata.get('nom_titre', 'N/A')}
Chapitre: {metadata.get('chapitre', 'N/A')}
Nom du chapitre: {metadata.get('nom_chapitre', 'N/A')}
Article: {metadata.get('article', 'N/A')}
Nom de l'article: {metadata.get('nom_article', 'N/A')}
Contenu: {metadata.get('contenu', 'N/A')}
"""

system_prompt = "Tu es un expert fiscal marocain. Lors de ta première réponse et uniquement la première, tu dois annoncer le sujet de la question de l'utilisateur en disant 'Votre question porte sur [sujet]'. Pour toutes les réponses suivantes, ne répète pas cette phrase. Réponds toujours à la question avec précision (sans utiliser des termes vagues comme 'en général' ou 'généralement'), car tu maîtrises parfaitement ton sujet. La fiscalité étant un domaine vaste, afin d'affiner ta réponse pour proposer à l'utilisateur une réponse qui lui convient au mieux, tu dois lui poser des questions (sauf si tu n'en as pas besoin). Lorsque tu réponds, cite toujours l'article sur lequel tu te bases."

# --- Generate AI Response ---
def generate_response(user_query, history):
    relevant_articles = search_similar_articles(user_query, top_k=5)
    context_articles = [format_article_context(article) for article in relevant_articles]
    context = "\n\n---\n\n".join(context_articles)

    article_match = re.search(r"(?:l['']?)?article\s+(\w+)", user_query.lower())
    system_prompt_full = system_prompt
    if article_match and len(relevant_articles) > 0 and str(relevant_articles[0].payload.get('article', '')).lower() == article_match.group(1).lower():
        system_prompt_full += f" L'utilisateur a demandé spécifiquement l'article {article_match.group(1)}, assurez-vous de fournir le texte complet de cet article et ses références exactes."

    context_prompt = f"""
    L'utilisateur pose la question suivante :
    \"{user_query}\"

    Voici des extraits pertinents du Code Général des Impôts (CGI) :
    {context}
    """

    messages = history.copy()
    if not any(m['role'] == 'system' for m in messages):
        messages.insert(0, {"role": "system", "content": system_prompt_full})

    messages.append({"role": "user", "content": context_prompt})

    response = openai.ChatCompletion.create(
        model="gpt-4o",
        messages=messages
    )

    return response["choices"][0]["message"]

# --- API Endpoints ---
@app.get("/healthcheck")
def healthcheck():
    return {"status": "ok"}

@app.get("/api/chats")
def list_chats():
    try:
        response = table.scan()
        items = response.get("Items", [])
        chat_summaries = []

        for item in items:
            chat_id = item.get("chat_id")
            messages = item.get("messages", [])
            # Trouver le premier message utilisateur
            first_user_message = next((m["content"] for m in messages if m["role"] == "user"), "Aucun message")
            chat_summaries.append({
                "chat_id": chat_id,
                "first_message": first_user_message
            })

        return chat_summaries

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/chats/message")
def create_chat_with_message(user_input: MessageInput):
    chat_id = str(uuid4())
    messages = [{"role": "system", "content": system_prompt}]
    user_message = user_input.message
    messages.append({"role": "user", "content": user_message})

    assistant_msg = generate_response(user_message, messages[:-1])
    messages.append(assistant_msg)

    table.put_item(Item={"chat_id": chat_id, "messages": messages})

    return {"chat_id": chat_id, "assistant_response": assistant_msg}

@app.post("/api/chats/{chat_id}/messages")
def post_message(chat_id: str, user_input: MessageInput):
    response = table.get_item(Key={"chat_id": chat_id})
    if "Item" not in response:
        raise HTTPException(status_code=404, detail="Chat not found")

    user_message = user_input.message
    messages = response["Item"].get("messages", [])
    messages.append({"role": "user", "content": user_message})

    assistant_msg = generate_response(user_message, messages[:-1])
    messages.append(assistant_msg)

    table.update_item(
        Key={"chat_id": chat_id},
        UpdateExpression="SET messages = :val",
        ExpressionAttributeValues={":val": messages}
    )

    return assistant_msg

@app.get("/api/chats/{chat_id}/messages")
def get_messages(chat_id: str):
    response = table.get_item(Key={"chat_id": chat_id})
    if "Item" not in response:
        raise HTTPException(status_code=404, detail="Chat not found")
    return response["Item"].get("messages", [])

# --- Lambda handler ---
handler = Mangum(app)

# --- FastAPI handler ---
#if __name__ == "__main__":
#    uvicorn.run(app, host="0.0.0.0", port=8000)