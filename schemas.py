from pydantic import BaseModel, EmailStr
from typing import Optional, List
from uuid import UUID
from datetime import datetime


# =====================================================
# 🧍 USUARIO
# =====================================================
class UsuarioBase(BaseModel):
    nombre: str
    correo: EmailStr


class UsuarioCreate(UsuarioBase):
    contrasena: str


class UsuarioResponse(UsuarioBase):
    id_usuario: int

    class Config:
        from_attributes = True


# =====================================================
# 🎥 VIDEO
# =====================================================
class VideoBase(BaseModel):
    titulo: str
    descripcion: Optional[str] = None
    duracion: str
    ruta: str


class VideoCreate(VideoBase):
    id_usuario: int


class VideoResponse(VideoBase):
    id_video: UUID
    id_usuario: int

    class Config:
        from_attributes = True


# =====================================================
# 🏷️ ETIQUETA
# =====================================================
class EtiquetaBase(BaseModel):
    nombre: str


class EtiquetaCreate(EtiquetaBase):
    id_video: UUID


class EtiquetaResponse(EtiquetaBase):
    id_etiqueta: int
    id_video: UUID

    class Config:
        from_attributes = True


# =====================================================
# 📊 INTERACCIÓN
# =====================================================
class InteraccionBase(BaseModel):
    total_vistas: int
    total_likes: int
    promedio_porcentaje_visto: Optional[float] = 0.0
    promedio_tiempo_visto: Optional[str] = "0 seconds"


class InteraccionCreate(BaseModel):
    id_video: UUID
    total_vistas: int = 0
    total_likes: int = 0


class InteraccionResponse(InteraccionBase):
    id_interaccion: int
    id_video: UUID

    class Config:
        from_attributes = True


# =====================================================
# ❤️ LIKE
# =====================================================
class LikeBase(BaseModel):
    id_usuario: int
    id_video: UUID


class LikeResponse(LikeBase):
    class Config:
        from_attributes = True


# =====================================================
# 🔐 LOGIN
# =====================================================
class LoginRequest(BaseModel):
    correo: EmailStr
    contrasena: str


class LoginResponse(BaseModel):
    message: str
    id_usuario: int
    nombre: str


# =====================================================
# 📦 RESPUESTAS COMPUESTAS
# =====================================================
class VideoDetalleResponse(VideoResponse):
    usuario: Optional[str] = None
    etiqueta: Optional[str] = None
    likes: Optional[int] = 0
    liked: Optional[bool] = False


# =====================================================
# 📚 CONJUNTO DE FLASHCARDS
# =====================================================
class ConjuntoFlashcardBase(BaseModel):
    titulo: str
    descripcion: Optional[str] = None


class ConjuntoFlashcardCreate(ConjuntoFlashcardBase):
    id_usuario: int


class ConjuntoFlashcardResponse(ConjuntoFlashcardBase):
    id_conjunto: int
    id_usuario: int
    fecha_creacion: Optional[datetime] = None

    class Config:
        from_attributes = True


# =====================================================
# 🎴 FLASHCARD
# =====================================================
class FlashcardBase(BaseModel):
    titulo: str
    contenido_frontal: str
    contenido_trasero: str
    tipo_contenido: Optional[str] = "texto"
    orden: Optional[int] = 0


class FlashcardCreate(FlashcardBase):
    id_conjunto: int


class FlashcardUpdate(BaseModel):
    titulo: Optional[str] = None
    contenido_frontal: Optional[str] = None
    contenido_trasero: Optional[str] = None
    tipo_contenido: Optional[str] = None
    orden: Optional[int] = None


class FlashcardResponse(FlashcardBase):
    id_flashcard: UUID
    id_conjunto: int
    fecha_creacion: Optional[datetime] = None

    class Config:
        from_attributes = True


# =====================================================
# 📦 CONJUNTO CON FLASHCARDS
# =====================================================
class ConjuntoConFlashcardsResponse(ConjuntoFlashcardResponse):
    flashcards: List[FlashcardResponse] = []

    class Config:
        from_attributes = True
