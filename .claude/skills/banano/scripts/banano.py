#!/usr/bin/env -S uv run python
"""Call Gemini Interactions API for Nano Banana image generation/editing."""

from __future__ import annotations

import argparse
import base64
import json
import mimetypes
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path


DEFAULT_MODEL = "gemini-3-pro-image"
API_BASE = "https://generativelanguage.googleapis.com"


def parse_json(value: str, label: str):
    try:
        return json.loads(value)
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Invalid JSON for {label}: {exc}") from exc


def merge_dict(base: dict, extra: dict) -> dict:
    for key, value in extra.items():
        if isinstance(value, dict) and isinstance(base.get(key), dict):
            base[key] = merge_dict(base[key], value)
        else:
            base[key] = value
    return base


def image_block(path: str) -> dict:
    image_path = Path(path).expanduser()
    if not image_path.exists():
        raise SystemExit(f"Image not found: {image_path}")
    mime_type = mimetypes.guess_type(image_path.name)[0] or "image/png"
    with image_path.open("rb") as handle:
        encoded = base64.b64encode(handle.read()).decode("utf-8")
    return {"type": "image", "data": encoded, "mime_type": mime_type}


def build_request(args: argparse.Namespace) -> dict:
    if args.request_json:
        request = parse_json(args.request_json, "--request-json")
        if not isinstance(request, dict):
            raise SystemExit("--request-json must be a JSON object")
    else:
        if not args.prompt and not args.prompt_file:
            raise SystemExit("Provide --prompt, --prompt-file, or --request-json")

        prompt = args.prompt or Path(args.prompt_file).read_text(encoding="utf-8")
        inputs: list[dict] = [{"type": "text", "text": prompt}]
        inputs.extend(image_block(path) for path in args.image)
        inputs.extend(parse_json(item, "--image-json") for item in args.image_json)

        request = {
            "model": args.model,
            "input": inputs if len(inputs) > 1 else prompt,
        }

        if args.previous_interaction_id:
            request["previous_interaction_id"] = args.previous_interaction_id
        if args.system_instruction:
            request["system_instruction"] = args.system_instruction

        if args.response_format_json:
            request["response_format"] = parse_json(
                args.response_format_json, "--response-format-json"
            )
        elif any([args.aspect_ratio, args.image_size, args.mime_type]):
            response_format = {"type": "image"}
            if args.mime_type:
                response_format["mime_type"] = args.mime_type
            if args.aspect_ratio:
                response_format["aspect_ratio"] = args.aspect_ratio
            if args.image_size:
                response_format["image_size"] = args.image_size
            request["response_format"] = response_format

        if args.response_modalities:
            request["response_modalities"] = [
                item.strip() for item in args.response_modalities.split(",") if item.strip()
            ]

        generation_config = {}
        if args.generation_config_json:
            generation_config = parse_json(
                args.generation_config_json, "--generation-config-json"
            )
            if not isinstance(generation_config, dict):
                raise SystemExit("--generation-config-json must be a JSON object")
        if args.thinking_level:
            generation_config["thinking_level"] = args.thinking_level
        if args.max_output_tokens is not None:
            generation_config["max_output_tokens"] = args.max_output_tokens
        if args.seed is not None:
            generation_config["seed"] = args.seed
        if args.temperature is not None:
            generation_config["temperature"] = args.temperature
        if generation_config:
            request["generation_config"] = generation_config

        if args.tools_json:
            request["tools"] = parse_json(args.tools_json, "--tools-json")
        elif args.google_search:
            tool = {"type": "google_search"}
            if args.search_types:
                tool["search_types"] = [
                    item.strip() for item in args.search_types.split(",") if item.strip()
                ]
            request["tools"] = [tool]

    if args.extra_json:
        extra = parse_json(args.extra_json, "--extra-json")
        if not isinstance(extra, dict):
            raise SystemExit("--extra-json must be a JSON object")
        request = merge_dict(request, extra)

    return request


def request_interaction(body: dict, api_key: str, api_version: str) -> dict:
    url = f"{API_BASE}/{api_version}/interactions"
    data = json.dumps(body).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "x-goog-api-key": api_key,
            "Content-Type": "application/json",
            "User-Agent": "codex-banano-skill/1.0",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"Gemini API HTTP {exc.code}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"Gemini API request failed: {exc}") from exc


def content_blocks(response: dict):
    for step in response.get("steps") or []:
        for block in step.get("content") or []:
            yield block
    for key in ("output_image", "output_text"):
        value = response.get(key)
        if isinstance(value, dict):
            yield value


def save_outputs(response: dict, output_dir: Path, basename: str) -> list[Path]:
    output_dir.mkdir(parents=True, exist_ok=True)
    saved: list[Path] = []
    image_count = 0
    text_count = 0

    for block in content_blocks(response):
        block_type = block.get("type")
        if block_type == "image":
            image_count += 1
            mime_type = block.get("mime_type") or "image/jpeg"
            ext = ".jpg" if mime_type == "image/jpeg" else mimetypes.guess_extension(mime_type) or ".img"
            if block.get("data"):
                path = output_dir / f"{basename}-{image_count}{ext}"
                path.write_bytes(base64.b64decode(block["data"]))
                saved.append(path)
            elif block.get("uri"):
                path = output_dir / f"{basename}-{image_count}.uri.txt"
                path.write_text(block["uri"], encoding="utf-8")
                saved.append(path)
        elif block_type == "text" and block.get("text"):
            text_count += 1
            path = output_dir / f"{basename}-text-{text_count}.txt"
            path.write_text(block["text"], encoding="utf-8")
            saved.append(path)

    metadata_path = output_dir / f"{basename}-interaction.json"
    metadata_path.write_text(json.dumps(response, indent=2, sort_keys=True), encoding="utf-8")
    saved.append(metadata_path)
    return saved


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Generate or edit images with Nano Banana Pro via Gemini Interactions API."
    )
    parser.add_argument("--prompt", help="Text prompt.")
    parser.add_argument("--prompt-file", help="Read prompt from a UTF-8 text file.")
    parser.add_argument("--model", default=DEFAULT_MODEL, help=f"Model ID. Default: {DEFAULT_MODEL}")
    parser.add_argument("--image", action="append", default=[], help="Local reference/edit image. Repeatable.")
    parser.add_argument("--image-json", action="append", default=[], help="Exact JSON image content block. Repeatable.")
    parser.add_argument("--previous-interaction-id", help="Continue a previous interaction.")
    parser.add_argument("--system-instruction", help="Optional system instruction.")
    parser.add_argument("--aspect-ratio", help="Image aspect ratio, e.g. 1:1, 16:9, 4:5, 21:9.")
    parser.add_argument("--image-size", help="Image size: 512, 1K, 2K, or 4K.")
    parser.add_argument("--mime-type", default="image/jpeg", help="Output MIME type. Default: image/jpeg.")
    parser.add_argument("--response-format-json", help="Exact response_format JSON object or array.")
    parser.add_argument("--response-modalities", help="Comma-separated response modalities, e.g. text,image.")
    parser.add_argument("--generation-config-json", help="Exact generation_config JSON object.")
    parser.add_argument("--thinking-level", choices=["minimal", "low", "medium", "high"])
    parser.add_argument("--max-output-tokens", type=int)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--temperature", type=float)
    parser.add_argument("--google-search", action="store_true", help="Enable Google Search grounding.")
    parser.add_argument("--search-types", help="Comma-separated search types, e.g. web_search,image_search.")
    parser.add_argument("--tools-json", help="Exact tools JSON array.")
    parser.add_argument("--request-json", help="Full Interactions request body JSON.")
    parser.add_argument("--extra-json", help="Extra top-level request fields to merge into the body.")
    parser.add_argument("--api-version", default="v1beta", help="API version path. Default: v1beta.")
    parser.add_argument("--output-dir", default="banano-output", help="Directory for saved outputs.")
    parser.add_argument("--basename", default="banano", help="Output filename prefix.")
    parser.add_argument("--dry-run", action="store_true", help="Print request JSON without calling the API.")
    args = parser.parse_args()

    body = build_request(args)
    if args.dry_run:
        print(json.dumps(body, indent=2, sort_keys=True))
        return 0

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise SystemExit("Set GEMINI_API_KEY before calling the Gemini API")

    response = request_interaction(body, api_key, args.api_version)
    saved = save_outputs(response, Path(args.output_dir), args.basename)

    print(f"interaction_id={response.get('id', '')}")
    print(f"status={response.get('status', '')}")
    for path in saved:
        print(path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
