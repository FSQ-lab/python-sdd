#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file() {
  [ -f "$repo_root/$1" ] || fail "missing $1"
}

assert_contains() {
  grep -F "$2" "$repo_root/$1" >/dev/null || fail "$1 does not contain $2"
}

assert_file "install.ps1"
assert_contains "README.md" "irm https://raw.githubusercontent.com/FSQ-lab/python-sdd/main/install.ps1 | iex"
assert_contains "docs/usage.md" "irm https://raw.githubusercontent.com/FSQ-lab/python-sdd/main/install.ps1 | iex"
assert_contains "docs/platforms.md" "irm https://raw.githubusercontent.com/FSQ-lab/python-sdd/main/install.ps1 | iex"
assert_contains "README.md" "PYTHON_SDD_INSTALL_YES"
assert_contains "install.ps1" "PYTHON_SDD_INSTALL_YES"
assert_contains "install.ps1" "PYTHON_SDD_INSTALL_FORCE"
assert_contains "install.ps1" ".github/skills/requirements-to-design"
assert_contains "install.ps1" ".github/prompts/spec-driven.prompt.md"
assert_contains "install.ps1" "SPEC.md"

printf 'PASS: Windows PowerShell installer entry is documented\n'
