---
name: opsboard-cd-promote
description: Prepare and execute an approval-gated Flux GitOps promotion of a tested
  OPSBOARD project revision to its declared live-demo Kubernetes environment. Use
  when defining CD, selecting a project namespace, preparing a canary or rollback
  plan, requesting deployment approval, or recording live-demo reconciliation evidence.
metadata:
  oasr:
    hash: sha256:cff1328f9cd22bbebc8ecd9104d0f0346a88c7ae13171c95d0c1e7b64be6c378
    source: skills/opsboard-cd-promote
    synced: 'generated'
---

# Promote a tested live demo with GitOps

Keep delivery state in Git/git-bug. For OPSBOARD, the live-demo target is Metrum EKS and the desired host is `opsboard.apps.metrum.ai`.

1. Require independently committed acceptance evidence for one immutable revision.
2. Read the declared GitOps path, Flux objects, host, health checks, and rollback revision. Keep kubeconfigs, tokens, and TLS material out of Git.
3. Discover namespace ownership first. Declare one namespace per project/environment; never use `default` or another project's namespace.
4. Propose a GitOps-only change pinned to the tested revision, with canary observation and Git-revert rollback. Record a deployment gate with namespace, revision, Flux path, host/TLS readiness, checks, and rollback.
5. Do not reconcile or alter EKS resources until that gate is explicitly closed. Afterwards observe Flux, workload readiness, smoke/Playwright against the live host, and record URL, revision, evidence, and rollback reference in Git/git-bug.

Rollback only through a reviewed Git revert and Flux reconciliation. Never treat a hostname as deployment proof without observed health evidence.
