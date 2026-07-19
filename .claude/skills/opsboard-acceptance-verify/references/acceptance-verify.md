# Acceptance verify reference

## Checklist

1. Clean clone/worktree from the immutable revision under review
2. Fetch `refs/bugs/*` and `refs/identities/*`
3. `validate-project` passes (including approvals scaffold)
4. Approval package present: `.opsboard/approvals/<sprint-id>/`
5. For each capability in `capabilities.md`:
   - Function Spec readable
   - Every Verification checkbox exercised or explicitly blocked with reason
6. Install / lint / typecheck / build / unit / browser as documented by the project
7. Screenshots or results committed under `.opsboard/demos/<sprint-id>/`
8. Demo markdown capability-coverage table updated
9. git-bug verification comment with SHA + capability results
10. Do **not** close deployment gates

## Evidence format

```markdown
## Acceptance result
revision: `<sha>`
sprint: <id>
package: .opsboard/approvals/<sprint-id>/

| Capability | Verification item | Result | Evidence |
| --- | --- | --- | --- |
| <slug> | <item> | pass/fail | path or command |

bootstrap: pass/fail
build: pass/fail
```

## Gating rules

- Failed bootstrap or failed verification matrix item → blocked; no silent pass
- Success evidence is factual only — not an approval of release/deploy
- Deployment still requires a separate closed deployment gate
