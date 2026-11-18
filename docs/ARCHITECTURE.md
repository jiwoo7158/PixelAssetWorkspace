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

## v2 확장: 오픈소스 선택과 재설치

현재 관리 도구는 `tools/UPSTREAMS.json`에 기록된 8개다. 설치 목록을 코드에 중복 하드코딩하지 않는다. `config/tool-routing.json`은 선택 방식(`auto`/`manual`/`approve`), 도구별 우선순위 및 외부 생성 서비스 승인 조건을 정의한다. **코드 기반 생성**(pixelfx, Pixelbolt, Codixel), **외부 이미지/영상 생성 의존**(2dimg2motion, Agent Sprite Forge, sprite-gen 일부), **후처리**(PixelOE, Pixel Snapper)를 명확히 구별한다.

새 Git clone에서 `scripts/setup-windows.ps1`을 실행하면 기본적으로 8개 소스를 공개 GitHub의 지정 SHA로 체크아웃한다. 기본 3개 도구만 설치하려면 `-CoreOnly`; 기록된 커밋 대신 최신 HEAD를 쓰려면 `-UseLatest`를 명시한다. PixelOE의 대형 PyTorch 의존성 및 Agent Sprite Forge Python 의존성은 **명시적 스위치**로만 설치한다. 기존 `tools/<name>` 체크아웃은 자동 업데이트하지 않는다. `scripts/tool-status.ps1`로 소스 보유와 CLI 준비 상태를 별도 확인한다.

외부 오픈소스 리포지토리는 Git에 하위 트리로 저장하지 않고 `.gitignore` 처리한다. GitHub에는 **프로젝트 설정, 스킬, 설치 스크립트, 라이선스 메타데이터**만 보관한다. 재생성 가능한 커밋 목록, 독립 `.venv`, 출처 SHA 로깅으로 재설치를 돕는다.
