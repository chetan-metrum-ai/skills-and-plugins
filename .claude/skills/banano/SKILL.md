---
name: banano
description: Generate, edit, and iterate images with Google's Nano Banana Pro / Gemini
  3 Pro Image model through the Gemini Interactions API. Use when Codex needs high-quality
  text-to-image generation, image editing from reference images, brand/style/character/object
  consistency, accurate text rendering in images, Google Search-grounded image prompts,
  multi-turn image refinement with previous_interaction_id, interleaved text-and-image
  outputs, or direct access to Gemini image-generation API options.
metadata:
  oasr:
    hash: sha256:69874dfaf3a9f1c3334f2fc9c38db7879cc7f69ead80ac427ce28a117a7d1d8e
    source: skills/banano
    synced: 'generated'
---

# Banano

Use Nano Banana Pro (`gemini-3-pro-image`) as the default model for professional, highly detailed image work. Prefer this skill over generic image generation when the user asks for detailed prompts, exact text in images, reference-image editing, style transfer, brand consistency, or multi-turn iteration.

Banano intentionally defaults to `gemini-3-pro-image`. Use `--model-preset flash` only when speed/generalist throughput matters more than the pro model's precision, or `--model-preset lite` for simple 1K-only work.

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

For role-specific references:

```bash
uv run skills/banano/scripts/banano.py \
  --prompt "Create a campaign hero image with this product, this person, and this visual style." \
  --object-image ./product.png \
  --character-image ./person.png \
  --style-image ./style-board.png \
  --aspect-ratio 16:9 \
  --image-size 4K \
  --output-dir ./banano-output
```

For video-to-image prompts with Gemini 3.1 Flash Image:

```bash
uv run skills/banano/scripts/banano.py \
  --model-preset flash \
  --video-uri "https://www.youtube.com/watch?v=..." \
  --prompt "Generate a cinematic poster image that captures the key themes of this video." \
  --aspect-ratio 16:9 \
  --output-dir ./banano-output
```

If a video call fails with "Audio input modality is not enabled for this model", retry local videos with `--strip-video-audio`. Public YouTube URLs are documented by Google as supported for `gemini-3.1-flash-image`, but the live API can reject videos when it tries to process audio; use a local silent/no-audio video or a Files API video URI when that happens.

If the user specifically wants a YouTube URL to work and the direct URL fails, suggest optionally downloading a video-only or no-audio MP4 with `yt-dlp`, then passing it as a local video:

```bash
uvx yt-dlp -f "bv*[ext=mp4][height<=720]/bv*" \
  -o /tmp/banano-youtube-video.%(ext)s \
  "https://www.youtube.com/watch?v=..."

uv run skills/banano/scripts/banano.py \
  --model-preset flash \
  --video /tmp/banano-youtube-video.mp4 \
  --strip-video-audio \
  --prompt "Generate a poster image that captures the key themes of this video." \
  --aspect-ratio 16:9 \
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
5. Also return saved thought, citation, and Google Search suggestion artifacts when present.
6. Return the output file paths and interaction ID. Keep the ID if the user may ask for follow-up edits.

## API Options

Read [references/gemini-image-api.md](references/gemini-image-api.md) when you need exact option names, model limits, response formats, or API citations.

The CLI exposes common options directly:

- `--model`: defaults to `gemini-3-pro-image`; use doc-current preview IDs only if the API rejects the stable alias.
- `--model-preset`: shortcut for `pro`, `flash`, `lite`, or `legacy`. `pro` maps to `gemini-3-pro-image`.
- `--image PATH`: repeat for local reference/edit images. MIME type is inferred from the extension.
- `--object-image PATH`, `--character-image PATH`, `--style-image PATH`: repeatable role-specific references. The CLI inserts role guidance text and validates current model limits.
- `--image-json JSON`: repeat for exact image content blocks, including `uri`, custom `mime_type`, or `resolution`.
- `--video PATH`: local video reference block for small videos. Prefer Files API or `--video-json` for large videos.
- `--strip-video-audio`: remove audio from local `--video` inputs with `ffmpeg` before uploading. Use this when `gemini-3.1-flash-image` rejects a video with an audio-modality error.
- `--video-uri URI`: public video URI, such as a YouTube URL, for video-to-image workflows.
- `--video-json JSON`: exact video content block, including Files API URIs.
- `--response-format-json JSON`: pass exact Interactions `response_format`, including arrays for text+image output.
- `--aspect-ratio`, `--image-size`, `--mime-type`: convenience image response-format fields.
- `--generation-config-json JSON`: pass temperature, seed, top_p, max_output_tokens, thinking controls, or other generation config fields.
- `--thinking-level`: convenience generation-config field. For `gemini-3.1-flash-image`, supported values are `minimal` and `high`.
- `--google-search` and `--search-types`: add Google Search grounding for current facts or image search.
- `--tools-json JSON`: pass the exact `tools` array when custom tool declarations are needed.
- `--previous-interaction-id`: continue an image conversation.
- `--request-json JSON`: send a full Interactions API request body. This is the escape hatch for new API options.
- `--extra-json JSON`: merge additional top-level request fields such as `store`, `background`, `service_tier`, `webhook_config`, `cached_content`, `environment`, or future fields.

## Prompting Notes

Use highly specific, compositional prompts. Include subject, scene, camera or design language, materials, lighting, typography, exact text, constraints, and negative instructions. For brand or character work, attach references and state which image is for identity, object fidelity, character consistency, or style.

For factual or current visuals, enable Google Search grounding and ask the model to use search for the facts before generating the image. When using image search grounding, use `--model-preset flash --google-search --search-types web_search,image_search` and preserve the saved search suggestion/citation files.

For edits, be explicit about what must remain unchanged. Example: "Preserve the person's face, pose, clothing shape, and background perspective; only replace the sign text with..."

For interleaved output, request both text and images with `--response-format-json '[{"type":"text"},{"type":"image","aspect_ratio":"16:9","image_size":"2K"}]'` and iterate through all saved outputs.

For image edits, make sure the user has rights to the uploaded images and avoid deceptive, infringing, harassing, or harmful transformations.

## Model Limits

- `gemini-3-pro-image` default: `1K`, `2K`, `4K`; up to 14 reference images total, with up to 6 object, 5 character, and 3 style references.
- `gemini-3.1-flash-image`: `512`, `1K`, `2K`, `4K`; up to 14 references, with up to 10 object and 4 character references; supports Google Image Search grounding and video-to-image.
- `gemini-3.1-flash-lite-image`: `1K` only; simple, fast, low-cost work; no Google Search grounding.
- `gemini-2.5-flash-image`: legacy Nano Banana model.

For large batch jobs, use the Gemini Batch API rather than looping foreground calls through this CLI.
