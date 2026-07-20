---
name: opsboard-issue-orchestrate
description: Coordinate implementation of one or more GitHub issues with dependency-aware
  ordering, isolated git-worktree subagents, GitHub human-decision comments, and a
  durable .opsboard status ledger. Use when the user supplies GitHub issue numbers
  or URLs and wants them planned, resumed, implemented, or status-synchronized across
  sessions.
metadata:
  oasr:
    hash: sha256:a77dddea71639508b518b4a79fa25454ebd01be47a4a184dea8be7909bfde1d1
    source: skills/opsboard-issue-orchestrate
    synced: 'generated'
---

# OPSBOARD Issue Orchestrator

Drive a bounded set of GitHub issues from discovery through implementation without losing dependency, human-decision, worktree, or verification state between invocations. GitHub remains the collaboration record; `.opsboard/issue-orchestrator/` is the repository-local coordination ledger.

## Operating rules

- Require an authenticated `gh` CLI and resolve the repository before changing anything. Accept issue numbers for the current repository and full GitHub issue URLs for another repository; do not silently mix repositories.
- Treat the issue title, body, linked issues/PRs, labels, and comments as requirements. Do not infer product choices, API contracts, destructive migrations, credentials, or deployment authority.
- Work only on open, ready issues. Never close issues, merge, deploy, push, or modify project-management labels unless the user explicitly requests it.
- Preserve existing user changes. Never reset, clean, or reuse a non-OPSBOARD worktree that contains unrelated changes.
- Be the sole writer of the central ledger. Subagents write a structured handoff in their own worktree; reconcile that handoff against Git before updating central state.

## 1. Discover and reconcile before planning

At the start of **every** invocation:

1. Read `references/state-contract.md`, then create `.opsboard/issue-orchestrator/` if absent. Do not store secrets in it.
2. Load `state.json` and `status.md` if present. Query `git worktree list --porcelain`, each recorded worktree's branch, `HEAD`, `git status --short`, and `git diff --stat <base>...HEAD` plus unstaged diff stats.
3. Fetch every tracked issue with its current state and comments. Check comments newer than `last_human_comment_at` or the last recorded comment ID. A new human comment that resolves a recorded question moves the issue to `ready`; an ambiguous comment remains blocked and gets one precise follow-up question.
4. Reconcile discrepancies rather than overwrite them: missing worktree, changed branch/base, uncommitted edits, closed issue, or failed verification becomes `needs-reconcile` with evidence in `status.md`. Do not launch another agent until resolved.

For a first invocation, fetch all requested issues before creating a worktree. Capture each issue's title, body, labels, links, comments, and current open/closed state in the ledger.

## 2. Build the dependency order

Extract explicit and implied dependencies from issue text and linked material:

- phrases such as `depends on`, `blocked by`, `after`, `before`, `requires`, and issue/PR links;
- shared APIs, schemas, migrations, deployment prerequisites, test fixtures, ownership boundaries, and acceptance criteria;
- conflicts where two issues would change the same contract or component incompatibly.

Record only evidence-backed edges. Topologically sort the issue graph and mark each issue `ready`, `waiting-dependency`, `blocked`, or `needs-reconcile`.

- A cycle, unresolved external dependency, or material ambiguity requires a human decision. Post one concise issue comment using the template in the reference, record the comment ID/time and exact question, and do not dispatch the issue.
- Do not comment repeatedly: comment only when the question, evidence, or state changes. Recheck all tracked issues for human replies on each invocation and after every agent round.
- Independent ready issues may run concurrently; dependent issues wait for the verified result of their prerequisites.

## 3. Persist the coordination ledger

Maintain the files defined in `references/state-contract.md` after every transition: discovery, dependency decision, agent launch, handoff, verification, human block, and completion.

`status.md` must be a concise human-readable narrative, not a raw log: what was discovered, what changed, tests run and results, current dependency order, human questions, next action, and per-worktree diff/branch/base snapshot. `state.json` is the machine-readable source for resuming.

Keep this state in the orchestrator checkout. It persists locally across invocations; do not automatically commit it unless the user requests a coordination/status commit. If the user asks to persist it in Git, commit only the `.opsboard/issue-orchestrator/` changes with a clearly scoped message.

## 4. Dispatch ready work to subagents

Use subagents for implementation. Dispatch at most three independent ready issues at once, reducing concurrency when the repository or work overlaps make that unsafe.

For each dispatch:

1. Create a dedicated external worktree and branch from the recorded base, for example `git worktree add ../<repo>-opsboard-<issue> -b opsboard/<issue>-<slug> <base>`. Record absolute worktree path, branch, base SHA, and launch time before starting the agent.
2. Give the subagent only its issue, dependency results, acceptance criteria, worktree path, relevant repository instructions, and this handoff contract. Tell it not to alter other worktrees, merge, push, deploy, or make GitHub status changes.
3. Require implementation, focused tests, and a handoff at `.opsboard/issue-orchestrator/handoffs/<issue>.md` in **its worktree**. The handoff must state: outcome, changed paths, commits and uncommitted diff, tests/results, unresolved risks, exact blocker/question if any, and recommended next state.
4. On return, independently inspect the worktree, commits, diff, tests, and handoff. Update the central ledger from observed facts. A missing or inconsistent handoff is `needs-reconcile`, not success.

Use the platform's subagent mechanism; never ask an agent to share the primary checkout. The orchestrator updates central status after each returned handoff so progress survives interruption and later invocations.

## 5. Human discussion and completion

When implementation needs a decision or cannot safely proceed, post the issue comment described in the reference. Include the evidence, the narrow question, options/trade-offs where useful, and the exact unblock condition. Record it as `blocked` and stop that issue while allowing unrelated ready issues to continue.

Before marking an issue `complete`, verify its acceptance criteria as far as the repository permits, capture commands and results, inspect its diff, and confirm no unresolved human question or dependency remains. Leave the issue open unless explicitly instructed otherwise. Report the completed work, remaining work, worktree branches, and next dependency-ready issue.

## Resume example

For “resume #123 and #128”, first reconcile the ledger, live worktrees, and all new GitHub comments. If #123 now has a human answer, update its decision record and dispatch it only if its prerequisites are verified. If #128 depends on #123, keep it waiting and state that plainly in `status.md`.
