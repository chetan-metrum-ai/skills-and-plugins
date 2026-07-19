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

for path in .opsboard/project.yaml .opsboard/sprints .opsboard/demos .opsboard/approvals; do
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

# Sprint files that declare plan-lock or an approvals path must have the package dir.
if [ -d "$project_root/.opsboard/sprints" ]; then
  shopt -s nullglob
  for sprint_file in "$project_root/.opsboard/sprints"/*.md; do
    sprint_id="$(basename "$sprint_file" .md)"
    needs_package=0
    if grep -Eqi 'plan-lock|plan_lock|plan lock' "$sprint_file"; then
      needs_package=1
    fi
    if grep -Eq "\.opsboard/approvals/${sprint_id}|approvals/${sprint_id}" "$sprint_file"; then
      needs_package=1
    fi
    if [ "$needs_package" -eq 1 ]; then
      package_dir="$project_root/.opsboard/approvals/$sprint_id"
      if [ ! -d "$package_dir" ]; then
        fail "sprint $sprint_id declares plan-lock/approvals but missing directory: .opsboard/approvals/$sprint_id"
      elif [ ! -f "$package_dir/README.md" ] && [ ! -f "$package_dir/capabilities.md" ]; then
        fail "sprint $sprint_id approval package lacks README.md or capabilities.md"
      fi
    fi
  done
  shopt -u nullglob
fi

if command -v git-bug >/dev/null 2>&1 && [ -d "$project_root/.opsboard/sprints" ]; then
  mapfile -t issue_ids < <(
    grep -RhoE 'git-bug `[0-9a-f]{7,64}`' "$project_root/.opsboard/sprints" 2>/dev/null \
      | sed -E 's/.*`([0-9a-f]+)`.*/\1/' | sort -u
  )

  # Empty sprint directory (init only) is allowed; proposals without issue IDs are allowed
  # until plan-lock closes and issues are created.
  if [ "${#issue_ids[@]}" -gt 0 ]; then
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
fi

if [ "$failures" -gt 0 ]; then
  echo "OPSBOARD project validation failed ($failures problem(s))." >&2
  exit 1
fi

echo "OPSBOARD project validation passed: $project_root"
