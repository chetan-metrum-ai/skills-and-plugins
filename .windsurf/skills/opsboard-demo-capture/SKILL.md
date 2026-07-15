---
name: opsboard-demo-capture
description: Capture Git-backed test evidence, screenshots, and demo references for
  an OPSBOARD sprint. Use when a task or sprint is ready for review, needs visible
  acceptance evidence, or must update the read-only dashboard demo view.
metadata:
  oasr:
    hash: sha256:e1aa4d90d4c935f2a71282ef328d8fb2099960b8f73d61e3c9e124522a84f5f1
    source: skills/opsboard-demo-capture
    synced: 'generated'
---

# Capture demo evidence

Read the sprint acceptance criteria first. Run the documented checks and capture
only evidence that was actually produced. For web products, use the project's
browser test tooling to capture deterministic desktop and responsive screenshots.

Store reviewable screenshots and concise test/build results in the repository's
declared demo location, then update `.opsboard/demos/<sprint-id>.md` with commit
references and non-secret demo links. Record the evidence in the related git-bug
issue and request the required review gate.

Do not claim a screenshot, release, deployment, or approval that did not happen.
Never commit generated status snapshots, credentials, test tokens, or private
environment configuration.
