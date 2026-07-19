# Dashboard register reference

## Catalog proposal template

```markdown
# Dashboard registration proposal

## Project
slug: <slug>
display_name: <name>

## Source
git_url: <url>
ref: <branch or sha>
workflow_package_commit: <sha>

## Credential
reference_name: <platform-managed read-only credential name>
scope: clone/fetch only
write_access: none

## Contract surfaces projected
- `.opsboard/project.yaml`
- `.opsboard/sprints/`
- `.opsboard/approvals/` (human-approval packages)
- `.opsboard/demos/`
- git-bug `refs/bugs/*` + `refs/identities/*`

## Owner approval required
Required comment: `approve dashboard registration <slug> credential <reference_name>`
```

## Credential reference format

Store only the **name** of a platform-managed secret or workload identity binding. Never store the secret value in Git, git-bug, or chat logs.

## Approval

Create an `opsboard:gate` (or owner `opsboard:human-decision`) linking this proposal. Close only after the repository owner comments the required phrase.
