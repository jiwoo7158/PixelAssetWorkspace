# PowerShell 5.1+ / Windows
[CmdletBinding()]
param([switch]$SkipPythonInstall)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$toolsDir = Join-Path $root 'tools'
New-Item -Path $toolsDir -ItemType Directory -Force | Out-Null

function Require-Command([string]$name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "$name 실행 파일을 찾을 수 없습니다. README.md의 준비 프로그램 항목을 확인하세요."
    }
}
Require-Command 'git'
Require-Command 'node'
$nodeVersion = (& node --version).Trim().TrimStart('v')
$major = [int](($nodeVersion -split '\.')[0])
if ($major -lt 18) { throw 'Node.js 18 이상이 필요합니다.' }

$repos = @(
  @{ name='sprite-gen'; url='https://github.com/aldegad/sprite-gen.git'; license='Apache-2.0' },
  @{ name='pixelfx'; url='https://github.com/patch-gg/pixelfx.git'; license='MIT' },
  @{ name='spritefusion-pixel-snapper'; url='https://github.com/Hugo-Dz/spritefusion-pixel-snapper.git'; license='MIT' }
)

$records = @()
$licenses = Join-Path $root 'licenses\third-party'
New-Item -Path $licenses -ItemType Directory -Force | Out-Null
foreach ($repo in $repos) {
    $path = Join-Path $toolsDir $repo.name
    if (Test-Path (Join-Path $path '.git')) {
        Write-Host "[기존 코드 사용] $($repo.name)" -ForegroundColor Cyan
    } elseif (Test-Path $path) {
        throw "기존 폴더가 있지만 Git 체크아웃이 아닙니다: $path. 임의로 덮어쓰지 않습니다."
    } else {
        Write-Host "[GitHub 다운로드] $($repo.name)" -ForegroundColor Cyan
        & git clone --depth 1 -- $repo.url $path
        if ($LASTEXITCODE -ne 0) { throw "git clone 실패: $($repo.name)" }
    }
    $sha = (& git -C $path rev-parse HEAD).Trim()
    if ($LASTEXITCODE -ne 0) { throw "커밋 확인 실패: $path" }
    $srcLicense = Join-Path $path 'LICENSE'
    if (-not (Test-Path $srcLicense)) { throw "$($repo.name) 저장소의 LICENSE 파일을 찾을 수 없습니다. 수동 검토 필요." }
    Copy-Item -LiteralPath $srcLicense -Destination (Join-Path $licenses "$($repo.name).LICENSE.txt") -Force
    foreach ($notice in @('NOTICE','NOTICE.md')) {
        $srcNotice = Join-Path $path $notice
        if (Test-Path $srcNotice) {
            Copy-Item -LiteralPath $srcNotice -Destination (Join-Path $licenses "$($repo.name).$notice.txt") -Force
        }
    }
    $records += [pscustomobject]@{ repository=$repo.url; name=$repo.name; commit=$sha; license=$repo.license }
}

$licFile = Join-Path $root 'licenses\sources-installed.json'
$records | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 -Path $licFile
Write-Host "[라이선스 및 커밋 기록 완료] $licFile" -ForegroundColor Green

if (-not $SkipPythonInstall) {
    $launcher = $null
    $launcherArgs = @()
    if (Get-Command py -ErrorAction SilentlyContinue) {
        foreach ($v in @('3.14','3.13','3.12','3.11')) {
            try {
                & py "-$v" -c 'import sys' 2>$null
                if ($LASTEXITCODE -eq 0) { $launcher='py'; $launcherArgs=@("-$v"); break }
            } catch { continue }
        }
    }
    if (-not $launcher -and (Get-Command python -ErrorAction SilentlyContinue)) {
        try {
            & python -c 'import sys; assert sys.version_info >= (3,11)' 2>$null
            if ($LASTEXITCODE -eq 0) { $launcher='python' }
        } catch { }
    }
    if (-not $launcher) { throw 'Python 3.11 이상을 찾지 못했습니다.' }
    $venvPath = Join-Path $root '.venv'
    $venvPython = Join-Path $venvPath 'Scripts\python.exe'
    if (-not (Test-Path $venvPython)) {
        Write-Host '[Python 가상환경 생성]' -ForegroundColor Cyan
        & $launcher @launcherArgs -m venv $venvPath
        if ($LASTEXITCODE -ne 0) { throw '가상환경 생성 실패' }
    }
    Write-Host '[sprite-gen 설치]' -ForegroundColor Cyan
    & $venvPython -m pip install --disable-pip-version-check -e (Join-Path $toolsDir 'sprite-gen')
    if ($LASTEXITCODE -ne 0) { throw 'sprite-gen Python 패키지 설치 실패' }
}
Write-Host '설정 완료! 다음: .\scripts\health-check.ps1' -ForegroundColor Green
