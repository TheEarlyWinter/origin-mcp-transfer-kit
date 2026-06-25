$ErrorActionPreference = "Stop"

$KitRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Src = Join-Path $KitRoot "origin-mcp-src"

Write-Host "[1/4] Kit root: $KitRoot"
Write-Host "[2/4] Python:"
python --version
$PythonExe = python -c "import sys; print(sys.executable)"
Write-Host "      $PythonExe"

Write-Host "[3/4] Installing editable origin-mcp..."
python -m pip install -e $Src
python -c "import origin_mcp; print('origin-mcp import OK:', origin_mcp.__file__)"

Write-Host "[4/4] Building and copying Origin App Start/Stop..."
python (Join-Path $Src "scripts\build_origin_app.py") --force --install

Write-Host ""
Write-Host "Done. Next steps:"
Write-Host "1. Configure Hana MCP using hana-config-example\origin-mcp-connector.example.json"
Write-Host "2. Restart HanaAgent"
Write-Host "3. Open Origin; if Apps Gallery lacks Start/Stop, run mkOPX commands from origin-mcp-src\build\origin-app\mkopx-command.txt and drag OPX into Origin"
Write-Host "4. Click Origin MCP Bridge Start before asking AI to control Origin"
