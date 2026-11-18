#!/usr/bin/env python3
"""Check PNG dimensions, alpha, and distinct visible colors. Requires Pillow."""
import argparse, json, sys
from pathlib import Path
from PIL import Image


def inspect(path: Path, require_alpha: bool):
    with Image.open(path) as im:
        rgba = im.convert('RGBA')
        w, h = rgba.size
        pixels = list(rgba.get_flattened_data()) if hasattr(rgba, 'get_flattened_data') else list(rgba.getdata())
        visible = [p for p in pixels if p[3] > 0]
        transparent_count = sum(1 for p in pixels if p[3] == 0)
        partial_alpha = sum(1 for p in pixels if 0 < p[3] < 255)
        colors = len(set(p[:3] for p in visible))
        has_alpha = 'A' in im.getbands() or 'transparency' in im.info
        result = dict(file=str(path), format=im.format, mode=im.mode,
                      width=w, height=h, has_alpha=has_alpha,
                      transparent_pixels=transparent_count, partial_alpha_pixels=partial_alpha,
                      visible_colors=colors, empty=(len(visible) == 0))
        issues = []
        if im.format != 'PNG': issues.append('PNG 파일이 아닙니다')
        if w < 1 or h < 1: issues.append('해상도가 잘못되었습니다')
        if require_alpha and (not has_alpha or transparent_count == 0):
            issues.append('투명 배경이 확인되지 않았습니다')
        if not visible: issues.append('이미지에 보이는 픽셀이 없습니다')
        result['issues'] = issues
        return result


def main():
    ap=argparse.ArgumentParser(description='도트 에셋 기본 품질 점검')
    ap.add_argument('file', type=Path)
    ap.add_argument('--require-alpha', action='store_true')
    ap.add_argument('--json', action='store_true')
    args=ap.parse_args()
    if not args.file.is_file(): ap.error(f'파일이 존재하지 않습니다: {args.file}')
    data=inspect(args.file, args.require_alpha)
    print(json.dumps(data, ensure_ascii=False, indent=2) if args.json else
          f"{data['file']}: {data['width']}x{data['height']} / 색 {data['visible_colors']}개 / 완전 투명 {data['transparent_pixels']}px / 문제 {data['issues']}")
    return 1 if data['issues'] else 0

if __name__=='__main__':
    sys.exit(main())
