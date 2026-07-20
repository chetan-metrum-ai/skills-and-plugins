# OPSBOARD issue-orchestration state contract

Store durable, non-secret coordination state under `.opsboard/issue-orchestrator/` in the target repository.

```text
.opsboard/issue-orchestrator/
  state.json
  status.md
  handoffs/                 # each agent worktree writes its own <issue>.md
```

`state.json` is a JSON object with `version`, `repository`, `updated_at`, and an `issues` map keyed by issue number. Each issue record contains at least:

```json
{
  "url": "https://github.com/owner/repo/issues/123",
  "title": "...",
  "state": "ready",
  "dependencies": [{"issue": 122, "reason": "Issue body: depends on #122"}],
  "worktree": {"path": "/absolute/path", "branch": "opsboard/123-slug", "base_sha": "...", "head_sha": "..."},
  "last_human_comment_at": "2026-07-20T00:00:00Z",
  "last_human_comment_id": "...",
  "last_opsboard_comment_id": "...",
  "human_question": null,
  "handoff_path": ".opsboard/issue-orchestrator/handoffs/123.md",
  "verification": {"commands": [], "result": "not-run"},
  "next_action": "dispatch",
  "history": []
}
```

Allowed state values: `discovered`, `ready`, `waiting-dependency`, `active`, `blocked`, `needs-reconcile`, `implemented`, `complete`, and `closed-external`. Append timestamped, factual events to `history`; never erase prior human questions or verification evidence.

`status.md` should contain an updated timestamp, a short narrative, a dependency-order table, blocked questions, and a worktree snapshot with branch, base/HEAD, `git status --short`, diff summary, tests, and next action. It must make an interrupted run understandable without reading tool logs.

## GitHub comment template

Use this only when a human decision or input is genuinely needed; avoid duplicate comments.

```markdown
OPSBOARD status: blocked

Evidence: <what the issue/repository/worktree shows>
Decision needed: <one specific question>
Options: <option A and trade-off>; <option B and trade-off>.
Unblocks: <the precise implementation or dependency step that can resume>
```

When a human reply resolves the question, record the reply ID/time and resolution in the issue history and status narrative. Do not treat reactions or vague acknowledgement as a technical or product decision.
