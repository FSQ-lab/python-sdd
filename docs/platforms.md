# Platform Usage

The canonical skill source is the `skills/` directory. Keep one copy of the skill text there and let each platform point to it.

## One-command Project Install

Run this from the target project root.

Windows PowerShell:

```powershell
$env:PYTHON_SDD_INSTALL_YES = '1'; irm https://raw.githubusercontent.com/FSQ-lab/python-sdd/main/install.ps1 | iex; Remove-Item Env:PYTHON_SDD_INSTALL_YES
```

macOS or Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/FSQ-lab/python-sdd/main/install.sh | sh -s -- --yes
```

The installer creates the Codex, VS Code, and Claude Code entry files described below. It preserves existing files unless `--force` is passed.

## Codex

For repository-local use:

```text
.github/skills/requirements-to-design/SKILL.md
.github/skills/spec-driven/SKILL.md
.github/skills/spec-implementation-audit/SKILL.md
.github/skills/python-architecture/SKILL.md
AGENTS.md
SPEC.md
```

Copy `templates/AGENTS.md` to the repository root and copy `skills/*` to `.github/skills/` or to your personal Codex skills directory.

Create root `SPEC.md` if the target repository does not already have one.

Daily use:

```text
$requirements-to-design <request>
$spec-driven docs/superpowers/specs/<design>.md
```

## Claude Code

For personal skill use, copy `skills/*` to your Claude skills directory, commonly:

```text
~/.claude/skills/
```

For repository guidance, copy `templates/CLAUDE.md` to the repository root. Keep `SPEC.md` as the source of truth.

Daily use:

```text
$requirements-to-design <request>
$spec-driven docs/superpowers/specs/<design>.md
```

## VS Code

VS Code support depends on the agent extension.

### VS Code with Codex

Use the Codex setup above: `AGENTS.md` plus the `skills/` directories.

### VS Code with GitHub Copilot

GitHub Copilot does not use Codex `SKILL.md` discovery directly. Use the same source files as prompt context:

```text
.github/copilot-instructions.md
.github/prompts/requirements-to-design.prompt.md
.github/prompts/spec-driven.prompt.md
skills/
SPEC.md
```

Copy:

- `templates/vscode/copilot-instructions.md` to `.github/copilot-instructions.md`
- `templates/vscode/requirements-to-design.prompt.md` to `.github/prompts/requirements-to-design.prompt.md`
- `templates/vscode/spec-driven.prompt.md` to `.github/prompts/spec-driven.prompt.md`

The prompt files tell Copilot to read the canonical `skills/` content before acting.

## Repository Source Of Truth

Across all platforms:

- `SPEC.md` is the implementation source of truth.
- `skills/` is the skill source of truth.
- `AGENTS.md`, `CLAUDE.md`, and Copilot instruction files are thin entry points.
