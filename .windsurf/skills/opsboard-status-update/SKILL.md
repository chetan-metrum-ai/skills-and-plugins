---
name: opsboard-status-update
description: Record durable, non-secret OPSBOARD project status in git-bug and Git.
  Use when an agent starts, hands off, becomes blocked, requests review, completes
  work, or needs to make dashboard status accurate.
metadata:
  oasr:
    hash: sha256:4574be076d185ff956bdfdef652131dfc13a8ca0a5837cf1ad068ee8f0e95a01
    source: skills/opsboard-status-update
    synced: 'generated'
---

# Record OPSBOARD status

Treat Git and git-bug as the only durable status store. Do not write status to a
database, dashboard cache, local session, or generated snapshot.

Update the assigned issue with an attributable git-bug comment and the appropriate
`opsboard:state:*` label. Include the sprint ID, role, commit or branch reference,
evidence actually produced, and a concise next action. Use `blocked` for missing
authority, failed validation, or an unmet gate; do not silently continue.

For a handoff, identify the next owner and exact repository evidence. For review,
link the diff/test/demo evidence and create or update the explicit gate. Never put
credentials, private remote URLs, personal tokens, local absolute paths, or raw
terminal output in the status record.
