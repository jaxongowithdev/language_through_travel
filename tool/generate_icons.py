#!/usr/bin/env python3
"""Vẽ các file icon gốc cho Language Through Travel.

Ý tưởng: một bong bóng hội thoại trắng đặt trên nền gradient xanh biển, bên
trong là chiếc máy bay giấy đang cất cánh — ngôn ngữ (bong bóng) gặp du lịch
(máy bay). Hình vẽ hoàn toàn bằng hình học nên sửa màu hay tỉ lệ chỉ cần đổi
hằng số ở đầu file, không phụ thuộc file thiết kế nào.

Quy trình hai bước:

    pip install pillow
    python3 tool/generate_icons.py     # 1. vẽ ảnh gốc vào assets/
    dart run flutter_launcher_icons    # 2. sinh icon cho mọi nền tảng

Bước 2 do gói `flutter_launcher_icons` lo (cấu hình nằm cuối pubspec.yaml).
Script này chỉ tạo ảnh gốc, không đụng tới android/ ios/ web/ — nhờ vậy chỉ có
một nơi duy nhất quyết định tên file và kích thước cho từng nền tảng, và bộ
icon luôn cập nhật theo phiên bản Flutter mới.

Nếu muốn bỏ qua gói kia và ghi thẳng vào các thư mục nền tảng (ví dụ máy CI
không chạy được `dart run`):

    python3 tool/generate_icons.py --platforms
"""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

# --- Tham số thiết kế ------------------------------------------------------

# Gradient nền, lấy quanh màu seed #0EA5E9 của app (lib/theme.dart).
BG_TOP_LEFT = (56, 189, 248)      # #38BDF8
BG_BOTTOM_RIGHT = (2, 110, 173)   # #026EAD

BUBBLE = (255, 255, 255)
PLANE_LIGHT = (56, 189, 248)      # #38BDF8 — cánh trên
PLANE_DARK = (2, 132, 199)        # #0284C7 — cánh dưới
TRAIL = (186, 230, 253)           # #BAE6FD — vệt bay

# Toàn bộ toạ độ bên dưới nằm trên khung 1024×1024 rồi được nhân lên khi vẽ.
CANVAS = 1024
SUPERSAMPLE = 3  # vẽ ở 3072 px rồi thu nhỏ để có viền mượt

ROOT = Path(__file__).resolve().parent.parent


# --- Vẽ --------------------------------------------------------------------


def _gradient(size: int) -> Image.Image:
    """Gradient chéo từ trái-trên xuống phải-dưới."""
    small = 256
    grad = Image.new('RGB', (small, small))
    pixels = []
    max_d = (small - 1) * 2
    for y in range(small):
        for x in range(small):
            t = (x + y) / max_d
            pixels.append(
                (
                    round(BG_TOP_LEFT[0] + (BG_BOTTOM_RIGHT[0] - BG_TOP_LEFT[0]) * t),
                    round(BG_TOP_LEFT[1] + (BG_BOTTOM_RIGHT[1] - BG_TOP_LEFT[1]) * t),
                    round(BG_TOP_LEFT[2] + (BG_BOTTOM_RIGHT[2] - BG_TOP_LEFT[2]) * t),
                )
            )
    grad.putdata(pixels)
    return grad.resize((size, size), Image.LANCZOS)


def _glow(size: int) -> Image.Image:
    """Vệt sáng mờ ở góc trên-trái cho nền bớt phẳng."""
    layer = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(layer)
    r = size * 0.55
    draw.ellipse(
        (-r * 0.35, -r * 0.45, r * 1.25, r * 1.05),
        fill=70,
    )
    return layer.filter(ImageFilter.GaussianBlur(size * 0.09))


def _scale(points, k: float):
    return [(x * k, y * k) for x, y in points]


def _draw_art(size: int, art_scale: float = 1.0) -> Image.Image:
    """Bong bóng + máy bay trên nền trong suốt.

    [art_scale] < 1 dùng cho icon adaptive của Android, nơi hình phải nằm gọn
    trong vùng an toàn 66% ở giữa vì launcher có thể cắt thành hình tròn.
    """
    k = size / CANVAS
    layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)

    # Bong bóng thoại: thân bo tròn + đuôi nhọn phía dưới bên trái.
    body = (196 * k, 226 * k, 828 * k, 706 * k)
    radius = 112 * k
    tail = _scale([(322, 690), (300, 838), (452, 706)], k)

    # Bóng đổ nhẹ để bong bóng nổi khỏi nền.
    shadow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(shadow)
    offset = 18 * k
    sdraw.rounded_rectangle(
        (body[0], body[1] + offset, body[2], body[3] + offset),
        radius=radius,
        fill=(2, 60, 100, 90),
    )
    sdraw.polygon([(x, y + offset) for x, y in tail], fill=(2, 60, 100, 90))
    shadow = shadow.filter(ImageFilter.GaussianBlur(22 * k))
    layer.alpha_composite(shadow)

    draw.rounded_rectangle(body, radius=radius, fill=BUBBLE)
    draw.polygon(tail, fill=BUBBLE)

    # Vệt bay: hai gạch bo tròn phía sau đuôi máy bay.
    for (x1, y1, x2, y2), width in (
        ((292, 592, 392, 592), 26),
        ((330, 660, 398, 660), 22),
    ):
        draw.line(
            _scale([(x1, y1), (x2, y2)], k),
            fill=TRAIL,
            width=round(width * k),
        )
        # Bo hai đầu gạch.
        for cx, cy in ((x1, y1), (x2, y2)):
            r = width * k / 2
            draw.ellipse((cx * k - r, cy * k - r, cx * k + r, cy * k + r), fill=TRAIL)

    # Máy bay giấy: hai đa giác ghép lại thành nếp gấp ở giữa.
    tip = (726, 316)
    left = (330, 486)
    fold = (498, 556)
    bottom = (566, 690)
    draw.polygon(_scale([tip, left, fold], k), fill=PLANE_LIGHT)
    draw.polygon(_scale([tip, fold, bottom], k), fill=PLANE_DARK)

    if art_scale != 1.0:
        inner = max(1, round(size * art_scale))
        shrunk = layer.resize((inner, inner), Image.LANCZOS)
        layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        pos = (size - inner) // 2
        layer.alpha_composite(shrunk, (pos, pos))

    return layer


def _draw_monochrome(size: int, art_scale: float = 1.0) -> Image.Image:
    """Bản một màu cho themed icon của Android 13+.

    Android chỉ đọc kênh alpha rồi tự tô màu theo hình nền của người dùng, nên
    hình phải là bóng đặc: bong bóng là khối, máy bay là lỗ khoét xuyên qua.
    Tô cả hai cùng một màu sẽ ra một cục vô nghĩa.
    """
    k = size / CANVAS
    layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)

    draw.rounded_rectangle(
        (196 * k, 226 * k, 828 * k, 706 * k),
        radius=112 * k,
        fill=(255, 255, 255, 255),
    )
    draw.polygon(_scale([(322, 690), (300, 838), (452, 706)], k),
                 fill=(255, 255, 255, 255))

    # Khoét máy bay ra khỏi bong bóng.
    plane = _scale([(726, 316), (330, 486), (498, 556), (566, 690)], k)
    draw.polygon(plane, fill=(0, 0, 0, 0))

    if art_scale != 1.0:
        inner = max(1, round(size * art_scale))
        shrunk = layer.resize((inner, inner), Image.LANCZOS)
        layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        pos = (size - inner) // 2
        layer.alpha_composite(shrunk, (pos, pos))

    return layer


def render(size: int, *, corner: float = 0.0, art_scale: float = 1.0,
           background: bool = True, art: bool = True,
           monochrome: bool = False) -> Image.Image:
    """Dựng icon ở [size] px.

    corner  — bán kính bo góc theo tỉ lệ cạnh (0 = vuông, dùng cho iOS).
    art_scale — thu nhỏ phần hình vẽ (dùng cho adaptive icon Android).
    """
    s = size * SUPERSAMPLE
    canvas = Image.new('RGBA', (s, s), (0, 0, 0, 0))

    if background:
        bg = _gradient(s).convert('RGBA')
        white = Image.new('RGBA', (s, s), (255, 255, 255, 255))
        bg = Image.composite(white, bg, _glow(s).point(lambda v: v // 3))
        canvas.alpha_composite(bg)

    if monochrome:
        canvas.alpha_composite(_draw_monochrome(s, art_scale))
    elif art:
        canvas.alpha_composite(_draw_art(s, art_scale))

    if corner > 0:
        mask = Image.new('L', (s, s), 0)
        ImageDraw.Draw(mask).rounded_rectangle(
            (0, 0, s - 1, s - 1), radius=round(s * corner), fill=255
        )
        canvas.putalpha(ImageChops.multiply(canvas.getchannel('A'), mask))

    return canvas.resize((size, size), Image.LANCZOS)


# --- Xuất file -------------------------------------------------------------


def _save(image: Image.Image, path: Path, *, flatten: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    out = image
    if flatten:
        # App Store từ chối icon có kênh alpha.
        base = Image.new('RGB', out.size, BG_BOTTOM_RIGHT)
        base.paste(out, mask=out.getchannel('A'))
        out = base
    out.save(path, 'PNG')
    print(f'  {path.relative_to(ROOT)}')


IOS_ICONS = [
    ('Icon-App-20x20@1x.png', 20),
    ('Icon-App-20x20@2x.png', 40),
    ('Icon-App-20x20@3x.png', 60),
    ('Icon-App-29x29@1x.png', 29),
    ('Icon-App-29x29@2x.png', 58),
    ('Icon-App-29x29@3x.png', 87),
    ('Icon-App-40x40@1x.png', 40),
    ('Icon-App-40x40@2x.png', 80),
    ('Icon-App-40x40@3x.png', 120),
    ('Icon-App-60x60@2x.png', 120),
    ('Icon-App-60x60@3x.png', 180),
    ('Icon-App-76x76@1x.png', 76),
    ('Icon-App-76x76@2x.png', 152),
    ('Icon-App-83.5x83.5@2x.png', 167),
    ('Icon-App-1024x1024@1x.png', 1024),
]

# Kích thước ic_launcher.png theo mật độ màn hình (dp × hệ số).
ANDROID_LEGACY = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

# Adaptive icon vẽ trên khung 108dp, launcher chỉ hiện 72dp ở giữa.
ANDROID_ADAPTIVE = {
    'mipmap-mdpi': 108,
    'mipmap-hdpi': 162,
    'mipmap-xhdpi': 216,
    'mipmap-xxhdpi': 324,
    'mipmap-xxxhdpi': 432,
}

ADAPTIVE_XML = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_foreground" />
</adaptive-icon>
"""


def write_assets() -> None:
    """Ảnh gốc mà flutter_launcher_icons đọc, cộng file dùng cho App Store."""
    print('assets/ — ảnh gốc cho flutter_launcher_icons')
    assets = ROOT / 'assets'
    # Vuông, không alpha: iOS, web, Windows, macOS đều tự bo góc theo cách riêng.
    _save(render(1024), assets / 'app_icon.png', flatten=True)
    # Bo góc sẵn cho icon Android đời cũ (API ≤ 25, không có adaptive icon).
    _save(render(1024, corner=0.2237), assets / 'app_icon_rounded.png')
    # Hai lớp của adaptive icon, vẽ trên khung 108dp với vùng an toàn 66%.
    _save(render(1024, art=False), assets / 'app_icon_background.png')
    _save(render(1024, background=False, art_scale=0.66),
          assets / 'app_icon_foreground.png')
    _save(render(1024, background=False, monochrome=True, art_scale=0.66),
          assets / 'app_icon_monochrome.png')

    print('branding/ — file dùng cho App Store Connect và ảnh quảng bá')
    branding = ROOT / 'branding'
    _save(render(1024), branding / 'icon-1024-square.png', flatten=True)
    _save(render(1024, corner=0.2237), branding / 'icon-1024-rounded.png')
    _save(render(512, corner=0.2237), branding / 'icon-512-rounded.png')


def write_platforms() -> None:
    """Ghi thẳng vào thư mục nền tảng — chỉ dùng khi không chạy được gói kia."""
    print('iOS')
    ios = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    for name, size in IOS_ICONS:
        _save(render(size), ios / name, flatten=True)

    print('Android — icon truyền thống')
    res = ROOT / 'android/app/src/main/res'
    for folder, size in ANDROID_LEGACY.items():
        _save(render(size, corner=0.2237), res / folder / 'ic_launcher.png')

    print('Android — adaptive icon')
    for folder, size in ANDROID_ADAPTIVE.items():
        _save(render(size, art=False), res / folder / 'ic_launcher_background.png')
        _save(
            render(size, background=False, art_scale=0.66),
            res / folder / 'ic_launcher_foreground.png',
        )
    xml_dir = res / 'mipmap-anydpi-v26'
    xml_dir.mkdir(parents=True, exist_ok=True)
    (xml_dir / 'ic_launcher.xml').write_text(ADAPTIVE_XML, encoding='utf-8')
    print(f'  {(xml_dir / "ic_launcher.xml").relative_to(ROOT)}')

    print('Web')
    web = ROOT / 'web'
    _save(render(192, corner=0.2237), web / 'icons/Icon-192.png')
    _save(render(512, corner=0.2237), web / 'icons/Icon-512.png')
    # Maskable: launcher cắt tới 20% mỗi cạnh nên hình phải co lại.
    _save(render(192, art_scale=0.7), web / 'icons/Icon-maskable-192.png')
    _save(render(512, art_scale=0.7), web / 'icons/Icon-maskable-512.png')
    _save(render(64, corner=0.2237), web / 'favicon.png')


def main() -> None:
    platforms = '--platforms' in sys.argv

    write_assets()
    if platforms:
        write_platforms()

    print()
    if platforms:
        print('Đã ghi thẳng vào android/ ios/ web/ — không cần chạy '
              'flutter_launcher_icons nữa.')
    else:
        print('Bước tiếp theo:  dart run flutter_launcher_icons')
    print('Nhớ `flutter clean` nếu icon cũ còn nằm trong build cache.')


if __name__ == '__main__':
    main()
