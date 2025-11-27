# 📱 Cómo Transferir el APK a tu Celular

## ✅ El APK ya está listo

📍 **Ubicación del archivo:**
```
C:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\app-release.apk
```

**Tamaño:** 22.9 MB  
**Nombre:** `app-release.apk`  
**Aplicación:** Microlearning UTB

---

## 🔄 Opción 1: Transferir por USB (RECOMENDADO - Más rápido)

### Paso 1: Conecta tu celular por USB
1. Conecta tu Android al PC con cable USB
2. En tu celular, selecciona **"Transferencia de archivos"** o **"MTP"**
3. En tu PC aparecerá como una carpeta

### Paso 2: Copia el APK
1. Abre esta carpeta en tu PC:
   ```
   C:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\
   ```
2. **Copia el archivo** `app-release.apk`
3. Pégalo en la carpeta **Descargas** (Downloads) de tu celular

### Paso 3: Instala la app
1. En tu celular, abre el **Explorador de archivos** o **Mi archivo**
2. Ve a **Descargas**
3. Toca el archivo **app-release.apk**
4. Si sale advertencia de "Fuentes desconocidas", presiona **Instalar de todas formas**
5. Espera a que termine ✅

---

## 📧 Opción 2: Transferir por Email/WhatsApp (Si no tienes USB)

### Por Email:
1. Abre **Gmail** o tu email
2. Crea un nuevo correo
3. Adjunta el archivo: `C:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\app-release.apk`
4. Envíatelo a ti mismo
5. En tu celular, descárgate el archivo desde el email
6. Abre y toca para instalar

### Por WhatsApp:
1. Abre WhatsApp en tu PC
2. Comparte el archivo con tu contacto personal o grupo
3. En el celular, descárgalo de WhatsApp
4. Abre y tapa para instalar

---

## 🎮 Paso Final: Prueba la App

Una vez instalada, abre **Microlearning UTB** y:

**Usuario de prueba:**
```
📧 Email: test@utp.edu.pe
🔐 Contraseña: password123
```

**Pantallas que puedes probar:**
- ✅ Login / Registro
- ✅ Videos (con botón + para subir)
- ✅ Flashcards (con botón + para crear)
- ✅ Perfil (con estadísticas: 12 videos, 45 flashcards, 7 días racha)

---

## ⚠️ Si tienes problemas

| Problema | Solución |
|----------|----------|
| "No puedo instalar desde fuentes desconocidas" | Ve a Configuración > Seguridad > Permitir instalación de apps desconocidas |
| "El archivo no se descarga en email" | Intenta por WhatsApp o USB, los archivos grandes a veces fallan |
| "La app no conecta a la API" | Asegúrate que tu celular esté en la **misma WiFi** que tu PC (192.168.1.x) |
| "Error al iniciar sesión" | Verifica que escribiste bien: `test@utp.edu.pe` y `password123` |

---

## 🆘 Comando para copiar manualmente (si nada funciona)

Abre PowerShell y ejecuta:
```powershell
Copy-Item "C:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\app-release.apk" -Destination "D:\app-release.apk"
```

(Cambia `D:\` por la letra de tu celular conectado por USB)

---

**¡Listo! El APK está en tu PC. Elige la opción que más te convenga para transferirlo. 📱✨**
