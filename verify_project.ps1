#!/usr/bin/env powershell
# VERIFICADOR DE ESTADO DEL PROYECTO
# Ejecutar: .\verify_project.ps1

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "📊 VERIFICADOR DE ESTADO DEL PROYECTO" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

$errorCount = 0
$warningCount = 0
$okCount = 0

function Check-File {
    param(
        [string]$path,
        [string]$description
    )
    
    if (Test-Path $path) {
        Write-Host "✅ $description" -ForegroundColor Green
        $script:okCount++
    } else {
        Write-Host "❌ FALTA: $description ($path)" -ForegroundColor Red
        $script:errorCount++
    }
}

function Check-Port {
    param(
        [int]$port,
        [string]$service
    )
    
    $connection = Test-NetConnection -ComputerName localhost -Port $port -InformationLevel Quiet
    if ($connection) {
        Write-Host "✅ $service corriendo en puerto $port" -ForegroundColor Green
        $script:okCount++
    } else {
        Write-Host "⚠️  $service NO está corriendo en puerto $port" -ForegroundColor Yellow
        $script:warningCount++
    }
}

Write-Host ""
Write-Host "📁 ARCHIVOS DEL PROYECTO" -ForegroundColor Magenta
Write-Host "------------------------" -ForegroundColor Magenta

# Backend
Check-File "main.py" "Backend FastAPI (main.py)"
Check-File "requirements.txt" "Dependencias Python"
Check-File "database.py" "Configuración BD"
Check-File "models.py" "Modelos de BD"

# Scripts
Check-File "RUN_ALL.bat" "Script de inicio automático"
Check-File "start_server.bat" "Script de servidor"

# Flutter
Check-File "microlearning_app\pubspec.yaml" "Configuración Flutter"
Check-File "microlearning_app\lib\main.dart" "App principal Flutter"
Check-File "microlearning_app\lib\screens\app_shell.dart" "Navegación central"

# Documentación
Check-File "README.md" "README principal"
Check-File "QUICK_START.md" "Guía rápida"
Check-File "SETUP.md" "Setup completo"
Check-File "RESUMEN_FINAL.md" "Resumen arquitectura"
Check-File "CHECKLIST.md" "Checklist features"
Check-File "PROJECT_STATUS.md" "Estado del proyecto"

Write-Host ""
Write-Host "🔧 CONFIGURACIÓN" -ForegroundColor Magenta
Write-Host "----------------" -ForegroundColor Magenta

# Verificar api_constants
$apiConstantsPath = "microlearning_app\lib\config\api_constants.dart"
if (Test-Path $apiConstantsPath) {
    $content = Get-Content $apiConstantsPath -Raw
    if ($content -match "localhost:8000") {
        Write-Host "✅ API apuntando a localhost:8000" -ForegroundColor Green
        $script:okCount++
    } else {
        Write-Host "⚠️  API no apunta a localhost:8000" -ForegroundColor Yellow
        $script:warningCount++
    }
}

# Verificar CORS en main.py
if (Test-Path "main.py") {
    $content = Get-Content "main.py" -Raw
    if ($content -match "CORSMiddleware") {
        Write-Host "✅ CORS middleware configurado" -ForegroundColor Green
        $script:okCount++
    } else {
        Write-Host "❌ CORS middleware NO encontrado" -ForegroundColor Red
        $script:errorCount++
    }
}

Write-Host ""
Write-Host "🌐 SERVICIOS EN LÍNEA (Opcional)" -ForegroundColor Magenta
Write-Host "------------------------------" -ForegroundColor Magenta

Check-Port 8000 "Backend (FastAPI)"
Check-Port 5000 "Frontend (Flutter web)"

Write-Host ""
Write-Host "📊 RESUMEN" -ForegroundColor Magenta
Write-Host "---------" -ForegroundColor Magenta
Write-Host "✅ OK:       $okCount" -ForegroundColor Green
Write-Host "⚠️  WARNINGS: $warningCount" -ForegroundColor Yellow
Write-Host "❌ ERRORES:   $errorCount" -ForegroundColor Red

Write-Host ""
if ($errorCount -eq 0) {
    Write-Host "🎉 TODO ESTÁ LISTO - PUEDES EJECUTAR RUN_ALL.bat" -ForegroundColor Green
    Write-Host ""
    Write-Host "Pasos:" -ForegroundColor Cyan
    Write-Host "1. Ejecuta: RUN_ALL.bat" -ForegroundColor Cyan
    Write-Host "2. Espera a que ambas ventanas muestren 'running on...'" -ForegroundColor Cyan
    Write-Host "3. Abre navegador: http://localhost:5000" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  REVISA LOS ERRORES ARRIBA ANTES DE EJECUTAR" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
