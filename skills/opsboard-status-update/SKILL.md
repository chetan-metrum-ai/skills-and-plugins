---
name: opsboard-status-update
description: Use this skill to record durable, non-secret OPSBOARD project status in git-bug and Git. Trigger when an agent starts, hands off, becomes blocked, requests review, completes work, or needs to make dashboard status accurate.
---

# Record OPSBOARD status

Git and git-bug are the only durable status store. Do **not** write status to a database, dashboard cache, local session, or generated snapshot.

## Status updates

Update the assigned issue with an attributable git-bug comment and the appropriate `opsboard:state:*` label. Include:

- Sprint ID
- Role
- Commit or branch reference
- Evidence actually produced
- Link to the approval package (`.opsboard/approvals/<sprint-id>/`) or decision folder when relevant
- Capability slugs touched
- Concise next action

Use `blocked` for missing authority, failed validation, or an unmet gate — do not silently continue.

## Human decisions

When a blocker needs a human decision, mark the task `blocked` and **defer package + issue creation to `opsboard-orchestrate`** (decision package under `approvals/<sprint-id>/decisions/` plus `opsboard:human-decision` issue with option visuals). Status comments must link the decision package path once it exists. Push git-bug identity and bug refs upstream after the orchestrator records them. Resume only after the human records the decision and closes the issue. Never leave the human without the artifact index.

## Handoffs and reviews

- **Handoff:** identify the next owner and the exact repository evidence.
- **Review:** link diff/test/demo evidence mapped to Function Spec verification items; create or update the explicit review gate.

## Never commit

Credentials, private remote URLs, personal tokens, local absolute paths, or raw terminal output — never in a status record.

## Reference

- [`references/status-update.md`](references/status-update.md) — Comment and label conventions
