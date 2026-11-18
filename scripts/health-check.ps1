[CmdletBinding()]
param([switch]$SkipVfxRender)
$ErrorActionPreference='Stop'
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
foreach($cmd in @('git','node')) { if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "$cmd 가 설치되어 있지 않습니다." } }
Write-Host ('Git: ' + (& git --version))
Write-Host ('Node: ' + (& node --version))
foreach($n in @('sprite-gen','pixelfx','spritefusion-pixel-snapper')) {
    if (-not (Test-Path (Join-Path $root "tools\$n\.git"))) { throw "오픈소스가 설치되지 않았습니다: $n. setup-windows.ps1을 실행하세요." }
    Write-Host "소스: $n OK" -ForegroundColor Green
}
$cli=Join-Path $root '.venv\Scripts\sprite-gen.exe'
if (-not (Test-Path $cli)) { throw 'sprite-gen 실행 파일이 없습니다. setup-windows.ps1을 확인하세요.' }
$helpText = & $cli --help
if ($LASTEXITCODE -ne 0) { throw 'sprite-gen --help 실행 실패' }
$helpText | Select-Object -First 12
if (-not $SkipVfxRender) {
    & (Join-Path $PSScriptRoot 'render-vfx.ps1') -Effect 'fire/torch'
    if ($LASTEXITCODE -ne 0) { throw 'pixelfx 렌더링 실패' }
}
Write-Host '기본 설치 확인 통과' -ForegroundColor Green
