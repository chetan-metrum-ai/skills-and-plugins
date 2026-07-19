---
name: opsboard-worktree-task
description: Use this skill to start one approved OPSBOARD git-bug issue in an isolated external Git worktree. Trigger when assigning an implementer or reviewer, creating a task branch, recording a handoff, or checking that a gate permits work to begin.
---

# Work one approved task

## Pre-work checks

- Confirm issue ID, owner role, sprint label, acceptance criteria, and all blocking gates.
- **Stop and report** a missing or open required gate — do not start work.

## Setup

- Create the worktree **outside** the main checkout, from up-to-date `main`, on a branch like `feat/<issue-id>-<slug>` (or `fix/`, `docs/` as appropriate).
- One issue gets one accountable agent, branch, and mutable worktree.

## During work

- Record an attributable git-bug start comment with branch and intended evidence.
- Keep commits focused.
- Before handoff, run the relevant formatter, typecheck, tests, and build. Record what actually ran and any blockers.

## Prohibited without approval

Do not rebase, merge, push, tag, release, deploy, or discard unrelated work without the applicable approval.

## Reference

- [`references/worktree-task.md`](references/worktree-task.md) — Branch naming, worktree layout, and handoff format
