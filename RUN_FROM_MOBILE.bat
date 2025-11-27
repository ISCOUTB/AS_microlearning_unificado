@echo off
REM Script para iniciar servidor accesible desde celular

echo.
echo =====================================================
echo  📱 Acceso desde CELULAR - Microlearning UTP
echo =====================================================
echo.

REM Obtener IP local
for /f "tokens=2 delims=: " %%A in ('ipconfig ^| findstr /R "IPv4"') do set IP=%%A

echo Tu dirección IP local es: %IP%
echo.
echo Asegúrate de que tu celular esté en la MISMA RED WiFi
echo.
echo Acceso desde celular:
echo   📱 http://%IP%:5000
echo.

REM Verificar Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Python no encontrado
    pause
    exit /b 1
)

echo ✅ Iniciando servidor...
echo.

REM Iniciar servidor backend
start "Backend FastAPI" cmd /k "cd /d c:\AS_microlearning_unificado-master && python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000"

REM Esperar
timeout /t 3 /nobreak

REM Iniciar Flutter
echo.
echo Compilando y ejecutando Flutter Web...
echo Por favor espera, puede tardar 2-3 minutos la primera vez...
echo.
start "Frontend Flutter Web" cmd /k "cd /d c:\AS_microlearning_unificado-master\microlearning_app && flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0"

echo.
echo ✅ ¡Aplicación iniciada!
echo.
echo Para acceder DESDE CELULAR:
echo   http://%IP%:5000
echo.
pause
