# Script para probar endpoints del backend
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "PROBANDO ENDPOINTS DEL BACKEND" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Test 1: Verificar que el servidor esté corriendo
Write-Host "`n1. Verificando servidor..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/" -Method GET -ErrorAction Stop
    Write-Host "✅ Servidor corriendo correctamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: El servidor no está corriendo" -ForegroundColor Red
    Write-Host "Por favor inicia el servidor con: uvicorn main:app --reload" -ForegroundColor Yellow
    exit
}

# Test 2: Listar usuarios
Write-Host "`n2. Probando GET /usuarios..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/usuarios" -Method GET
    Write-Host "✅ Endpoint /usuarios funciona" -ForegroundColor Green
    Write-Host "Respuesta: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Error en /usuarios: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Listar videos
Write-Host "`n3. Probando GET /videos..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/videos" -Method GET
    Write-Host "✅ Endpoint /videos funciona" -ForegroundColor Green
} catch {
    Write-Host "❌ Error en /videos: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Listar conjuntos de flashcards (NUEVO)
Write-Host "`n4. Probando GET /conjuntos..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/conjuntos" -Method GET
    Write-Host "✅ Endpoint /conjuntos funciona" -ForegroundColor Green
    Write-Host "Respuesta: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Error en /conjuntos: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Crear un conjunto de flashcards (NUEVO)
Write-Host "`n5. Probando POST /conjuntos..." -ForegroundColor Yellow
$conjuntoData = @{
    titulo = "Conjunto de Prueba"
    descripcion = "Este es un conjunto de prueba"
    id_usuario = 1
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/conjuntos" -Method POST -Body $conjuntoData -ContentType "application/json"
    Write-Host "✅ Endpoint POST /conjuntos funciona" -ForegroundColor Green
    $conjuntoCreado = $response.Content | ConvertFrom-Json
    Write-Host "ID del conjunto creado: $($conjuntoCreado.id_conjunto)" -ForegroundColor Gray
    
    # Test 6: Crear una flashcard en el conjunto
    Write-Host "`n6. Probando POST /flashcards..." -ForegroundColor Yellow
    $flashcardData = @{
        titulo = "Flashcard de Prueba"
        contenido_frontal = "¿Qué es Flutter?"
        contenido_trasero = "Flutter es un framework de Google para crear apps móviles"
        es_imagen = $false
        id_conjunto = $conjuntoCreado.id_conjunto
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "http://localhost:8000/flashcards" -Method POST -Body $flashcardData -ContentType "application/json"
    Write-Host "✅ Endpoint POST /flashcards funciona" -ForegroundColor Green
    
    # Test 7: Obtener flashcards del conjunto (ruta corregida)
    Write-Host "`n7. Probando GET /conjuntos/{id_conjunto}/flashcards..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri "http://localhost:8000/conjuntos/$($conjuntoCreado.id_conjunto)/flashcards" -Method GET
    Write-Host "✅ Endpoint GET /conjuntos/{id}/flashcards funciona" -ForegroundColor Green
    Write-Host "Respuesta: $($response.Content)" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "TESTING COMPLETADO" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
