---
name: pixel-animation
description: Create 2D pixel character animations, poses and sprite sheets using the most appropriate available image-gen, video-gen or code-rig workflow; never assume external model access.
---

# 캐릭터 애니메이션 제작

- 캐릭터의 기준 이미지는 `references/`에서 보존하고, 인체/무기/방향/루프와 프레임 목표를 먼저 확인한다.
- 사용 가능한 후보: `Codixel`(참고 기반 코드 리깅), `Pixelbolt`(레시피 기반 애니메이션), `2dimg2motion`(모델이 핵심 자세와 중간 프레임을 재생성), `Agent Sprite Forge`(이미지/영상 생성 기반), `sprite-gen`(영상/이미지 스프라이트 처리).
- 외부 이미지 모델이 없을 때 영상 기반 생성이 자동 실행되는 것으로 가정하지 않는다. 이미지/영상 서비스 호출은 사용자의 명시적 승인 이후에만 한다.
- `tools/*` 내부의 공식 README 또는 SKILL.md는 선택 후 필요한 부분만 읽는다. 도구 선택은 루트 `AGENTS.md`가 우선한다.
- 프레임별 크기, 기준선, 알파, 무기 손, 캐릭터 외형, 루프 연결, JSON 경계 좌표, 결과 파일을 검사한다.
- 출력은 `outputs/animations/`, 레시피는 `recipes/sprites/` 또는 사용자가 지정한 독립 폴더에 저장한다.
