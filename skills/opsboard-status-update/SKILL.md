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
- Concise next action

Use `blocked` for missing authority, failed validation, or an unmet gate — do not silently continue.

## Human decisions

When a blocker needs a human decision, create a separate `opsboard:human-decision` issue, link it from the blocked task, and state the exact choice and resume condition. Push the git-bug identity and bug refs upstream. Resume only after the human records the decision and closes the issue.

## Handoffs and reviews

- **Handoff:** identify the next owner and the exact repository evidence.
- **Review:** link diff/test/demo evidence and create or update the explicit gate.

## Never commit

Credentials, private remote URLs, personal tokens, local absolute paths, or raw terminal output — never in a status record.

## Reference

- [`references/status-update.md`](references/status-update.md) — Comment and label conventions
