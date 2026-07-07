#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rm -rf "$repo_root/plugins/nvidia-setup/skills/nvidia-setup"
mkdir -p "$repo_root/plugins/nvidia-setup/skills"
cp -R "$repo_root/skills/nvidia-setup" "$repo_root/plugins/nvidia-setup/skills/nvidia-setup"
