#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 /path/to/project" >&2
  exit 64
fi

project_root="$(cd "$1" && pwd)"
failures=0

fail() {
  echo "FAIL: $*" >&2
  failures=$((failures + 1))
}

if ! git -C "$project_root" rev-parse --show-toplevel >/dev/null 2>&1; then
  fail "not a Git worktree: $project_root"
fi

if ! command -v git-bug >/dev/null 2>&1; then
  fail "git-bug is required to read the durable backlog"
fi

for path in .opsboard/project.yaml .opsboard/sprints .opsboard/demos; do
  if [ ! -e "$project_root/$path" ]; then
    fail "missing required project-contract path: $path"
  fi
done

if [ -f "$project_root/.opsboard/project.yaml" ]; then
  for key in version slug display_name default_ref; do
    if ! grep -Eq "^${key}:" "$project_root/.opsboard/project.yaml"; then
      fail "project.yaml is missing required key: $key"
    fi
  done
fi

if command -v git-bug >/dev/null 2>&1 && [ -d "$project_root/.opsboard/sprints" ]; then
  mapfile -t issue_ids < <(
    grep -RhoE 'git-bug `[0-9a-f]{7,64}`' "$project_root/.opsboard/sprints" 2>/dev/null \
      | sed -E 's/.*`([0-9a-f]+)`.*/\1/' | sort -u
  )

  if [ "${#issue_ids[@]}" -eq 0 ]; then
    fail "no git-bug issue IDs were found in .opsboard/sprints"
  fi

  available_ids="$(cd "$project_root" && git-bug bug --format id 2>/dev/null || true)"
  if [ -z "$available_ids" ]; then
    fail "git-bug cannot list local issues; fetch refs/bugs/* and refs/identities/* first"
  fi

  for issue_id in "${issue_ids[@]}"; do
    matches="$(printf '%s\n' "$available_ids" | grep -E "^${issue_id}" || true)"
    if [ "$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l)" -ne 1 ]; then
      fail "referenced git-bug issue is unavailable or ambiguous locally: $issue_id"
      continue
    fi
    full_issue_id="$(printf '%s\n' "$matches" | sed -n '1p')"
    if ! (cd "$project_root" && git-bug bug show "$full_issue_id" >/dev/null 2>&1); then
      fail "referenced git-bug issue cannot be read locally: $issue_id"
    fi
  done
fi

if [ "$failures" -gt 0 ]; then
  echo "OPSBOARD project validation failed ($failures problem(s))." >&2
  exit 1
fi

echo "OPSBOARD project validation passed: $project_root"
