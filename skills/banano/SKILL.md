---
name: banano
description: Generate, edit, and iterate images with Google's Nano Banana Pro / Gemini 3 Pro Image model through the Gemini Interactions API. Use when Codex needs high-quality text-to-image generation, image editing from reference images, brand/style/character/object consistency, accurate text rendering in images, Google Search-grounded image prompts, multi-turn image refinement with previous_interaction_id, interleaved text-and-image outputs, or direct access to Gemini image-generation API options.
---

# Banano

Use Nano Banana Pro (`gemini-3-pro-image`) as the default model for professional, highly detailed image work. Prefer this skill over generic image generation when the user asks for detailed prompts, exact text in images, reference-image editing, style transfer, brand consistency, or multi-turn iteration.

## Quick Start

Use the bundled CLI with `uv`:

```bash
uv run skills/banano/scripts/banano.py \
  --prompt "Create a cinematic product photo of..." \
  --aspect-ratio 16:9 \
  --image-size 4K \
  --output-dir ./banano-output
```

Read `GEMINI_API_KEY` from the process environment. Never print the key.

For editing or reference images:

```bash
uv run skills/banano/scripts/banano.py \
  --prompt "Put this logo on a high-end ad for banana scented perfume." \
  --image ./logo.png \
  --aspect-ratio 4:5 \
  --image-size 2K \
  --output-dir ./banano-output
```

For multi-turn iteration, pass the previous interaction ID returned by the first run:

```bash
uv run skills/banano/scripts/banano.py \
  --prompt "Translate the poster text to Spanish without changing layout." \
  --previous-interaction-id "v1_..." \
  --output-dir ./banano-output
```

## Workflow

1. Clarify output requirements only when needed: final use, aspect ratio, exact text, brand/reference constraints, and whether edits must preserve identity/layout.
2. Write a detailed prompt. For text in images, specify the exact text in quotes, approximate placement, font style, hierarchy, spacing, and any text that must not appear.
3. Use `banano.py` for API calls when a Gemini key is available. Use `--dry-run` to inspect request JSON without calling the API.
4. Save all generated image blocks, not only the last image. Nano Banana Pro can return interleaved text and images.
5. Return the output file paths and interaction ID. Keep the ID if the user may ask for follow-up edits.

## API Options

Read [references/gemini-image-api.md](references/gemini-image-api.md) when you need exact option names, model limits, response formats, or API citations.

The CLI exposes common options directly:

- `--model`: defaults to `gemini-3-pro-image`; use doc-current preview IDs only if the API rejects the stable alias.
- `--image PATH`: repeat for local reference/edit images. MIME type is inferred from the extension.
- `--image-json JSON`: repeat for exact image content blocks, including `uri`, custom `mime_type`, or `resolution`.
- `--response-format-json JSON`: pass exact Interactions `response_format`, including arrays for text+image output.
- `--aspect-ratio`, `--image-size`, `--mime-type`: convenience image response-format fields.
- `--generation-config-json JSON`: pass temperature, seed, top_p, max_output_tokens, thinking controls, or other generation config fields.
- `--thinking-level`: convenience generation-config field. For Nano Banana Pro, thinking is part of the model behavior; use this only when the API/model supports explicit control.
- `--google-search` and `--search-types`: add Google Search grounding for current facts or image search.
- `--tools-json JSON`: pass the exact `tools` array when custom tool declarations are needed.
- `--previous-interaction-id`: continue an image conversation.
- `--request-json JSON`: send a full Interactions API request body. This is the escape hatch for new API options.
- `--extra-json JSON`: merge additional top-level request fields such as `store`, `background`, `service_tier`, `webhook_config`, `cached_content`, `environment`, or future fields.

## Prompting Notes

Use highly specific, compositional prompts. Include subject, scene, camera or design language, materials, lighting, typography, exact text, constraints, and negative instructions. For brand or character work, attach references and state which image is for identity, object fidelity, character consistency, or style.

For factual or current visuals, enable Google Search grounding and ask the model to use search for the facts before generating the image.

For edits, be explicit about what must remain unchanged. Example: "Preserve the person's face, pose, clothing shape, and background perspective; only replace the sign text with..."

For interleaved output, request both text and images with `--response-format-json '[{"type":"text"},{"type":"image","aspect_ratio":"16:9","image_size":"2K"}]'` and iterate through all saved outputs.
