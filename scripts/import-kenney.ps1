[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$SourceDir,
  [Parameter(Mandatory=$true)][string]$PackName,
  [Parameter(Mandatory=$true)][string]$SourceUrl
)
$ErrorActionPreference='Stop'
if ($PackName -notmatch '^[a-zA-Z0-9][a-zA-Z0-9_-]*$') { throw 'PackName은 영문·숫자·-·_로 구성하세요.' }
if (-not (Test-Path -LiteralPath $SourceDir -PathType Container)) { throw "원본 폴더 없음: $SourceDir" }
if (-not $SourceUrl.StartsWith('https://kenney.nl/assets/')) { throw 'Kenney 에셋 페이지의 원본 URL을 입력하세요.' }
$root=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$dest=Join-Path $root "references\kenney\$PackName"
if (Test-Path $dest) { throw "팩 이름이 이미 존재합니다. 기존 원본을 덮어쓰지 않습니다: $dest" }
New-Item -Path $dest -ItemType Directory -Force | Out-Null
Get-ChildItem -LiteralPath $SourceDir -Force | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $dest -Recurse -Force }
$metaFolder=Join-Path $root 'references\kenney\_provenance'
New-Item -Path $metaFolder -ItemType Directory -Force | Out-Null
[pscustomobject]@{ pack=$PackName; url=$SourceUrl; imported_at=(Get-Date).ToString('o'); source_path=$SourceDir; license='CC0 (원본 팩 LICENSE 반드시 확인)' } |
  ConvertTo-Json | Set-Content -Path (Join-Path $metaFolder "$PackName.json") -Encoding UTF8
Write-Host "Kenney 원본 복사 완료: $dest" -ForegroundColor Green
