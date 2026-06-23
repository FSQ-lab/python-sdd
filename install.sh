#!/bin/sh
set -eu

repo_url=${PYTHON_SDD_REPO_URL:-https://github.com/FSQ-lab/python-sdd}
ref=${PYTHON_SDD_REF:-main}
target_dir=$(pwd)
force=0
yes=0
tmp_dir=

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Install Python SDD Architecture Skills into a target project.

Options:
  --target DIR   Install into DIR instead of the current directory.
  --force        Overwrite existing entry files and installed skills.
  --yes          Run non-interactively.
  -h, --help     Show this help.

Environment:
  PYTHON_SDD_SOURCE_DIR  Use a local source checkout instead of downloading.
  PYTHON_SDD_REPO_URL    GitHub repository URL for download mode.
  PYTHON_SDD_REF         Branch, tag, or commit for download mode. Default: main.
EOF
}

log() {
  printf '%s\n' "$1"
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

cleanup() {
  if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
}

trap cleanup EXIT INT TERM

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      [ "$#" -ge 2 ] || fail '--target requires a directory'
      target_dir=$2
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    --yes)
      yes=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown option: $1"
      ;;
  esac
done

target_dir=$(CDPATH= cd -- "$target_dir" && pwd) || fail "target directory does not exist: $target_dir"

confirm_install() {
  if [ "$yes" -eq 1 ]; then
    return 0
  fi

  printf 'Install Python SDD skills into %s? [y/N] ' "$target_dir" >&2
  read answer
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) fail 'installation cancelled' ;;
  esac
}

script_dir() {
  case "$0" in
    */*) CDPATH= cd -- "$(dirname -- "$0")" && pwd ;;
    *) return 1 ;;
  esac
}

download_source() {
  command -v curl >/dev/null 2>&1 || fail 'curl is required when PYTHON_SDD_SOURCE_DIR is not set'
  command -v tar >/dev/null 2>&1 || fail 'tar is required when PYTHON_SDD_SOURCE_DIR is not set'

  tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/python-sdd.XXXXXX")
  archive=$tmp_dir/source.tar.gz
  url=$repo_url/archive/$ref.tar.gz

  log "Downloading Python SDD from $url"
  curl -fsSL "$url" -o "$archive"
  tar -xzf "$archive" -C "$tmp_dir"
  find "$tmp_dir" -mindepth 1 -maxdepth 1 -type d ! -name '.*' | sed -n '1p'
}

resolve_source() {
  if [ -n "${PYTHON_SDD_SOURCE_DIR:-}" ]; then
    CDPATH= cd -- "$PYTHON_SDD_SOURCE_DIR" && pwd
    return
  fi

  local_dir=$(script_dir 2>/dev/null || true)
  if [ -n "$local_dir" ] && [ -d "$local_dir/skills" ] && [ -d "$local_dir/templates" ]; then
    printf '%s\n' "$local_dir"
    return
  fi

  download_source
}

copy_file() {
  src=$1
  dest=$2
  mode=${3:-keep}

  [ -f "$src" ] || fail "source file missing: $src"
  if [ -e "$dest" ] && [ "$force" -ne 1 ] && [ "$mode" != create ]; then
    log "Skipped existing $(relative_path "$dest")"
    return 0
  fi
  if [ -e "$dest" ] && [ "$mode" = create ]; then
    log "Kept existing $(relative_path "$dest")"
    return 0
  fi

  mkdir -p "$(dirname -- "$dest")"
  cp "$src" "$dest"
  log "Installed $(relative_path "$dest")"
}

copy_dir() {
  src=$1
  dest=$2

  [ -d "$src" ] || fail "source directory missing: $src"
  if [ -e "$dest" ]; then
    if [ "$force" -ne 1 ]; then
      log "Skipped existing $(relative_path "$dest")"
      return 0
    fi
    rm -rf "$dest"
  fi

  mkdir -p "$(dirname -- "$dest")"
  cp -R "$src" "$dest"
  log "Installed $(relative_path "$dest")"
}

relative_path() {
  path=$1
  case "$path" in
    "$target_dir"/*) printf '%s\n' "${path#$target_dir/}" ;;
    *) printf '%s\n' "$path" ;;
  esac
}

create_spec() {
  dest=$target_dir/SPEC.md
  if [ -e "$dest" ]; then
    log "Kept existing SPEC.md"
    return 0
  fi

  cat > "$dest" <<'EOF'
# SPEC

## Purpose

Describe the product, service, or library this repository implements.

## Architecture

Record the current package boundaries, public APIs, domain model, and infrastructure decisions.

## Behavior

Track accepted user-facing and developer-facing behavior. Keep this synchronized with implementation.

## Verification

List the commands that prove the implementation matches this SPEC.
EOF
  log 'Installed SPEC.md'
}

confirm_install
source_dir=$(resolve_source)

[ -d "$source_dir/skills" ] || fail "invalid source: missing skills directory in $source_dir"
[ -d "$source_dir/templates" ] || fail "invalid source: missing templates directory in $source_dir"

copy_dir "$source_dir/skills/requirements-to-design" "$target_dir/.github/skills/requirements-to-design"
copy_dir "$source_dir/skills/spec-driven" "$target_dir/.github/skills/spec-driven"
copy_dir "$source_dir/skills/python-architecture" "$target_dir/.github/skills/python-architecture"
copy_dir "$source_dir/skills/spec-implementation-audit" "$target_dir/.github/skills/spec-implementation-audit"

copy_file "$source_dir/templates/AGENTS.md" "$target_dir/AGENTS.md"
copy_file "$source_dir/templates/CLAUDE.md" "$target_dir/CLAUDE.md"
copy_file "$source_dir/templates/vscode/copilot-instructions.md" "$target_dir/.github/copilot-instructions.md"
copy_file "$source_dir/templates/vscode/requirements-to-design.prompt.md" "$target_dir/.github/prompts/requirements-to-design.prompt.md"
copy_file "$source_dir/templates/vscode/spec-driven.prompt.md" "$target_dir/.github/prompts/spec-driven.prompt.md"
create_spec

log 'Python SDD installation finished.'
