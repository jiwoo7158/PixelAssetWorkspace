---
name: pixel-sprite
description: Create and curate independent 2D pixel art items, sprites and atlases using Kenney CC0 sources, sprite-gen and deterministic processing; no game engine integration.
---

# Pixel Sprite 제작

1. 요청이 아이템/캐릭터/타일/아이콘인지, 정적/애니메이션인지 분류한다.
2. `references/kenney/`, `references/custom/`의 합법적인 베이스 원본부터 확인한다. Kenney 팩별 원본과 라이선스를 보관한다.
3. 원본 픽셀아트라면 색상 변경/부분 도트 수정을 **우선** 한다. AI 생성이 필수라고 가정하지 않는다.
4. `tools/sprite-gen/README.ko.md`, `SKILL.md`에서 필요한 단일 CLI의 정확한 사용법을 확인한다. `sprite-gen --help`를 먼저 실행한다.
5. `cutout`, `slice-sheet`, `unpack-atlas`, `curation`, `recolor`, `compose-atlas` 등 이미 구현된 기능을 우선 사용한다.
6. 애니메이션 신규 생성 기능은 환경이 지원하는 Codex 이미지 Provider가 실제 동작하는지 **검사 후** 사용한다. API 키나 외부 모델로 자동 전환하지 않는다.
7. pixel-unfake / pixel-snapper는 격자가 불규칙할 때만 적용하고 적용 전/후를 비교한다.
8. `outputs/sprites` 또는 `outputs/animations`에 PNG/JSON 저장. 생성 설정, 베이스 경로, 변경사항을 기록한다.

게임 엔진에 자동 복사하거나 LÖVE2D 로더를 구현하지 않는다.
