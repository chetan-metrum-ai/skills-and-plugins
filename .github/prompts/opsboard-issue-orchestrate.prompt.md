# opsboard-issue-orchestrate

Coordinate implementation of one or more GitHub issues with dependency-aware ordering, isolated git-worktree subagents, GitHub human-decision comments, and a durable .opsboard status ledger. Use when the user supplies GitHub issue numbers or URLs and wants them planned, resumed, implemented, or status-synchronized across sessions.

This prompt delegates to the agent skill at `../skills/opsboard-issue-orchestrate/`.

## Skill Location

- **Path:** `../skills/opsboard-issue-orchestrate/`
- **Manifest:** `../skills/opsboard-issue-orchestrate/SKILL.md`

## Usage

Invoke this skill by typing `/opsboard-issue-orchestrate` in the Copilot chat.
