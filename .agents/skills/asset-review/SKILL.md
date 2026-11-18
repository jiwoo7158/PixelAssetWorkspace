---
name: asset-review
description: Inspect 2D pixel asset outputs for dimensions, alpha, palette count, frames and licenses; report issues without silently altering source files.
---

# 에셋 QA 및 출처 검수

1. 대상은 `outputs/` 결과물 또는 사용자가 지정한 이미지/시트로 한정한다.
2. `scripts/inspect-image.py`로 크기, 모드, 투명도, 팔레트 색 개수를 확인한다.
3. 스프라이트 시트는 JSON 프레임 좌표, 루프 정보, 프레임 크기/재생 속도를 기존 도구 규격에 따라 검사한다.
4. pixelfx 결과라면 해당 이펙트의 `node tools/check.mjs <id>` 및 컨택트 시트 확인을 포함한다.
5. 입력 출처(Kenney 팩/자체 제작), 오픈소스 LICENSE·NOTICE, 변경 기록 확인.
6. 실패 항목과 조치 방안을 한국어로 보고한다. `references/` 원본은 **절대 자동 수정하지 않는다**.
