<#
PowerShell script to update the baseUrl in `api_constants.dart` and build release APK.
Usage:
  .\update_baseurl_and_build.ps1 -BaseUrl "https://my-backend.onrender.com"

This script:
- Makes a backup of `api_constants.dart`
- Replaces the baseUrl constant
- Runs flutter clean, pub get and flutter build apk --release
- Outputs path to new APK
#>

param(
  [Parameter(Mandatory=$true)]
  [string]$BaseUrl
)

$projRoot = Split-Path -Parent $PSScriptRoot
$apiFile = Join-Path $projRoot "lib\config\api_constants.dart"
if (-Not (Test-Path $apiFile)) {
  Write-Error "File not found: $apiFile"
  exit 1
}

# Backup
$backup = "$apiFile.bak"
Copy-Item -Path $apiFile -Destination $backup -Force
Write-Host "Backup created: $backup"

# Update baseUrl (simple regex replacement)
(Get-Content $apiFile -Raw) -replace "const\s+String\s+baseUrl\s*=\s*'[^']*'\s*;","const String baseUrl = '$BaseUrl';" | Set-Content $apiFile
Write-Host "Updated baseUrl in api_constants.dart to $BaseUrl"

# Build APK
Push-Location -Path (Join-Path $projRoot "..") # go to microlearning_app parent (if script is inside microlearning_app)
# Ensure we are at microlearning_app folder
$flutterFolder = (Resolve-Path "$(Get-Location)")
Write-Host "Running flutter build from: $flutterFolder"

# Run flutter commands
flutter clean
flutter pub get
flutter build apk --release

$apkPath = Join-Path $projRoot "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
  Write-Host "APK generated: $apkPath"
} else {
  Write-Error "APK not found at expected path: $apkPath"
}

Pop-Location
