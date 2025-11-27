# 🚀 COMIENZA AQUÍ - Flutter App

## ⚡ En 30 segundos

```bash
# Terminal 1: Inicia backend
cd ..
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Terminal 2: Inicia frontend
flutter run -d web-server --web-port=5000

# Navegador:
http://localhost:5000
```

## 📖 O lee primero:

👉 **[Ir a documentación completa](../README.md)**

---

## 🎯 Acceso rápido a pantallas

| Pantalla | Ruta en Código | Estado |
|----------|----------------|--------|
| 🎬 Videos | `lib/screens/video_list_screen.dart` | ✅ |
| 📇 Flashcards | `lib/screens/flashcard_list_screen.dart` | ✅ |
| 👤 Perfil | `lib/screens/profile_screen.dart` | ✅ |
| 🔐 Login | `lib/screens/login_screen.dart` | ✅ |
| ⚙️ Navegación | `lib/screens/app_shell.dart` | ✅ |

---

## 🔧 Archivos importantes

- `pubspec.yaml` - Dependencias
- `lib/main.dart` - Punto de entrada
- `lib/config/api_constants.dart` - URLs de API
- `lib/services/api_service.dart` - Cliente HTTP
- `lib/providers/` - Estado (Auth, Video, Flashcard)

---

## 📱 Comandos Flutter útiles

```bash
# Limpiar todo
flutter clean

# Obtener dependencias
flutter pub get

# Ejecutar en web
flutter run -d web-server --web-port=5000

# Build para web
flutter build web --release

# Build para Android
flutter build apk --release

# Build para iOS
flutter build ios --release
```

---

## ✨ Stack

- **UI Framework**: Flutter
- **State**: Provider
- **API**: http package
- **Storage**: shared_preferences

## 🎨 Colores

```dart
const azulUTP = Color(0xFF0A45C2);       // Primary
const azulClaro = Color(0xFFBFDD0FF);    // Secondary
const verde = Color(0xFF00AA00);         // Success
const rojo = Color(0xFFFF0000);          // Error
```

---

**¿Necesitas ayuda?** → Revisa [`../README.md`](../README.md)

**¿Listo?** → Ejecuta los comandos arriba 🎉
