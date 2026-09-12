#!/usr/bin/env bash
# Install the agent working agreement: either layer, or both.
#
#   ./install.sh                     dry run, global layer
#   ./install.sh --global            global layer only  (this machine)
#   ./install.sh --project DIR       project files into DIR (the repository to set up)
#   ./install.sh --all DIR           both
#
#   --yes     actually write (nothing is written without it)
#   --force   overwrite project files that already exist
#
# Global layer = the universal contract, installed to both tools:
#   ~/.claude/CLAUDE.md      Claude Code user-level memory
#   ~/.codex/AGENTS.md       Codex user-level instructions
#   ~/.claude/code-style.md  per-language style, referenced by the contract
#
# Project layer = the four templates copied into a repository, never overwritten unless --force.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DO_GLOBAL=0
DO_PROJECT=0
PROJECT_DIR=""
WRITE=0
FORCE=0

usage() { sed -n '2,17p' "$0"; exit "${1:-0}"; }
die() { echo "error: $*" >&2; exit 2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) DO_GLOBAL=1; shift ;;
    --project) DO_PROJECT=1; PROJECT_DIR="${2:-}"; [[ -n "$PROJECT_DIR" ]] || die "--project needs a directory"; shift 2 ;;
    --all) DO_GLOBAL=1; DO_PROJECT=1; PROJECT_DIR="${2:-}"; [[ -n "$PROJECT_DIR" ]] || die "--all needs a directory"; shift 2 ;;
    --yes|-y) WRITE=1; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

# No target given: the safe default is the machine layer, the one nobody can forget.
if [[ $DO_GLOBAL -eq 0 && $DO_PROJECT -eq 0 ]]; then
  DO_GLOBAL=1
fi

GLOBAL_SRC_AGENTS="$HERE/global/AGENTS.md"
GLOBAL_SRC_STYLE="$HERE/global/code-style.md"
GLOBAL_TARGETS=("$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md" "$HOME/.claude/code-style.md")

PROJECT_FILES=("AGENTS.md" "CLAUDE.md" "STATE.md" "TODO.md")

for f in "$GLOBAL_SRC_AGENTS" "$GLOBAL_SRC_STYLE"; do
  [[ -f "$f" ]] || die "missing source file: $f"
done
for f in "${PROJECT_FILES[@]}"; do
  [[ -f "$HERE/project/$f" ]] || die "missing template: $HERE/project/$f"
done

if [[ $DO_PROJECT -eq 1 ]]; then
  [[ -d "$PROJECT_DIR" ]] || die "not a directory: $PROJECT_DIR"
  for f in "${PROJECT_FILES[@]}"; do
    if [[ -e "$PROJECT_DIR/$f" && ! -f "$PROJECT_DIR/$f" ]]; then
      die "$PROJECT_DIR/$f exists and is not a regular file"
    fi
  done
fi

[[ $WRITE -eq 0 ]] && ACTION="would write" || ACTION="writes"

# --- global layer -----------------------------------------------------------------------------

if [[ $DO_GLOBAL -eq 1 ]]; then
  echo "GLOBAL layer — $ACTION:"
  for i in "${!GLOBAL_TARGETS[@]}"; do
    dest="${GLOBAL_TARGETS[$i]}"
    src="$GLOBAL_SRC_AGENTS"
    [[ "$dest" == *code-style.md ]] && src="$GLOBAL_SRC_STYLE"
    if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
      state="already up to date"
      [[ $WRITE -eq 1 ]] && state="up to date, untouched"
    elif [[ -e "$dest" && ! -f "$dest" ]]; then
      die "$dest exists and is not a regular file"
    elif [[ -f "$dest" ]]; then
      state="OVERWRITTEN (existing file replaced)"
    else
      state="created"
    fi
    if [[ $WRITE -eq 1 ]]; then
      mkdir -p "$(dirname "$dest")"
      cp "$src" "$dest"
    fi
    printf '  %-38s %s\n' "$dest" "$state"
  done
  echo
fi

# --- project layer ----------------------------------------------------------------------------

if [[ $DO_PROJECT -eq 1 ]]; then
  echo "PROJECT layer — $ACTION into $PROJECT_DIR:"
  skipped=0
  for f in "${PROJECT_FILES[@]}"; do
    src="$HERE/project/$f"
    dest="$PROJECT_DIR/$f"
    if [[ ! -e "$dest" ]]; then
      state="created"
    elif cmp -s "$src" "$dest"; then
      state="already identical, untouched"
    elif [[ $FORCE -eq 1 ]]; then
      state="OVERWRITTEN (--force)"
    else
      state="EXISTS, skipped (use --force to replace)"
      skipped=$((skipped + 1))
    fi
    if [[ $WRITE -eq 1 && ( ! -e "$dest" || $FORCE -eq 1 ) ]]; then
      cp "$src" "$dest"
    fi
    printf '  %-38s %s\n' "$dest" "$state"
  done
  echo
  if [[ $skipped -gt 0 ]]; then
    echo "  $skipped file(s) left untouched. Compare them with the templates before forcing:"
    echo "    diff <file> $HERE/project/<file>"
    echo
  fi
  echo "  Next: fill in PROJECT FACTS in $PROJECT_DIR/AGENTS.md"
  echo
fi

if [[ $WRITE -eq 0 ]]; then
  echo "Dry run. Re-run with --yes to write."
else
  echo "Done."
fi
