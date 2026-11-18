# PixelAssetWorkspace — Codex 기반 2D 픽셀 에셋 작업 공간

> **목적:** 게임 엔진에 종속되지 않고, **2D 픽셀아트·스프라이트·스킬 이펙트**를 빠르게 제작·수정·보관하는 작업 공간입니다.  
> **사용 환경:** Windows / VS Code / Codex / Python / Node.js  
> **기본 제작 방식:** **Codex만 사용**합니다. FLUX, ComfyUI, 별도 로컬 이미지 생성 모델은 설치·연결하지 않습니다.

이 프로젝트는 GameAssetAI(3D 기반 제작 시스템)와 **별개**입니다. LÖVE2D를 포함한 **어떤 게임 엔진과도 자동 연결하지 않습니다**. 완성된 `PNG`, `JSON`, 스프라이트 시트 등의 결과물만 필요할 때 직접 가져다 쓰면 됩니다.

## 0. ZIP 구성과 원본 저장소 다운로드 방식 (먼저 읽기)

이 ZIP에는 **작업 공간, 한국어 사용 문서, Codex 전용 스킬 지침, PowerShell 설치·실행 스크립트, 실제 PNG 테스트 에셋**이 포함되어 있습니다.

**GitHub의 대형 오픈소스 저장소 전체 소스는 ZIP에 미포함입니다.** 원본 저장소의 정확한 코드를 가져오도록 아래 `setup-windows.ps1`에서 공식 GitHub 저장소 3개를 `tools/` 아래에 자동으로 내려받습니다. 따라서 **최초 설정 시 인터넷 연결이 필요**합니다. 설정 후에는 설치된 코드와 에셋을 로컬에서 활용할 수 있습니다(단, sprite-gen의 이미지 생성 Provider는 별도 인증·기능이 필요할 수 있음).

- 포함/다운로드 대상: [`sprite-gen`](https://github.com/aldegad/sprite-gen) (Apache-2.0), [`pixelfx`](https://github.com/patch-gg/pixelfx) (MIT), [`spritefusion-pixel-snapper`](https://github.com/Hugo-Dz/spritefusion-pixel-snapper) (MIT).
- 선택적 참고: [`perfectPixel`](https://github.com/theamusing/perfectPixel) — README와 pyproject에 MIT 표기가 있지만 확인한 시점에 LICENSE 원문 파일이 없어 **자동 다운로드/코드 통합 대상에서 제외**했습니다.
- 에셋 원본: [Kenney Assets](https://kenney.nl/assets) — **에셋 팩은 선택해서 직접 다운로드**합니다. 사이트에 있는 모든 자료를 임의로 포함하지 않습니다. 팩에 포함된 라이선스도 보관하세요.

실제로 어떤 소스 코드가 설치되었는지는 설정 후 만들어지는 `licenses/sources-installed.json`에 **커밋 SHA**가 기록됩니다.

---

## 1. 프로젝트가 하는 일 / 하지 않는 일

### 주요 용도

| 에셋 유형 | 우선 사용 도구 | 제작 방식 |
|---|---|---|
| 아이콘·아이템·타일·정적 스프라이트 | Kenney, Codex+Python, sprite-gen | CC0 원본을 색상 변형/부분 수정/정렬/투명화 |
| 캐릭터 애니메이션·프레임 아틀라스 | sprite-gen | 기본 이미지에서 프레임 분리·정리·선택·시트 구성 |
| 공격·마법·폭발·UI 스킬 이펙트 | pixelfx | 기존 JS 이펙트의 색상·타이밍·형태 수정, 또는 코드로 신규 제작 |
| 불규칙한 픽셀 그리드·팔레트 정리 | sprite-gen Pixel Unfake, Pixel Snapper | 문제가 있는 이미지에만 선택적으로 적용 |

### 의도적으로 제외

- **게임 엔진 연동:** LÖVE2D/Unity 전용 플러그인, 런타임 로더, 자동 에셋 복사 없음.
- **별도 로컬 이미지 생성 모델:** FLUX/SD/ComfyUI 설치 없음.
- **Codex와 로컬 AI 혼합 제어:** 없음. Codex가 독립된 작업 주체입니다.
- **3D 생성:** GameAssetAI에서 다룰 범위입니다.
- **실행 중 자동으로 인터넷에 결과물을 업로드하는 기능:** 없음. 외부 Provider를 명시적으로 사용하면 해당 서비스의 정책에 따릅니다.

> **Codex의 역할:** 요청에 따라 로컬 파일/오픈소스 코드를 읽고, 기존 CLI 명령을 실행하거나 Python/JavaScript 코드를 작성·수정하고, 출력 결과를 검사하는 것입니다. Codex가 보이지 않는 FLUX/ComfyUI를 관리하는 것은 **아닙니다**.

## 2. Windows 설치 (최초 1회)

### 2-1. 준비할 프로그램

1. **Git** — `git --version`이 동작해야 합니다. [공식 사이트](https://git-scm.com/downloads)
2. **Python 3.11 이상** — `py -3.13 --version` 또는 `python --version` 확인. [공식 사이트](https://www.python.org/downloads/)
3. **Node.js 18 이상** — `node --version` 확인. [공식 사이트](https://nodejs.org/)
4. **VS Code + Codex** — 이미 사용 중인 작업 환경을 그대로 사용합니다.
5. **선택사항: Rust/Cargo** — Pixel Snapper CLI 설치 시에만 필요. [공식 사이트](https://rustup.rs/)

권장: 압축을 `C:\Projects\PixelAssetWorkspace`처럼 **공백이 적고 관리하기 편한 경로**에 풀고, VS Code에서 해당 폴더를 엽니다.

### 2-2. 프로젝트 열기 및 자동 설치

VS Code에서 **터미널 → 새 터미널 (PowerShell)** 을 열고 아래를 실행합니다.

```powershell
cd C:\Projects\PixelAssetWorkspace    # 실제 압축 해제한 위치로 변경
.\scripts\setup-windows.ps1
```

설치 스크립트가 PowerShell 실행 정책 때문에 차단되면, **내용을 확인하고 신뢰하는 경우에만** 압축 해제한 파일의 차단을 해제하거나 현재 세션의 실행 정책을 조정하세요. 보안 정책이 있는 PC라면 해당 정책을 우선합니다.

스크립트는 다음만 수행합니다.

1. `tools/sprite-gen`, `tools/pixelfx`, `tools/spritefusion-pixel-snapper`를 **공식 GitHub 저장소에서 shallow clone**합니다. 이미 체크아웃이 있으면 자동 덮어쓰지 않습니다.
2. 프로젝트 루트에 `.venv`를 만들고 `sprite-gen` Python 패키지를 `pip install -e`로 설치합니다.
3. 확인한 `LICENSE`, `NOTICE`를 `licenses/third-party/`에 보존하고 저장소 커밋 SHA를 기록합니다.
4. **모델 다운로드, 외부 유료 API 호출, Kenney 에셋 자동 수집, 게임 엔진 연결은 수행하지 않습니다.**

> 공식 pixelfx 도구는 Node.js로 실행하며, 기본 `tools/render.mjs`를 사용하기 위해 글로벌 npm 패키지를 설치할 필요는 없습니다. 일부 부가 기능은 별도 실행 파일이 필요할 수 있습니다.

### 2-3. 설치 확인

```powershell
.\scripts\health-check.ps1
```

확인 항목: Git/Node/Python, 오픈소스 폴더 존재, `sprite-gen --help`, pixelfx 이펙트 렌더링(옵션).

---

## 3. 가장 먼저 해볼 일: pixelfx로 이펙트 만들기

기본 예제는 **마법 얼음 폭발**입니다. `pixelfx`는 별도의 AI 이미지 모델 없이 **코드 자체로 이펙트를 생성**합니다.

### 방법 A: 프로젝트 스크립트 사용 (권장)

```powershell
.\scripts\render-vfx.ps1 -Effect 'ice/frost-nova'
```

실행 결과는 두 곳에 남습니다.

- `tools/pixelfx/records/ice/frost-nova/` : 원본 pixelfx 도구가 생성한 파일
- `outputs/vfx/ice/frost-nova/` : 프로젝트가 모아 둔 결과 복사본

다른 예시:

```powershell
.\scripts\render-vfx.ps1 -Effect 'fire/torch'
.\scripts\render-vfx.ps1 -Effect 'melee/sword-slash'
```

### 방법 B: pixelfx 명령 직접 실행

```powershell
cd .\tools\pixelfx
node tools/list.mjs frost
node tools/render.mjs ice/frost-nova --sheet
node tools/check.mjs ice/frost-nova
node tools/serve.mjs
```

- `render.mjs --sheet`: 투명 PNG 스프라이트 시트 + Aseprite 스타일 JSON 출력
- `check.mjs`: 캔버스 넘침, 루프 경계, 랜덤 시드 등 코드 수준 오류 검사
- `serve.mjs`: pixelfx 로컬 갤러리 실행(터미널에 표시되는 주소 확인)

**새 이펙트를 만들 때**는 먼저 기존 이펙트를 찾아 수정하고, 없을 때 `node tools/new.mjs arcane/my-spell`로 신규 코드를 만듭니다. 그런 다음 **렌더 → 화면 확인 → 수정 → 재렌더 → 검사** 순서로 작업합니다.

`pixelfx`의 Claude 전용 플러그인 명령(`/plugin ...`)을 Codex에 실행하지 않습니다. 대신 이 프로젝트의 **`.agents/skills/pixel-vfx/`**를 사용합니다.

> pixelfx README: [공식](https://github.com/patch-gg/pixelfx) / [이펙트 갤러리](https://patch-gg.github.io/pixelfx/). `gallery/fonts`의 **Patch Pixel 폰트는 pixelfx의 MIT 라이선스에 포함되지 않음**에 주의하세요.

---

## 4. Kenney 에셋 가져오기

Kenney의 에셋 페이지에서 원하는 **팩별로** 다운로드합니다. Kenney 공식 Support에 따르면 게임 에셋 페이지의 팩은 일반적으로 **CC0**이고 유료 게임에 사용할 수 있으며 출처 표기는 의무가 아닙니다. 단, 팩마다 포함된 라이선스를 확인해야 하고 Kenney 로고/상표는 별도입니다.

추천 탐색: [Kenney assets](https://kenney.nl/assets), [Roguelike Characters](https://kenney.nl/assets/roguelike-characters), [Pixel UI Pack](https://kenney.nl/assets/pixel-ui-pack).

1. 원하는 ZIP을 직접 다운로드하고 압축 해제합니다.
2. 아래 스크립트로 원본을 작업 공간에 **복사**합니다. **원본은 수정하지 않습니다.**

```powershell
.\scripts\import-kenney.ps1 `
  -SourceDir 'C:\Downloads\KenneyPack' `
  -PackName 'my-first-pack' `
  -SourceUrl 'https://kenney.nl/assets/원본-팩-주소'
```

3. `references/kenney/my-first-pack/`에서 참고 이미지를 골라 `runs/` 또는 `recipes/`에서 변형합니다.
4. 출처 기록은 `references/kenney/_provenance/`에 저장됩니다.

**주의:** 배경 이미지·캐릭터·아이템을 포함한 팩 원본을 AI로 다시 그려야 하는 것은 아닙니다. 색상 변경·픽셀 정렬 정도면 코드를 이용한 **결정론적 변형**이 더 정확하고 빠릅니다.

---

## 5. sprite-gen 활용: 에셋 정리·시트 생성

sprite-gen은 **Codex/Claude 스킬 + Python CLI**입니다. 특히 이미 준비한 원본 PNG를 정리할 때 유용합니다.

```powershell
# 프로젝트 루트 기준
.\.venv\Scripts\sprite-gen.exe --help

# 단일 이미지의 배경 키잉 / 투명화 (이미지가 흰색/단색 배경일 때만)
.\.venv\Scripts\sprite-gen.exe cutout .\references\custom\icon.png --white-check

# 이미지 또는 완성 시트를 가져와 큐레이션 가능한 작업 폴더 구성
.\.venv\Scripts\sprite-gen.exe unpack-atlas --pngs-dir .\runs\candidate-pngs --out-dir .\runs\sample-curation

# 검수용 로컬 웹뷰
.\.venv\Scripts\sprite-gen.exe curation --run-dir .\runs\sample-curation --lang ko
```

**중요:** `cutout`은 원본의 색/배경 조건에 따라 실패하거나 의도하지 않은 부분을 지울 수 있습니다. **먼저 원본을 복사하고** 스크립트 옵션은 `sprite-gen cutout --help`로 확인하세요. `unpack-atlas` 역시 입력 폴더가 준비되어 있어야 합니다.

캐릭터 프레임 생성(`prepare → gen-set → extract → compose-atlas`)을 사용하려면 **Codex 환경에서 sprite-gen의 `codex` 이미지 생성 Provider가 실제 작동하는지 먼저 확인**해야 합니다. Codex CLI로 로그인했다고 해서 모든 환경에서 이미지 생성 호출이 보장되는 것은 아닙니다. Provider가 사용할 수 없는 경우 다른 유료 API로 자동 전환하지 않습니다.

간단한 작업은 이미지 생성 없이 `slice-sheet`, `unpack-atlas`, `curation`, `recolor`, `compose-atlas` 등을 활용하세요. 사용 가능한 서브커맨드는 버전에 따라 달라질 수 있으니 설치한 코드의 `--help` 및 `tools/sprite-gen/README.ko.md`를 우선합니다.

---

## 6. 픽셀 정렬 보정

**이미 올바른 도트 그리드를 갖는 Kenney 원본에는 픽셀 보정을 무조건 적용하지 마세요.** 오히려 디테일이 손상될 수 있습니다.

### 기본: sprite-gen Pixel Unfake

sprite-gen의 픽셀아트 스프라이트 추출 경로에 포함된 기능입니다. 여러 프레임에 대해 픽셀 그리드를 일정하게 맞추는 용도로 사용합니다. 설정 방법: `tools/sprite-gen/docs/pixel-unfake.md`.

### 선택: Sprite Fusion Pixel Snapper (MIT)

설치 스크립트가 **원본 소스 코드만** `tools/spritefusion-pixel-snapper`에 내려받습니다. CLI 실행 파일을 사용하려면 Rust/Cargo 설치 후:

```powershell
cargo install spritefusion-pixel-snapper
spritefusion-pixel-snapper .\references\custom\before.png .\outputs\sprites\after.png 16
```

커스텀 팔레트 / 픽셀 크기 옵션은 [공식 설명서](https://github.com/Hugo-Dz/spritefusion-pixel-snapper)를 확인하세요. Rust를 설치하기 싫으면 이 기능은 건너뛰어도 됩니다.

### 보류: perfectPixel

`perfectPixel`은 유용한 격자 감지 라이브러리지만, 2026-11-19에 확인한 저장소의 README/패키지 메타데이터에 MIT로 적혀 있는 것과 별개로 `LICENSE` 원문 파일을 확인하지 못했습니다. **현재 ZIP에서는 의존성으로 사용하지 않으며, 해당 이슈 확인 후 별도 평가**합니다.

---

## 7. Codex에서 실제로 사용하는 방법

Codex에서 **이 폴더 전체를 작업 루트로 열어** 사용하세요. Codex는 다음 파일을 읽을 수 있습니다.

- `AGENTS.md`: 프로젝트의 목적, 금지 범위, 에셋 제작 및 검증 규칙
- `.agents/skills/pixel-vfx/SKILL.md`: pixelfx 스킬 이펙트 제작 절차
- `.agents/skills/pixel-sprite/SKILL.md`: Kenney, sprite-gen, 도트 에셋 제작 절차
- `.agents/skills/asset-review/SKILL.md`: 결과물·라이선스·픽셀 품질 점검 절차

**프롬프트 예시:**

> `pixel-vfx 스킬로 pixelfx 기존 frost-nova를 바탕으로 파란 얼음 폭발을 3가지 버전으로 제작해. 먼저 기존 이펙트를 찾고 원본 소스는 보존한 뒤 recipes/vfx에 변경 코드를 관리해. PNG 시트와 JSON은 outputs/vfx에 저장하고 미리보기를 비교해.`

> `pixel-sprite 스킬로 references/kenney에 넣은 포션 원본을 사용해 색상만 다른 4개 변형을 만들어 줘. 형태는 변경하지 말고 원본 파일은 보존해. 16색 이내에서 처리하고 결과를 outputs/sprites에 저장해.`

> `asset-review 스킬로 outputs/vfx/ice/frost-nova의 파일 형식, 투명 배경, 프레임 정보, pixelfx 체크 결과를 확인해.`

좀 더 자세한 예시는 [`docs/CODEX_EXAMPLES.md`](docs/CODEX_EXAMPLES.md)에 있어요.

Codex는 **기본적으로 CLI 실행/코드 작성 도구**입니다. 이미지 생성 API 또는 별도 모델을 반드시 호출하도록 설계하지 않았습니다. Pixelfx에서는 JS 코드를 직접 수정하고 실행하는 것만으로 이펙트를 만들 수 있습니다.

---

## 8. 프로젝트 폴더 설명

```text
PixelAssetWorkspace/
├─ README.md                         # 이 사용 설명서
├─ AGENTS.md                         # Codex 공통 지침
├─ .agents/skills/                   # 프로젝트 전용 Codex 스킬 3개
├─ scripts/                          # 설치·진단·렌더링·Kenney 가져오기
├─ tools/                            # 최초 설치 시 GitHub 원본 코드 내려받는 위치
│  ├─ sprite-gen/                    # [설치 후] Apache-2.0
│  ├─ pixelfx/                       # [설치 후] MIT
│  └─ spritefusion-pixel-snapper/    # [설치 후] MIT
├─ references/
│  ├─ kenney/                        # 팩별 원본 (수정 금지)
│  └─ custom/                        # 직접 만든/소유한 참고 이미지
├─ recipes/
│  ├─ sprites/                       # 변형 레시피
│  └─ vfx/                           # 이펙트 제작 코드/설정
├─ runs/                              # 임시 생성 과정·프레임·검수 자료
├─ outputs/
│  ├─ sprites/                       # 정적 PNG
│  ├─ animations/                    # 캐릭터 시트
│  └─ vfx/                           # 효과 스프라이트 시트·JSON
├─ samples/                          # 자체 제작 데모 PNG 1장 + 시트
├─ licenses/
│  ├─ third-party/                   # 설치한 소스의 LICENSE / NOTICE 복사
│  └─ provenance/                    # 에셋 생성·출처 메타데이터
└─ docs/                              # 정책·실습·문제 해결
```

`tools/` 아래 코드는 **업스트림 원본** 취급합니다. 임의로 수정하지 말고, 자체 수정 사항은 `recipes/`에 두거나 명시적으로 별도 패치로 관리하세요. `outputs/`에는 배포 후보 에셋만, `runs/`에는 재생성 가능한 중간 결과를 보관하세요.

## 9. 자체 데모 에셋 확인

`samples/demo-potion.png`, `samples/demo-potion-sheet.png`는 **이 프로젝트를 위해 새로 만든 테스트용 도트 이미지**입니다. Kenney에서 가져온 것이 아닙니다. 설치 전에 파일 탐색기/픽셀 편집기에서 바로 열어 볼 수 있습니다.

이미지 형식 및 알파 채널 점검(설치 후):

```powershell
.\.venv\Scripts\python.exe .\scripts\inspect-image.py .\samples\demo-potion.png --require-alpha --json
```

## 10. 상업 이용과 저작권 관리

**유료 게임에 사용하는 것 자체는** Kenney의 CC0 에셋, sprite-gen의 Apache-2.0, pixelfx·Pixel Snapper의 MIT 라이선스 조건 아래 가능하지만, **코드 자체 재배포는 별도 고지 의무**가 있습니다. 이 ZIP 안에 자동으로 추가되는 `tools/`의 원본 저장소는 업데이트될 수 있으므로 라이선스 파일을 실제로 확인하세요.

- Kenney: 팩별 CC0 증빙 보관, 로고/상표 별도 취급
- sprite-gen: 수정된 코드 배포 시 Apache-2.0 LICENSE/NOTICE 및 변경 고지 확인
- pixelfx: 코드/대량의 코드 부분 배포 시 MIT 저작권·라이선스 포함, `gallery/fonts` 제외
- Pixel Snapper: MIT 고지 유지
- perfectPixel: 현재 필수 의존성 제외
- Codex 이미지 생성 Provider를 활용하는 경우: 해당 **서비스 약관·요금·출력 권리**는 별도 확인
- 오픈소스 사용 허락은 제3자의 저작권/상표권 침해까지 면책하는 것은 아닙니다.

상세: [`docs/LICENSES.md`](docs/LICENSES.md)

## 11. 자주 생기는 문제

**Q. Git clone이 실패해요.**  
A. Git 설치·네트워크를 확인하고 공식 저장소에 브라우저로 접속되는지 확인하세요. 설정 스크립트는 정상적으로 체크아웃된 폴더를 임의로 지우지 않습니다.

**Q. Node.js가 없다고 나와요.**  
A. Node.js 18 이상 설치 후 VS Code 터미널을 새로 열고 `node --version`을 확인하세요.

**Q. `sprite-gen --help`가 실행되지 않아요.**  
A. `.venv`가 만들어졌는지와 `pip install -e tools/sprite-gen`이 성공했는지 확인하세요. `scripts/setup-windows.ps1` 재실행도 가능합니다.

**Q. Python 코드에서 OpenCV 오류가 나요.**  
A. 기본 설치에서는 OpenCV를 설치하지 않습니다. 현재 기본 워크플로는 sprite-gen/Pillow 위주로 구성하고, OpenCV가 필요한 도구를 채택할 때 그 도구의 별도 환경에 설치하세요.

**Q. 이미지를 자동으로 그려주는 모델이 ZIP에 없나요?**  
A. 네. 이번 결정은 **Codex 단독**입니다. pixelfx는 코드 렌더링이고, `sprite-gen`의 추가 이미지 생성 Provider는 지원되는 Codex 환경·인증이 있을 때만 사용합니다. 로컬 FLUX/ComfyUI는 포함하지 않았습니다.

**Q. pixelfx 결과가 바로 게임에서 돌아가나요?**  
A. 이 워크스페이스는 PNG와 JSON을 **생산**할 뿐 런타임 로더를 만들지 않습니다. 어느 엔진에서든 나중에 필요할 때 별도로 가져다 쓸 수 있습니다.

---

## 12. 공식 링크

- [Codex 프로젝트 스킬 위치 (`.agents/skills`)](https://learn.chatgpt.com/docs/build-skills)
- [Kenney](https://kenney.nl/assets) · [Kenney 사용 허가 설명](https://kenney.nl/support)
- [sprite-gen 한국어 README](https://github.com/aldegad/sprite-gen/blob/main/README.ko.md)
- [pixelfx GitHub](https://github.com/patch-gg/pixelfx) · [pixelfx Gallery](https://patch-gg.github.io/pixelfx/)
- [Sprite Fusion VFX 제작 글](https://www.spritefusion.com/blog/how-to-make-good-pixel-art-effects-with-claude)
- [Pixel Snapper](https://github.com/Hugo-Dz/spritefusion-pixel-snapper) · [perfectPixel](https://github.com/theamusing/perfectPixel)

현재 구조는 **초기 운영안**이며, 실사용하면서 문제가 드러난 기능만 최소한으로 추가하는 것을 목표로 합니다.
