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

for skill_dir in "$repo_root"/skills/*; do
  [ -d "$skill_dir" ] || continue
  $oasr_bin validate "$skill_dir"
done

"$repo_root/scripts/sync-plugin-skills.sh"
