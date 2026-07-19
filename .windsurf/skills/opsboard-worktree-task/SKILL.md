---
name: opsboard-worktree-task
description: Use this skill to start one approved OPSBOARD git-bug issue in an isolated
  external Git worktree. Trigger when assigning an implementer or reviewer, creating
  a task branch, recording a handoff, or checking that a gate permits work to begin.
metadata:
  oasr:
    hash: sha256:c5d80566f9b28106fd14ce55a6df93038a0ccae5521b41a742805aefda216683
    source: skills/opsboard-worktree-task
    synced: 'generated'
---

# Work one approved task

## Pre-work checks

- Confirm issue ID, owner role, sprint label, acceptance criteria, and all blocking gates.
- Confirm **plan-lock is closed** and the sprint approval package exists at `.opsboard/approvals/<sprint-id>/`.
- Confirm Function Specs exist for every capability this task owns (links from the task or sprint file).
- **Stop and report** a missing/open required gate or missing Function Spec — do not start work.

## Setup

- Create the worktree **outside** the main checkout, from up-to-date `main`, on a branch like `feat/<issue-id>-<slug>` (or `fix/`, `docs/` as appropriate).
- One issue gets one accountable agent, branch, and mutable worktree.

## During work

- Record an attributable git-bug start comment with branch, owned capability slugs, and intended evidence (mapped to Function Spec verification).
- Keep commits focused.
- Before handoff, run the relevant formatter, typecheck, tests, and build. Record what actually ran and any blockers.
- If a product choice appears, use `opsboard-orchestrate` (decision package + human-decision issue) — do not invent policy in chat.

## Prohibited without approval

Do not rebase, merge, push, tag, release, deploy, or discard unrelated work without the applicable approval.

## Reference

- [`references/worktree-task.md`](references/worktree-task.md) — Branch naming, worktree layout, capability linkage, and handoff format
