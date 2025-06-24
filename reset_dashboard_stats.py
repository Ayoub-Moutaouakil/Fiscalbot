import psycopg2
import logging
from datetime import datetime

# Configuration du logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class DashboardReset:
    def __init__(self):
        self.conn = None
        self.cur = None
        
    def connect(self):
        """Établit la connexion à la base de données PostgreSQL"""
        try:
            self.conn = psycopg2.connect(
                host="aws-0-eu-west-3.pooler.supabase.com",
                port="6543",
                database="postgres",
                user="postgres.hhgbwbmfmkpzumlvwsfi",
                password="8-fJh4+&qh73uHK"
            )
            self.cur = self.conn.cursor()
            logger.info("✅ Connexion à la base de données établie avec succès")
            return True
        except Exception as e:
            logger.error(f"❌ Erreur de connexion à la base de données: {str(e)}")
            return False
    
    def get_current_stats(self):
        """Affiche les statistiques actuelles avant suppression"""
        try:
            # Compter le nombre total de conversations
            self.cur.execute("SELECT COUNT(*) FROM conversations")
            total_conversations = self.cur.fetchone()[0]
            
            # Compter par type de feedback
            self.cur.execute("""
                SELECT 
                    COALESCE(feedback_type, 'sans_feedback') as type,
                    COUNT(*) as count
                FROM conversations
                GROUP BY feedback_type
                ORDER BY count DESC
            """)
            feedback_stats = self.cur.fetchall()
            
            # Statistiques par méthode de recherche
            self.cur.execute("""
                SELECT 
                    COALESCE(search_method, 'non_specifie') as method,
                    COUNT(*) as count
                FROM conversations
                GROUP BY search_method
                ORDER BY count DESC
            """)
            search_method_stats = self.cur.fetchall()
            
            # Date de la première et dernière conversation
            self.cur.execute("""
                SELECT 
                    MIN(timestamp) as first_conversation,
                    MAX(timestamp) as last_conversation
                FROM conversations
            """)
            date_range = self.cur.fetchone()
            
            logger.info("📊 STATISTIQUES ACTUELLES DU DASHBOARD:")
            logger.info(f"   Total conversations: {total_conversations}")
            
            if date_range[0] and date_range[1]:
                logger.info(f"   Période: {date_range[0]} à {date_range[1]}")
            
            logger.info("   Répartition par feedback:")
            for feedback_type, count in feedback_stats:
                logger.info(f"     - {feedback_type}: {count}")
            
            logger.info("   Répartition par méthode de recherche:")
            for method, count in search_method_stats:
                logger.info(f"     - {method}: {count}")
            
            return total_conversations
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de la récupération des statistiques: {str(e)}")
            return 0
    
    def backup_data(self, backup_file=None):
        """Crée une sauvegarde des données avant suppression (optionnel)"""
        if backup_file is None:
            backup_file = f"dashboard_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}.sql"
        
        try:
            # Exporter toutes les données de la table conversations
            self.cur.execute("""
                SELECT 
                    id, question, response, articles, feedback_type, feedback_comment,
                    search_method, semantic_score, query_complexity, execution_time,
                    model_used, timestamp
                FROM conversations
                ORDER BY timestamp
            """)
            
            conversations = self.cur.fetchall()
            
            with open(backup_file, 'w', encoding='utf-8') as f:
                f.write("-- Sauvegarde des données du dashboard FiscalBot\n")
                f.write(f"-- Créée le: {datetime.now()}\n")
                f.write(f"-- Nombre de conversations: {len(conversations)}\n\n")
                
                f.write("-- Structure de la table conversations\n")
                f.write("""
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
);

""")
                
                f.write("-- Données\n")
                for conv in conversations:
                    # Échapper les apostrophes pour SQL
                    question = conv[1].replace("'", "''")
                    response = conv[2].replace("'", "''")
                    articles = str(conv[3]).replace("'", "''")
                    feedback_comment = conv[5].replace("'", "''") if conv[5] else 'NULL'
                    
                    f.write(f"""
INSERT INTO conversations (question, response, articles, feedback_type, feedback_comment, search_method, semantic_score, query_complexity, execution_time, model_used, timestamp)
VALUES ('{question}', '{response}', '{articles}', {'NULL' if conv[4] is None else "'" + conv[4] + "'"}, {'NULL' if conv[5] is None else "'" + feedback_comment + "'"}, {'NULL' if conv[6] is None else "'" + conv[6] + "'"}, {conv[7] if conv[7] is not None else 'NULL'}, {conv[8] if conv[8] is not None else 'NULL'}, {conv[9] if conv[9] is not None else 'NULL'}, {'NULL' if conv[10] is None else "'" + conv[10] + "'"}, '{conv[11]}');
""")
            
            logger.info(f"💾 Sauvegarde créée: {backup_file}")
            return backup_file
            
        except Exception as e:
            logger.error(f"❌ Erreur lors de la sauvegarde: {str(e)}")
            return None
    
    def reset_dashboard_stats(self, create_backup=True):
        """Vide complètement la table conversations pour remettre les stats à zéro"""
        try:
            # Afficher les stats actuelles
            total_before = self.get_current_stats()
            
            if total_before == 0:
                logger.info("ℹ️ La base de données est déjà vide")
                return True
            
            # Demander confirmation
            print(f"\n⚠️  ATTENTION: Vous allez supprimer {total_before} conversations du dashboard!")
            confirmation = input("Tapez 'CONFIRMER' pour continuer (ou 'q' pour annuler): ")
            
            if confirmation != 'CONFIRMER':
                logger.info("❌ Opération annulée par l'utilisateur")
                return False
            
            # Créer une sauvegarde si demandé
            if create_backup:
                logger.info("💾 Création d'une sauvegarde avant suppression...")
                backup_file = self.backup_data()
                if backup_file:
                    logger.info(f"✅ Sauvegarde créée: {backup_file}")
            
            # Supprimer toutes les données
            logger.info("🗑️ Suppression de toutes les conversations...")
            self.cur.execute("DELETE FROM conversations")
            
            # Remettre à zéro la séquence des IDs
            self.cur.execute("ALTER SEQUENCE conversations_id_seq RESTART WITH 1")
            
            # Valider les changements
            self.conn.commit()
            
            # Vérifier que la suppression a fonctionné
            self.cur.execute("SELECT COUNT(*) FROM conversations")
            remaining_count = self.cur.fetchone()[0]
            
            if remaining_count == 0:
                logger.info("✅ Dashboard remis à zéro avec succès!")
                logger.info("📊 Nouvelles statistiques:")
                logger.info("   - Total conversations: 0")
                logger.info("   - Tous les compteurs sont remis à zéro")
                return True
            else:
                logger.error(f"❌ Erreur: {remaining_count} conversations restantes")
                return False
                
        except Exception as e:
            logger.error(f"❌ Erreur lors de la remise à zéro: {str(e)}")
            self.conn.rollback()
            return False
    
    def close(self):
        """Ferme les connexions à la base de données"""
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()
        logger.info("🔌 Connexion fermée")

def main():
    """Fonction principale"""
    print("🔄 RESET DU DASHBOARD FISCALBOT 3.0")
    print("=" * 40)
    
    # Initialiser le reset manager
    reset_manager = DashboardReset()
    
    # Se connecter à la base
    if not reset_manager.connect():
        print("❌ Impossible de se connecter à la base de données")
        return
    
    try:
        # Effectuer la remise à zéro
        success = reset_manager.reset_dashboard_stats(create_backup=True)
        
        if success:
            print("\n🎉 DASHBOARD REMIS À ZÉRO AVEC SUCCÈS!")
            print("   - Toutes les conversations ont été supprimées")
            print("   - Les statistiques sont remises à zéro")
            print("   - Une sauvegarde a été créée")
        else:
            print("\n❌ Échec de la remise à zéro")
            
    except KeyboardInterrupt:
        print("\n⚠️ Opération interrompue par l'utilisateur")
    except Exception as e:
        print(f"\n❌ Erreur inattendue: {str(e)}")
    finally:
        reset_manager.close()

if __name__ == "__main__":
    main()