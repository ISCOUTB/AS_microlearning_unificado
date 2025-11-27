# Script para verificar dependencias
Set-Location -Path "c:\AS_microlearning_unificado-master\microlearning_app"
Write-Host "Verificando dependencias de Flutter..." -ForegroundColor Green
flutter pub get
Write-Host "`nDependencias instaladas!" -ForegroundColor Green
Write-Host "`nVerificando errores..." -ForegroundColor Yellow
flutter analyze
