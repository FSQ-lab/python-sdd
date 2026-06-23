# Python SDD Architecture Skills

This repository contains a Spec-Driven Development skill suite for Python projects. It is designed to be usable from Codex, VS Code agent workflows, and Claude Code while keeping `skills/` as the single source of truth.

The intended daily workflow has two manual entry points:

1. Invoke `requirements-to-design` to clarify non-trivial work and produce a confirmed design document.
2. Invoke `spec-driven` with that design document path. It updates `SPEC.md`, waits for SPEC confirmation, implements, verifies, synchronizes, and audits.

The `python-architecture` skill is used as an internal rules layer for Python package boundaries, public APIs, architecture level decisions, and SPEC/code audits.

## Platforms

- Codex: use `AGENTS.md` plus repository or personal skills.
- VS Code with Codex: use the Codex setup.
- VS Code with GitHub Copilot: use `.github/copilot-instructions.md` and prompt files that point to `skills/`.
- Claude Code: use `CLAUDE.md` plus installed skills.

See [docs/usage.md](docs/usage.md) for the bundle layout and [docs/platforms.md](docs/platforms.md) for platform-specific setup.
