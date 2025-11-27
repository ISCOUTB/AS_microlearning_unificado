<#
pack_and_push_docker.ps1

Crea un contexto de build limpio (sin archivos 'basura'), construye una imagen Docker y la sube a Docker Hub.

Uso:
  .\pack_and_push_docker.ps1 -ImageName 'miusuario/microlearning-backend' -Tag 'v1'

Requisitos:
- Tener Docker Desktop instalado y `docker` en PATH.
- Ejecutar `docker login` antes de push (o el script te pedirá que lo hagas).

El script realiza:
- Crea carpeta temporal .release_build
- Copia solo los archivos necesarios para el backend (lista configurable)
- Copia el `Dockerfile`
- Crea `.dockerignore` para reducir tamaño
- Construye la imagen y hace push al registry: docker.io/<ImageName>:<Tag>
- Limpia la carpeta temporal

#>

param(
  [Parameter(Mandatory=$true)]
  [string]$ImageName,
  [string]$Tag = 'latest'
)

$repoRoot = Resolve-Path "./" | Select-Object -ExpandProperty Path
$workDir = Join-Path $repoRoot ".release_build"

Write-Host "Repo root: $repoRoot"
Write-Host "Working dir: $workDir"

if (Test-Path $workDir) {
  Write-Host "Removing previous working dir..."
  Remove-Item -Path $workDir -Recurse -Force
}

New-Item -Path $workDir -ItemType Directory | Out-Null

# Archivos y carpetas que queremos copiar al contexto de build
$itemsToCopy = @(
  'main.py',
  'requirements.txt',
  'database.py',
  'models.py',
  'schemas.py',
  'crud.py',
  'migrate_flashcards.py',
  'Dockerfile'
)

# Si tu backend está en un subfolder diferente, añádelo aquí. Ejemplo: 'backend/'
# También puede incluir carpetas como 'app' o 'src' según tu estructura.

foreach ($item in $itemsToCopy) {
  $src = Join-Path $repoRoot $item
  if (Test-Path $src) {
    Write-Host "Copying $item..."
    Copy-Item -Path $src -Destination $workDir -Recurse -Force
  } else {
    Write-Host "Warning: $item not found in repo root. Skipping."
  }
}

# Copiar carpeta del backend si existe (microlearning_app es frontend, evitar copiarlo)
# Si tu backend está en una carpeta llamada 'backend' o similar, añádelo manualmente arriba.

# Crear .dockerignore para evitar subir archivos innecesarios al contexto
$dockerignore = @(
  '.git',
  '.git\*',
  '.vscode',
  '.idea',
  'node_modules',
  '__pycache__',
  '*.pyc',
  'build',
  'dist',
  '*.log',
  '*.bak',
  '.release_build',
  'microlearning_app',
  'assets',
  'images',
  'test',
  '*.ps1'
) -join "`r`n"

Set-Content -Path (Join-Path $workDir '.dockerignore') -Value $dockerignore
Write-Host ".dockerignore created"

# Build image
$fullImageName = "$ImageName:$Tag"
Push-Location -Path $workDir
try {
  Write-Host "Building Docker image: $fullImageName"
  $build = docker build -t $fullImageName .
  if ($LASTEXITCODE -ne 0) {
    throw "Docker build failed"
  }

  # Check docker login
  Write-Host "Checking Docker login status..."
  $whoami = docker info --format '{{json .ClientInfo.Username}}' 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Please login to Docker Hub now (a new window may open). Running 'docker login'..."
    docker login
    if ($LASTEXITCODE -ne 0) { throw "Docker login failed" }
  }

  Write-Host "Pushing image to registry: $fullImageName"
  docker push $fullImageName
  if ($LASTEXITCODE -ne 0) { throw "Docker push failed" }

  Write-Host "Image pushed successfully: $fullImageName"
}
finally {
  Pop-Location
  Write-Host "Cleaning up working dir..."
  # Keep the build folder for inspection; comment the next line if you want to keep it
  Remove-Item -Path $workDir -Recurse -Force
}

Write-Host "Done. Next: deploy this image to Render or another provider."
Write-Host "Render: New -> Web Service -> 'Private Docker' -> docker.io/$ImageName:$Tag"

