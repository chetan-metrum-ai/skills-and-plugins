#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sync_skill() {
  local plugin_name="$1"
  local skill_name="$2"

  rm -rf "$repo_root/plugins/$plugin_name/skills/$skill_name"
  mkdir -p "$repo_root/plugins/$plugin_name/skills"
  cp -R "$repo_root/skills/$skill_name" "$repo_root/plugins/$plugin_name/skills/$skill_name"
}

for skill_name in opsboard-issue-orchestrate; do
  sync_skill opsboard-workflow "$skill_name"
done

# OPSBOARD now uses the host's subagent orchestration and per-issue worktrees.
# It intentionally has no project-scoped custom-agent templates to copy.
