from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Form, Request, Query
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse, Response
from sqlalchemy.orm import Session
from typing import List
from uuid import UUID
from datetime import timedelta
import os, random
from moviepy.editor import VideoFileClip

# Importaciones locales
import models, schemas, crud
from database import SessionLocal, engine
from models import UsuarioApp, Video, Like, Etiqueta, Interaccion

# Crear tablas en caso de no existir
models.Base.metadata.create_all(bind=engine)

# =====================================================
# 🚀 APP CONFIG
# =====================================================
app = FastAPI(title="API Plataforma de Videos", version="2.0")

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
