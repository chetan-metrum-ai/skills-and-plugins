---
name: opsboard-dashboard-register
description: Prepare a Git-native project for a hosted read-only OPSBOARD dashboard.
  Use when declaring a repository, Git ref, dashboard metadata, demo references, or
  a revocable read-only remote credential reference without granting OPSBOARD write
  access.
metadata:
  oasr:
    hash: sha256:bf27c1642907c14e35310d8d70d831f354e12f246694f09e1e6a1723ec4c4fd0
    source: skills/opsboard-dashboard-register
    synced: 'generated'
---

# Register a read-only dashboard source

Validate `.opsboard/project.yaml`, sprint files, demo records, and git-bug status
before registration. The project repository remains authoritative; OPSBOARD only
clones the declared ref and renders a non-secret projection.

Record a catalog proposal containing the project slug, display name, Git URL/ref,
workflow-package commit, and the name of a platform-managed read-only credential
reference. Never commit or paste the credential itself, a token, a private key, or
a generated projection.

Require the repository owner to approve registration and credential scope. The
credential permits read-only clone/fetch only; no browser or hosted dashboard path
may edit Git or git-bug. Verify the selected ref contains a valid contract and
report stale, unavailable, malformed, or unauthorized projection states visibly.
