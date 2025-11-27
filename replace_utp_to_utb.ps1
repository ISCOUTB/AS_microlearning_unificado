<#
PowerShell script: replace 'UTP' with 'UTB' across common files, creating backups (.bak).
Run from repository root.
Usage: .\replace_utp_to_utb.ps1 -ConfirmReplace

The script first previews matches. If -ConfirmReplace is provided, it executes replacements.
#>

param(
  [switch]$ConfirmReplace
)

$patterns = @('*.dart','*.md','*.yaml','*.yml','*.txt')
$matches = @()

Write-Host "Scanning repository for 'UTP' occurrences..."
foreach ($p in $patterns) {
  $files = Get-ChildItem -Path . -Recurse -Include $p -File -ErrorAction SilentlyContinue
  foreach ($f in $files) {
    $lines = Select-String -Path $f.FullName -Pattern '\bUTP\b' -SimpleMatch -ErrorAction SilentlyContinue
    if ($lines) {
      foreach ($l in $lines) {
        $matches += [PSCustomObject]@{File=$f.FullName; LineNumber=$l.LineNumber; Line=$l.Line}
      }
    }
  }
}

if ($matches.Count -eq 0) {
  Write-Host "No exact 'UTP' occurrences found (word-boundary)."
  exit 0
}

Write-Host "Found occurrences (preview):"
$matches | Format-Table -AutoSize

if (-not $ConfirmReplace) {
  Write-Host "\nTo actually perform the replacements run the script with -ConfirmReplace parameter. Example:\n  .\\replace_utp_to_utb.ps1 -ConfirmReplace\n"
  exit 0
}

# Perform replacements with backup
foreach ($p in $patterns) {
  $files = Get-ChildItem -Path . -Recurse -Include $p -File -ErrorAction SilentlyContinue
  foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match '\bUTP\b') {
      Copy-Item -Path $f.FullName -Destination "$($f.FullName).bak" -Force
      $new = $content -replace '\bUTP\b','UTB'
      Set-Content -Path $f.FullName -Value $new
      Write-Host "Replaced in: $($f.FullName) (backup: $($f.FullName).bak)"
    }
  }
}

Write-Host "Replacement completed. Review backups (*.bak) if you need to revert."
