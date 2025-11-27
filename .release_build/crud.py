from sqlalchemy.orm import Session
from sqlalchemy import func
from uuid import UUID
from models import UsuarioApp, Video, Like, Etiqueta, Interaccion

# =====================================================
# 🧍 USUARIOS
# =====================================================

def get_usuario_by_correo(db: Session, correo: str):
    """Obtiene un usuario por correo electrónico"""
    return db.query(UsuarioApp).filter(UsuarioApp.correo == correo).first()

def crear_usuario(db: Session, nombre: str, correo: str, contrasena: str):
    """Crea un nuevo usuario"""
    nuevo_usuario = UsuarioApp(nombre=nombre, correo=correo, contrasena=contrasena)
    db.add(nuevo_usuario)
    db.commit()
    db.refresh(nuevo_usuario)
    return nuevo_usuario

def get_usuario_by_id(db: Session, id_usuario: int):
    """Obtiene un usuario por su ID"""
    return db.query(UsuarioApp).filter(UsuarioApp.id_usuario == id_usuario).first()

def listar_usuarios(db: Session):
    """Devuelve todos los usuarios"""
    return db.query(UsuarioApp).all()

# =====================================================
# 🎥 VIDEOS
# =====================================================

def crear_video(db: Session, titulo: str, descripcion: str, duracion, id_usuario: int, ruta: str):
    """Crea un nuevo video"""
    nuevo_video = Video(
        titulo=titulo,
        descripcion=descripcion,
        duracion=duracion,
        id_usuario=id_usuario,
        ruta=ruta
    )
    db.add(nuevo_video)
    db.commit()
    db.refresh(nuevo_video)
    return nuevo_video

def get_videos(db: Session, skip: int = 0, limit: int = 10):
    """Obtiene lista paginada de videos"""
    return db.query(Video).order_by(Video.fecha_subida.asc()).offset(skip).limit(limit).all()

def get_video_by_id(db: Session, id_video: UUID):
    """Obtiene un video por su UUID"""
    return db.query(Video).filter(Video.id_video == id_video).first()

def eliminar_video(db: Session, id_video: UUID):
    """Elimina un video (y sus dependencias por ON DELETE CASCADE)"""
    video = db.query(Video).filter(Video.id_video == id_video).first()
    if video:
        db.delete(video)
        db.commit()
        return True
    return False

def contar_videos(db: Session):
    """Cuenta el total de videos"""
    return db.query(Video).count()

# =====================================================
# 🏷️ ETIQUETAS
# =====================================================

def crear_etiqueta(db: Session, nombre: str, id_video: UUID):
    """Crea una etiqueta asociada a un video"""
    nueva_etiqueta = Etiqueta(nombre=nombre, id_video=id_video)
    db.add(nueva_etiqueta)
    db.commit()
    db.refresh(nueva_etiqueta)
    return nueva_etiqueta

def get_etiqueta_por_video(db: Session, id_video: UUID):
    """Obtiene la etiqueta asociada a un video"""
    return db.query(Etiqueta).filter(Etiqueta.id_video == id_video).first()

def listar_etiquetas(db: Session):
    """Lista todas las etiquetas"""
    return db.query(Etiqueta).all()

# =====================================================
# 💬 INTERACCIONES
# =====================================================

def crear_interaccion(db: Session, id_video: UUID):
    """Crea un registro de interacciones para un video"""
    interaccion = Interaccion(id_video=id_video)
    db.add(interaccion)
    db.commit()
    db.refresh(interaccion)
    return interaccion

def get_interaccion_por_video(db: Session, id_video: UUID):
    """Obtiene la interacción de un video"""
    return db.query(Interaccion).filter(Interaccion.id_video == id_video).first()

def actualizar_interaccion(db: Session, id_video: UUID, vistas: int = None, likes: int = None):
    """Actualiza el número de vistas o likes de un video"""
    interaccion = db.query(Interaccion).filter(Interaccion.id_video == id_video).first()
    if interaccion:
        if vistas is not None:
            interaccion.total_vistas = vistas
        if likes is not None:
            interaccion.total_likes = likes
        db.commit()
        db.refresh(interaccion)
        return interaccion
    return None

# =====================================================
# ❤️ LIKES
# =====================================================

def get_like(db: Session, id_usuario: int, id_video: UUID):
    """Verifica si un usuario ya dio like a un video"""
    return db.query(Like).filter(
        Like.id_usuario == id_usuario,
        Like.id_video == id_video
    ).first()

def create_like(db: Session, id_usuario: int, id_video: UUID):
    """Agrega un nuevo like"""
    nuevo_like = Like(id_usuario=id_usuario, id_video=id_video)
    db.add(nuevo_like)
    db.commit()
    db.refresh(nuevo_like)
    return nuevo_like

def delete_like(db: Session, id_usuario: int, id_video: UUID):
    """Quita un like si existe"""
    like = db.query(Like).filter(
        Like.id_usuario == id_usuario,
        Like.id_video == id_video
    ).first()
    if like:
        db.delete(like)
        db.commit()
        return True
    return False

def get_total_likes(db: Session, id_video: UUID):
    """Cuenta los likes totales de un video"""
    return db.query(func.count(Like.id_video)).filter(Like.id_video == id_video).scalar()


# =====================================================
# 📚 CONJUNTOS DE FLASHCARDS
# =====================================================

def crear_conjunto_flashcard(db: Session, titulo: str, descripcion: str, id_usuario: int):
    """Crea un nuevo conjunto de flashcards"""
    from models import ConjuntoFlashcard
    nuevo_conjunto = ConjuntoFlashcard(
        titulo=titulo,
        descripcion=descripcion,
        id_usuario=id_usuario
    )
    db.add(nuevo_conjunto)
    db.commit()
    db.refresh(nuevo_conjunto)
    return nuevo_conjunto


def get_conjuntos_flashcard(db: Session, id_usuario: int = None):
    """Obtiene todos los conjuntos de flashcards, opcionalmente filtrados por usuario"""
    from models import ConjuntoFlashcard
    query = db.query(ConjuntoFlashcard)
    if id_usuario:
        query = query.filter(ConjuntoFlashcard.id_usuario == id_usuario)
    return query.all()


def get_conjunto_flashcard_by_id(db: Session, id_conjunto: int):
    """Obtiene un conjunto de flashcards por su ID"""
    from models import ConjuntoFlashcard
    return db.query(ConjuntoFlashcard).filter(ConjuntoFlashcard.id_conjunto == id_conjunto).first()


def eliminar_conjunto_flashcard(db: Session, id_conjunto: int):
    """Elimina un conjunto de flashcards (y sus flashcards por CASCADE)"""
    from models import ConjuntoFlashcard
    conjunto = db.query(ConjuntoFlashcard).filter(ConjuntoFlashcard.id_conjunto == id_conjunto).first()
    if conjunto:
        db.delete(conjunto)
        db.commit()
        return True
    return False


# =====================================================
# 🎴 FLASHCARDS
# =====================================================
def crear_flashcard(db: Session, titulo: str, contenido_frontal: str, contenido_trasero: str, 
                   id_conjunto: int, tipo_contenido: str = "texto", orden: int = 0):
    """Crea una nueva flashcard"""
    from models import Flashcard
    nueva_flashcard = Flashcard(
        titulo=titulo,
        contenido_frontal=contenido_frontal,
        contenido_trasero=contenido_trasero,
        tipo_contenido=tipo_contenido,
        orden=orden,
        id_conjunto=id_conjunto
    )
    db.add(nueva_flashcard)
    db.commit()
    db.refresh(nueva_flashcard)
    return nueva_flashcard


def get_flashcards_by_conjunto(db: Session, id_conjunto: int):
    """Obtiene todas las flashcards de un conjunto, ordenadas"""
    from models import Flashcard
    return db.query(Flashcard).filter(
        Flashcard.id_conjunto == id_conjunto
    ).order_by(Flashcard.orden).all()


def get_flashcard_by_id(db: Session, id_flashcard: UUID):
    """Obtiene una flashcard por su UUID"""
    from models import Flashcard
    return db.query(Flashcard).filter(Flashcard.id_flashcard == id_flashcard).first()


def actualizar_flashcard(db: Session, id_flashcard: UUID, **kwargs):
    """Actualiza una flashcard con los campos proporcionados"""
    from models import Flashcard
    flashcard = db.query(Flashcard).filter(Flashcard.id_flashcard == id_flashcard).first()
    if flashcard:
        for key, value in kwargs.items():
            if value is not None and hasattr(flashcard, key):
                setattr(flashcard, key, value)
        db.commit()
        db.refresh(flashcard)
        return flashcard
    return None


def eliminar_flashcard(db: Session, id_flashcard: UUID):
    """Elimina una flashcard"""
    from models import Flashcard
    flashcard = db.query(Flashcard).filter(Flashcard.id_flashcard == id_flashcard).first()
    if flashcard:
        db.delete(flashcard)
        db.commit()
        return True
    return False


def contar_flashcards_en_conjunto(db: Session, id_conjunto: int):
    """Cuenta el total de flashcards en un conjunto"""
    from models import Flashcard
    return db.query(Flashcard).filter(Flashcard.id_conjunto == id_conjunto).count()