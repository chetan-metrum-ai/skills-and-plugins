---
name: opsboard-project-init
description: Use this skill to initialize or validate a Git-native OPSBOARD project. Trigger when a repository needs the standard `.opsboard` contract, git-bug sprint taxonomy, external-worktree conventions, approval-package layout, or project-scoped OPSBOARD Codex agents.
---

# Initialize an OPSBOARD project

Git is the source of truth. OPSBOARD only reads a Git/git-bug projection — no database, no hosted state, no secrets.

## Preflight

1. Confirm repo root, current branch, remote, and selected tracker.
2. Make git-bug refs fetchable (Git's default clone refspec omits them), then validate:

   ```bash
   git -C /path/to/project fetch origin \
     '+refs/bugs/*:refs/bugs/*' '+refs/identities/*:refs/identities/*'
   git -C /path/to/project config --add remote.origin.fetch '+refs/bugs/*:refs/bugs/*'
   git -C /path/to/project config --add remote.origin.fetch '+refs/identities/*:refs/identities/*'
   skills/opsboard-project-init/scripts/validate-project.sh /path/to/project
   ```

   The validator is read-only. A referenced issue that cannot be read is a **failed** bootstrap, not an empty backlog. Do not replace an existing tracker or metadata without an explicit migration request.
3. Inspect `AGENTS.md`, existing `.codex/`, and `.opsboard/` before creating files.

## Initialize the contract

- Create `.opsboard/project.yaml` with slug, display name, default Git ref, dashboard/demo metadata.
- Create `.opsboard/sprints/`, `.opsboard/demos/` (with a non-secret placeholder), and `.opsboard/approvals/` (empty scaffold for human-approval packages).
- Install OPSBOARD custom-agent templates; preserve local agents and record the marketplace commit that supplied them:

  ```bash
  skills/opsboard-project-init/scripts/install-agents.sh /path/to/project
  ```

  On PowerShell, run `scripts/install-agents.ps1 <project-path>` instead. The script refuses to overwrite a different local agent file — resolve conflicts explicitly.
- Create or document git-bug labels:
  - `opsboard:sprint`, `opsboard:gate`, `opsboard:human-decision`, `opsboard:sprint:<id>`
  - `opsboard:role:<planner|implementer|reviewer|status-steward|orchestrator|acceptance-tester|deployment-engineer|deployment-approver>`
  - `opsboard:state:<planned|active|blocked|review|done>`
- Commit the initialized contract as one focused change. Never commit credentials, remote tokens, generated dashboard snapshots, or local worktree paths.

## Verify

Show the committed contract, label taxonomy, installed agent templates, approvals scaffold, and a passing validator result. State the repository revision a read-only OPSBOARD dashboard may project.

## Reference

- [`references/project-contract.md`](references/project-contract.md) — Full contract schema, approval-package layout, and gate/label taxonomy
