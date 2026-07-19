# Copilot Instructions

<!-- ASR-MANAGED-SKILLS -->
## Available Skills

The following agent skills are available. Invoke them by typing `/<skill-name>` in chat.

- **/nabapro** — Use this skill when the user needs to generate, edit, or iterate on images with Google's Gemini image-generation API (Nano Banana Pro). Trigger on requests for product visuals, brand/campaign imagery, text-in-image rendering, reference-based editing, style transfer, video-to-image, multi-turn refinement, or any Gemini image workflow. Applies Metrum AI branding by default unless the user provides another brand.
- **/narrated-video-production** — Use this skill when the user needs a narrated product demo, tutorial, launch video, training video, or informational video that combines voice-over with slides, text, images, screen recordings, or clips. Trigger on any request to plan or produce a video with a speech narrative.
- **/nvidia-setup** — Use this skill when installing or repairing NVIDIA GPU drivers, CUDA, Fabric Manager, or Docker GPU runtime on Ubuntu Linux servers. Trigger when the user asks to set up a GPU host, clean up an old NVIDIA stack, prepare a server for CUDA or vLLM workloads, or validate that containers can see GPUs.
- **/opsboard-acceptance-verify** — Use this skill to independently verify an OPSBOARD sprint from a clean Git checkout and capture factual Git-backed acceptance evidence. Trigger when a sprint needs clean-clone/bootstrap validation, build/unit/Playwright verification, committed screenshots, or an independent release-evidence review.
- **/opsboard-cd-promote** — Use this skill to prepare and execute an approval-gated promotion of a tested OPSBOARD project revision to its declared live-demo Kubernetes environment. Trigger when defining CD, selecting a project namespace, preparing a canary or rollback plan, requesting deployment approval, or recording live-demo evidence.
- **/opsboard-dashboard-register** — Use this skill to prepare a Git-native project for a hosted read-only OPSBOARD dashboard. Trigger when declaring a repository, Git ref, dashboard metadata, demo references, or a revocable read-only remote credential reference without granting OPSBOARD write access.
- **/opsboard-demo-capture** — Use this skill to capture Git-backed test evidence, screenshots, and demo references for an OPSBOARD sprint. Trigger when a task or sprint is ready for review, needs visible acceptance evidence, or must update the read-only dashboard demo view.
- **/opsboard-orchestrate** — Use this skill to coordinate Git-native OPSBOARD worktrees and human decision gates. Trigger when agents are blocked on human input, when an operator must list waiting worktrees, when reviewing open decision issues, or when resuming work after a git-bug approval.
- **/opsboard-project-init** — Use this skill to initialize or validate a Git-native OPSBOARD project. Trigger when a repository needs the standard `.opsboard` contract, git-bug sprint taxonomy, external-worktree conventions, approval-package layout, or project-scoped OPSBOARD Codex agents.
- **/opsboard-sprint-plan** — Use this skill to turn a terse product brief into a reviewable, approval-gated OPSBOARD sprint. Trigger when planning a sprint, breaking work into issues, defining acceptance criteria, building a human-approval package, or creating human gates before agents start work.
- **/opsboard-status-update** — Use this skill to record durable, non-secret OPSBOARD project status in git-bug and Git. Trigger when an agent starts, hands off, becomes blocked, requests review, completes work, or needs to make dashboard status accurate.
- **/opsboard-worktree-task** — Use this skill to start one approved OPSBOARD git-bug issue in an isolated external Git worktree. Trigger when assigning an implementer or reviewer, creating a task branch, recording a handoff, or checking that a gate permits work to begin.

<!-- /ASR-MANAGED-SKILLS -->
