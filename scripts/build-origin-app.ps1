$ErrorActionPreference = "Stop"

$KitRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Src = Join-Path $KitRoot "origin-mcp-src"

Write-Host "Rebuilding Origin App from: $Src"
python (Join-Path $Src "scripts\build_origin_app.py") --force --install
Write-Host "Done. If Origin was running Bridge, click Stop first and rerun this script."
