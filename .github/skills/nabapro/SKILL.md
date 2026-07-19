---
name: nabapro
description: Use this skill when the user needs to generate, edit, or iterate on images
  with Google's Gemini image-generation API (Nano Banana Pro). Trigger on requests
  for product visuals, brand/campaign imagery, text-in-image rendering, reference-based
  editing, style transfer, video-to-image, multi-turn refinement, or any Gemini image
  workflow. Applies Metrum AI branding by default unless the user provides another
  brand.
metadata:
  oasr:
    hash: sha256:e764a9c9d941542936fbee1237ae575a531e601b5d936e758a9a903c08fa666b
    source: skills/nabapro
    synced: 'generated'
---

# Nabapro

Use `gemini-3-pro-image` (Nano Banana Pro) as the default model. This skill bundles a CLI that wraps the Gemini Interactions API. Use `--dry-run` to inspect the request JSON before any API call.

## Brand

By default nabapro injects the [Metrum AI logo](assets/metrum-logo-white.png) as a style reference. This gives generated images the correct brand look. Read [`references/metrum-ai-brand.md`](references/metrum-ai-brand.md) for the full brand guide (colors, typography, composition).

Control with `--brand`:

| Value | Behavior |
| --- | --- |
| `metrum` (default) | Auto-inject the bundled Metrum logo as a style reference |
| `none` / `off` | No brand reference — fully custom |
| `/path/to/logo.png` | Use a custom logo as a style reference |
| `--no-brand-style` | Skip brand injection even when `--brand` is set |

When the user requests a different brand or no brand, respect their choice. Pass `--brand none` and adjust the prompt accordingly.

## Workflow

1. **Clarify requirements** — Final use, aspect ratio, exact textual content, brand/reference constraints, and whether edits must preserve identity/layout. If brand is not mentioned, use Metrum by default. If the user specifies a different brand, pass `--brand none` and describe the brand in the prompt instead.
2. **Research (if needed)** — For factual/current visuals, enable Google Search grounding with `--google-search --search-types web_search,image_search` and use model preset `flash`.
3. **Draft the prompt** — Highly specific and compositional: subject, scene, camera/design language, materials, lighting, typography, exact text in quotes, constraints, negative instructions. For edits, state what must remain unchanged. For brand work, reference the brand guide; for custom work, describe the requested aesthetic explicitly.
4. **Run with `--dry-run` first** — Inspect the request JSON before any paid API call.
5. **Run with `nabapro.py`** (see Quick Start) — Use `--previous-interaction-id` for follow-up turns. Save all returned images, not only the last one. Also save thought, citation, and Google Search suggestion artifacts.
6. **Return results** — Output file paths, the interaction ID (in case of follow-up), and any saved artifacts. Never print the `GEMINI_API_KEY`.

## Quick Start

```bash
uv run skills/nabapro/scripts/nabapro.py --help

# Default: Metrum-branded image
uv run skills/nabapro/scripts/nabapro.py \
  --prompt "A cinematic product photo..." \
  --aspect-ratio 16:9 --image-size 4K \
  --output-dir ./nabapro-output --dry-run

# No brand — fully custom look
uv run skills/nabapro/scripts/nabapro.py \
  --brand none \
  --prompt "A minimalist Apple-style product shot, white background..." \
  --aspect-ratio 16:9 --image-size 4K \
  --output-dir ./nabapro-output

# Editing an existing image with Metrum branding applied
uv run skills/nabapro/scripts/nabapro.py \
  --prompt "Put this logo on a high-end ad for a futuristic product." \
  --image ./existing-design.png \
  --aspect-ratio 4:5 --image-size 2K \
  --output-dir ./nabapro-output
```

Read `GEMINI_API_KEY` from the process environment. Never print the key.

Set `--model-preset flash` for high-throughput or video-to-image. Use `--previous-interaction-id` for multi-turn edits.

## Key constraints

- **Video-to-image** requires `--model-preset flash`. If the API rejects with "Audio input modality is not enabled", retry a local video with `--strip-video-audio`.
- **Multi-turn** — Keep the returned interaction ID. Pass `--previous-interaction-id` for follow-up edits.
- **Image rights** — Verify the user has rights to uploaded images. Avoid deceptive or infringing transformations.

## Reference

- `scripts/nabapro.py` — Full CLI options via `--help`
- `references/gemini-image-api.md` — Model limits, request/response schemas, and API options
- `references/metrum-ai-brand.md` — Metrum AI brand guide (colors, typography, composition, logo usage)
- `assets/metrum-logo-white.png` — Bundled white logo for style injection
