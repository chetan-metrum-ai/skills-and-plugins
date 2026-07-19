---
name: opsboard-sprint-plan
description: Use this skill to turn a terse product brief into a reviewable, approval-gated
  OPSBOARD sprint. Trigger when planning a sprint, breaking work into issues, defining
  acceptance criteria, or creating human gates before agents start work.
metadata:
  oasr:
    hash: sha256:14958343da920499c5908a3e6f458ad61ad75f205495b081546a848fef52a799
    source: skills/opsboard-sprint-plan
    synced: 'generated'
---

# Plan an OPSBOARD sprint

Start from the user's terse brief and the repository's existing `.opsboard/` contract. Ask only for product decisions that cannot be found in the repository.

## Workflow

1. **Produce a proposal first.** Write `.opsboard/sprints/<id>.md` with goal, in/out of scope, acceptance criteria, dependencies, demos, and explicit approval gates. Split implementation into independently verifiable git-bug issues — one owner, non-overlapping file scopes. Include a plan-lock gate before parallel work.
2. **Stop for approval.** Do **not** create issues, branches, worktrees, or commits until the user approves the proposal. Approval creates one sprint issue (`opsboard:sprint`), task issues (`opsboard:sprint:<id>`), and separate `opsboard:gate` issues.
3. **Keep execution observable.** Every task states its expected evidence (tests, review, docs, demo artifact). Use a gate for external deployment, security-sensitive changes, schema/policy changes, and any irreversible action. A closed task is **not** a release or deployment authorization.

## Reference

- [`references/sprint-plan.md`](references/sprint-plan.md) — Proposal template, gate taxonomy, and examples
