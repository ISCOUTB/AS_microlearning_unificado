@echo off
REM Script para verificar y preparar el APK para envío

echo.
echo =====================================================
echo  📱 VERIFICADOR Y PREPARADOR DE APK
echo =====================================================
echo.

setlocal enabledelayedexpansion

set "APK_PATH=build\app\outputs\flutter-apk\app-release.apk"
set "APK_BACKUP=..\app-release.apk"

if not exist "%APK_PATH%" (
    echo ❌ APK NO ENCONTRADO en: %APK_PATH%
    echo.
    echo Esperando... el build puede estar en progreso
    echo Verifica que hayas ejecutado: flutter build apk --release
    echo.
    pause
    exit /b 1
)

echo ✅ APK ENCONTRADO
echo.

REM Mostrar información del archivo
for %%F in ("%APK_PATH%") do (
    set "size=%%~zF"
    echo Ruta:     %APK_PATH%
    echo Tamaño:   %size% bytes ^(aprox. !size:~0,-6! MB^)
    echo.
)

REM Crear copia en la raíz del proyecto para fácil acceso
echo Creando copia en c:\AS_microlearning_unificado-master\
copy "%APK_PATH%" "%APK_BACKUP%" >nul
if exist "%APK_BACKUP%" (
    echo ✅ Copia creada: %APK_BACKUP%
) else (
    echo ⚠️  No se pudo crear copia
)

echo.
echo =====================================================
echo 📋 PRÓXIMOS PASOS:
echo =====================================================
echo.
echo 1. Transferir el APK a tu celular:
echo    - Por cable USB (recomendado)
echo    - Por email/WhatsApp
echo    - Por Bluetooth
echo.
echo 2. En el celular, abre el archivo y habilita:
echo    - "Permitir apps desconocidas" (si aparece)
echo.
echo 3. ¡A disfrutar Microlearning UTB!
echo.
echo Credenciales de prueba:
echo   Email: test@utp.edu.pe
echo   Password: password123
echo.
echo =====================================================
echo.

pause
