$ErrorActionPreference = "Continue"

$KitRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Src = Join-Path $KitRoot "origin-mcp-src"

Write-Host "Kit root: $KitRoot"
Write-Host "Source exists: $(Test-Path $Src)"
Write-Host ""
Write-Host "Python:"
python --version
python -c "import sys; print(sys.executable)"
Write-Host ""
Write-Host "origin_mcp import:"
python -c "import origin_mcp; print(origin_mcp.__file__)"
Write-Host ""
Write-Host "Origin likely install dirs:"
@('C:\Program Files\OriginLab','C:\Program Files (x86)\OriginLab') | ForEach-Object {
  if (Test-Path $_) { Get-ChildItem $_ -Recurse -Filter Origin*.exe -ErrorAction SilentlyContinue | Select-Object -First 10 -ExpandProperty FullName }
}
Write-Host ""
Write-Host "Origin Apps dir: $env:LOCALAPPDATA\OriginLab\Apps"
if (Test-Path "$env:LOCALAPPDATA\OriginLab\Apps") { Get-ChildItem "$env:LOCALAPPDATA\OriginLab\Apps" | Select-Object Name }
Write-Host ""
Write-Host "Hana MCP config: $env:USERPROFILE\.hanako\plugin-data\mcp\config.json"
Write-Host "Exists: $(Test-Path "$env:USERPROFILE\.hanako\plugin-data\mcp\config.json")"
