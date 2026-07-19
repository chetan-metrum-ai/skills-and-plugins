---
name: opsboard-orchestrate
description: Use this skill to coordinate Git-native OPSBOARD worktrees and human decision gates. Trigger when agents are blocked on human input, when an operator must list waiting worktrees, when reviewing open decision issues, or when resuming work after a git-bug approval.
---

# Orchestrate worktrees and human decisions

Git-bug is the durable pause/resume queue. Do **not** keep human requests only in chat, local terminals, or an in-memory orchestrator state.

## When a worktree needs a person

1. Create a separate git-bug issue titled `decision: <specific choice>`.
2. Label it `opsboard:human-decision`, `opsboard:sprint:<id>`, and `opsboard:state:planned`. Include:
   - Owning task issue
   - Branch and worktree purpose
   - Required choice
   - Safe options
   - Impact
   - Exact resume condition
3. Mark the owning task `opsboard:state:blocked`, add a factual comment linking the decision issue, and push both `refs/bugs/*` and `refs/identities/*` to the project remote. Do **not** continue speculative implementation.

## Orchestrator loop

Read `git worktree list --porcelain`, then list open git-bug issues labelled `opsboard:human-decision` and blocked task issues. Report each worktree's branch, task, decision ID, requested choice, and last durable evidence. A missing decision issue for a blocked worktree is itself a status defect.

## Resuming

When a human comments with an approval and closes the decision issue:

- Verify the comment supplies the requested choice and any required deployment authority.
- Mark the owning task active.
- Record the resume comment.
- Fetch the approved refs in that worktree.
- Continue from the recorded revision.

Re-open or create a new decision issue when the approved answer does not cover a new risk.

## Prohibited

The orchestrator may summarize and resume local work. It may **not**:

- Impersonate a human approver
- Close a deployment gate
- Write browser state
- Treat a chat-only answer as durable approval

## Reference

- [`references/orchestrate.md`](references/orchestrate.md) — Decision-issue schema, worktree report format, and resume procedure
