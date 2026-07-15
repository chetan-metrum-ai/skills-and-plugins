---
name: opsboard-orchestrate
description: Coordinate Git-native OPSBOARD worktrees and human decision gates. Use when agents are blocked on human input, when an operator must list waiting worktrees, when reviewing open decision issues, or when resuming work after a git-bug approval.
---

# Orchestrate worktrees and human decisions

Git-bug is the durable pause/resume queue. Do not keep human requests only in
chat, local terminals, or an in-memory orchestrator state.

## When a worktree needs a person

1. Create a separate git-bug issue titled `decision: <specific choice>`.
2. Label it `opsboard:human-decision`, `opsboard:sprint:<id>`, and
   `opsboard:state:planned`; include the owning task issue, branch, worktree
   purpose, required choice, safe options, impact, and exact resume condition.
3. Mark the owning task `opsboard:state:blocked`, add a factual comment linking
   the decision issue, and push both `refs/bugs/*` and `refs/identities/*` to the
   project remote. Do not continue speculative implementation.

## Orchestrator loop

Read `git worktree list --porcelain`, then list open git-bug issues labelled
`opsboard:human-decision` and blocked task issues. Report each worktree's branch,
task, decision ID, requested choice, and last durable evidence. A missing decision
issue for a blocked worktree is itself a status defect.

When a human comments with an approval and closes the decision issue, verify the
comment supplies the requested choice and any required deployment authority. Only
then mark the owning task active, record the resume comment, fetch the approved
refs in that worktree, and continue from the recorded revision. Re-open or create
a new decision issue when the approved answer does not cover a new risk.

The orchestrator may summarize and resume local work; it may not impersonate a
human approver, close a deployment gate, write browser state, or treat a chat-only
answer as durable approval.
