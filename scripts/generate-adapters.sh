#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
oasr_bin="${OASR_BIN:-oasr}"

if ! command -v "$oasr_bin" >/dev/null 2>&1; then
  if command -v uvx >/dev/null 2>&1; then
    oasr_bin="uvx oasr"
  else
    echo "oasr is required. Install it with: uv tool install oasr" >&2
    exit 127
  fi
fi

uv_cache_dir="${UV_CACHE_DIR:-${HOME:-}/.cache/uv}"
uv_tool_dir="${UV_TOOL_DIR:-${HOME:-}/.local/share/uv/tools}"
oasr_home="$(mktemp -d)"
cleanup() {
  rm -rf "$oasr_home"
}
trap cleanup EXIT

export HOME="$oasr_home/home"
export XDG_CONFIG_HOME="$oasr_home/config"
export XDG_DATA_HOME="$oasr_home/data"
export UV_CACHE_DIR="$uv_cache_dir"
export UV_TOOL_DIR="$uv_tool_dir"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

"$repo_root/scripts/validate-skills.sh"

for skill_dir in "$repo_root"/skills/*; do
  [ -d "$skill_dir" ] || continue
  $oasr_bin registry add "$skill_dir"
done

$oasr_bin registry sync
$oasr_bin adapter --output-dir "$repo_root" cursor
$oasr_bin adapter --output-dir "$repo_root" windsurf
$oasr_bin adapter --output-dir "$repo_root" codex
$oasr_bin adapter --output-dir "$repo_root" copilot
$oasr_bin adapter --output-dir "$repo_root" claude

while IFS= read -r -d '' generated_skill; do
  skill_name="$(basename "$(dirname "$generated_skill")")"
  perl -0pi -e \
    "s#source: \\Q$repo_root\\E/skills/$skill_name#source: skills/$skill_name#g; s#synced: '[^']+'#synced: 'generated'#g" \
    "$generated_skill"
done < <(find "$repo_root"/.codex "$repo_root"/.claude "$repo_root"/.cursor "$repo_root"/.windsurf "$repo_root"/.github -path '*/skills/*/SKILL.md' -type f -print0)

# Remove generated skill directories that no longer have a canonical source.
# OASR only cleans up stale top-level adapter files, not the */skills/<name>/ copies.
for adapter_root in "$repo_root"/.codex "$repo_root"/.claude "$repo_root"/.cursor "$repo_root"/.windsurf "$repo_root"/.github; do
  skills_dir="$adapter_root/skills"
  [ -d "$skills_dir" ] || continue
  for generated_skill_dir in "$skills_dir"/*; do
    [ -d "$generated_skill_dir" ] || continue
    skill_name="$(basename "$generated_skill_dir")"
    if [ ! -d "$repo_root/skills/$skill_name" ]; then
      echo "Removing stale generated skill: $generated_skill_dir"
      rm -rf "$generated_skill_dir"
    fi
  done
done
