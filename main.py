from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Form, Request, Query
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, Response
from sqlalchemy.orm import Session
from typing import List
from uuid import UUID
from datetime import timedelta
import os, random, sys

# Importar moviepy de forma correcta
try:
    from moviepy import VideoFileClip  # type: ignore
except ImportError:
    try:
        from moviepy.video.io.VideoFileClip import VideoFileClip  # type: ignore
    except ImportError:
        # Fallback si falla
        VideoFileClip = None  # type: ignore

# Importaciones locales
import models, schemas, crud
from database import SessionLocal, engine
from models import UsuarioApp, Video, Like, Etiqueta, Interaccion
from dotenv import load_dotenv
from starlette.middleware.sessions import SessionMiddleware
try:
    from auth.routes import router as auth_router
except Exception:
    auth_router = None

# Crear tablas en caso de no existir
models.Base.metadata.create_all(bind=engine)

# =====================================================
# 🚀 APP CONFIG
# =====================================================
app = FastAPI(title="API Plataforma de Videos", version="2.0")
load_dotenv()
app.add_middleware(SessionMiddleware, secret_key=os.getenv("SECRET_KEY", "dev-secret"))

# Agregar CORS para permitir acceso desde Flutter Web
from fastapi.middleware.cors import CORSMiddleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permitir todos los orígenes (desarrollo)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

if auth_router is not None:
    app.include_router(auth_router)

# Directorios
app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/images", StaticFiles(directory="images"), name="images")

VIDEO_DIR = os.path.join(os.path.dirname(__file__), "media")  # Cambia "videos" por "media"
os.makedirs(VIDEO_DIR, exist_ok=True)
app.mount("/media", StaticFiles(directory=VIDEO_DIR), name="media")


# =====================================================
# 📦 DEPENDENCIA DE DB
# =====================================================
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# =====================================================
# 🌐 RUTA PRINCIPAL
# =====================================================
@app.get("/")
def root():
    return FileResponse(os.path.join("static", "index.html"))


# =====================================================
# 🧍 USUARIOS
# =====================================================
@app.get("/usuarios", response_model=List[schemas.UsuarioResponse])
def listar_usuarios(db: Session = Depends(get_db)):
    return crud.listar_usuarios(db)

@app.post("/usuarios", response_model=schemas.UsuarioResponse)
def crear_usuario(usuario: schemas.UsuarioCreate, db: Session = Depends(get_db)):
    existente = crud.get_usuario_by_correo(db, usuario.correo)
    if existente:
        raise HTTPException(status_code=400, detail="Correo ya registrado")
    nuevo = crud.crear_usuario(db, usuario.nombre, usuario.correo, usuario.contrasena)
    return schemas.UsuarioResponse.from_orm(nuevo)


# =====================================================
# 🔐 LOGIN
# =====================================================
@app.post("/login", response_model=schemas.LoginResponse)
def login(request: schemas.LoginRequest, db: Session = Depends(get_db)):
    usuario = crud.get_usuario_by_correo(db, request.correo)
    if not usuario:
        raise HTTPException(status_code=401, detail="Correo no registrado")
    if usuario.contrasena != request.contrasena:
        raise HTTPException(status_code=401, detail="Contraseña incorrecta")
    return schemas.LoginResponse(
        message="Login exitoso",
        id_usuario=usuario.id_usuario,
        nombre=usuario.nombre
    )


# =====================================================
# 🎥 VIDEOS
# =====================================================
@app.get("/videos")
def listar_videos(page: int = 1, db: Session = Depends(get_db)):
    limit = 3
    skip = (page - 1) * limit
    videos = crud.get_videos(db, skip=skip, limit=limit)
    total = crud.contar_videos(db)
    has_more = skip + limit < total

    result = []
    for v in videos:
        usuario = crud.get_usuario_by_id(db, v.id_usuario)
        etiqueta = crud.get_etiqueta_por_video(db, v.id_video)
        total_likes = crud.get_total_likes(db, v.id_video)
        result.append({
            "id_video": str(v.id_video),
            "titulo": v.titulo,
            "descripcion": v.descripcion,
            "ruta": v.ruta,
            "usuario": usuario.nombre if usuario else "Desconocido",
            "etiqueta": etiqueta.nombre if etiqueta else "",
            "likes": total_likes or 0,
            "liked": False
        })
    return {"page": page, "videos": result, "has_more": has_more}


@app.post("/upload_video")
def upload_video(
    titulo: str = Form(...),
    descripcion: str = Form(""),
    etiqueta: str = Form(""),
    id_usuario: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    usuario = crud.get_usuario_by_id(db, id_usuario)
    if not usuario:
        raise HTTPException(status_code=401, detail="Usuario no válido")

    filename = file.filename
    save_path = os.path.join(VIDEO_DIR, filename)
    os.makedirs(VIDEO_DIR, exist_ok=True)
    with open(save_path, "wb") as buffer:
        buffer.write(file.file.read())

    # Calcular duración del video
    if VideoFileClip is None:
        raise HTTPException(status_code=500, detail="moviepy no está disponible en el entorno. Instala moviepy para subir videos.")
    clip = VideoFileClip(save_path)
    duracion = str(timedelta(seconds=clip.duration))
    clip.close()

    # Guardar en BD correctamente
    ruta = f"media/{filename}"
    nuevo = crud.crear_video(db, titulo, descripcion, duracion, id_usuario, ruta)

    if etiqueta:
        crud.crear_etiqueta(db, etiqueta, nuevo.id_video)

    return {
        "message": "Video subido correctamente",
        "id_video": str(nuevo.id_video),
        "ruta": ruta,
        "duracion": duracion
    }


# 🔴 Desactiva la generación random de videos
# @app.get("/videos/random")
# def videos_random(id_usuario: int = Query(None), db: Session = Depends(get_db)):
#     videos = db.query(Video).all()
#     if not videos:
#         raise HTTPException(status_code=404, detail="No hay videos disponibles")
#     random.shuffle(videos)

#     result = []
#     for v in videos[:10]:
#         usuario = crud.get_usuario_by_id(db, v.id_usuario)
#         etiqueta = crud.get_etiqueta_por_video(db, v.id_video)
#         total_likes = crud.get_total_likes(db, v.id_video)
#         liked = (
#             db.query(Like)
#             .filter(Like.id_usuario == id_usuario, Like.id_video == v.id_video)
#             .first() is not None
#         ) if id_usuario else False

#         result.append({
#             "id_video": str(v.id_video),
#             "titulo": v.titulo,
#             "descripcion": v.descripcion,
#             "ruta": v.ruta,
#             "usuario": usuario.nombre if usuario else "Desconocido",
#             "etiqueta": etiqueta.nombre if etiqueta else "",
#             "likes": total_likes,
#             "liked": liked
#         })
#     return result


@app.get("/videos/{id_video}/like")
def get_like_status(id_video: UUID, id_usuario: int, db: Session = Depends(get_db)):
    video = crud.get_video_by_id(db, id_video)
    if not video:
        raise HTTPException(status_code=404, detail="Video no encontrado")

    liked = crud.get_like(db, id_usuario, id_video) is not None
    total_likes = crud.get_total_likes(db, id_video)
    return {"likes": total_likes, "liked": liked}


@app.post("/videos/{id_video}/like")
def toggle_like(id_video: UUID, id_usuario: int, db: Session = Depends(get_db)):
    video = crud.get_video_by_id(db, id_video)
    if not video:
        raise HTTPException(status_code=404, detail="Video no encontrado")

    like = crud.get_like(db, id_usuario, id_video)
    if like:
        crud.delete_like(db, id_usuario, id_video)
        liked = False
    else:
        crud.create_like(db, id_usuario, id_video)
        liked = True

    total_likes = crud.get_total_likes(db, id_video)
    return {"likes": total_likes, "liked": liked}


@app.delete("/videos/{id_video}")
def eliminar_video(id_video: UUID, id_usuario: int, db: Session = Depends(get_db)):
    video = crud.get_video_by_id(db, id_video)
    if not video:
        raise HTTPException(status_code=404, detail="Video no encontrado")
    if video.id_usuario != id_usuario:
        raise HTTPException(status_code=403, detail="No tienes permiso para eliminar este video")

    crud.eliminar_video(db, id_video)
    return {"message": "Video eliminado correctamente"}


@app.get("/videos/nuevos")
def obtener_videos_nuevos(ultimo_id: int = 0, db: Session = Depends(get_db)):
    """
    Devuelve los videos más recientes con id_video > ultimo_id
    """
    videos = (
        db.query(Video)
        .filter(Video.id_usuario > ultimo_id)
        .order_by(Video.fecha_subida.desc())
        .limit(5)
        .all()
    )
    return [
        {
            "id_video": str(v.id_video),
            "titulo": v.titulo,
            "descripcion": v.descripcion,
            "ruta": v.ruta,
        }
        for v in videos
    ]


# =====================================================
# 🏷️ ETIQUETAS
# =====================================================
@app.get("/etiquetas", response_model=List[schemas.EtiquetaResponse])
def listar_etiquetas(db: Session = Depends(get_db)):
    return crud.listar_etiquetas(db)


@app.post("/etiquetas", response_model=schemas.EtiquetaResponse)
def crear_etiqueta(etiqueta: schemas.EtiquetaCreate, db: Session = Depends(get_db)):
    nueva = crud.crear_etiqueta(db, etiqueta.nombre, etiqueta.id_video)
    return schemas.EtiquetaResponse.from_orm(nueva)


# =====================================================
# 📚 CONJUNTOS DE FLASHCARDS
# =====================================================
@app.post("/conjuntos", response_model=schemas.ConjuntoFlashcardResponse)
def crear_conjunto(conjunto: schemas.ConjuntoFlashcardCreate, db: Session = Depends(get_db)):
    """Crea un nuevo conjunto de flashcards"""
    usuario = crud.get_usuario_by_id(db, conjunto.id_usuario)
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    nuevo = crud.crear_conjunto_flashcard(db, conjunto.titulo, conjunto.descripcion, conjunto.id_usuario)
    return schemas.ConjuntoFlashcardResponse.from_orm(nuevo)


@app.get("/conjuntos", response_model=List[schemas.ConjuntoFlashcardResponse])
def listar_conjuntos(id_usuario: int = Query(None), db: Session = Depends(get_db)):
    """Lista todos los conjuntos de flashcards, opcionalmente filtrados por usuario"""
    conjuntos = crud.get_conjuntos_flashcard(db, id_usuario)
    return [schemas.ConjuntoFlashcardResponse.from_orm(c) for c in conjuntos]


@app.get("/conjuntos/{id_conjunto}", response_model=schemas.ConjuntoConFlashcardsResponse)
def obtener_conjunto(id_conjunto: int, db: Session = Depends(get_db)):
    """Obtiene un conjunto específico con todas sus flashcards"""
    conjunto = crud.get_conjunto_flashcard_by_id(db, id_conjunto)
    if not conjunto:
        raise HTTPException(status_code=404, detail="Conjunto no encontrado")
    
    flashcards = crud.get_flashcards_by_conjunto(db, id_conjunto)
    return {
        "id_conjunto": conjunto.id_conjunto,
        "titulo": conjunto.titulo,
        "descripcion": conjunto.descripcion,
        "id_usuario": conjunto.id_usuario,
    "fecha_creacion": conjunto.fecha_creacion if conjunto.fecha_creacion else None,
        "flashcards": [schemas.FlashcardResponse.from_orm(f) for f in flashcards]
    }


@app.delete("/conjuntos/{id_conjunto}")
def eliminar_conjunto(id_conjunto: int, id_usuario: int, db: Session = Depends(get_db)):
    """Elimina un conjunto de flashcards"""
    conjunto = crud.get_conjunto_flashcard_by_id(db, id_conjunto)
    if not conjunto:
        raise HTTPException(status_code=404, detail="Conjunto no encontrado")
    if conjunto.id_usuario != id_usuario:
        raise HTTPException(status_code=403, detail="No tienes permiso para eliminar este conjunto")
    
    crud.eliminar_conjunto_flashcard(db, id_conjunto)
    return {"message": "Conjunto eliminado correctamente"}


# =====================================================
# 🎴 FLASHCARDS
# =====================================================
@app.post("/flashcards", response_model=schemas.FlashcardResponse)
def crear_flashcard_endpoint(flashcard: schemas.FlashcardCreate, db: Session = Depends(get_db)):
    """Crea una nueva flashcard"""
    conjunto = crud.get_conjunto_flashcard_by_id(db, flashcard.id_conjunto)
    if not conjunto:
        raise HTTPException(status_code=404, detail="Conjunto no encontrado")
    
    nueva = crud.crear_flashcard(
        db,
        flashcard.titulo,
        flashcard.contenido_frontal,
        flashcard.contenido_trasero,
        flashcard.id_conjunto,
        flashcard.tipo_contenido,
        flashcard.orden
    )
    return schemas.FlashcardResponse.from_orm(nueva)


@app.get("/flashcards/{id_flashcard}", response_model=schemas.FlashcardResponse)
def obtener_flashcard(id_flashcard: UUID, db: Session = Depends(get_db)):
    """Obtiene una flashcard específica"""
    flashcard = crud.get_flashcard_by_id(db, id_flashcard)
    if not flashcard:
        raise HTTPException(status_code=404, detail="Flashcard no encontrada")
    return schemas.FlashcardResponse.from_orm(flashcard)


@app.put("/flashcards/{id_flashcard}", response_model=schemas.FlashcardResponse)
def actualizar_flashcard_endpoint(
    id_flashcard: UUID,
    flashcard_update: schemas.FlashcardUpdate,
    db: Session = Depends(get_db)
):
    """Actualiza una flashcard"""
    flashcard = crud.get_flashcard_by_id(db, id_flashcard)
    if not flashcard:
        raise HTTPException(status_code=404, detail="Flashcard no encontrada")
    
    actualizada = crud.actualizar_flashcard(db, id_flashcard, **flashcard_update.dict(exclude_unset=True))
    return schemas.FlashcardResponse.from_orm(actualizada)


@app.delete("/flashcards/{id_flashcard}")
def eliminar_flashcard_endpoint(id_flashcard: UUID, db: Session = Depends(get_db)):
    """Elimina una flashcard"""
    flashcard = crud.get_flashcard_by_id(db, id_flashcard)
    if not flashcard:
        raise HTTPException(status_code=404, detail="Flashcard no encontrada")
    
    crud.eliminar_flashcard(db, id_flashcard)
    return {"message": "Flashcard eliminada correctamente"}


@app.get("/conjuntos/{id_conjunto}/flashcards", response_model=List[schemas.FlashcardResponse])
def listar_flashcards_conjunto(id_conjunto: int, db: Session = Depends(get_db)):
    """Lista todas las flashcards de un conjunto"""
    conjunto = crud.get_conjunto_flashcard_by_id(db, id_conjunto)
    if not conjunto:
        raise HTTPException(status_code=404, detail="Conjunto no encontrado")
    
    flashcards = crud.get_flashcards_by_conjunto(db, id_conjunto)
    return [schemas.FlashcardResponse.from_orm(f) for f in flashcards]
