---
name: opsboard-acceptance-verify
description: Use this skill to independently verify an OPSBOARD sprint from a clean Git checkout and capture factual Git-backed acceptance evidence. Trigger when a sprint needs clean-clone/bootstrap validation, build/unit/Playwright verification, committed screenshots, or an independent release-evidence review.
---

# Verify an OPSBOARD delivery

Work in a fresh external clone or worktree, independent of the implementing agent.

## Workflow

1. **Bootstrap from scratch.** Initialize submodules; fetch `refs/identities/*` and `refs/bugs/*`; run the project validator; install project agents twice. A changed template hash or missing contract is a **failed** bootstrap result.
2. **Read the immutable revision.** Inspect the current sprint, approval package, gates, and git-bug records at the revision under review.
3. **Walk the Function Spec verification matrix** for every in-scope capability. Record pass/fail per checkbox — not a generic “looks good.”
4. **Run the documented checks.** Install, lint, typecheck, build, unit, and browser checks. For web work, inspect deterministic desktop and mobile renders.
5. **On success:** commit only factual results and screenshots in `.opsboard/demos/<sprint-id>/`, update the demo record with capability coverage, and comment on the verification issue.
6. **On failure:** leave application code unchanged, record the exact failed command or assertion (and capability slug), and mark the issue blocked.

## Prohibited

Do not deploy, close deployment gates, expose credentials, or infer state from a local process. Never treat a hostname as deployment proof without observed health evidence. Closing acceptance does **not** authorize deployment.

## Reference

- [`references/acceptance-verify.md`](references/acceptance-verify.md) — Verification checklist, evidence format, and gating rules
