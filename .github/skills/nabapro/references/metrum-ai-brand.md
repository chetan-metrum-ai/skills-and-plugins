# Metrum AI Brand Guide

Source of truth: [Metrum AI website](https://www.metrum.ai/). Refresh from the official site before production work when possible.

## Logo

- **White logo** (dark backgrounds): `assets/metrum-logo-white.png` (2244×405 RGBA)
- Preserve aspect ratio; do not redraw or recreate as text
- Keep clear space around the logo
- Use on title frames, closing frames, and hero visuals; avoid on content-heavy frames where it competes

## Color Palette

| Role | Value |
| --- | --- |
| Background | Near-black or black |
| Primary text | White |
| Secondary text | Restrained gray |
| Accent gradient | `#FF3132 → #FE005F → #EE0089 → #CC28AF → #9948CB → #465CDA` |

Do not introduce unrelated accent colors.

## Typography

| Role | Font | Notes |
| --- | --- | --- |
| Display headlines | **Geist** | Light or regular weight, tight tracking |
| Body copy | **Poppins** | Explanatory labels and body text |
| Technical labels | **Geist Mono** | Small uppercase, metadata, timestamps, CTAs; modest letter spacing |

Load fonts from the official site or use licensed local equivalents. Do not substitute a different visual family when a Metrum asset is available.

## Composition

- Thin technical rules, subtle grid/topology cues
- Square or minimally rounded UI elements
- Deliberate empty space
- Restrained motion: gentle opacity fades, short line reveals, data-flow motion
- Avoid: bouncy motion, cartoon illustration, glossy 3D, rounded consumer-app cards, generic template styles

## Usage in Nabapro

When generating images for Metrum AI, pass the white logo as a style reference:

```bash
uv run skills/nabapro/scripts/nabapro.py \
  --prompt "..." \
  --style-image skills/nabapro/assets/metrum-logo-white.png \
  ...
```

The `--brand` flag (default `metrum`) automatically includes this reference. Override with `--brand none` or `--brand /path/to/custom-brand.png` for a different brand system.
