# 📚 Índice de Documentación - Plataforma Microlearning UTP

## 🎯 ¿Por dónde empiezo?

### Si eres nuevo:
1. **Primero**: Lee [`QUICK_START.md`](QUICK_START.md) (5 minutos)
2. **Luego**: Ejecuta los scripts para probar
3. **Finalmente**: Lee [`RESUMEN_FINAL.md`](RESUMEN_FINAL.md) para entender la arquitectura

### Si quieres más detalles:
- [`SETUP.md`](SETUP.md) - Guía de instalación y deployment
- [`CHECKLIST.md`](CHECKLIST.md) - Lista de features completadas

---

## 📁 Estructura de Archivos

```
Documentación:
├── README.md            ← Este archivo (índice)
├── QUICK_START.md       ← EMPIEZA AQUÍ (paso a paso)
├── RESUMEN_FINAL.md     ← Arquitectura y features
├── SETUP.md             ← Instalación y deployment
└── CHECKLIST.md         ← Lista de features

Scripts:
├── RUN_ALL.bat          ← Inicia TODO automáticamente
├── start_server.bat     ← Solo backend
└── start_web.bat        ← Solo frontend (en microlearning_app/)

Backend:
├── main.py              ← Servidor FastAPI
├── models.py            ← Modelos de BD
├── schemas.py           ← Validaciones
├── crud.py              ← Operaciones DB
├── database.py          ← Conexión PostgreSQL
├── requirements.txt     ← Dependencias
└── auth/routes.py       ← Rutas de autenticación

Frontend (Flutter):
├── lib/main.dart        ← App entry point
├── lib/screens/         ← Todas las pantallas
├── lib/providers/       ← State management
├── lib/services/        ← API calls
├── lib/models/          ← Data models
├── lib/config/          ← Configuración
├── pubspec.yaml         ← Dependencias
└── build/web/           ← Output compilado
```

---

## 🚀 Comandos Rápidos

### Iniciar TODO (2 ventanas automáticamente)
```bash
cd c:\AS_microlearning_unificado-master
RUN_ALL.bat
```

### O manualmente (2 terminales diferentes):

**Terminal 1 - Backend**
```bash
cd c:\AS_microlearning_unificado-master
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Frontend**
```bash
cd c:\AS_microlearning_unificado-master\microlearning_app
flutter run -d web-server --web-port=5000
```

### Luego abre en navegador:
```
http://localhost:5000
```

---

## 📋 Checklist de Funcionalidades

### ✅ Backend (FastAPI)
- [x] Login/Registro
- [x] Listar usuarios
- [x] CRUD de videos
- [x] CRUD de flashcards
- [x] Sistema de likes
- [x] Paginación
- [x] CORS habilitado
- [x] PostgreSQL integrado

### ✅ Frontend (Flutter)
- [x] 5 Pantallas completas
- [x] Navegación inferior
- [x] Animaciones
- [x] Conexión API
- [x] State management
- [x] Validaciones
- [x] Session persistence
- [x] Error handling

### ✅ UI/UX
- [x] Diseño UTP profesional
- [x] Colores consistentes
- [x] Responsive web/mobile
- [x] Animaciones suaves
- [x] Accesibilidad

---

## 🎯 Pantallas Implementadas

| Pantalla | Estado | Acceso |
|----------|--------|--------|
| Splash | ✅ Completa | Automática |
| Login | ✅ Completa | `/login` |
| Videos | ✅ Completa | Home → Tab Videos |
| Flashcards | ✅ Completa | Home → Tab Flashcards |
| Perfil | ✅ Completa | Home → Tab Perfil |

---

## 🔌 Endpoints API

### Autenticación
```
POST   /login              Login de usuario
POST   /usuarios           Registrar nuevo usuario
GET    /usuarios           Listar todos los usuarios
```

### Videos
```
GET    /videos?page=1      Listar videos
POST   /videos/{id}/like   Dar like a un video
GET    /videos/{id}        Obtener detalles de video
```

### Flashcards
```
GET    /conjuntos                           Listar conjuntos
GET    /conjuntos/{id}                      Obtener detalles
GET    /conjuntos/{id}/flashcards           Listar flashcards
POST   /conjuntos                           Crear conjunto
POST   /flashcards                          Crear flashcard
DELETE /flashcards/{id}                     Eliminar flashcard
```

---

## 🎨 Esquema de Colores

```
Azul UTP:       #0A45C2  (Primario - Botones, Headers)
Azul Claro:     #BFDD0FF (Secundario - Cards)
Verde:          #00AA00  (Acciones - Play, Like)
Rojo:           #FF0000  (Peligro - Eliminar)
Blanco:         #FFFFFF  (Fondo)
Gris:           #F5F5F5  (Superficie)
```

---

## 📱 URLs Importantes

| Servicio | URL |
|----------|-----|
| 🌐 App Web | http://localhost:5000 |
| 🔌 Backend API | http://localhost:8000 |
| 📖 Swagger Docs | http://localhost:8000/docs |
| 📚 ReDoc | http://localhost:8000/redoc |

---

## 🧪 Probar la API

### Crear usuario (PowerShell):
```powershell
$body = @{
    nombre = "Test User"
    correo = "test@utp.edu.pe"
    contrasena = "password123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8000/usuarios" `
  -Method POST -ContentType "application/json" -Body $body
```

### Login en app:
- Email: `test@utp.edu.pe`
- Password: `password123`

---

## 🐛 Troubleshooting

### Puerto en uso (8000 o 5000)
```bash
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Flutter web no funciona
```bash
flutter config --enable-web
flutter clean
flutter pub get
flutter run -d web-server --web-port=5000
```

### No conecta a API
1. Verifica que backend esté corriendo en http://localhost:8000
2. Revisa http://localhost:8000/docs (debe mostrar Swagger)
3. Revisa `lib/config/api_constants.dart` → baseUrl debe ser localhost:8000
4. Revisa console del navegador (F12) para más detalles

### Base de datos no conecta
1. Verifica PostgreSQL URL en `database.py`
2. Verifica que Railway está disponible
3. Revisa que las credenciales sean correctas

---

## 🚀 Deployment

### A Producción (Web)
```bash
cd microlearning_app
flutter build web --release
# Servir carpeta build/web/ con tu host
```

### A Android
```bash
cd microlearning_app
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### A iOS
```bash
cd microlearning_app
flutter build ios --release
# Abrir build/ios/Runner.xcworkspace en Xcode y archivar
```

---

## 📚 Stack Tecnológico

**Frontend**:
- Flutter 3.x (Web + Mobile)
- Provider (State Management)
- http (API Client)
- shared_preferences (Local Storage)

**Backend**:
- FastAPI 0.116.1
- SQLAlchemy (ORM)
- PostgreSQL (Database)
- Pydantic v2 (Validation)

**Infrastructure**:
- Railway (Hosting)
- PostgreSQL (Database)
- CORS enabled

---

## 📖 Documentación Completa

Para información más detallada, consulta:

| Archivo | Contenido |
|---------|-----------|
| [`QUICK_START.md`](QUICK_START.md) | Cómo empezar en 5 minutos |
| [`RESUMEN_FINAL.md`](RESUMEN_FINAL.md) | Arquitectura del proyecto |
| [`SETUP.md`](SETUP.md) | Instalación y configuración |
| [`CHECKLIST.md`](CHECKLIST.md) | Todas las features implementadas |

---

## 🎉 ¡Bienvenido!

**¿Listo para empezar?**

1. Lee [`QUICK_START.md`](QUICK_START.md) (5 minutos)
2. Ejecuta `RUN_ALL.bat`
3. Abre http://localhost:5000
4. ¡Disfruta! 🚀

---

## 📧 Soporte

- **Issues**: Abre un issue en GitHub
- **Documentación**: Consulta los archivos .md
- **API Docs**: http://localhost:8000/docs

---

**Proyecto**: AS Microlearning Unificado  
**Institución**: UTP (Universidad Tecnológica del Perú)  
**Versión**: 2.0  
**Última actualización**: 11 de Noviembre, 2025  
**Estado**: ✅ Listo para Producción
