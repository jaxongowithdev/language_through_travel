#!/usr/bin/env python3
"""Vẽ các file icon gốc cho Nói Ngay.

Ý tưởng: một dạng sóng âm năm cột trắng trên nền gradient tím sang hồng. Sóng
âm là hình ảnh trực tiếp nhất của việc nói ra tiếng, và ở kích thước 40 điểm
ảnh trên màn hình chính nó vẫn đọc được, khác hẳn những icon có hình vẽ chi
tiết. Cột giữa cao nhất và bo tròn hai đầu, tạo nhịp giống một câu nói.

Toàn bộ hình vẽ bằng hình học thuần, không phụ thuộc file thiết kế nào, nên đổi
màu thương hiệu chỉ cần sửa vài hằng số ở đầu file rồi chạy lại:

    pip install pillow
    python3 tool/generate_icons.py     # 1. vẽ ảnh gốc vào assets/
    dart run flutter_launcher_icons    # 2. sinh icon cho mọi nền tảng

Bước 2 do gói flutter_launcher_icons lo, cấu hình nằm cuối pubspec.yaml. Script
này chỉ tạo ảnh gốc và không đụng tới android/ ios/ web/, nhờ vậy chỉ có một
nơi duy nhất quyết định tên file và kích thước cho từng nền tảng.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

# --- Tham số thiết kế ------------------------------------------------------

# Gradient nền, đi từ tím ở góc trên trái sang hồng ở góc dưới phải.
BG_TOP_LEFT = (124, 58, 237)      # #7C3AED
BG_MIDDLE = (168, 85, 247)        # #A855F7
BG_BOTTOM_RIGHT = (219, 39, 119)  # #DB2777

BAR = (255, 255, 255)
BAR_SOFT = (255, 228, 245)        # #FFE4F5 — hai cột ngoài cùng nhạt hơn

CANVAS = 1024
SUPERSAMPLE = 3  # vẽ ở 3072 px rồi thu nhỏ để mép cong thật mượt

# Năm cột sóng: (tỉ lệ chiều cao so với cạnh, màu).
BARS = (
    (0.30, BAR_SOFT),
    (0.52, BAR),
    (0.72, BAR),
    (0.52, BAR),
    (0.30, BAR_SOFT),
)
BAR_WIDTH = 0.084     # bề rộng một cột theo cạnh canvas
BAR_GAP = 0.052       # khoảng cách giữa hai cột

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / 'assets'
BRANDING = ROOT / 'branding'


# --- Vẽ --------------------------------------------------------------------


def _gradient(size: int) -> Image.Image:
    """Gradient chéo ba chặng từ trái trên xuống phải dưới."""
    small = 256
    grad = Image.new('RGB', (small, small))
    pixels = []
    max_d = (small - 1) * 2
    for y in range(small):
        for x in range(small):
            t = (x + y) / max_d
            if t < 0.5:
                k = t / 0.5
                a, b = BG_TOP_LEFT, BG_MIDDLE
            else:
                k = (t - 0.5) / 0.5
                a, b = BG_MIDDLE, BG_BOTTOM_RIGHT
            pixels.append(
                (
                    round(a[0] + (b[0] - a[0]) * k),
                    round(a[1] + (b[1] - a[1]) * k),
                    round(a[2] + (b[2] - a[2]) * k),
                )
            )
    grad.putdata(pixels)
    return grad.resize((size, size), Image.LANCZOS)


def _glow(size: int) -> Image.Image:
    """Quầng sáng mờ ở góc trên trái cho nền bớt phẳng."""
    layer = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(layer)
    r = size * 0.58
    draw.ellipse((-r * 0.4, -r * 0.5, r * 1.2, r * 1.0), fill=90)
    return layer.filter(ImageFilter.GaussianBlur(size * 0.16))


def _bar_boxes(size: int) -> list[tuple[tuple[float, float, float, float], tuple[int, int, int]]]:
    """Toạ độ năm cột sóng, căn giữa theo cả hai chiều."""
    width = size * BAR_WIDTH
    gap = size * BAR_GAP
    total = len(BARS) * width + (len(BARS) - 1) * gap
    left = (size - total) / 2
    middle = size / 2

    boxes = []
    for index, (ratio, color) in enumerate(BARS):
        x0 = left + index * (width + gap)
        height = size * ratio
        boxes.append((
            (x0, middle - height / 2, x0 + width, middle + height / 2),
            color,
        ))
    return boxes


def _draw_wave(size: int, colored: bool) -> Image.Image:
    """Lớp sóng âm trên nền trong suốt.

    [colored] tắt sẽ vẽ toàn bộ bằng trắng đặc, dùng cho lớp monochrome của
    Android 13 vì hệ thống chỉ đọc kênh alpha rồi tự tô lại màu.
    """
    layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    radius = size * BAR_WIDTH / 2
    for box, color in _bar_boxes(size):
        draw.rounded_rectangle(box, radius=radius, fill=(*(color if colored else BAR), 255))
    return layer


def _square(size: int) -> Image.Image:
    """Ảnh vuông đầy đủ: nền gradient cộng quầng sáng cộng sóng âm."""
    base = _gradient(size).convert('RGBA')
    white = Image.new('RGBA', (size, size), (255, 255, 255, 255))
    base = Image.composite(white, base, _glow(size).point(lambda v: v // 6))
    base.alpha_composite(_draw_wave(size, colored=True))
    return base


def _rounded(image: Image.Image, radius_ratio: float = 0.2237) -> Image.Image:
    """Bo góc theo tỉ lệ squircle của iOS (khoảng 22.37 phần trăm cạnh)."""
    size = image.size[0]
    mask = Image.new('L', (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size - 1, size - 1),
        radius=size * radius_ratio,
        fill=255,
    )
    out = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    out.paste(image, (0, 0), mask)
    return out


def _shrink(image: Image.Image) -> Image.Image:
    return image.resize((CANVAS, CANVAS), Image.LANCZOS)


def main() -> None:
    ASSETS.mkdir(exist_ok=True)
    BRANDING.mkdir(exist_ok=True)
    big = CANVAS * SUPERSAMPLE

    square = _square(big)

    # 1. Ảnh vuông đầy đủ — App Store, macOS, Windows, web.
    icon = _shrink(square)
    icon.convert('RGB').save(ASSETS / 'app_icon.png')

    # 2. Bản bo góc sẵn — Android API 25 trở xuống không tự bo.
    rounded = _shrink(_rounded(square))
    rounded.save(ASSETS / 'app_icon_rounded.png')

    # 3. Adaptive icon Android: nền và tiền cảnh là hai lớp rời.
    #    Lớp tiền cảnh phải tự chừa vùng an toàn 66 phần trăm ở giữa, vì
    #    pubspec đã đặt adaptive_icon_foreground_inset về 0.
    _shrink(_gradient(big).convert('RGBA')).convert('RGB').save(
        ASSETS / 'app_icon_background.png'
    )

    foreground = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    wave = _draw_wave(big, colored=True)
    safe = int(big * 0.66)
    foreground.alpha_composite(
        wave.resize((safe, safe), Image.LANCZOS),
        ((big - safe) // 2, (big - safe) // 2),
    )
    _shrink(foreground).save(ASSETS / 'app_icon_foreground.png')

    # 4. Themed icon Android 13+: bóng đặc, hệ thống tự tô màu theo hình nền.
    mono = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    mono.alpha_composite(
        _draw_wave(big, colored=False).resize((safe, safe), Image.LANCZOS),
        ((big - safe) // 2, (big - safe) // 2),
    )
    _shrink(mono).save(ASSETS / 'app_icon_monochrome.png')

    # 5. Bản xem trước để đính kèm hồ sơ App Store.
    icon.convert('RGB').save(BRANDING / 'icon-1024-square.png')
    rounded.save(BRANDING / 'icon-1024-rounded.png')
    rounded.resize((512, 512), Image.LANCZOS).save(
        BRANDING / 'icon-512-rounded.png'
    )
    rounded.resize((180, 180), Image.LANCZOS).save(
        BRANDING / 'icon-180-preview.png'
    )

    print('Da ve xong icon trong assets/ va branding/')


if __name__ == '__main__':
    main()
