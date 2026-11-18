#requires -Version 5.1
[CmdletBinding()]
param([switch]$AsJson)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$registry = Get-Content -LiteralPath (Join-Path $root 'tools\UPSTREAMS.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$nodeAvailable = [bool](Get-Command node -ErrorAction SilentlyContinue)
$nodeReady = $false
if ($nodeAvailable) {
    try { $nodeReady = ([int]((& node --version).Trim().TrimStart('v').Split('.')[0]) -ge 20) } catch { }
}
$python = Join-Path $root '.venv\Scripts\python.exe'
$checks = @()
foreach ($tool in @($registry.repositories)) {
    $dir = Join-Path (Join-Path $root 'tools') ([string]$tool.name)
    $source = Test-Path -LiteralPath (Join-Path $dir '.git')
    $cli = $false
    $reason = ''
    if (-not $source) { $reason = '소스 코드 미설치' }
    else {
        switch ([string]$tool.name) {
            'sprite-gen' { $cli = Test-Path (Join-Path $root '.venv\Scripts\sprite-gen.exe'); $reason='Python 가상환경 설치 필요' }
            'pixelfx' { $cli = $nodeReady -and (Test-Path (Join-Path $dir 'tools\render.mjs')); $reason='Node.js 20+ 필요' }
            'spritefusion-pixel-snapper' {
                $cli = [bool](Get-Command spritefusion-pixel-snapper -ErrorAction SilentlyContinue) -or (Test-Path (Join-Path $dir 'target\release\spritefusion-pixel-snapper.exe'))
                $reason='소스만 설치됨; Rust/Cargo 또는 별도 CLI 설치 필요'
            }
            'pixelbolt' { $cli=$nodeReady -and (Test-Path (Join-Path $dir 'bin\pixelbolt.js')); $reason='Node.js 20+ 필요' }
            'codixel' { $cli=$nodeReady -and (Test-Path (Join-Path $dir 'core\pixel.js')); $reason='Node.js와 core/pixel.js 필요' }
            'agent-sprite-forge' { $cli=(Test-Path $python) -and (Test-Path (Join-Path $dir 'skills\generate2dsprite\SKILL.md')); $reason='일부 생성 기능은 이미지/영상 모델과 추가 Python 패키지 필요' }
            '2dimg2motion' { $cli=(Test-Path (Join-Path $dir 'SKILL.md')) -and (Test-Path $python); $reason='전체 애니메이션 제작에는 Codex image_gen 접근 필요' }
            'pixeloe' { $cli=Test-Path (Join-Path $root '.venv-pixeloe\Scripts\pixeloe.pixelize.exe'); $reason='-InstallPixelOE 별도 설치 필요' }
        }
    }
    $checks += [pscustomobject]@{
        name=[string]$tool.name; source_installed=[bool]$source; local_runtime_ready=[bool]$cli;
        requires_external_generation=@($tool.requires_external_generation_for).Count -gt 0;
        note=if($cli){'로컬 실행 조건 확인됨. 외부 모델 접근성·개별 생성 품질은 별개.'}else{$reason}
    }
}
if ($AsJson) { ConvertTo-Json -InputObject @($checks) -Depth 5 }
else {
    Write-Host 'PixelAssetWorkspace 설치 상태 (소스 설치 / 로컬 실행 가능성 분리)' -ForegroundColor Cyan
    $checks | Format-Table name,source_installed,local_runtime_ready,requires_external_generation -AutoSize
    Write-Host '참고: true라고 해도 유료 API/외부 이미지 모델을 자동 사용할 수 있다는 뜻은 아닙니다.'
}
