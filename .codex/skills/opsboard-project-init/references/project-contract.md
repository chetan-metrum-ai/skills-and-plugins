# OPSBOARD project contract

```text
.opsboard/
  project.yaml
  sprints/<sprint-id>.md
  approvals/<sprint-id>/
    README.md                 # index: gates, status, links
    capabilities.md           # catalog of every capability in sprint
    capabilities/<slug>.md    # one Function Spec per capability
    flows/<slug>.md           # mermaid user + admin schematics
    mocks/<slug>/             # mock screens (png/html)
    videos/<slug>/            # short mock interaction video + narration lock notes
    decisions/<decision-id>/  # mid-flight option packages
  demos/<sprint-id>.md
  demos/<sprint-id>/
```

`project.yaml` records only a stable product slug, display name, default ref,
dashboard title, and non-secret demo references.

A sprint file records goal, scope, acceptance criteria, and the path to its
approval package (`.opsboard/approvals/<sprint-id>/`). Issue and gate IDs are
filled in **after** plan-lock closes; a proposal may exist without them.

An approval package is the human decision surface. Agents auto-build it before
plan-lock; humans only approve or steer. Every in-scope product capability has
a Function Spec under `capabilities/<slug>.md` plus linked flows, mocks, and
(when UI-facing) a short mock interaction video.

A demo file links committed screenshots, test/build evidence, and a non-secret
demo URL when one exists. Post-build evidence must map to the Function Spec
verification matrix in the approval package.

## Git-bug taxonomy

Git-bug is the backlog and audit source. Use a sprint issue with
`opsboard:sprint`; attach every task and gate to it with
`opsboard:sprint:<id>`. Gates are separate issues with `opsboard:gate`. Mid-flight
choices use `opsboard:human-decision` and link a folder under
`approvals/<sprint-id>/decisions/`. Progress is an attributable git-bug comment
or a commit; never infer it from a local process or an uncommitted worktree.

### Labels

- `opsboard:sprint`
- `opsboard:gate`
- `opsboard:human-decision`
- `opsboard:sprint:<id>`
- `opsboard:role:<planner|implementer|reviewer|status-steward|orchestrator|acceptance-tester|deployment-engineer|deployment-approver>`
- `opsboard:state:<planned|active|blocked|review|done>`

### Gate types

See the sprint-plan reference for the full taxonomy: `plan-lock`, `design-ux`,
`review`, `deployment`, `policy` / `security` / `schema` / `irreversible`, and
`human-decision`.

Approval is durable only when a human comments the required choice and closes
the gate or decision issue. Chat-only answers are never enough. Agents never
impersonate approvers.

For a repository to be independently projectable, publish its Git-bug objects in
both `refs/bugs/*` and `refs/identities/*`. A consumer fetches those refs
explicitly before running `git-bug`; ordinary Git clone refspecs fetch branches
only. These Git refs remain the sole backlog/audit state.
