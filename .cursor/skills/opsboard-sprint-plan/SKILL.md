---
name: opsboard-sprint-plan
description: Turn a terse product brief into a reviewable, approval-gated OPSBOARD
  sprint in a Git/git-bug project. Use when planning a sprint, breaking work into
  issues, defining acceptance criteria, or creating human gates before agents start
  work.
metadata:
  oasr:
    hash: sha256:f0552b2616134c1e7dd25c62091b376d76ecbd197cb2e794b43a99eaa9439639
    source: skills/opsboard-sprint-plan
    synced: 'generated'
---

# Plan an OPSBOARD sprint

Start from the user's terse brief and the repository's existing `.opsboard/`
contract. Ask only for product decisions that cannot be found in the repository.

## Produce a proposal first

Write a proposed `.opsboard/sprints/<id>.md` containing the goal, in/out of
scope, acceptance criteria, dependencies, demos, and explicit approval gates.
Split implementation into independently verifiable git-bug issues with one owner
and non-overlapping file scopes. Include a plan-lock gate before parallel work.

Do not create issues, branches, worktrees, or commits until the user approves the
proposal. An approved plan creates one sprint issue labeled `opsboard:sprint`,
task issues labeled `opsboard:sprint:<id>`, and separate `opsboard:gate` issues.

## Keep execution observable

Every task must state its expected evidence: tests, review, documentation, or demo
artifact. Use a gate for external deployment, security-sensitive changes, schema
or policy changes, and any irreversible action. A closed task is not a release or
deployment authorization.
