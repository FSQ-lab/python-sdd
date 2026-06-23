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
- `sdd-init`: bootstrap/migration helper for repositories.

## Install Shape

Copy `skills/*` into a repository-level skill directory such as `.github/skills/`, or into your personal Codex skills directory if you want them globally available.

For repository use, initialize root `SPEC.md`, then keep `AGENTS.md` and `CLAUDE.md` as thin pointers to `SPEC.md`.
