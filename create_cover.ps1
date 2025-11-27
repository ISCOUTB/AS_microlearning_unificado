<#
create_cover.ps1
Genera una imagen PNG 1024x1024 con fondo UTB azul (#0A45C2) y texto "Microlearning UTB" centrado.
Requisitos: PowerShell en Windows (System.Drawing está disponible).
Uso:
  .\create_cover.ps1 -OutputPath .\microlearning_cover.png
#>
param(
  [string]$OutputPath = ".\microlearning_cover.png",
  [int]$Size = 1024
)

Add-Type -AssemblyName System.Drawing

$bmp = New-Object System.Drawing.Bitmap $Size, $Size
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::FromArgb(0x0A,0x45,0xC2))

# Texto
$text = "Microlearning"
$text2 = "UTB"

# Fuente
$fontName = 'Segoe UI'
$font = New-Object System.Drawing.Font $fontName, 72, [System.Drawing.FontStyle]::Bold
$font2 = New-Object System.Drawing.Font $fontName, 120, [System.Drawing.FontStyle]::Bold

# Medir texto
$brush = [System.Drawing.Brushes]::White
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center

# Dibujar Microlearning arriba y UTB grande abajo
$rectTop = New-Object System.Drawing.RectangleF(0, $Size*0.22, $Size, $Size*0.3)
$rectBottom = New-Object System.Drawing.RectangleF(0, $Size*0.5, $Size, $Size*0.45)

$g.DrawString($text, $font, $brush, $rectTop, $sf)
$g.DrawString($text2, $font2, $brush, $rectBottom, $sf)

# Opcional: pequeño subtítulo
$font3 = New-Object System.Drawing.Font $fontName, 18, [System.Drawing.FontStyle]::Regular
$rectSub = New-Object System.Drawing.RectangleF(0, $Size*0.88, $Size, $Size*0.12)
$g.DrawString("Universidad Tecnológica de Bogotá", $font3, $brush, $rectSub, $sf)

# Guardar
$bmp.Save((Resolve-Path $OutputPath).ProviderPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Write-Host "Imagen creada en:" (Resolve-Path $OutputPath)
