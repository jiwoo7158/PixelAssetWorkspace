# 설치·실행 문제 해결

## PowerShell 실행이 제한됨
회사/학교 PC 정책을 우회하지 마세요. 스크립트 원문을 먼저 읽고 실행 여부를 결정합니다. 일반 개인 PC에서 ZIP에 다운로드 보안 표시가 붙었다면 파일 속성의 차단 해제 여부를 확인합니다.

## git 인증 또는 네트워크 에러
`git ls-remote https://github.com/patch-gg/pixelfx.git HEAD`로 GitHub 연결을 점검합니다. 공개 저장소를 가져오는 데 별도 GitHub 인증은 일반적으로 필요하지 않습니다.

## sprite-gen Python 의존성 충돌
반드시 이 프로젝트의 `.venv`만 사용합니다. 설치 오류가 나면 Python 버전(>=3.11)과 전체 오류 로그를 확인하세요. 다른 프로젝트의 `.venv`를 공유하지 않습니다.

## pixelfx 명령이 실패
`node --version`으로 Node.js 18+를 확인합니다. README 예제의 실행 위치는 **`tools/pixelfx` 내부**입니다. 프로젝트 루트에서는 `scripts/render-vfx.ps1`를 사용할 수 있습니다.

## 모델 없이 이미지 생성이 안 됨
pixelfx는 모델이 없이도 코드 기반 이펙트를 렌더링합니다. sprite-gen의 프레임 신규 생성은 별도 Provider가 필요하므로 Codex 실행 환경의 이미지 생성 기능을 확인하세요. API 키를 자동으로 찾아서 사용하지 않습니다.

## 결과를 pixelfx/records에서만 찾을 수 있음
직접 `node tools/render.mjs`를 호출하면 해당 저장소의 `records` 아래에 만들어집니다. 프로젝트 `outputs/vfx`에 결과를 복사하려면 `scripts/render-vfx.ps1` 사용을 권장합니다.
