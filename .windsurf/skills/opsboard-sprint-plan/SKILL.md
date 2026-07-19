---
name: opsboard-sprint-plan
description: Use this skill to turn a terse product brief into a reviewable, approval-gated
  OPSBOARD sprint. Trigger when planning a sprint, breaking work into issues, defining
  acceptance criteria, building a human-approval package, or creating human gates
  before agents start work.
metadata:
  oasr:
    hash: sha256:5ff54f441cfe796a85db30413c6b2ee65e3dabd64fba896bcb685dfebb9db36c
    source: skills/opsboard-sprint-plan
    synced: 'generated'
---

# Plan an OPSBOARD sprint

Start from the user's terse brief and the repository's existing `.opsboard/` contract. Ask only for product decisions that cannot be found in the repository.

The human's job is to **approve or steer**. Agents must auto-build every artifact needed for that decision before asking.

## Workflow

1. **Inventory capabilities.** Split the brief into product capabilities (user-facing actions + any admin activation path). Not API inventories or code functions.
2. **Auto-build the approval package** under `.opsboard/approvals/<sprint-id>/` before requesting approval:
   - `README.md` — index of gates, package status, links
   - `capabilities.md` — catalog of every in-scope capability
   - `capabilities/<slug>.md` — one Function Spec per capability (see reference)
   - `flows/<slug>.md` — mermaid user flow; separate admin flow when activation needs admin
   - `mocks/<slug>/` — mock screens via **nabapro** (or HTML prototype if image API unavailable); document which tool was used
   - `videos/<slug>/` — for any **user-facing UI** capability: short mock interaction video via **narrated-video-production** (or silent HTML-prototype recording if labeled as such)
   - Backend-only capabilities: Function Spec + schematics required; mocks/video marked `n/a` with justification
3. **Write the sprint proposal** at `.opsboard/sprints/<sprint-id>.md` linking the package, acceptance criteria, dependencies, demos, and explicit gates (always include **plan-lock** before parallel work; add **design-ux** when design is contested).
4. **Stop for approval.** Present one decision surface: **Approve plan-lock** or **Steer with deltas**. Do **not** create issues, branches, worktrees, or commits until the human closes plan-lock with the required comment. Incomplete visuals mean the package is not plan-lock-ready.
5. **After plan-lock closes:** create one sprint issue (`opsboard:sprint`), task issues (`opsboard:sprint:<id>`), and separate `opsboard:gate` issues. Every task states expected evidence mapped to Function Spec verification. A closed task is **not** release or deployment authorization.

## Reference

- [`references/sprint-plan.md`](references/sprint-plan.md) — Function Spec template, gate taxonomy, approval-package checklist, and examples
