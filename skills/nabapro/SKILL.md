---
name: nabapro
description: Use this skill when the user needs to generate, edit, or iterate on images with Google's Gemini image-generation API (Nano Banana Pro). Trigger on requests for product visuals, brand/campaign imagery, text-in-image rendering, reference-based editing, style transfer, video-to-image, multi-turn refinement, or any Gemini image workflow.
---

# Nabapro

Use `gemini-3-pro-image` (Nano Banana Pro) as the default model. This skill bundles a CLI that wraps the Gemini Interactions API. Use `--dry-run` to inspect the request JSON before any API call.

## Workflow

1. **Clarify requirements** — Final use, aspect ratio, exact textual content, brand/reference constraints, and whether edits must preserve identity/layout.
2. **Research (if needed)** — For factual/current visuals, enable Google Search grounding with `--google-search --search-types web_search,image_search` and use model preset `flash`.
3. **Draft the prompt** — Highly specific and compositional: subject, scene, camera/design language, materials, lighting, typography, exact text in quotes, constraints, negative instructions. For edits, state what must remain unchanged.
4. **Run with `--dry-run` first** — Inspect the request JSON before any paid API call.
5. **Run with `nabapro.py`** (see Quick Start) — Use `--previous-interaction-id` for follow-up turns. Save all returned images, not only the last one. Also save thought, citation, and Google Search suggestion artifacts.
6. **Return results** — Output file paths, the interaction ID (in case of follow-up), and any saved artifacts. Never print the `GEMINI_API_KEY`.

## Quick Start

```bash
uv run skills/nabapro/scripts/nabapro.py --help
uv run skills/nabapro/scripts/nabapro.py \
  --prompt "A cinematic product photo..." \
  --aspect-ratio 16:9 --image-size 4K \
  --output-dir ./nabapro-output --dry-run
```

Pass `--image PATH` for reference edits, `--object-image / --character-image / --style-image` for role-specific references, `--model-preset flash` for high-throughput, and `--previous-interaction-id` for multi-turn.

Read `GEMINI_API_KEY` from the process environment. Never print the key.

## Key constraints

- **Video-to-image** requires `--model-preset flash`. If the API rejects with "Audio input modality is not enabled", retry a local video with `--strip-video-audio`.
- **Multi-turn** — Keep the returned interaction ID. Pass `--previous-interaction-id` for follow-up edits.
- **Image rights** — Verify the user has rights to uploaded images. Avoid deceptive or infringing transformations.

## Reference

- `scripts/nabapro.py` — Full CLI options via `--help`
- `references/gemini-image-api.md` — Model limits, request/response schemas, and API options
