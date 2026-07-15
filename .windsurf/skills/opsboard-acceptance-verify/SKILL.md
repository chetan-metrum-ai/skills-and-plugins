---
name: opsboard-acceptance-verify
description: Independently verify an OPSBOARD sprint from a clean Git checkout and
  capture factual Git-backed acceptance evidence. Use when a sprint needs clean-clone/bootstrap
  validation, build/unit/Playwright verification, committed screenshots, or an independent
  release-evidence review.
metadata:
  oasr:
    hash: sha256:a59d1a818a2bdbd27c8bad63f7ae89e49fd42c9c63d4795457379fb5bafd6fa1
    source: skills/opsboard-acceptance-verify
    synced: 'generated'
---

# Verify an OPSBOARD delivery

Work in a fresh external clone or worktree, independent of the implementing agent.

1. Initialize submodules. Fetch `refs/identities/*` and `refs/bugs/*`, run the project validator, and install project agents twice. A changed template hash or missing contract is a failed bootstrap result.
2. Read the current sprint, gate, and git-bug records at the immutable revision under review.
3. Run documented install, lint, typecheck, build, unit, and browser checks. For web work inspect deterministic desktop and mobile renders.
4. If all checks pass, commit only factual results and screenshots in `.opsboard/demos/<sprint-id>/`, update the demo record, and comment on the verification issue.

On failure, leave application code unchanged, record the exact failed command or assertion, and mark the issue blocked. Do not deploy, close deployment gates, expose credentials, or infer state from a local process.
