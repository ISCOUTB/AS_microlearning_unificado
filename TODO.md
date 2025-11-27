# 📋 TODO - Desarrollo App Móvil Flutter

## ✅ COMPLETADO
- [x] Análisis del backend existente
- [x] Verificación de tablas en base de datos
- [x] Identificación de tablas faltantes

## 🔄 EN PROGRESO

### FASE 1: BACKEND - Sistema de Flashcards ✅ COMPLETADA
- [x] 1.1 Agregar modelos Vista y TiempoVisto faltantes en models.py
- [x] 1.2 Agregar modelos ConjuntoFlashcard y Flashcard en models.py
- [x] 1.3 Crear schemas para flashcards en schemas.py
- [x] 1.4 Crear funciones CRUD para flashcards en crud.py
- [x] 1.5 Crear endpoints API para flashcards en main.py
- [x] 1.6 Ejecutar migración segura (solo crear tablas nuevas)
- [x] 1.7 Verificar que tablas existentes no fueron afectadas

**Resultado:** 9 tablas en BD (7 existentes + 2 nuevas)
- ✅ conjunto_flashcard (NUEVA)
- ✅ flashcard (NUEVA)
- ✅ Todas las tablas anteriores intactas

### FASE 2: FLUTTER - Estructura del Proyecto ✅ COMPLETADA
- [x] 2.1 Crear proyecto Flutter
- [x] 2.2 Configurar pubspec.yaml con dependencias
- [x] 2.3 Crear estructura de carpetas (lib/models, lib/services, lib/screens, lib/widgets, lib/providers, lib/config)
- [x] 2.4 Configurar colores y tema (app_colors.dart)
- [x] 2.5 Configurar constantes de API (api_constants.dart)
- [x] 2.6 Instalar dependencias con flutter pub get

### FASE 3: FLUTTER - Modelos y Servicios ✅ COMPLETADA
- [x] 3.1 Crear modelos de datos
  - [x] Usuario (usuario.dart)
  - [x] Video (video.dart)
  - [x] Flashcard y ConjuntoFlashcard (flashcard.dart)
- [x] 3.2 Crear servicio API (api_service.dart)
  - [x] Endpoints de autenticación
  - [x] Endpoints de videos
  - [x] Endpoints de flashcards
- [x] 3.3 Implementar gestión de estado
  - [x] AuthProvider (auth_provider.dart)
  - [x] VideoProvider (video_provider.dart)
  - [x] FlashcardProvider (flashcard_provider.dart)
- [x] 3.4 Crear main.dart con configuración de app

### FASE 4: FLUTTER - Pantallas UI ⏳ EN PROGRESO
- [ ] 4.1 Pantalla Splash (splash_screen.dart)
- [ ] 4.2 Pantalla de Login/Registro (login_screen.dart)
- [ ] 4.3 Pantalla Principal/Home (home_screen.dart)
- [ ] 4.4 Pantalla de Perfil de Usuario (profile_screen.dart)
- [ ] 4.5 Pantalla de Videos (video_screen.dart)
- [ ] 4.6 Pantalla de Flashcards (flashcard_screen.dart)
- [ ] 4.7 Lista de Conjuntos (flashcard_list_screen.dart)
- [ ] 4.8 Barra de Navegación Global (bottom_nav_bar.dart)

### FASE 5: WIDGETS REUTILIZABLES
- [ ] 5.1 VideoCard widget
- [ ] 5.2 FlashcardCard widget
- [ ] 5.3 CustomAppBar widget
- [ ] 5.4 LoadingWidget
- [ ] 5.5 ErrorWidget

### FASE 6: FUNCIONALIDADES
- [ ] 6.1 Sistema de autenticación completo
- [ ] 6.2 Reproducción de videos
- [ ] 6.3 Sistema de likes
- [ ] 6.4 Sistema de comentarios
- [ ] 6.5 Compartir contenido
- [ ] 6.6 Navegación entre flashcards
- [ ] 6.7 Animación de volteo de flashcards

### FASE 7: TESTING Y APK
- [ ] 7.1 Probar en emulador Android
- [ ] 7.2 Ajustar diseño según imágenes proporcionadas
- [ ] 7.3 Generar APK para instalación
- [ ] 7.4 Pruebas en dispositivo físico

## 📊 PROGRESO GENERAL
- **Fase 1 (Backend):** ✅ 100%
- **Fase 2 (Estructura Flutter):** ✅ 100%
- **Fase 3 (Modelos y Servicios):** ✅ 100%
- **Fase 4 (Pantallas UI):** ⏳ 0%
- **Fase 5 (Widgets):** ⏳ 0%
- **Fase 6 (Funcionalidades):** ⏳ 0%
- **Fase 7 (Testing):** ⏳ 0%

**Progreso Total:** 43% (3 de 7 fases completadas)

---
**Última actualización:** Fase 3 completada - Instalando dependencias Flutter
**Siguiente paso:** Crear pantallas UI (Fase 4)
