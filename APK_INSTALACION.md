# 📱 INSTRUCCIONES APK - Microlearning UTB

## 📍 Ubicación del APK (cuando esté listo)

```
c:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\app-release.apk
```

## 📥 Cómo Instalar en tu Android

### Opción 1: Transferencia por Cable USB
1. Conecta tu celular al PC con cable USB
2. Habilita "Transferencia de archivos" en el celular
3. Copia el archivo `app-release.apk` a tu celular
4. En el celular, abre el archivo APK
5. Permite la instalación (Configuración → Seguridad → Permitir Apps desconocidas si es necesario)
6. ¡Listo! La app está instalada

### Opción 2: Transferencia por Email/WhatsApp
1. Desde tu PC, adjunta el `app-release.apk` a un email/WhatsApp
2. Descárgalo en tu celular desde el email/WhatsApp
3. Abre el archivo descargado
4. Sigue los pasos 5-6 de Opción 1

### Opción 3: Bluetooth
1. Copia el `app-release.apk` a tu carpeta de descargas del PC
2. Desde el PC, envía por Bluetooth a tu celular
3. Abre el archivo desde el celular y sigue pasos 5-6 de Opción 1

---

## ⚙️ Configuración del Celular

### Permitir Instalar Apps Desconocidas (si es necesario)

**Android 9 o inferior:**
- Configuración → Seguridad → Permitir apps desconocidas

**Android 10+:**
- Configuración → Apps y notificaciones → Acceso especial → Instalar apps desconocidas
- Selecciona tu administrador de descargas y habilita

---

## 🌐 ALTERNATIVA: Usa el Navegador Mientras se Compila

**Si el APK aún está compilando**, puedes acceder desde el navegador del celular AHORA:

```
http://192.168.1.73:5000
```

**Funciona 100% igual que la app instalada**, solo que desde el navegador.

---

## ✅ Verificaciones Antes de Instalar

Asegúrate de que:
- [ ] El archivo `app-release.apk` existe (5-50 MB)
- [ ] Tu celular tiene espacio libre
- [ ] Tienes WiFi o datos activos (para conectar a la API)
- [ ] El archivo NO está corrupto

Para verificar el archivo en PowerShell:
```powershell
Get-Item "c:\AS_microlearning_unificado-master\microlearning_app\build\app\outputs\flutter-apk\app-release.apk" | Select-Object FullName, Length
```

---

## 🚀 Una Vez Instalada la App

1. **Abre Microlearning UTB** en tu celular
2. **Espera a que cargue** (Splash Screen 2 segundos)
3. **Login o Regístrate**
4. **Disfruta** de los Videos, Flashcards y tu Perfil

### Credenciales de Prueba
- Email: `test@utp.edu.pe`
- Password: `password123`

---

## ⚠️ Requisitos de Red

La app necesita conectarse al backend en `192.168.1.73:8000`

**Importante:**
- El PC debe estar encendido y con los servidores corriendo
- Tu celular debe estar en la MISMA WiFi que el PC
- Si cambias de red, la app no podrá conectar

---

## 🆘 Solución de Problemas

### "No se puede instalar"
- [ ] ¿Es un archivo APK válido?
- [ ] ¿Permitiste apps desconocidas en Configuración?
- [ ] ¿Tienes espacio en la memoria del celular?

### "La app no carga"
- [ ] ¿Estás en la misma WiFi que el PC?
- [ ] ¿El PC tiene los servidores corriendo?
- [ ] ¿Firewall del PC bloqueando los puertos?

Solución: Abre http://192.168.1.73:5000 desde el navegador del celular para verificar que la red funciona

### "Error de conexión a API"
- El backend no está corriendo
- Ejecuta: `python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000`
- En: `c:\AS_microlearning_unificado-master`

---

## 📊 Especificaciones del APK

- **App:** Microlearning UTB
- **Versión:** 2.0
- **Plataforma:** Android 7.0+ (API 24+)
- **Tamaño:** ~30-50 MB
- **Arquitectura:** arm64-v8a (la mayoría de celulares)

---

## 📞 Próximas Mejoras Post-Instalación

- [ ] Upload de videos desde la app
- [ ] Crear flashcards desde la app
- [ ] Estadísticas detalladas
- [ ] Notificaciones push
- [ ] Modo offline

---

**Última actualización:** 11 de Noviembre, 2025
