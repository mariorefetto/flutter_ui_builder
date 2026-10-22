"""Draws the application icon and writes it to the macOS asset catalog.

    python3 tool/generate_app_icon.py

The icon is a widget tree: a root node over two children, on a blue to
graphite tile with the rounded shape macOS expects.
"""

from PIL import Image, ImageDraw, ImageFilter

OUT = "macos/Runner/Assets.xcassets/AppIcon.appiconset"
SIZES = [16, 32, 64, 128, 256, 512, 1024]
SCALE = 2  # drawn at twice the size, then reduced, for smooth edges
BASE = 1024
TOP = (47, 128, 237)
BOTTOM = (18, 28, 51)
WHITE = (255, 255, 255)
SOFT = (170, 195, 240)


def lerp(a, b, t):
    return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3))


def tile(size):
    gradient = Image.new("RGB", (size, size))
    pixels = gradient.load()
    for y in range(size):
        color = lerp(TOP, BOTTOM, y / (size - 1))
        for x in range(size):
            pixels[x, y] = color
    margin = round(size * 0.098)
    radius = round(size * 0.225)
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (margin, margin, size - margin, size - margin), radius, fill=255
    )
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(gradient, (0, 0), mask)
    return out, margin


def glyph(size):
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    unit = size / BASE
    stroke = round(34 * unit)
    radius = round(54 * unit)

    def box(cx, cy, w, h, fill=None, outline=None):
        draw.rounded_rectangle(
            (cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2),
            radius,
            fill=fill,
            outline=outline,
            width=stroke,
        )

    cx = size / 2
    root_y, leaf_y = 400 * unit, 690 * unit
    left, right = 345 * unit, 679 * unit
    # connectors run from the bottom edge of the root to the top edge of each
    # leaf, in one solid colour so the overlaps do not show
    bus_y = 545 * unit
    root_bottom = root_y + 75 * unit
    leaf_top = leaf_y - 70 * unit
    for path in (
        [(cx, root_bottom), (cx, bus_y)],
        [(left, leaf_top), (left, bus_y), (right, bus_y), (right, leaf_top)],
    ):
        draw.line(path, fill=SOFT, width=stroke, joint="curve")
        for x, y in path:
            draw.ellipse(
                (x - stroke / 2, y - stroke / 2, x + stroke / 2, y + stroke / 2),
                fill=SOFT,
            )
    box(cx, root_y, 300 * unit, 150 * unit, fill=WHITE)
    box(left, leaf_y, 230 * unit, 140 * unit, outline=WHITE)
    box(right, leaf_y, 230 * unit, 140 * unit, outline=WHITE)
    return layer


def main():
    size = BASE * SCALE
    base, margin = tile(size)
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (margin, margin + 18 * SCALE, size - margin, size - margin + 18 * SCALE),
        round(size * 0.225),
        fill=(0, 0, 0, 90),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(14 * SCALE))
    canvas = Image.alpha_composite(shadow, base)
    canvas = Image.alpha_composite(canvas, glyph(size))
    for target in SIZES:
        canvas.resize((target, target), Image.LANCZOS).save(
            f"{OUT}/app_icon_{target}.png"
        )
    print("Wrote", ", ".join(str(s) for s in SIZES))


main()
