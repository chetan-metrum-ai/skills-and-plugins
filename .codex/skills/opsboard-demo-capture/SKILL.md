---
name: opsboard-demo-capture
description: Use this skill to capture Git-backed test evidence, screenshots, and
  demo references for an OPSBOARD sprint. Trigger when a task or sprint is ready for
  review, needs visible acceptance evidence, or must update the read-only dashboard
  demo view.
metadata:
  oasr:
    hash: sha256:a046b3b398025350a50ec32c116fd397e43c855dca6df74fe4aca4e7efb18511
    source: skills/opsboard-demo-capture
    synced: 'generated'
---

# Capture demo evidence

## Workflow

1. Read the sprint acceptance criteria first. Capture only evidence actually produced.
2. For web products, use the project's browser test tooling to capture deterministic desktop and responsive screenshots.
3. Store reviewable screenshots and concise test/build results in the repository's declared demo location.
4. Update `.opsboard/demos/<sprint-id>.md` with commit references and non-secret demo links.
5. Record evidence in the related git-bug issue and request the required review gate.

## Honesty rules

- Do **not** claim a screenshot, release, deployment, or approval that did not happen.
- Never commit generated status snapshots, credentials, test tokens, or private environment configuration.

## Reference

- [`references/demo-capture.md`](references/demo-capture.md) — Demo file layout, screenshot conventions, and commit conventions
