# 오픈소스 설치 위치

ZIP에는 오픈소스 전체 코드를 미리 담지 않았습니다. Windows에서 `scripts/setup-windows.ps1` 실행 시 아래 폴더에 원본 저장소를 **공식 GitHub에서** 내려받습니다.

- `sprite-gen/` (Apache-2.0)
- `pixelfx/` (MIT)
- `spritefusion-pixel-snapper/` (MIT)

`tools/*`는 **업스트림 체크아웃**이므로 직접 수정하지 않고 `recipes/` 아래에 제작 코드를 저장하세요. 설치 후 실제 SHA는 `licenses/sources-installed.json`을 확인합니다.

## v2: 전체 목록 및 고정 버전

`tools/UPSTREAMS.json`에 기본 3개(sprite-gen, pixelfx, spritefusion-pixel-snapper)와 선택 후보 5개(agent-sprite-forge, codixel, pixelbolt, 2dimg2motion, pixeloe)를 등록했다. 기본 재설치는 지정 커밋 8개를 복제하고, 설치 스크립트에서 무거운 의존성은 필요할 때만 설치한다. 소스만 있는 도구와 실행 가능한 도구를 구분한다. `scripts/tool-status.ps1`로 확인한다.
