# 제3자 오픈소스·에셋 라이선스 기록 (2026-11-19 확인 기준)

| 대상 | 적용 조건 | 상업 제작 | 재배포 관련 핵심 |
|---|---|---|---|
| [sprite-gen](https://github.com/aldegad/sprite-gen/blob/main/LICENSE) | Apache License 2.0, `NOTICE` | 허용 | 코드/파생물 배포 시 라이선스/NOTICE·변경 고지 조건 확인 |
| [pixelfx](https://github.com/patch-gg/pixelfx/blob/main/LICENSE) | MIT, `NOTICE.md` | 허용 | 소프트웨어 복사본/상당 부분 배포 시 저작권·라이선스 표시 유지 |
| [Sprite Fusion Pixel Snapper](https://github.com/Hugo-Dz/spritefusion-pixel-snapper/blob/main/LICENSE) | MIT | 허용 | MIT 고지 유지 |
| [Kenney assets](https://kenney.nl/support) | 게임 에셋 페이지의 CC0 팩 | 허용 | 팩별 라이선스 기록, Kenney 이름/로고/상표 별도 취급 |
| [perfectPixel](https://github.com/theamusing/perfectPixel) | README/pyproject MIT 표기, LICENSE 원문 미확인 | 코드 통합 보류 | 원문 또는 저작자 확인 전 기본 구성 제외 |

## pixelfx 특별 주의사항

`gallery/fonts`에 포함된 Patch Pixel 폰트는 저장소 MIT 범위에서 제외됩니다. 폰트 파일은 별도 권리 확인 없이 복사하거나 배포하지 마세요. `NOTICE.md`에 기재된 Sprite Fusion / Hollow Crown 유래 코드의 저작권 고지도 유지하세요.

## 사용 시나리오별 판단

- **제작 도구로 로컬 실행 후 PNG만 게임에 포함:** 일반적으로 도구 소스코드를 게임에 포함하는 것이 아니므로 도구 자체의 소스 공개 의무가 생기지 않습니다. 모델/원본 에셋/제3자 권리는 별도로 확인.
- **오픈소스 코드를 본인 툴 안에 포함하여 재배포:** Apache-2.0, MIT 고지 의무를 이행해야 합니다.
- **sprite-gen 이미지 생성 Provider:** Codex 로그인·API 사용 자격·서비스 약관·요금 정책은 오픈소스 코드 라이선스와 별개입니다. 이 프로젝트 설치가 상업 출력에 대한 모든 권리를 보장하지 않습니다.
- **원본 Kenney CC0 픽셀 수정:** 에셋 팩별 CC0 조건 확인 후 가능. Kenney 로고/상표와 혼동하지 않기.

설치 스크립트는 각 원본의 LICENSE/NOTICE를 `licenses/third-party/`에 복사하고, 설치 SHA를 `licenses/sources-installed.json`에 기록합니다. ZIP 안에 원본 저장소 전체가 이미 담겨 있다고 해석하지 마세요.

이 문서는 기술 프로젝트의 라이선스 관리용 설명이며, 구체적 법률 판단이 필요한 계약·분쟁에 대한 자문은 아닙니다.

## v2 추가 소스 5개

| 도구 | 라이선스 | 핵심 의무·주의 |
|---|---|---|
| [Agent Sprite Forge](https://github.com/0x0funky/agent-sprite-forge) | MIT | 소프트웨어 재배포 시 고지. **외부 이미지/영상 Provider의 별도 권리·요금 조건** 확인 |
| [Codixel](https://github.com/mankidev/codixel) | MIT | 코드 재배포 시 고지, 참고 이미지의 권리는 별개 |
| [Pixelbolt](https://github.com/skulitom/Pixelbolt) | MIT | 코드 재배포 시 고지, 레시피 기반 코드 생성 |
| [2dimg2motion](https://github.com/WU-HAOTIAN34/2dimg2motion) | MIT | 이미지 생성 모델에 접근해야 하는 핵심 기능; 모델 사용 약관 별도 |
| [PixelOE](https://github.com/KohakuBlueleaf/PixelOE) | Apache 2.0 | 코드 배포 시 LICENSE/NOTICE 및 변경 고지 조건 검토. PyTorch/Slang 등 **의존 패키지는 별도 라이선스** |

실제 라이선스 원문은 설치 시 `licenses/third-party/`에 복사된다. 도구 소스 복제와 사용 가능성을 구분하고, 사용된 Git 커밋을 `licenses/sources-installed.json`에 기록한다. 게임에 PNG를 넣는 경우와 오픈소스 코드를 재배포하는 경우를 혼동하지 않는다.
