---
name: pixel-vfx
description: Code-first 2D pixel art skill effects, explosions, magic, attacks and UI VFX with pixelfx; render sprite sheets, preview and validate without a local image model.
---

# Pixel VFX 제작

이 스킬은 **독립적인 2D 스킬 이펙트 에셋 제작**에만 사용한다. 게임 엔진 통합이나 외부 생성 모델 호출은 하지 않는다.

1. `tools/pixelfx`가 존재하는지 확인하고 없으면 `scripts/setup-windows.ps1`을 안내한다.
2. `tools/pixelfx/skills/pixelfx/SKILL.md`, `docs/AUTHORING.md`를 필요한 범위에서 읽는다. 프로젝트 지침인 `AGENTS.md`가 우선이다.
3. `node tools/list.mjs <키워드>` 또는 `docs/CATALOG.md`로 기존 이펙트부터 찾는다.
4. 기존 효과의 옵션 변경/재색상으로 해결 가능한지 우선 검토한다. 새 이펙트가 필요하다면 `node tools/new.mjs <category>/<name>`을 바탕으로 별도 `recipes/vfx/`에서 원본을 관리하고 사용자가 원하면 pixelfx의 새 효과 파일 위치를 지정한다.
5. `node tools/render.mjs <id> --sheet` 및 미리보기 렌더로 출력한다.
6. `node tools/check.mjs <id>`와 실제 프레임/컨택트 시트를 통해 검사한다.
7. `outputs/vfx/<category>/<name>/`에 PNG/JSON/미리보기, `licenses/provenance/`에 출처·도구 커밋·수정 사항을 기록한다.
8. 공개/재배포 전에 MIT LICENSE/NOTICE 준수 및 pixelfx `gallery/fonts` 제외 확인.

예시: `scripts/render-vfx.ps1 -Effect 'ice/frost-nova'`.

절대로 Codex 이미지 생성 API 또는 ComfyUI/FLUX를 이 스킬의 암묵적 필수 단계로 추가하지 않는다.

## v2: pixelfx 외 대안

이펙트 요청에는 pixelfx가 기본 우선이지만 `Pixelbolt` 유체·레시피 기반 이펙트 또는 `Codixel` 리깅/코드 이펙트가 더 적합한 경우가 있다. `config/tool-routing.json`에서 후보를 확인하되, **요청에 필요하지 않은 도구들을 모두 실행하지 않는다.** 사용자가 pixelfx만 명시하면 그 도구만 사용한다.
