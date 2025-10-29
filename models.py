from sqlalchemy import (
    Column,
    String,
    Integer,
    Text,
    TIMESTAMP,
    ForeignKey,
    Interval,
    Numeric,
    func
)
from sqlalchemy.dialects.postgresql import UUID as PG_UUID
from sqlalchemy.orm import relationship
from database import Base
import uuid


# =====================================================
# 🧍 USUARIO
# =====================================================
class UsuarioApp(Base):
    __tablename__ = "usuario_app"

    id_usuario = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    correo = Column(String(150), unique=True, nullable=False)
    contrasena = Column(String(255), nullable=False)
    fecha_registro = Column(TIMESTAMP, server_default=func.now())

    # Relaciones
    videos = relationship("Video", back_populates="usuario", cascade="all, delete-orphan")
    likes = relationship("Like", back_populates="usuario", cascade="all, delete-orphan")


# =====================================================
# 🎥 VIDEO
# =====================================================
class Video(Base):
    __tablename__ = "video"

    id_video = Column(PG_UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    titulo = Column(String(200), nullable=False)
    descripcion = Column(Text)
    duracion = Column(Interval, nullable=False)
    fecha_subida = Column(TIMESTAMP, server_default=func.now())
    id_usuario = Column(Integer, ForeignKey("usuario_app.id_usuario", ondelete="CASCADE"), nullable=False)
    ruta = Column(String(500), nullable=False)

    # Relaciones
    usuario = relationship("UsuarioApp", back_populates="videos")
    etiquetas = relationship("Etiqueta", back_populates="video", cascade="all, delete-orphan")
    interaccion = relationship("Interaccion", back_populates="video", uselist=False, cascade="all, delete-orphan")
    likes = relationship("Like", back_populates="video", cascade="all, delete-orphan")


# =====================================================
# 🏷️ ETIQUETA
# =====================================================
class Etiqueta(Base):
    __tablename__ = "etiqueta"

    id_etiqueta = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    id_video = Column(PG_UUID(as_uuid=True), ForeignKey("video.id_video", ondelete="CASCADE"), nullable=False)

    # Relaciones
    video = relationship("Video", back_populates="etiquetas")


# =====================================================
# 📊 INTERACCIÓN
# =====================================================
class Interaccion(Base):
    __tablename__ = "interaccion"

    id_interaccion = Column(Integer, primary_key=True, index=True)
    id_video = Column(PG_UUID(as_uuid=True), ForeignKey("video.id_video", ondelete="CASCADE"), unique=True, nullable=False)
    total_vistas = Column(Integer, default=0)
    total_likes = Column(Integer, default=0)
    promedio_porcentaje_visto = Column(Numeric(5, 2), default=0.00)
    promedio_tiempo_visto = Column(Interval, default="0 seconds")

    # Relaciones
    video = relationship("Video", back_populates="interaccion")


# =====================================================
# ❤️ LIKE
# =====================================================
class Like(Base):
    __tablename__ = "likes"

    id_usuario = Column(Integer, ForeignKey("usuario_app.id_usuario", ondelete="CASCADE"), primary_key=True)
    id_video = Column(PG_UUID(as_uuid=True), ForeignKey("video.id_video", ondelete="CASCADE"), primary_key=True)

    # Relaciones
    usuario = relationship("UsuarioApp", back_populates="likes")
    video = relationship("Video", back_populates="likes")
