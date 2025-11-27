# 🎓 Plataforma Microlearning UTP - Guía de Desarrollo

## 📋 Requisitos Previos

- **Python 3.9+** instalado
- **Flutter SDK** instalado y configurado
- **Node.js** (para web, opcional)
- **Git** (para clonar repositorio)

## 🚀 Inicio Rápido

### Opción 1: Ejecutar con Scripts (Recomendado)

#### Terminal 1 - Servidor Backend
```bash
# Windows
cd c:\AS_microlearning_unificado-master
start_server.bat

# o ejecutar manualmente
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Terminal 2 - Aplicación Flutter Web
```bash
# Windows
cd c:\AS_microlearning_unificado-master\microlearning_app
start_web.bat

# o ejecutar manualmente
flutter run -d web-server --web-port=5000
```

### Opción 2: Ejecución Manual

#### Backend (FastAPI)
```bash
cd c:\AS_microlearning_unificado-master
pip install -r requirements.txt
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Servidor disponible en: `http://localhost:8000`

#### Frontend (Flutter Web)
```bash
cd c:\AS_microlearning_unificado-master\microlearning_app
flutter pub get
flutter run -d web-server --web-port=5000
```

Aplicación disponible en: `http://localhost:5000`

## 📱 Probar la Aplicación

### En Web (para testing)
1. Abre `http://localhost:5000` en tu navegador
2. Usa credenciales de prueba para login
3. Navega entre pantallas con la barra inferior

### En Mobile (después de testing)
```bash
# Para Android
flutter run

# Para iOS
flutter run -d ios

# Para construir APK
flutter build apk --release
```

## 🔑 Credenciales de Prueba

Primero crea un usuario usando el endpoint:

```bash
POST http://localhost:8000/usuarios
Content-Type: application/json

{
  "nombre": "Juan Pérez",
  "correo": "juan@example.com",
  "contrasena": "password123"
}
```

Luego usa en la app:
- **Email**: juan@example.com
- **Password**: password123

## 🎨 Esquema de Colores

- **Azul UTP**: `#0A45C2` (Color primario)
- **Azul Claro**: `#BFDD0FF` (Tarjetas y componentes)
- **Verde**: Para botones de acción (Play, Reproducir)
- **Rojo**: Para acciones destructivas (Eliminar)
- **Blanco**: Fondo principal

## 📁 Estructura del Proyecto

```
AS_microlearning_unificado-master/
├── main.py                          # Servidor FastAPI
├── requirements.txt                 # Dependencias Python
├── models.py                        # Modelos de BD
├── schemas.py                       # Esquemas Pydantic
├── crud.py                          # Operaciones CRUD
├── database.py                      # Configuración BD
├── auth/                            # Módulo de autenticación
│   └── routes.py                   # Rutas de auth
│
└── microlearning_app/              # App Flutter
    ├── lib/
    │   ├── main.dart               # Entry point
    │   ├── config/
    │   │   └── api_constants.dart  # Configuración API
    │   ├── providers/              # Providers (State management)
    │   │   ├── auth_provider.dart
    │   │   ├── video_provider.dart
    │   │   └── flashcard_provider.dart
    │   ├── screens/                # Pantallas
    │   │   ├── login_screen.dart
    │   │   ├── app_shell.dart      # Navegación principal
    │   │   ├── home_screen.dart
    │   │   ├── video_list_screen.dart
    │   │   ├── flashcard_list_screen.dart
    │   │   ├── flashcard_screen.dart
    │   │   └── profile_screen.dart
    │   ├── models/                 # Modelos de datos
    │   ├── services/               # Servicios (API)
    │   └── widgets/                # Widgets reutilizables
    └── pubspec.yaml                # Dependencias Flutter
```

## 🔧 Configuración API

El archivo `lib/config/api_constants.dart` controla la URL del servidor:

```dart
// Desarrollo local
static const String baseUrl = 'http://localhost:8000';

// Producción (Railway, Heroku, etc.)
static const String baseUrl = 'https://tu-servidor.com';
```

## 📚 Endpoints Disponibles

### Autenticación
- `POST /login` - Iniciar sesión
- `POST /usuarios` - Registrar usuario
- `GET /usuarios` - Listar usuarios

### Videos
- `GET /videos?page=1` - Listar videos
- `POST /videos/{id_video}/like` - Toggle like en video

### Flashcards
- `GET /conjuntos` - Listar conjuntos
- `GET /conjuntos/{id}` - Obtener conjunto con flashcards
- `GET /conjuntos/{id}/flashcards` - Listar flashcards
- `POST /conjuntos` - Crear conjunto
- `POST /flashcards` - Crear flashcard

## 🧪 Testing

### Test Backend
```bash
cd c:\AS_microlearning_unificado-master
.\test_backend.ps1
```

### Test Frontend
```bash
cd c:\AS_microlearning_unificado-master\microlearning_app
flutter test
```

## 🐛 Solución de Problemas

### Puerto 8000 en uso
```bash
# Windows - encontrar y matar proceso
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Flutter Web no inicia
```bash
# Limpiar y reintentar
flutter clean
flutter pub get
flutter run -d web-server
```

### Error de CORS
- Verificar que `api_constants.dart` use `http://localhost:8000`
- Verificar que el backend tenga CORS habilitado en `main.py`

### Base de datos no sincroniza
```bash
# Resetear BD
python -c "from database import engine; from models import Base; Base.metadata.drop_all(bind=engine); Base.metadata.create_all(bind=engine)"
```

## 📦 Deployment

### Producción (Web)
```bash
flutter build web --release
# Servir archivos en `build/web/`
```

### Producción (Mobile APK)
```bash
flutter build apk --release
# APK en `build/app/outputs/flutter-apk/app-release.apk`
```

## 📞 Soporte

Para reportar problemas o sugerencias, contacta al equipo de desarrollo.

---

**Última actualización**: 11 de Noviembre, 2025  
**Versión**: 2.0  
**Estado**: 🟢 En desarrollo
