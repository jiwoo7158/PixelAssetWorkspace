#requires -Version 5.1
# UTF-8 with BOM for Windows PowerShell 5.1 Korean output.
[CmdletBinding()]
param(
    [switch]$CoreOnly,
    [switch]$SkipPythonInstall,
    [switch]$InstallForgeDependencies,
    [switch]$InstallPixelOE,
    [switch]$UseLatest
)
$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
$env:PYTHONIOENCODING = 'utf-8'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$toolsDir = Join-Path $root 'tools'
$licenseDir = Join-Path $root 'licenses\third-party'
$registryFile = Join-Path $toolsDir 'UPSTREAMS.json'
if (-not (Test-Path -LiteralPath $registryFile)) { throw 'tools/UPSTREAMS.json 파일이 없습니다.' }
$registry = Get-Content -LiteralPath $registryFile -Raw -Encoding UTF8 | ConvertFrom-Json
if ($registry.schema -ne 'pixelasset/upstreams-v2') { throw 'UPSTREAMS.json 스키마가 지원되지 않습니다.' }
if (($InstallPixelOE -or $InstallForgeDependencies) -and $SkipPythonInstall) {
    throw '-InstallPixelOE / -InstallForgeDependencies는 -SkipPythonInstall과 함께 사용할 수 없습니다.'
}
if ($CoreOnly -and ($InstallPixelOE -or $InstallForgeDependencies)) {
    throw '-CoreOnly에서는 추가 도구의 Python 의존성을 설치할 수 없습니다.'
}
function Need([string]$name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "$name 명령어가 없습니다. README.md 설치 안내를 확인하세요."
    }
}
function Native([string]$label,[scriptblock]$command) {
    & $command
    if ($LASTEXITCODE -ne 0) { throw "$label 실행 실패 (exit=$LASTEXITCODE)" }
}
function PythonLauncher {
    if (Get-Command py -ErrorAction SilentlyContinue) {
        foreach ($v in @('3.12','3.11','3.13')) {
            try {
                & py "-$v" -c 'import sys; print(sys.version_info[:2])' 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) { return @('py',"-$v") }
            } catch { continue }
        }
    }
    if (Get-Command python -ErrorAction SilentlyContinue) {
        try {
            & python -c 'import sys; assert (3,11)<=sys.version_info[:2]<=(3,13)' 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) { return @('python') }
        } catch { }
    }
    throw 'Python 3.11~3.13을 찾지 못했습니다. Python 설치 또는 PATH 설정을 확인하세요.'
}
function EnsureVenv([string]$name, [object[]]$launcher) {
    $envPath = Join-Path $root $name
    $exe = Join-Path $envPath 'Scripts\python.exe'
    if (-not (Test-Path -LiteralPath $exe)) {
        Write-Host "[가상환경 생성] $name" -ForegroundColor Cyan
        if ($launcher.Count -eq 2) { & $launcher[0] $launcher[1] -m venv $envPath }
        else { & $launcher[0] -m venv $envPath }
        if ($LASTEXITCODE -ne 0) { throw "가상환경 생성 실패: $name" }
    }
    return $exe
}
Need 'git'
Need 'node'
$nodeV = (& node --version).Trim().TrimStart('v')
if ([int]($nodeV.Split('.')[0]) -lt 20) { throw 'Node.js 20 이상이 필요합니다 (Pixelbolt 요구 조건).' }
New-Item -Path $toolsDir -ItemType Directory -Force | Out-Null
New-Item -Path $licenseDir -ItemType Directory -Force | Out-Null
# Git tracks files, not empty folders. Recreate runtime directories on a fresh clone.
foreach ($relative in @('references\kenney','references\custom','outputs\sprites','outputs\animations','outputs\vfx','runs')) {
    New-Item -Path (Join-Path $root $relative) -ItemType Directory -Force | Out-Null
}
$all = @($registry.repositories)
$wanted = @($all | Where-Object { (-not $CoreOnly) -or $_.tier -eq 'core' })
foreach ($item in $wanted) {
    $name = [string]$item.name
    $url = [string]$item.url
    $revision = [string]$item.revision
    if ($name -notmatch '^[a-z0-9][a-z0-9_-]*$' -or $url -notmatch '^https://github\.com/[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+\.git$' -or $revision -notmatch '^[0-9a-f]{40}$') {
        throw "도구 설정 값이 올바르지 않습니다: $name"
    }
    $path = Join-Path $toolsDir $name
    if (Test-Path -LiteralPath $path) {
        if (-not (Test-Path -LiteralPath (Join-Path $path '.git'))) { throw "기존 폴더가 Git 체크아웃이 아닙니다: $path" }
        $origin = (& git -C $path remote get-url origin).Trim()
        if ($LASTEXITCODE -ne 0 -or $origin -ne $url) { throw "기존 Git 저장소의 origin이 다릅니다: $name ($origin). 수동 확인이 필요합니다." }
        Write-Host "[보존] $name (기존 설치는 임의로 갱신하지 않음)" -ForegroundColor DarkCyan
        continue
    }
    $temporary = Join-Path $toolsDir ('.installing-' + $name)
    if (Test-Path -LiteralPath $temporary) {
        throw "이전 설치의 임시 폴더가 남아 있습니다. 확인 후 수동 처리하세요: $temporary"
    }
    Write-Host "[다운로드] $name" -ForegroundColor Cyan
    New-Item -Path $temporary -ItemType Directory | Out-Null
    try {
        & git -C $temporary init -q
        if ($LASTEXITCODE -ne 0) { throw "git init 실패: $name" }
        & git -C $temporary remote add origin $url
        if ($LASTEXITCODE -ne 0) { throw "git remote 실패: $name" }
        if ($UseLatest) {
            & git -C $temporary fetch -q --no-tags --depth 1 origin HEAD
        } else {
            & git -C $temporary fetch -q --no-tags --depth 1 origin $revision
        }
        if ($LASTEXITCODE -ne 0) { throw "git fetch 실패: $name. 고정 커밋을 받을 수 없으면 -UseLatest로 새 설치를 시험해 보세요." }
        & git -C $temporary checkout -q --detach FETCH_HEAD
        if ($LASTEXITCODE -ne 0) { throw "git checkout 실패: $name" }
        Move-Item -LiteralPath $temporary -Destination $path
    } catch {
        if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary -Recurse -Force }
        throw
    }
}
# Every installed source must retain its license and exact commit SHA in a local manifest.
$records = @()
foreach ($item in $all) {
    $name = [string]$item.name
    $path = Join-Path $toolsDir $name
    if (-not (Test-Path -LiteralPath $path)) { continue }
    if (-not (Test-Path -LiteralPath (Join-Path $path '.git'))) { throw "도구가 Git 저장소가 아닙니다: $name" }
    $origin = (& git -C $path remote get-url origin).Trim()
    if ($LASTEXITCODE -ne 0 -or $origin -ne [string]$item.url) { throw "도구의 origin이 예상과 다릅니다: $name ($origin)" }
    $sha = (& git -C $path rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw "커밋 확인 실패: $name" }
    $license = Join-Path $path 'LICENSE'
    if (-not (Test-Path -LiteralPath $license)) { throw "$name 저장소에 LICENSE가 없습니다. 자동 설치를 중지합니다." }
    Copy-Item -LiteralPath $license -Destination (Join-Path $licenseDir ($name+'.LICENSE.txt')) -Force
    foreach ($notice in @('NOTICE','NOTICE.md','NOTICE.txt')) {
        $n = Join-Path $path $notice
        if (Test-Path -LiteralPath $n) { Copy-Item -LiteralPath $n -Destination (Join-Path $licenseDir ($name+'.'+$notice+'.txt')) -Force }
    }
    $records += [pscustomobject]@{
        name=$name; repository=[string]$item.url; pinned_commit=[string]$item.revision;
        installed_commit=$sha; license=[string]$item.license;
        pinned_version=($sha -eq [string]$item.revision)
    }
}
$recordPath = Join-Path $root 'licenses\sources-installed.json'
ConvertTo-Json -InputObject @($records) -Depth 7 | Set-Content -LiteralPath $recordPath -Encoding UTF8
Write-Host "[출처·라이선스 기록] $recordPath" -ForegroundColor Green
if (-not $SkipPythonInstall) {
    $launcher = @(PythonLauncher)
    $python = EnsureVenv '.venv' $launcher
    $sprite = Join-Path $toolsDir 'sprite-gen'
    Write-Host '[Python 설치] sprite-gen (.venv 전용)' -ForegroundColor Cyan
    & $python -m pip install --disable-pip-version-check -e $sprite
    if ($LASTEXITCODE -ne 0) { throw 'sprite-gen 설치 실패' }
    if ($InstallForgeDependencies) {
        $req = Join-Path $toolsDir 'agent-sprite-forge\requirements.txt'
        if (-not (Test-Path -LiteralPath $req)) { throw 'Agent Sprite Forge requirements.txt가 없습니다.' }
        Write-Host '[선택 설치] Agent Sprite Forge 의존성' -ForegroundColor Cyan
        & $python -m pip install --disable-pip-version-check -r $req
        if ($LASTEXITCODE -ne 0) { throw 'Agent Sprite Forge 의존성 설치 실패' }
    }
    if ($InstallPixelOE) {
        $py2 = EnsureVenv '.venv-pixeloe' $launcher
        Write-Host '[선택 설치] PixelOE(PyTorch 포함, 다운로드 용량 큼)' -ForegroundColor Yellow
        & $py2 -m pip install --disable-pip-version-check -e (Join-Path $toolsDir 'pixeloe')
        if ($LASTEXITCODE -ne 0) { throw 'PixelOE 설치 실패' }
    }
}
Write-Host '[설정 완료] 다음 명령어를 실행하세요: .\scripts\health-check.ps1' -ForegroundColor Green
Write-Host '추가 도구 사용 상태: .\scripts\tool-status.ps1' -ForegroundColor Cyan
