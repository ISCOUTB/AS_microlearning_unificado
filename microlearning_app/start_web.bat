@echo off
REM Script para iniciar Flutter Web

echo =====================================================
echo Iniciando Flutter Web en http://localhost:5000
echo =====================================================

cd /d c:\AS_microlearning_unificado-master\microlearning_app

REM Verificar que flutter esté instalado
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter no está instalado o no está en PATH
    echo Por favor instala Flutter desde https://flutter.dev
    pause
    exit /b 1
)

REM Habilitar web si no está habilitado
echo Habilitando Flutter Web...
flutter config --enable-web -q

REM Limpiar compilaciones anteriores
echo Limpiando compilaciones anteriores...
flutter clean -q

REM Ejecutar en web
echo.
echo Iniciando aplicación...
flutter run -d web-server --web-port=5000

pause
