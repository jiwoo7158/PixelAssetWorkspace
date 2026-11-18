# 오픈소스 설치 위치

ZIP에는 오픈소스 전체 코드를 미리 담지 않았습니다. Windows에서 `scripts/setup-windows.ps1` 실행 시 아래 폴더에 원본 저장소를 **공식 GitHub에서** 내려받습니다.

- `sprite-gen/` (Apache-2.0)
- `pixelfx/` (MIT)
- `spritefusion-pixel-snapper/` (MIT)

`tools/*`는 **업스트림 체크아웃**이므로 직접 수정하지 않고 `recipes/` 아래에 제작 코드를 저장하세요. 설치 후 실제 SHA는 `licenses/sources-installed.json`을 확인합니다.
