# 🎬 CÓMO INICIAR LA APP - Guía Paso a Paso

## ⚙️ Prerequisitos

Verifica que tengas instalado:
- ✅ Python 3.9+
- ✅ Flutter SDK
- ✅ Git

## 🚀 Paso 1: Iniciar el Backend

### Opción A: Automático (Recomendado)
```bash
cd c:\AS_microlearning_unificado-master
start_server.bat
```
**Espera a ver**: `Uvicorn running on http://0.0.0.0:8000`

### Opción B: Manual
```bash
cd c:\AS_microlearning_unificado-master
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

---

## 🚀 Paso 2: Iniciar el Frontend

### En OTRA terminal (Terminal 2):

### Opción A: Automático
```bash
cd c:\AS_microlearning_unificado-master\microlearning_app
start_web.bat
```
**Espera a ver**: `http://localhost:5000`

### Opción B: Manual
```bash
cd c:\AS_microlearning_unificado-master\microlearning_app
flutter pub get
flutter run -d web-server --web-port=5000
```

---

## 🌐 Paso 3: Abrir en el Navegador

1. Abre tu navegador (Chrome recomendado)
2. Ve a: **http://localhost:5000**
3. ¡Deberías ver la pantalla de Splash!

---

## 🔐 Paso 4: Crear Usuario de Prueba

### En PowerShell/Terminal (Terminal 3):

```powershell
$body = @{
    nombre = "Juan Test"
    correo = "juan@test.com"
    contrasena = "password123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8000/usuarios" `
  -Method POST `
  -ContentType "application/json" `
  -Body $body
```

**Si funciona**, verás una respuesta con los datos del usuario.

---

## 👤 Paso 5: Hacer Login

En la app (http://localhost:5000):

1. **Email**: `juan@test.com`
2. **Password**: `password123`
3. **Click**: "Iniciar Sesión"

**Deberías ver** la pantalla de Videos (Home)

---

## 🎬 Paso 6: Probar Navegación

### Barra inferior con 5 iconos:
- 🏠 **Home** - Videos
- 🔒 **Lock** - Flashcards
- ⚙️ **Settings** - Estadísticas (placeholder)
- ▶️ **Play** - Notificaciones (placeholder)
- 👤 **Person** - Perfil

**Toca cada icono** para navegar entre pantallas

---

## 🎯 Funcionalidades a Probar

### En VideoListScreen:
- [ ] ¿Se cargan videos?
- [ ] ¿Funciona el buscador?
- [ ] ¿Se puede dar like?
- [ ] ¿Funciona pull-to-refresh?

### En FlashcardListScreen:
- [ ] ¿Se cargan conjuntos?
- [ ] ¿Se ven en grid 2x2?
- [ ] ¿Al tapear abre FlashcardScreen?

### En FlashcardScreen:
- [ ] ¿Se anima el volteo?
- [ ] ¿Funcionan botones prev/next?
- [ ] ¿Se ven los 3 botones de control?

### En ProfileScreen:
- [ ] ¿Se muestra tu nombre?
- [ ] ¿Se ve el avatar?
- [ ] ¿Se ven los iconos?

---

## 🐛 Solución Rápida de Problemas

### "ERROR: Cannot connect to localhost:8000"
```
Solución: 
1. Verifica que Terminal 1 (Backend) esté corriendo
2. Verifica que no haya errores en Terminal 1
3. Intenta refrescar la página (F5)
```

### "ERROR: Port 8000 already in use"
```
Solución:
1. Abre PowerShell como Admin
2. Ejecuta: netstat -ano | findstr :8000
3. Copia el PID
4. Ejecuta: taskkill /PID <PID> /F
5. Reinicia el backend
```

### "Flutter: Cannot find web platform"
```
Solución:
flutter config --enable-web
flutter clean
flutter pub get
flutter run -d web-server
```

### "App se queda en pantalla de Splash"
```
Solución:
1. Abre DevTools (F12)
2. Ve a Console
3. Busca errores de red
4. Verifica que backend esté corriendo
5. Verifica que api_constants.dart use localhost:8000
```

---

## 🔍 Debugging

### Ver Console de Errores
- **En navegador**: Presiona `F12` → Console
- **En Flutter**: Terminal muestra logs automáticamente

### Ver Peticiones HTTP
- **F12** → **Network** tab
- Filtra por `XHR/Fetch`
- Haz click en una request
- Ve a **Response** para ver datos

### Ver API Documentation
- Abre: http://localhost:8000/docs
- Aquí puedes ver todos los endpoints
- Prueba directamente desde aquí

---

## 📝 Comandos Útiles

```bash
# Limpiar y reiniciar Flutter
flutter clean
flutter pub get
flutter run -d web-server

# Ver logs en tiempo real
flutter logs

# Formato código
flutter format lib/

# Analizar código
flutter analyze

# Build para producción
flutter build web --release
```

---

## 🎉 ¡Éxito!

Si llegaste hasta aquí, significa que:
✅ Backend está corriendo  
✅ Frontend está corriendo  
✅ Conexión API funciona  
✅ Base de datos responde  
✅ **¡LA APP FUNCIONA! 🎊**

---

## 📊 Checklist Final

- [ ] Backend corriendo en Terminal 1
- [ ] Frontend corriendo en Terminal 2
- [ ] Navegador abierto en http://localhost:5000
- [ ] Usuario de prueba creado
- [ ] Login exitoso
- [ ] Navegación entre pantallas funciona
- [ ] Videos/Flashcards cargan
- [ ] Botones responden

---

## 💬 Preguntas Frecuentes

**P: ¿Puedo usar en mi teléfono?**
R: Por ahora en web. Para Android/iOS necesitas `flutter build apk/ipa`

**P: ¿Cómo cambio el color?**
R: Edita el color en cada Screen (busca `azulUTP`)

**P: ¿Cómo agrego más videos?**
R: En BD directamente o crea endpoint de admin

**P: ¿Cómo despliego a producción?**
R: Ver SETUP.md → Deployment section

---

## 🆘 Contacto

Si algo no funciona:
1. Verifica que hayas seguido TODOS los pasos
2. Lee el Troubleshooting arriba
3. Revisa las Terminals por errores
4. Intenta: `flutter clean && flutter pub get`

---

**¡Listo! Ahora disfruta tu app! 🎉**
