from qdrant_client import QdrantClient
from qdrant_client.http import models
import logging

# Configuration Qdrant (même que les autres scripts)
QDRANT_HOST = "13.39.82.37"
QDRANT_PORT = 6333

# Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def delete_all_faq():
    """Supprime tous les documents de type 'faq' de la collection cgi_annexe_optimized"""
    
    # Configuration Qdrant (même que faq.py et annnexevoyagev2.py)
    qdrant_client = QdrantClient(host=QDRANT_HOST, port=QDRANT_PORT)
    
    collection_name = "cgi_annexe_optimized"
    
    try:
        print(f"🔍 Recherche des documents FAQ dans la collection '{collection_name}'...")
        
        # Rechercher tous les points avec type = "faq"
        search_result = qdrant_client.scroll(
            collection_name=collection_name,
            scroll_filter=models.Filter(
                must=[
                    models.FieldCondition(
                        key="type",
                        match=models.MatchValue(value="faq")
                    )
                ]
            ),
            limit=10000,  # Limite élevée pour récupérer tous les FAQ
            with_payload=True,
            with_vectors=False
        )
        
        points, next_page_offset = search_result
        
        if not points:
            print("✅ Aucun document FAQ trouvé dans la collection.")
            return
        
        print(f"📊 {len(points)} documents FAQ trouvés.")
        
        # Extraire les IDs des points à supprimer
        point_ids = [point.id for point in points]
        
        print(f"🗑️ Suppression de {len(point_ids)} documents FAQ...")
        
        # Supprimer les points par batch
        batch_size = 100
        deleted_count = 0
        
        for i in range(0, len(point_ids), batch_size):
            batch_ids = point_ids[i:i + batch_size]
            
            qdrant_client.delete(
                collection_name=collection_name,
                points_selector=models.PointIdsList(
                    points=batch_ids
                )
            )
            
            deleted_count += len(batch_ids)
            print(f"   ✅ Supprimé {deleted_count}/{len(point_ids)} documents")
        
        print(f"\n🎉 Suppression terminée ! {deleted_count} documents FAQ supprimés de la collection '{collection_name}'.")
        
        # Vérification finale
        verification_result = qdrant_client.scroll(
            collection_name=collection_name,
            scroll_filter=models.Filter(
                must=[
                    models.FieldCondition(
                        key="type",
                        match=models.MatchValue(value="faq")
                    )
                ]
            ),
            limit=10,
            with_payload=True,
            with_vectors=False
        )
        
        remaining_points, _ = verification_result
        
        if not remaining_points:
            print("✅ Vérification : Aucun document FAQ restant dans la collection.")
        else:
            print(f"⚠️ Attention : {len(remaining_points)} documents FAQ encore présents.")
        
    except Exception as e:
        print(f"❌ Erreur lors de la suppression des FAQ : {str(e)}")
        logger.error(f"Erreur détaillée: {e}")
        raise

if __name__ == "__main__":
    print("🚀 Démarrage du script de suppression des FAQ...")
    delete_all_faq()
    print("\n✨ Script terminé. Vous pouvez maintenant relancer le script faq.py pour réembarquer les données sans doublons.")