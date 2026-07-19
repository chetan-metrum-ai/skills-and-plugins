---
name: opsboard-dashboard-register
description: Use this skill to prepare a Git-native project for a hosted read-only OPSBOARD dashboard. Trigger when declaring a repository, Git ref, dashboard metadata, demo references, or a revocable read-only remote credential reference without granting OPSBOARD write access.
---

# Register a read-only dashboard source

The project repository is authoritative. OPSBOARD only clones the declared ref and renders a non-secret projection.

## Workflow

1. **Validate before registration.** `.opsboard/project.yaml`, sprint files, demo records, and git-bug status must all be valid.
2. **Record a catalog proposal** containing:
   - Project slug and display name
   - Git URL and ref
   - Workflow-package commit
   - Name of a platform-managed read-only credential reference
3. **Require owner approval.** Both the registration and the credential scope must be approved by the repository owner.
4. **Verify the selected ref** contains a valid contract. Report stale, unavailable, malformed, or unauthorized projection states visibly.

## Constraints

- Never commit or paste the credential itself, a token, a private key, or a generated projection.
- The credential permits read-only clone/fetch only — no browser or hosted dashboard path may edit Git or git-bug.

## Reference

- [`references/dashboard-register.md`](references/dashboard-register.md) — Catalog proposal template and credential reference format
