---
name: sdd-init
description: Use when initializing or migrating a Python repository to Spec-Driven Development with root SPEC.md, thin agent instruction files, and Python architecture-aware workflow skills.
---

# SDD Init

Bootstrap a repository for Spec-Driven Development with Python architecture rules. This prepares project instructions and workflow skills; it is not the daily development workflow.

## Target Daily Workflow

Users manually invoke two entry points:

```text
requirements-to-design
  -> confirmed design document
  -> prompt user to invoke spec-driven with the design path

spec-driven
  -> SPEC.md updates
  -> user confirms SPEC.md changes
  -> implementation
  -> verification
  -> SPEC/code synchronization check
  -> spec-implementation-audit
```

`python-architecture` is an internal rules layer used by `requirements-to-design`, `spec-driven`, and `spec-implementation-audit` for Python projects.

## Supported Entry Points

```text
AGENTS.md                         # Codex / VS Code Codex
CLAUDE.md                         # Claude / Claude Code
.github/copilot-instructions.md   # VS Code with GitHub Copilot
.github/prompts/*.prompt.md       # VS Code reusable prompts
```

Do not modify other instruction files unless the user explicitly asks.

## Target Structure

After initialization, the repository should have:

```text
SPEC.md
AGENTS.md
CLAUDE.md
.github/skills/requirements-to-design/SKILL.md
.github/skills/spec-driven/SKILL.md
.github/skills/spec-implementation-audit/SKILL.md
.github/skills/python-architecture/SKILL.md
.github/skills/python-architecture/references/*.md
.github/copilot-instructions.md         (optional for VS Code Copilot)
.github/prompts/requirements-to-design.prompt.md
.github/prompts/spec-driven.prompt.md
```

## Procedure

### 1. Inspect Existing Instructions

Check for:

- Root `SPEC.md`.
- `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md`.
- Existing `.github/skills/` files.
- Existing project rules that conflict with SDD hard gates.

If a conflict exists, stop and ask which policy should win. Do not silently overwrite project rules.

### 2. Create Or Update Root SPEC.md

If root `SPEC.md` does not exist and agent instruction files contain project specification content, migrate that content into root `SPEC.md`.

Root `SPEC.md` should include:

```text
# {project} Project Specification
## Spec-Driven Development Workflow
## Module Table
## Architecture Diagram
## Development Rules
## Python Architecture Rules
```

Insert or update the SDD gates:

```text
For non-trivial development:
1. Use requirements-to-design to clarify requirements and produce a design document.
2. Invoke spec-driven with that design document path.
3. Update or create relevant root/module SPEC.md files.
4. Get SPEC.md confirmation before implementation.
5. Implement only against confirmed SPEC.md.
6. If implementation reveals missing design, stop and update SPEC.md first.
7. Before claiming completion, run diff-based SPEC implementation audit.
```

For Python repositories, add:

```text
Python modules must document public APIs, internal modules, dependency direction, architecture level, model boundaries, and testing contracts in module SPEC.md files.
```

Bug fixes that do not change public interfaces or intended behavior may skip design document creation, but must still read relevant `SPEC.md` files and verify specs remain accurate.

### 3. Create Thin Agent Entry Points

Update `AGENTS.md` and `CLAUDE.md` so they point to root `SPEC.md` without duplicating the project specification.

Each should state:

- This repository uses SDD.
- Root `SPEC.md` is the project-level source of truth.
- Relevant module `SPEC.md` files must be read before changes.
- Non-trivial work starts with `requirements-to-design`; implementation starts with `spec-driven` after design approval.
- Completion requires diff-based SPEC implementation audit.

For VS Code with GitHub Copilot, create `.github/copilot-instructions.md` and prompt files under `.github/prompts/` that point to the canonical `skills/` files instead of duplicating the workflow text.

### 4. Install Workflow Skills

Install or update:

- `requirements-to-design`
- `spec-driven`
- `spec-implementation-audit`
- `python-architecture`

Do not duplicate all workflow details in `sdd-init`; point to the dedicated skills.

### 5. Verify Bootstrap

Confirm:

- Root `SPEC.md` exists and contains SDD gates.
- `AGENTS.md` and `CLAUDE.md` are thin pointers to root `SPEC.md`.
- All four workflow skills exist under `.github/skills/`.
- Python architecture references exist.
- VS Code templates are installed when requested.
- No unsupported instruction files were modified.

## Completion Message

End by telling the user:

```text
Daily workflow:
1. Invoke requirements-to-design for non-trivial changes.
2. Review the generated design document.
3. Invoke spec-driven with the design document path.
```
