# Status update reference

## Comment template

```text
status: <planned|active|blocked|review|done>
sprint: <id>
role: <opsboard role>
branch/commit: <ref>
capabilities: <slug list>
package: .opsboard/approvals/<sprint-id>/
evidence: <what actually ran or was produced>
next: <one concrete action>
```

## Blocked with human decision

Defer issue + decision-package creation to `opsboard-orchestrate`. Status-update only records the block and links the package once it exists:

```text
status: blocked
reason: needs human decision
decision: git-bug `<id>` (after orchestrate creates it)
package: .opsboard/approvals/<sprint-id>/decisions/<decision-id>/
choice: <required choice one-liner>
resume when: decision issue closed with a listed option
next: invoke opsboard-orchestrate if decision package is missing
```

## Review request

```text
status: review
capabilities: <slug list>
verification matrix: see capabilities/<slug>.md Verification
demo: .opsboard/demos/<sprint-id>.md
gate: review (create or update opsboard:gate)
```

## Labels

Update `opsboard:state:*` to match the comment. Do not invent durable state outside git-bug labels and comments.
