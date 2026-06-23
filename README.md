# Python SDD Architecture Skills

This repository contains a Spec-Driven Development skill suite for Python projects.

The intended daily workflow has two manual entry points:

1. Invoke `requirements-to-design` to clarify non-trivial work and produce a confirmed design document.
2. Invoke `spec-driven` with that design document path. It updates `SPEC.md`, waits for SPEC confirmation, implements, verifies, synchronizes, and audits.

The `python-architecture` skill is used as an internal rules layer for Python package boundaries, public APIs, architecture level decisions, and SPEC/code audits.

See [docs/usage.md](docs/usage.md) for the bundle layout and install shape.
