# skills-and-plugins

Public marketplace of reusable AI coding skills and plugins, structured so the same repo can be added to both Codex and Claude Code.

## Install

### Codex

Add the marketplace:

```bash
codex plugin marketplace add chetan-metrum-ai/skills-and-plugins
```

Codex will read the marketplace manifest from this repo and make the packaged plugins available in supported Codex surfaces.

### Claude Code

From inside Claude Code, add the marketplace:

```text
/plugin marketplace add chetan-metrum-ai/skills-and-plugins
```

Then install the first plugin:

```text
/plugin install nvidia-setup@skills-and-plugins
```

You can also validate the repo locally before publishing:

```bash
claude plugin validate .
```

## Current plugins

### `nvidia-setup`

Sets up NVIDIA drivers, CUDA, Fabric Manager, Docker GPU access, and post-install validation on Ubuntu GPU servers.

Typical prompts:

- "Install NVIDIA drivers and CUDA on this Ubuntu GPU server."
- "Set up this box for Docker GPU workloads."
- "Detect the GPU model and pick a current driver branch."

## Repo layout

```text
.agents/plugins/marketplace.json    Codex marketplace manifest
.claude-plugin/marketplace.json     Claude Code marketplace manifest
plugins/
  nvidia-setup/
    .codex-plugin/plugin.json
    .claude-plugin/plugin.json
    skills/nvidia-setup/
      SKILL.md
      agents/openai.yaml
      references/compatibility.md
      steps/*.sh
```

## Add a new plugin

1. Create `plugins/<plugin-name>/`.
2. Add both plugin manifests:
   `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json`.
3. Put the skill under `skills/<skill-name>/SKILL.md`.
4. Update both marketplace files:
   `.agents/plugins/marketplace.json` and `.claude-plugin/marketplace.json`.
5. Validate with `claude plugin validate .`.

This repo intentionally keeps the skill content inside each plugin so one plugin tree can be consumed by both ecosystems.
