# 설계 결정 및 흐름

## 비목표

- 게임 엔진 연동(LÖVE2D 포함) 및 게임 런타임 코드
- 3D / GameAssetAI 프로젝트 재사용
- Codex + FLUX/ComfyUI 혼합 파이프라인
- 새 독립 하네스 구축

## 3가지 독립 작업 흐름

### 정적 에셋

Kenney/자체 원본 → (선택) Python 색상·도트 수정 → (선택) sprite-gen 정리 → `outputs/sprites/`

### 캐릭터 애니메이션

합법적 베이스 이미지 → (이미지 Provider가 실제 제공될 경우에만 생성) 또는 이미 존재하는 프레임 → sprite-gen 프레임 추출/큐레이션 → `outputs/animations/`

### 픽셀 이펙트

pixelfx 기존 JS 코드/레시피 → Codex가 수정 또는 새 이펙트 코드 작성 → Node.js 렌더/QA → `outputs/vfx/`

모든 흐름은 독립적. pixelfx 결과를 무조건 sprite-gen으로 다시 처리하지 않는다.

## Codex의 범위

Codex는 **코드 작업 에이전트**다. 로컬 명령 실행, 코드 수정, QA, 문서·메타데이터 기록이 역할이다. 현재 요구사항에서 FLUX/ComfyUI를 호출하는 상위 제어 장치가 아니다.

## 의존성과 소스 보존

업스트림 원본(`tools/*`)과 개인 레시피(`recipes/*`)를 분리한다. 소스의 SHA는 설치 시 기록하고, 커밋 후 업데이트는 별도 검증한다. `references/kenney/*`는 불변 원본이며, `runs`는 중간 결과, `outputs`는 최종 납품 대상이다.
