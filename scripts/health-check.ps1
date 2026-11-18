#requires -Version 5.1
[CmdletBinding()]
param([switch]$SkipVfxRender)
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
$env:PYTHONIOENCODING = 'utf-8'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
foreach($cmd in @('git','node')) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "$cmd 명령어가 없습니다." }
}
Write-Host ('Git: ' + (& git --version))
Write-Host ('Node: ' + (& node --version))
$nodeMajor=[int]((& node --version).Trim().TrimStart('v').Split('.')[0])
if ($nodeMajor -lt 20) { throw 'Node.js 20 이상이 필요합니다.' }
$statusJson = & (Join-Path $PSScriptRoot 'tool-status.ps1') -AsJson
if ($LASTEXITCODE -ne 0) { throw 'tool-status.ps1 진단 실패' }
$status = @($statusJson | ConvertFrom-Json)
$core = @('sprite-gen','pixelfx','spritefusion-pixel-snapper')
foreach($name in $core) {
    $entry=$status | Where-Object { $_.name -eq $name } | Select-Object -First 1
    if (-not $entry -or -not $entry.source_installed) { throw "기본 소스 누락: $name. setup-windows.ps1을 실행하세요." }
    Write-Host "[소스 확인] $name" -ForegroundColor Green
}
$cli = Join-Path $root '.venv\Scripts\sprite-gen.exe'
if (-not (Test-Path -LiteralPath $cli)) { throw 'sprite-gen CLI가 없습니다. setup-windows.ps1을 확인하세요.' }
# 먼저 전체 도움말을 수신하고 종료 코드를 확인합니다.
# Select-Object -First N을 네이티브 명령에 직접 연결하면 stdout 파이프가
# 조기에 닫혀 Python CLI가 BrokenPipeError로 종료할 수 있습니다.
$helpText = & $cli --help
if ($LASTEXITCODE -ne 0) { throw 'sprite-gen --help 실패' }
$helpText | Select-Object -First 5
$bolt=Join-Path $root 'tools\pixelbolt\bin\pixelbolt.js'
if (Test-Path -LiteralPath $bolt) {
    $boltHelp = & node $bolt --help
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Pixelbolt CLI 실행 점검 실패' }
    else { $boltHelp | Select-Object -First 5 }
}
if (-not $SkipVfxRender) {
    & (Join-Path $PSScriptRoot 'render-vfx.ps1') -Effect 'fire/torch'
    if (-not $?) { throw 'pixelfx 렌더링 실패' }
}
Write-Host '[기본 설치 및 실행 검사 완료]' -ForegroundColor Green
& (Join-Path $PSScriptRoot 'tool-status.ps1')
