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

## 새 Git clone에서 재설치

Git, Node.js 20+, Python 3.11~3.13이 준비돼 있으면 `scripts/setup-windows.ps1`을 실행한다. 기본 설치는 8개 도구 **원본 저장소**를 내려받고 `sprite-gen`만 `.venv`에 설치한다. 네트워크가 필요하며, 업스트림 소스 용량이 클 수 있다. 새 도구는 소스만 존재할 수도 있으므로 `scripts/tool-status.ps1`에서 사용 가능 상태를 구분한다. 선택적 Python 설치는 `-InstallPixelOE` 또는 `-InstallForgeDependencies` 스위치를 사용한다. 외부 모델은 포함하지 않는다.

## GitHub 복제 중 고정 커밋 fetch 실패

기본 설치는 `tools/UPSTREAMS.json`에 기록된 커밋 SHA를 가져온다. 저장소에서 과거 커밋을 더 이상 얕게 가져올 수 없는 상황이 발생하면 먼저 해당 저장소 URL과 커밋을 확인하고, 필요할 때 `-UseLatest`로 다시 시도할 수 있다. `-UseLatest`는 새로 설치하는 소스에만 적용되며 이미 존재하는 체크아웃은 변경하지 않는다.

## PowerShell 5.1 한글 깨짐

수정된 `.ps1`은 UTF-8 BOM 인코딩으로 저장돼 있어 일반 Windows PowerShell 5.1에서 한글 문자열을 올바르게 읽을 수 있다. ZIP에서 받은 스크립트의 서명 실행 오류는 텍스트 인코딩과 다른 문제다. 실행 전에 내용을 검토하고 필요하다면 해당 파일만 `Unblock-File`한다. 시스템 실행 정책을 영구적으로 낮출 필요는 없다.
