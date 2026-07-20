# skills-and-plugins

Public marketplace of reusable AI coding skills and plugins. Canonical skills live once under `skills/`, and OASR generates supported agent-specific adapters from that source.

## Install

### Codex

```bash
codex plugin marketplace add chetan-metrum-ai/skills-and-plugins
```

Codex reads `.agents/plugins/marketplace.json` and makes the packaged plugins available in supported Codex surfaces.

### Claude Code

From inside Claude Code, add the marketplace:

```text
/plugin marketplace add chetan-metrum-ai/skills-and-plugins
```

Then install a plugin:

```text
/plugin install opsboard-workflow@skills-and-plugins
```

### Generated Agent Adapters

This repo commits generated OASR adapters so agents can consume the public GitHub repo directly or copy the relevant generated directory into a project:

- Cursor: `.cursor/commands/*.md`
- Windsurf: `.windsurf/workflows/*.md`
- Codex skills: `.codex/skills/*.md`
- GitHub Copilot: `.github/prompts/*.prompt.md`
- Claude Code commands: `.claude/commands/*.md`

Use the committed generated adapter for your agent. You do not need OASR unless you are editing or regenerating skills in this repository.

## Development

Canonical skills live under `skills/`. OASR is only needed when developing skills or regenerating supported adapter output.

Install OASR with `uv`:

```bash
uv tool install oasr
```

Validate and regenerate all supported adapters:

```bash
make validate-skills
make generate-adapters
```

Equivalent scripts:

```bash
scripts/validate-skills.sh
scripts/generate-adapters.sh
```

Unsupported agents are intentionally not generated in this repo. Add support upstream in OASR instead of maintaining local custom adapters.

## Current skills

### `nvidia-setup`

Sets up NVIDIA drivers, CUDA, Fabric Manager, Docker GPU access, and post-install validation on Ubuntu GPU servers. Consumed as an OASR-generated skill adapter (not a marketplace plugin).

Typical prompts:

- "Install NVIDIA drivers and CUDA on this Ubuntu GPU server."
- "Set up this box for Docker GPU workloads."
- "Detect the GPU model and pick a current driver branch."

### `nabapro`

Generates and edits images with Google's Nano Banana Pro / Gemini image-generation API.

Typical prompts:

- "Use Nabapro to generate a product image from this prompt."
- "Edit this reference image while preserving the layout."
- "Create a poster with exact rendered text."

Real API calls require `GEMINI_API_KEY` in the environment. Dry runs do not require a key.

### `opsboard-issue-orchestrate`

Coordinates GitHub issues using dependency-aware sequencing, isolated worktree subagents, human-decision comments, and a durable `.opsboard/issue-orchestrator/` ledger.

## Current plugins

### `opsboard-workflow`

Coordinates GitHub issue delivery in a repository-owned `.opsboard/` ledger.
It determines evidence-backed issue dependencies, uses isolated git worktrees
for independent implementation subagents, posts focused comments when a human
decision is needed, and reconciles comments, worktrees, diffs, and status on
each invocation.

Typical prompts:

- "Use OPSBOARD to plan and implement GitHub issues #123 and #456."
- "Resume OPSBOARD for #123 and check whether the human answered the blocker."

## OPSBOARD issue workflow

The `opsboard-issue-orchestrate` skill provides a GitHub-issue workflow for
product repositories. It builds a dependency graph from issue evidence, starts
only ready work, and dispatches each independent issue to an isolated external
git worktree. The primary orchestrator is the sole writer of a durable
`.opsboard/issue-orchestrator/` ledger; subagents provide structured handoffs
that it verifies against the worktree before recording progress.

Humans steer unresolved requirements in the affected GitHub issue. OPSBOARD
checks for new human comments at every resume and after agent rounds, and only
posts a new comment when the evidence, question, or state changes.

It is a skill, not a hosted execution service. GitHub and Git remain the source
of issue and code truth. The `.opsboard` ledger contains no credentials and is
only committed when the user asks to persist that coordination state in Git.

## Repo layout

```text
.codex/skills/                     Generated OASR Codex adapters
.claude/commands/                  Generated OASR Claude Code adapters
.cursor/commands/                  Generated OASR Cursor adapters
.github/prompts/                   Generated OASR GitHub Copilot adapters
.windsurf/workflows/               Generated OASR Windsurf adapters
.agents/plugins/marketplace.json    Codex marketplace manifest
.claude-plugin/marketplace.json     Claude Code marketplace manifest
skills/
  nabapro/
    SKILL.md
    agents/openai.yaml
    references/gemini-image-api.md
    scripts/nabapro.py
  nvidia-setup/
    SKILL.md
    agents/openai.yaml
    references/compatibility.md
    steps/*.sh
  opsboard-issue-orchestrate/
    SKILL.md
    agents/openai.yaml
    references/state-contract.md
plugins/
  opsboard-workflow/
    .codex-plugin/plugin.json
    .claude-plugin/plugin.json
    skills/opsboard-issue-orchestrate/  Compatibility copy synced from skills/
scripts/
  generate-adapters.sh
  sync-plugin-skills.sh
  validate-skills.sh
```

## Add a new skill

1. Create `skills/<skill-name>/SKILL.md`.
2. Add bundled scripts, references, and agent metadata under `skills/<skill-name>/`.
3. Validate and regenerate adapters:

   ```bash
   make validate-skills
   make generate-adapters
   ```

   Equivalent scripts:

   ```bash
   scripts/validate-skills.sh
   scripts/generate-adapters.sh
   ```

4. If the skill is also packaged as a plugin, create `plugins/<plugin-name>/`.
5. Add both plugin manifests:
   `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json`.
6. Update both marketplace files:
   `.agents/plugins/marketplace.json` and `.claude-plugin/marketplace.json`.
7. Validate with `claude plugin validate .` when publishing Claude plugin metadata.

`skills/` is the source of truth. Compatibility copies under `plugins/*/skills/*` are generated or synced from canonical skill folders.
