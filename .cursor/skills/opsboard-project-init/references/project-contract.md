# OPSBOARD project contract

```text
.opsboard/
  project.yaml
  sprints/<sprint-id>.md
  demos/<sprint-id>.md
```

`project.yaml` records only a stable product slug, display name, default ref,
dashboard title, and non-secret demo references. A sprint file records goal,
scope, acceptance criteria, issue IDs, and explicit gate IDs. A demo file links
committed screenshots, test/build evidence, and a non-secret demo URL when one
exists.

Git-bug is the backlog and audit source. Use a sprint issue with
`opsboard:sprint`; attach every task and gate to it with
`opsboard:sprint:<id>`. Gates are separate issues with `opsboard:gate`. Progress
is an attributable git-bug comment or a commit; never infer it from a local
process or an uncommitted worktree.
