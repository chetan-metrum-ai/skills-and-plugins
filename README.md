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
/plugin install nvidia-setup@skills-and-plugins
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

## Current plugins

### `nvidia-setup`

Sets up NVIDIA drivers, CUDA, Fabric Manager, Docker GPU access, and post-install validation on Ubuntu GPU servers.

Typical prompts:

- "Install NVIDIA drivers and CUDA on this Ubuntu GPU server."
- "Set up this box for Docker GPU workloads."
- "Detect the GPU model and pick a current driver branch."

### `banano`

Generates and edits images with Google's Nano Banana Pro / Gemini image-generation API.

Typical prompts:

- "Use Banano to generate a product image from this prompt."
- "Edit this reference image while preserving the layout."
- "Create a poster with exact rendered text."

Real API calls require `GEMINI_API_KEY` in the environment. Dry runs do not require a key.

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
  banano/
    SKILL.md
    agents/openai.yaml
    references/gemini-image-api.md
    scripts/banano.py
  nvidia-setup/
    SKILL.md
    agents/openai.yaml
    references/compatibility.md
    steps/*.sh
plugins/
  nvidia-setup/
    .codex-plugin/plugin.json
    .claude-plugin/plugin.json
    skills/nvidia-setup/            Compatibility copy synced from skills/nvidia-setup
scripts/
  generate-adapters.sh
  sync-plugin-skills.sh
  validate-skills.sh
```

## Add a new plugin

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
