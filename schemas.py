from pydantic import BaseModel, EmailStr
from typing import Optional, List
from uuid import UUID


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
