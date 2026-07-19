# Demo capture reference

## Demo file layout

```text
.opsboard/demos/<sprint-id>.md
.opsboard/demos/<sprint-id>/
  <capability-slug>-desktop.png
  <capability-slug>-mobile.png
  results.md
```

## Demo markdown skeleton

```markdown
# Demo: <sprint-id>

## Revision
`<sha>`

## Capability coverage
| Capability | Verification item | Evidence path | Pass? |
| --- | --- | --- | --- |
| <slug> | <checkbox text from Function Spec> | demos/<sprint-id>/... | yes/no |

## Non-secret demo URL
<url or none>

## Approval package
`.opsboard/approvals/<sprint-id>/`
```

## Screenshot conventions

- Name files with capability slug + viewport.
- Prefer deterministic browser tests over manual captures.
- One primary happy-path shot per UI capability; add error/empty states when the Function Spec lists them under Verification.

## Review gate body must cite

- Capability IDs covered
- Path to `demos/<sprint-id>.md`
- Path to approval package verification matrices
- Commit SHA of evidence
