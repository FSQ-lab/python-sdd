# Python SDD Architecture Skills

This bundle provides a two-entry SDD workflow for Python projects.

## Daily Flow

1. Invoke `requirements-to-design` for non-trivial changes.
2. Review and confirm the generated design document.
3. Invoke `spec-driven` with the design document path.
4. `spec-driven` updates specs, asks for SPEC confirmation, implements, verifies, synchronizes, and audits.

## Skills

- `requirements-to-design`: design-only entry point.
- `spec-driven`: main orchestrator from SPEC updates through implementation and audit.
- `python-architecture`: Python package, boundary, and architecture rules used internally by the flow.
- `spec-implementation-audit`: diff-based SPEC compliance audit.

## Install Shape

Keep `skills/` as the canonical source. Copy or reference it from the platform-specific location:

- Codex repository-local: copy `skills/*` to `.github/skills/` and use `templates/AGENTS.md` as root `AGENTS.md`.
- Codex personal: copy `skills/*` to your personal Codex skills directory.
- Claude Code: copy `skills/*` to your Claude skills directory and use `templates/CLAUDE.md` as root `CLAUDE.md`.
- VS Code with Copilot: copy the templates under `templates/vscode/` into `.github/` and `.github/prompts/`.

For repository use, create or maintain root `SPEC.md`, then keep `AGENTS.md` and `CLAUDE.md` as thin pointers to `SPEC.md`.

See `docs/platforms.md` for details.
