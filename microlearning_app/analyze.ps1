# Script para analizar errores de Flutter
Write-Host "Analizando código Flutter..." -ForegroundColor Green
Set-Location -Path "c:\AS_microlearning_unificado-master\microlearning_app"
flutter analyze
Write-Host "Análisis completado!" -ForegroundColor Green
