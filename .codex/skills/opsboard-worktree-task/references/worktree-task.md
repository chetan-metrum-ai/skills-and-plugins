# Worktree task reference

## Pre-start gate checklist

- [ ] Sprint plan-lock gate closed (human comment + close)
- [ ] `.opsboard/approvals/<sprint-id>/capabilities.md` present
- [ ] Every capability owned by this task has `capabilities/<slug>.md`
- [ ] No open `opsboard:human-decision` blocking this task
- [ ] Review/deployment/policy gates that block start are closed or not applicable

## Branch naming

- `feat/<short-issue-id>-<slug>`
- `fix/<short-issue-id>-<slug>`
- `docs/<short-issue-id>-<slug>`

## Worktree layout

Create **outside** the primary checkout, e.g.:

```bash
git fetch origin main
git worktree add -b feat/<id>-<slug> ../<repo>-<id> origin/main
```

Do not commit absolute local worktree paths into `.opsboard/` or status comments.

## Start comment template

```text
started
branch: feat/<id>-<slug>
capabilities: <slug>, <slug>
intended evidence: tests X; screens for verification items Y; demo update
approval package: .opsboard/approvals/<sprint-id>/
```

## Handoff format

```text
handoff
next owner: <role>
capabilities: <slug list>
commit: <sha>
evidence: <paths or commands>
verification matrix: mapped to capabilities/<slug>.md Verification section
open gates: <none | list>
```
