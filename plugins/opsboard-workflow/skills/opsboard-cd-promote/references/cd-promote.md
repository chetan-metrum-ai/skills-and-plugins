# CD promote reference

## Deployment gate template

Title: `gate: deployment <sprint-id> <revision-short>`

Labels: `opsboard:gate`, `opsboard:sprint:<id>`, `opsboard:state:planned`

```markdown
## Deployment authority required
Close only with explicit human deployment authority.
Required comment: `approve deployment <ns> @ <sha>`

## Immutable revision
`<full-sha>`

## Acceptance evidence
SHA: `<evidence-sha>`
Demo: `.opsboard/demos/<sprint-id>.md`
Package: `.opsboard/approvals/<sprint-id>/`
Capability coverage: <pass count>/<total> (link table)

## Namespace ownership
namespace: <project-env>
cluster: Metrum EKS
forbidden: default, shared foreign namespaces

## Manifest
path: <path>
host: opsboard.apps.metrum.ai (or project host)
TLS: ready | gap: ...
health checks: ...

## Canary
steps: ...
observe for: ...
abort when: ...

## Rollback
revision: `<previous-sha>`
procedure: ...
```

## Canary plan (minimum)

1. Apply pinned revision to owned namespace only
2. Wait for workload ready
3. Smoke + Playwright against live host
4. Record URL, revision, evidence paths in git-bug
5. Abort to rollback revision on health failure

## Rollback format

```text
rollback
from: <failed-sha>
to: <previous-sha>
namespace: <ns>
reason: <observed failure>
evidence: <log or check>
```

Agents never close this gate. Humans comment the required phrase and close.
