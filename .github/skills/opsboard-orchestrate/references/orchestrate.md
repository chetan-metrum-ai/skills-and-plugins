# Orchestrate reference

## Decision-issue schema

Title: `decision: <specific choice>`

Labels:

- `opsboard:human-decision`
- `opsboard:sprint:<id>`
- `opsboard:state:planned` (while open)

Body must include:

```markdown
## Owning task
git-bug `<id>` — <title>

## Branch / worktree
branch: <name>
purpose: <one line>

## Required choice
<exact question the human must answer>

## Safe options
1. <option A> — impact: ...
2. <option B> — impact: ...
3. <defer / rollback> — impact: ...

## Decision package
`.opsboard/approvals/<sprint-id>/decisions/<decision-id>/`

## Resume condition
Continue only after a human comment selects one option above and this issue is closed.
Forbidden until then: speculative implementation of unchosen options.
```

## Decision-folder template

`.opsboard/approvals/<sprint-id>/decisions/<decision-id>/`:

```text
README.md           # mirrors issue body; status open|closed
options.md          # comparison table
flows/              # optional mermaid per option
mocks/              # optional screen per option (nabapro or HTML)
```

`options.md` example:

```markdown
| Option | Summary | Pros | Cons | Mock / schematic |
| --- | --- | --- | --- | --- |
| A | ... | ... | ... | mocks/a.png |
| B | ... | ... | ... | mocks/b.png |
| Defer | Stop and re-plan | Safe | Delay | — |
```

Agents must present the human a clear decision: pick an option or steer with deltas. Do not ask open-ended questions without options.

## Worktree report format

When listing blocked work:

```text
worktree: <path>
branch: <name>
task: git-bug <id>
decision: git-bug <id>
package: .opsboard/approvals/<sprint-id>/decisions/<decision-id>/
choice: <required choice one-liner>
evidence: <last commit or none>
```

## Resume procedure

1. Confirm decision issue is closed.
2. Confirm closing comment names a listed option (or explicit steer that produced a revised package).
3. Comment on the owning task: `resumed after decision <id>: chose <option>`.
4. Set task state to `active`.
5. Fetch bug/identity refs in the worktree; continue from recorded revision.
6. If a new risk appears, create a new decision — do not stretch the old approval.
