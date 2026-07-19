---
name: opsboard-cd-promote
description: Use this skill to prepare and execute an approval-gated promotion of a tested OPSBOARD project revision to its declared live-demo Kubernetes environment. Trigger when defining CD, selecting a project namespace, preparing a canary or rollback plan, requesting deployment approval, or recording live-demo evidence.
---

# Promote a tested live demo

Keep delivery state in Git/git-bug. For OPSBOARD, the live-demo target is Metrum EKS and the desired host is `opsboard.apps.metrum.ai`.

## Workflow

1. **Require independent acceptance evidence** for one immutable revision, including capability coverage against the approval package.
2. **Read the declared deployment.** Manifests, host, health checks, and rollback revision. Keep kubeconfigs, tokens, and TLS material out of Git.
3. **Discover namespace ownership first.** Declare one namespace per project/environment. Never use `default` or another project's namespace.
4. **Propose the deployment change.** Pin the manifest to the tested revision, with canary observation and documented rollback. Record a **deployment** gate whose body links: namespace, revision, manifest path, host/TLS readiness, checks, rollback, acceptance evidence SHA, and capability coverage summary.
5. **Wait for the gate.** Do **not** alter EKS resources until that gate is explicitly closed by a human with deployment authority. After closure, observe rollout and workload readiness, run smoke/Playwright against the live host, and record URL, revision, evidence, and rollback reference in Git/git-bug.

## Rollback

Roll back through the reviewed procedure recorded in the gate. Never treat a hostname as deployment proof without observed health evidence.

## Reference

- [`references/cd-promote.md`](references/cd-promote.md) — Gate template, canary plan, and rollback format
