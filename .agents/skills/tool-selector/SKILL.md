---
name: tool-selector
description: Choose exactly the relevant installed open-source tool for a 2D pixel game asset request; supports user-selected, automatic and approval-first modes, with license and runtime checks.
---

# 도구 선택 스킬

1. 사용자 요청을 `static_sprite`, `reference_to_sprite`, `existing_character_animation`, `model_generated_animation`, `sprite_sheet_processing`, `skill_vfx`, `map_or_tileset`, `high_resolution_image_pixelization`, `irregular_pixel_grid_fix`, `palette_reduction` 중 하나로 분류한다.
2. 루트의 `AGENTS.md`, `config/tool-routing.json`, `tools/UPSTREAMS.json`을 읽는다. 사용자가 도구를 지정했다면 **무조건 수동 지정 우선**이다.
3. `scripts/tool-status.ps1`의 소스 설치 상태와 로컬 실행 가능성을 확인한다. 소스만 존재하는 것과 모델/CLI 사용 가능은 별개다.
4. 자동 모드라면 지원 기능과 출력 요구를 고려해 하나의 **주 제작 도구**를 결정하고 선택 이유를 짧게 기록한다. 후처리는 필요한 경우에만 추가한다.
5. 이미지·영상 모델 호출, 외부 전송, 유료 API는 승인 없이 수행하지 않는다. Provider가 없는 경우 결과를 날조하지 말고 코드 기반 대안과 한계를 설명한다.
6. 해당 도구의 README/SKILL.md와 `--help`를 읽고 실제 도구 버전에 맞는 명령을 사용한다. 업스트림 수정 금지.
7. 결과물과 재현 레시피, 도구 버전(SHA)을 기록하고 한국어로 요약한다.

사용자 직접 지정 예: `Pixelbolt만 사용해 32x32 슬라임을 만들어줘.`
자동 선택 예: `고해상도 포션 이미지를 16색 도트로 변환해줘. 적절한 도구 하나를 골라줘.`
승인 선택 예: `사용할 도구를 비교해 먼저 제안하고 승인받은 후 시작해.`
