# Platform Usage

The canonical skill source is the `skills/` directory. Keep one copy of the skill text there and let each platform point to it.

## Codex

For repository-local use:

```text
.github/skills/requirements-to-design/SKILL.md
.github/skills/spec-driven/SKILL.md
.github/skills/spec-implementation-audit/SKILL.md
.github/skills/python-architecture/SKILL.md
.github/skills/sdd-init/SKILL.md
AGENTS.md
SPEC.md
```

Copy `templates/AGENTS.md` to the repository root and copy `skills/*` to `.github/skills/` or to your personal Codex skills directory.

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
