---
name: opsboard-worktree-task
description: Start one approved OPSBOARD git-bug issue in an isolated external Git worktree. Use when assigning an implementer or reviewer, creating a task branch, recording a handoff, or checking that a gate permits work to begin.
---

# Work one approved task

Confirm the issue ID, owner role, sprint label, acceptance criteria, and all
blocking gates before mutating a repository. Stop and report a missing or open
required gate.

Create the worktree outside the main checkout from up-to-date `main` using a
branch such as `feat/<issue-id>-<slug>` (or `fix/` and `docs/` as appropriate).
One issue gets one accountable agent, branch, and mutable worktree.

Record an attributable git-bug start comment with the branch and intended evidence.
Keep commits focused. Before handoff, run the relevant formatter, typecheck,
tests, and build; record what actually ran and any blockers. Do not rebase, merge,
push, tag, release, deploy, or discard unrelated work without the applicable
approval.
