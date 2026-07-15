#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/project" >&2
  exit 64
fi

project_root="$(cd "$1" && pwd)"
source_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source_agents="$source_root/agents"
target_agents="$project_root/.codex/agents"

if [ ! -d "$source_agents" ]; then
  echo "OPSBOARD agent templates are missing from $source_agents" >&2
  exit 1
fi

mkdir -p "$target_agents"
for source in "$source_agents"/opsboard-*.toml; do
  target="$target_agents/$(basename "$source")"
  if [ -e "$target" ] && ! cmp -s "$source" "$target"; then
    echo "refusing to overwrite local agent template: $target" >&2
    exit 1
  fi
  cp "$source" "$target"
done

echo "Installed OPSBOARD agent templates in $target_agents"
