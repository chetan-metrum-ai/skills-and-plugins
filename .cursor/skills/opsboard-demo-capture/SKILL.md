---
name: opsboard-demo-capture
description: Use this skill to capture Git-backed test evidence, screenshots, and
  demo references for an OPSBOARD sprint. Trigger when a task or sprint is ready for
  review, needs visible acceptance evidence, or must update the read-only dashboard
  demo view.
metadata:
  oasr:
    hash: sha256:3026882868b322d47e05abb0a474b8506fdc0be19bf544b9b1755d3f8f590d6f
    source: skills/opsboard-demo-capture
    synced: 'generated'
---

# Capture demo evidence

## Workflow

1. Read the sprint acceptance criteria **and** Function Spec verification matrices under `.opsboard/approvals/<sprint-id>/capabilities/`. Capture only evidence actually produced.
2. Map every screenshot or test result to a capability slug and a verification checkbox — not free-form galleries.
3. For web products, use the project's browser test tooling to capture deterministic desktop and responsive screenshots.
4. Store reviewable screenshots and concise test/build results in the repository's declared demo location.
5. Update `.opsboard/demos/<sprint-id>.md` with commit references, capability IDs covered, and non-secret demo links.
6. Record evidence in the related git-bug issue and request the required **review** gate. The gate body must cite capability IDs.

## Honesty rules

- Do **not** claim a screenshot, release, deployment, or approval that did not happen.
- Never commit generated status snapshots, credentials, test tokens, or private environment configuration.
- Pre-build mocks/videos in the approval package are foresight, not acceptance proof — replace or supplement with post-build evidence for review.

## Reference

- [`references/demo-capture.md`](references/demo-capture.md) — Demo file layout, verification mapping, and commit conventions
