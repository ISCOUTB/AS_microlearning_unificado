# Script para instalar dependencias de Flutter
Write-Host "Instalando dependencias de Flutter..." -ForegroundColor Green
Set-Location -Path "c:\AS_microlearning_unificado-master\microlearning_app"
flutter pub get
Write-Host "Dependencias instaladas!" -ForegroundColor Green
