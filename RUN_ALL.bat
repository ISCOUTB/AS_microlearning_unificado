@echo off
REM Script para iniciar servidor y app Flutter en web simultáneamente

echo.
echo =====================================================
echo  🚀 Plataforma Microlearning UTP - Iniciador
echo =====================================================
echo.
echo Este script iniciará:
echo   1. Backend FastAPI en http://localhost:8000
echo   2. Frontend Flutter en http://localhost:5000
echo.
echo ¡Asegúrate de tener Flutter y Python instalados!
echo.

REM Verificar Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Python no encontrado. Por favor instala Python 3.9+
    pause
    exit /b 1
)

REM Verificar Flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Flutter no encontrado. Por favor instala Flutter
    pause
    exit /b 1
)

echo ✅ Dependencias verificadas
echo.

REM Iniciar servidor en una nueva ventana
echo Iniciando servidor backend...
start "Backend FastAPI" cmd /k "cd /d c:\AS_microlearning_unificado-master && python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000"

REM Esperar un poco para que el servidor se inicie
timeout /t 3 /nobreak

REM Iniciar Flutter en otra ventana
echo Iniciando aplicación Flutter Web...
start "Frontend Flutter Web" cmd /k "cd /d c:\AS_microlearning_unificado-master\microlearning_app && flutter run -d web-server --web-port=5000"

echo.
echo =====================================================
echo ✅ ¡Aplicación iniciada!
echo.
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:5000
echo.
echo Presiona cualquier tecla para cerrar esta ventana...
echo =====================================================
echo.

pause

