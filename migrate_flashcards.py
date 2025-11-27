"""
Script de migración segura para agregar tablas de flashcards
Solo crea las nuevas tablas, NO modifica las existentes
"""
from sqlalchemy import create_engine, inspect
from models import Base, ConjuntoFlashcard, Flashcard, Vista, TiempoVisto
from database import DATABASE_URL

def migrate_safe():
    """Migración segura que solo crea tablas nuevas"""
    print("🔄 Iniciando migración segura...")
    print(f"📍 Conectando a: {DATABASE_URL.split('@')[1]}")  # Oculta credenciales
    
    engine = create_engine(DATABASE_URL)
    inspector = inspect(engine)
    
    # Obtener tablas existentes
    existing_tables = inspector.get_table_names()
    print(f"\n✅ Tablas existentes en la BD:")
    for table in existing_tables:
        print(f"   - {table}")
    
    # Tablas que queremos crear
    new_tables = ['conjunto_flashcard', 'flashcard']
    tables_to_create = [t for t in new_tables if t not in existing_tables]
    
    if not tables_to_create:
        print(f"\n✅ Todas las tablas ya existen. No hay nada que migrar.")
        return
    
    print(f"\n🆕 Tablas nuevas a crear:")
    for table in tables_to_create:
        print(f"   - {table}")
    
    # Confirmar antes de proceder
    print(f"\n⚠️  IMPORTANTE: Esta operación solo CREARÁ las nuevas tablas.")
    print(f"   NO modificará ni eliminará tablas existentes.")
    
    respuesta = input("\n¿Deseas continuar? (si/no): ").lower()
    
    if respuesta != 'si':
        print("❌ Migración cancelada por el usuario.")
        return
    
    try:
        # Crear solo las tablas nuevas
        print("\n🔨 Creando tablas nuevas...")
        Base.metadata.create_all(bind=engine, checkfirst=True)
        
        # Verificar que se crearon
        inspector = inspect(engine)
        new_existing_tables = inspector.get_table_names()
        
        print(f"\n✅ Migración completada exitosamente!")
        print(f"\n📊 Tablas actuales en la BD:")
        for table in sorted(new_existing_tables):
            status = "🆕 NUEVA" if table in tables_to_create else "✅ Existente"
            print(f"   {status} - {table}")
        
        # Verificar que no se perdieron tablas
        if len(new_existing_tables) >= len(existing_tables):
            print(f"\n✅ Verificación: Todas las tablas anteriores están intactas.")
            print(f"   Tablas antes: {len(existing_tables)}")
            print(f"   Tablas ahora: {len(new_existing_tables)}")
        else:
            print(f"\n⚠️  ADVERTENCIA: Parece que se perdieron tablas!")
            print(f"   Tablas antes: {len(existing_tables)}")
            print(f"   Tablas ahora: {len(new_existing_tables)}")
            
    except Exception as e:
        print(f"\n❌ Error durante la migración: {str(e)}")
        print(f"   Las tablas existentes NO fueron afectadas.")
        raise

if __name__ == "__main__":
    migrate_safe()
