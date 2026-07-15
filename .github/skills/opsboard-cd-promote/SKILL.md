---
name: opsboard-cd-promote
description: Prepare and execute an approval-gated promotion of a tested OPSBOARD
  project revision to its declared live-demo Kubernetes environment. Use when defining
  CD, selecting a project namespace, preparing a canary or rollback plan, requesting
  deployment approval, or recording live-demo evidence.
metadata:
  oasr:
    hash: sha256:50f66a0e919179f78f0652e1bba3df093bc55d39bd6cdfb13980130ac1eba7dc
    source: skills/opsboard-cd-promote
    synced: 'generated'
---

# Promote a tested live demo

Keep delivery state in Git/git-bug. For OPSBOARD, the live-demo target is Metrum EKS and the desired host is `opsboard.apps.metrum.ai`.

1. Require independently committed acceptance evidence for one immutable revision.
2. Read the declared deployment manifests, host, health checks, and rollback revision. Keep kubeconfigs, tokens, and TLS material out of Git.
3. Discover namespace ownership first. Declare one namespace per project/environment; never use `default` or another project's namespace.
4. Propose the deployment manifest change pinned to the tested revision, with canary observation and documented rollback. Record a deployment gate with namespace, revision, manifest path, host/TLS readiness, checks, and rollback.
5. Do not alter EKS resources until that gate is explicitly closed. Afterwards observe rollout and workload readiness, run smoke/Playwright against the live host, and record URL, revision, evidence, and rollback reference in Git/git-bug.

Rollback through the reviewed procedure recorded in the gate. Never treat a hostname as deployment proof without observed health evidence.
