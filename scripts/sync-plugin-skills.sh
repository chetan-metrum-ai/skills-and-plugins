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

sync_skill nvidia-setup nvidia-setup

for skill_name in opsboard-dashboard-register opsboard-demo-capture \
  opsboard-project-init opsboard-sprint-plan opsboard-status-update \
  opsboard-worktree-task; do
  sync_skill opsboard-workflow "$skill_name"
done

rm -rf "$repo_root/plugins/opsboard-workflow/agents"
cp -R "$repo_root/agents" "$repo_root/plugins/opsboard-workflow/agents"
