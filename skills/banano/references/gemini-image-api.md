# Gemini Image API Reference

Current source: <https://ai.google.dev/gemini-api/docs/image-generation> and <https://ai.google.dev/api/interactions-api>, checked while creating this skill.

## Preferred API

Use the Gemini Interactions API for current image-generation features:

```http
POST https://generativelanguage.googleapis.com/v1beta/interactions
x-goog-api-key: $GEMINI_API_KEY
Content-Type: application/json
```

Use the `GEMINI_API_KEY` environment variable. Do not print it.

Core request fields:

- `model`: use `gemini-3-pro-image` for Nano Banana Pro unless the API requires the current preview ID (`gemini-3-pro-image-preview` in the API reference at creation time).
- `input`: string or content blocks. Content blocks include text and image blocks.
- `response_format`: image output format object or an array such as `[{"type":"text"},{"type":"image"}]`.
- `generation_config`: model controls such as `temperature`, `top_p`, `seed`, `stop_sequences`, `thinking_level`, `thinking_summaries`, and `max_output_tokens`.
- `tools`: tool declarations, including `{"type":"google_search"}`.
- `previous_interaction_id`: continue a prior image interaction.
- `response_modalities`: requested modalities such as `text` and `image`.
- Other top-level fields include `system_instruction`, `stream`, `store`, `background`, `cached_content`, `environment`, `service_tier`, and `webhook_config`.

## Models

- Nano Banana Pro / Gemini 3 Pro Image: `gemini-3-pro-image`. Premium model for complex visual tasks, professional asset production, advanced localization, brand consistency, precision creative control, 4K output, Google Search grounding, and complex multi-turn editing.
- Nano Banana 2 / Gemini 3.1 Flash Image: `gemini-3.1-flash-image`. Faster generalist image model.
- Nano Banana 2 Lite / Gemini 3.1 Flash Lite Image: `gemini-3.1-flash-lite-image`. Fastest and cheapest Gemini image model; not optimized for multiple references or sequential editing.
- Nano Banana / Gemini 2.5 Flash Image: `gemini-2.5-flash-image`. Legacy Nano Banana series model.

All generated images include a SynthID watermark.

## Input Blocks

Text block:

```json
{"type": "text", "text": "Create a detailed image..."}
```

Image block:

```json
{"type": "image", "data": "BASE64_ENCODED_IMAGE", "mime_type": "image/png"}
```

Image blocks may also use `uri` instead of `data` where supported:

```json
{"type": "image", "uri": "https://example.com/reference.png", "mime_type": "image/png"}
```

Supported image input MIME types in the Interactions API reference include `image/png`, `image/jpeg`, `image/webp`, `image/heic`, `image/heif`, `image/gif`, `image/bmp`, and `image/tiff`. Image input blocks also support a `resolution` hint: `low`, `medium`, `high`, or `ultra_high`.

Gemini 3 image workflows support up to 14 total reference images. Nano Banana Pro supports high-fidelity reference use for up to 6 object images, up to 5 character-consistency images, and up to 3 style-reference images within that total.

## Output Format

Image response format:

```json
{
  "type": "image",
  "mime_type": "image/jpeg",
  "aspect_ratio": "16:9",
  "image_size": "4K"
}
```

Supported image output fields:

- `type`: always `image`.
- `mime_type`: `image/jpeg`.
- `aspect_ratio`: `1:1`, `2:3`, `3:2`, `3:4`, `4:3`, `4:5`, `5:4`, `9:16`, `16:9`, `21:9`, `1:8`, `8:1`, `1:4`, `4:1`.
- `image_size`: `512`, `1K`, `2K`, `4K`. Use uppercase `K`; lowercase values can be rejected. Nano Banana Pro supports up to 4K.

Text+image interleaved output:

```json
[
  {"type": "text"},
  {"type": "image", "aspect_ratio": "16:9", "image_size": "2K"}
]
```

Do not rely only on SDK convenience properties such as `output_image` for interleaved output. Iterate through returned `steps[].content[]` and save every image block.

## Google Search Grounding

Use:

```json
{"type": "google_search"}
```

Optional `search_types` values include `web_search`, `image_search`, and `enterprise_web_search`. Use grounding when the prompt depends on current weather, recent events, stock charts, maps, factual visual details, or current reference imagery.

## Multi-Turn Editing

Use `previous_interaction_id` with a follow-up prompt:

```json
{
  "model": "gemini-3-pro-image",
  "input": "Change the poster language to Spanish. Do not alter layout or imagery.",
  "previous_interaction_id": "v1_...",
  "response_format": {"type": "image", "aspect_ratio": "16:9", "image_size": "2K"}
}
```

Keep the returned interaction ID in the final answer when further edits are likely.
