---
name: opsboard-project-init
description: Initialize or validate a Git-native OPSBOARD project. Use when a repository needs the standard .opsboard contract, git-bug sprint taxonomy, external-worktree conventions, or project-scoped OPSBOARD Codex agents.
---

# Initialize an OPSBOARD project

Keep the product repository as the durable source of truth. OPSBOARD only reads
its Git/git-bug projection; do not add a database, hosted task state, or secrets.

## Preflight

1. Confirm the repository root, current branch, remote, and selected issue tracker.
2. Confirm `git-bug` is available and fetch the portable Git-bug refs before its
   first invocation (Git's default clone refspec does not include them):

   ```bash
   git -C /path/to/project fetch origin \
     '+refs/bugs/*:refs/bugs/*' '+refs/identities/*:refs/identities/*'
   git -C /path/to/project config --add remote.origin.fetch '+refs/bugs/*:refs/bugs/*'
   git -C /path/to/project config --add remote.origin.fetch '+refs/identities/*:refs/identities/*'
   skills/opsboard-project-init/scripts/validate-project.sh /path/to/project
   ```

   The validator is read-only. A referenced issue that cannot be read is a failed
   bootstrap, not an empty backlog. The repository must publish both ref families
   readably; never substitute hosted state or a database. Do not replace an
   existing tracker or metadata without an explicit migration request.
3. Inspect `AGENTS.md`, existing `.codex/`, and `.opsboard/` before creating files.

## Initialize the contract

Create `.opsboard/project.yaml` with a stable slug, display name, default Git ref,
and dashboard/demo metadata. Create `.opsboard/sprints/` and `.opsboard/demos/`
(with a non-secret placeholder until there is demo evidence).
Use the contract in [references/project-contract.md](references/project-contract.md).

Install the OPSBOARD custom-agent templates with the bundled script. Preserve local
agent files and record the marketplace commit that supplied the templates:

```bash
skills/opsboard-project-init/scripts/install-agents.sh /path/to/project
```

On PowerShell, run `scripts/install-agents.ps1 <project-path>` instead.

The script refuses to overwrite a different local agent file. Resolve that conflict
explicitly instead of silently replacing project guidance.

Create or document these git-bug labels:

- `opsboard:sprint`, `opsboard:gate`, and `opsboard:sprint:<id>`;
- `opsboard:role:<planner|implementer|reviewer|status-steward>`;
- `opsboard:state:<planned|active|blocked|review|done>`.

Commit the initialized contract as one focused change. Do not put credentials,
remote tokens, generated dashboard snapshots, or local worktree paths in Git.

## Verify

Show the committed contract, label taxonomy, installed agent templates, and a
passing validator result. State the repository revision that a read-only OPSBOARD
dashboard may project.
