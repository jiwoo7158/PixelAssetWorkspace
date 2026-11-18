---
name: pixel-postprocess
description: Clean or pixelize 2D images with Pixel Snapper, PixelOE or sprite-gen postprocessing, preserving references and comparing before/after.
---

# 픽셀 이미지 변환·보정

- 원본 이미지와 목표(일반 일러스트를 도트화 / 불규칙한 픽셀 격자를 정렬 / 팔레트 제한)를 구별한다.
- 일반 일러스트의 윤곽·명암을 유지하며 도트화: `PixelOE`를 우선 검토한다. **별도 `.venv-pixeloe`에 실제 설치됐는지 확인**해야 한다.
- AI가 만든 가짜 픽셀아트의 격자 정렬: `spritefusion-pixel-snapper`를 우선 검토하고 CLI 설치 여부를 확인한다.
- 기존 애니메이션 시트의 정리: `sprite-gen`이 적합할 수 있다.
- 세 도구를 연속 적용하는 것이 기본값은 아니다. 먼저 하나로 처리하고 결과 비교 후 정말 필요할 때만 추가한다.
- 원본은 절대 수정하지 않으며, 전후 미리보기와 도트 크기, 팔레트, 알파 손실을 검사한다.
