[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$Effect
)
$ErrorActionPreference='Stop'
if ($Effect -notmatch '^[a-z0-9][a-z0-9_-]*(/[a-z0-9][a-z0-9_-]*)+$') {
    throw "이펙트 ID 형식이 올바르지 않습니다: $Effect (예: ice/frost-nova)"
}
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$repo=Join-Path $root 'tools\pixelfx'
if (-not (Test-Path (Join-Path $repo 'tools\render.mjs'))) {
    throw 'pixelfx가 설치되지 않았습니다. .\scripts\setup-windows.ps1을 먼저 실행하세요.'
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw 'Node.js가 필요합니다.' }
Push-Location $repo
try {
    & node 'tools/render.mjs' $Effect '--sheet'
    if ($LASTEXITCODE -ne 0) { throw "pixelfx 렌더 실패: $Effect" }
    $source=Join-Path $repo ('records\' + ($Effect -replace '/','\'))
    if (-not (Test-Path $source)) { throw "예상 출력 폴더가 없습니다: $source" }
    $target=Join-Path $root ('outputs\vfx\' + ($Effect -replace '/','\'))
    New-Item -Path $target -ItemType Directory -Force | Out-Null
    $files=Get-ChildItem -LiteralPath $source -File | Where-Object { $_.Extension -in @('.png','.json','.gif','.webp','.mp4') }
    if (-not $files -or $files.Count -eq 0) { throw '렌더 결과 파일을 찾지 못했습니다.' }
    foreach($f in $files) { Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $target $f.Name) -Force }
    $sha=(& git -C $repo rev-parse HEAD).Trim()
    [pscustomobject]@{
        effect=$Effect; upstream='https://github.com/patch-gg/pixelfx'; commit=$sha;
        source_record=$source; exported_to=$target;
        generated_at=(Get-Date).ToString('o'); license='MIT';
        note='오픈소스 pixelfx 렌더. 폰트 리소스는 별도 라이선스.'
    } | ConvertTo-Json -Depth 3 | Set-Content -Path (Join-Path $target '_provenance.json') -Encoding UTF8
    Write-Host "VFX 출력 완료: $target" -ForegroundColor Green
} finally { Pop-Location }
