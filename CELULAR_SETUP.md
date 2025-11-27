# 📱 Acceso desde CELULAR - Microlearning UTB

## ✅ Estado Actual
- ✅ Backend FastAPI corriendo en `http://192.168.1.73:8000`
- ✅ Frontend Flutter Web corriendo en `http://192.168.1.73:5000`
- ✅ API configurada para usar IP local `192.168.1.73:8000`
- ✅ Servidor web escuchando en `0.0.0.0:5000` (accesible desde LAN)

## 🚀 Para Acceder desde tu CELULAR

### Requisitos
1. Celular y PC en la **MISMA RED WiFi** (no datos móviles)
2. PC con servidor corriendo (ambas ventanas activas)

### Pasos
1. En tu celular, abre el navegador
2. Escribe exactamente:
   ```
   http://192.168.1.73:5000
   ```
3. Presiona Enter
4. ¡Verás la app de Microlearning UTB en tu móvil!

### Funcionalidades disponibles
- ✅ Splash Screen (carga inicial)
- ✅ Login/Registro
- ✅ Ver Videos (Tab 1)
- ✅ Ver Flashcards (Tab 2)
- ✅ Perfil (Tab 5)
- ✅ Navegación con Bottom Nav Bar (5 iconos)
- ⏳ Subir Videos (botón + en Videos)
- ⏳ Crear Flashcards (botón + en Flashcards)

### Si NO funciona desde celular

#### Opción A: Permitir firewall de Windows
```powershell
# Ejecutar como Administrador en PowerShell
New-NetFirewallRule -DisplayName "Allow Microlearning UTB" -Direction Inbound -LocalPort 5000,8000 -Protocol TCP -Action Allow
```

#### Opción B: Verificar que estés en la misma red
1. En PC, escribe en CMD/PowerShell: `ipconfig`
2. Busca "IPv4 Address" bajo tu conexión WiFi
3. Si ve `192.168.1.73`, es correcto
4. Si ve otra IP (ej. `10.0.0.5`), reemplaza en el celular: `http://<TU_IP>:5000`

#### Opción C: Probar desde el PC primero
1. Abre http://localhost:5000 en el PC (debe funcionar)
2. O http://192.168.1.73:5000 en el PC
3. Si funciona en PC pero no en celular → problema de firewall (usa Opción A)

---

## 📋 Credenciales de Prueba

**Email:** `test@utp.edu.pe`  
**Password:** `password123`

O crea una cuenta nueva directamente en la pantalla de Registro.

---

## 🎨 Información de la App

- **Nombre:** Microlearning UTB
- **Universidad:** Universidad Tecnológica de Bogotá (UTB)
- **Colores:**
  - Azul Primario: #0A45C2 (Branding UTB)
  - Azul Claro: #BFDD0FF (Tarjetas)
- **Plataformas:** Web + Mobile (iOS/Android)

---

## 🛑 Si algo falla

### Error: "Cannot reach server"
→ Verifica que ambos procesos (backend + frontend) están corriendo

### Error: "Connection refused"
→ Asegúrate de estar en la misma WiFi, no en datos móviles

### Error: "CORS error" (en consola del navegador)
→ El backend debe tener CORS habilitado (ya lo está por defecto)

### Pantalla en blanco o lenta
→ Espera 5-10 segundos a que cargue Flutter (primera vez es más lenta)

---

## ✨ Próximas Mejoras

- [ ] Upload de videos desde la app
- [ ] Crear flashcards desde la app
- [ ] Estadísticas de usuario
- [ ] Comentarios en videos
- [ ] Editar perfil

---

**Última actualización:** 11 de Noviembre, 2025
