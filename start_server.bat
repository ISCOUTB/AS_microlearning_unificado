@echo off
REM Script para iniciar el servidor FastAPI

echo =====================================================
echo Iniciando Servidor FastAPI en http://localhost:8000
echo =====================================================

cd /d c:\AS_microlearning_unificado-master

REM Verificar que uvicorn esté instalado
python -m pip show uvicorn >nul 2>&1
if %errorlevel% neq 0 (
    echo Instalando uvicorn...
    python -m pip install uvicorn -q
)

REM Iniciar servidor
echo.
echo Iniciando servidor...
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause
