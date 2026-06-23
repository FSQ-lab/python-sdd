#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tmp_root=${TMPDIR:-/tmp}/python-sdd-install-test-$$
target=$tmp_root/project

cleanup() {
  rm -rf "$tmp_root"
}

trap cleanup EXIT INT TERM

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$target/$1" ] || fail "missing $1"
}

assert_contains() {
  grep -F "$2" "$target/$1" >/dev/null || fail "$1 does not contain $2"
}

mkdir -p "$target"
printf '# Existing spec\n' > "$target/SPEC.md"
printf 'keep me\n' > "$target/AGENTS.md"

PYTHON_SDD_SOURCE_DIR=$repo_root sh "$repo_root/install.sh" --target "$target" --yes

assert_file ".github/skills/requirements-to-design/SKILL.md"
assert_file ".github/skills/spec-driven/SKILL.md"
assert_file ".github/skills/python-architecture/SKILL.md"
assert_file ".github/skills/spec-implementation-audit/SKILL.md"
assert_file ".github/skills/python-architecture/references/implementation-rules.md"
assert_file ".github/copilot-instructions.md"
assert_file ".github/prompts/requirements-to-design.prompt.md"
assert_file ".github/prompts/spec-driven.prompt.md"
assert_file "CLAUDE.md"
assert_contains "SPEC.md" "# Existing spec"
assert_contains "AGENTS.md" "keep me"

PYTHON_SDD_SOURCE_DIR=$repo_root sh "$repo_root/install.sh" --target "$target" --yes --force

assert_contains "AGENTS.md" "This repository uses Python Spec-Driven Development."

fresh=$tmp_root/fresh-project
mkdir -p "$fresh"
target=$fresh
PYTHON_SDD_SOURCE_DIR=$repo_root sh "$repo_root/install.sh" --target "$target" --yes

assert_file "SPEC.md"
assert_contains "SPEC.md" "# SPEC"

printf 'PASS: install script installs project-local Python SDD files\n'
