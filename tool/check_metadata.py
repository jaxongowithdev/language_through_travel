#!/usr/bin/env python3
"""Kiểm tra metadata App Store trước khi nộp.

App Store Connect từ chối cả bản nộp nếu một trường vượt giới hạn ký tự, mà
báo lỗi thì mơ hồ. Script này đếm trước, ngay trên máy.

    python3 tool/check_metadata.py

Đếm theo ký tự Unicode đã chuẩn hoá NFC — đúng cách Apple đếm, nên "ữ" tính
là một ký tự chứ không phải hai.
"""

from __future__ import annotations

import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
METADATA = ROOT / 'fastlane' / 'metadata'

# Giới hạn ký tự của App Store Connect.
LIMITS = {
    'name.txt': 30,
    'subtitle.txt': 30,
    'keywords.txt': 100,
    'promotional_text.txt': 170,
    'description.txt': 4000,
    'release_notes.txt': 4000,
    'support_url.txt': 255,
    'marketing_url.txt': 255,
    'privacy_url.txt': 255,
}

REQUIRED = ['name.txt', 'subtitle.txt', 'keywords.txt', 'description.txt']

GREEN, YELLOW, RED, DIM, RESET = (
    '\033[32m', '\033[33m', '\033[31m', '\033[2m', '\033[0m'
)


def length(text: str) -> int:
    return len(unicodedata.normalize('NFC', text.strip()))


def check_locale(folder: Path) -> list[str]:
    problems: list[str] = []
    print(f'\n{folder.name}')

    for name in REQUIRED:
        if not (folder / name).exists():
            problems.append(f'{folder.name}/{name}: thiếu file bắt buộc')

    for path in sorted(folder.glob('*.txt')):
        limit = LIMITS.get(path.name)
        text = path.read_text(encoding='utf-8')
        n = length(text)

        if limit is None:
            print(f'  {DIM}{path.name:<22} {n:>5}   (không giới hạn){RESET}')
            continue

        if n > limit:
            colour, mark = RED, '✗'
            problems.append(f'{folder.name}/{path.name}: {n}/{limit} ký tự — thừa {n - limit}')
        elif n > limit * 0.95:
            colour, mark = YELLOW, '!'
        else:
            colour, mark = GREEN, '✓'
        print(f'  {colour}{mark} {path.name:<20} {n:>5}/{limit}{RESET}')

        if path.name == 'keywords.txt':
            problems.extend(check_keywords(folder.name, text))

    return problems


def check_keywords(locale: str, raw: str) -> list[str]:
    """Trường keywords có vài cái bẫy nhỏ nhưng tốn một vòng review."""
    problems: list[str] = []
    text = raw.strip()

    if ', ' in text:
        problems.append(
            f'{locale}/keywords.txt: có khoảng trắng sau dấu phẩy — mỗi dấu cách '
            'ăn mất một ký tự của hạn mức 100'
        )

    words = [w.strip() for w in text.split(',') if w.strip()]
    seen: set[str] = set()
    for word in words:
        low = word.lower()
        if low in seen:
            problems.append(f'{locale}/keywords.txt: từ khoá lặp "{word}"')
        seen.add(low)

    print(f'    {DIM}{len(words)} từ khoá{RESET}')
    return problems


def main() -> int:
    if not METADATA.exists():
        print(f'Không thấy {METADATA}')
        return 1

    locales = sorted(p for p in METADATA.iterdir() if p.is_dir())
    if not locales:
        print('Chưa có thư mục locale nào trong fastlane/metadata/')
        return 1

    problems: list[str] = []
    for folder in locales:
        problems.extend(check_locale(folder))

    print()
    if problems:
        print(f'{RED}Còn {len(problems)} vấn đề:{RESET}')
        for item in problems:
            print(f'  • {item}')
        return 1

    print(f'{GREEN}Mọi trường đều nằm trong giới hạn của App Store.{RESET}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
