#!/usr/bin/env bash
# Install the agent working agreement: either layer, or both.
#
#   ./install.sh                     dry run, global layer
#   ./install.sh --global            global layer only  (this machine)
#   ./install.sh --project DIR       project files into DIR (the repository to set up)
#   ./install.sh --all DIR           both
#
#   --yes          actually write (nothing is written without it)
#   --force        overwrite project files that already exist
#   --no-backup    do not keep a copy of the files being replaced
#   --keep N       keep at most N backups per file (default 0 = keep them all)
#
# Global layer = the universal contract, installed to both tools:
#   ~/.claude/CLAUDE.md      Claude Code user-level memory
#   ~/.codex/AGENTS.md       Codex user-level instructions
#   ~/.claude/code-style.md  per-language style, referenced by the contract
#
# Project layer = the four templates copied into a repository, never overwritten unless --force.
#
# Any file about to be replaced is copied to <file>.bak-YYYYmmdd-HHMMSS first, so a wrong install
# is one `cp` away from being undone. Identical files are left alone and never backed up, and the
# exact rollback command is printed at the end. Nothing is ever deleted by default: pass --keep N
# if you want old backups pruned.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

DO_GLOBAL=0
DO_PROJECT=0
PROJECT_DIR=""
WRITE=0
FORCE=0
BACKUP=1
KEEP=0

ROLLBACKS=()
PRUNED=0

usage() {
  cat <<'USAGE'
Install the agent working agreement: either layer, or both.

  ./install.sh                     dry run, global layer
  ./install.sh --global            global layer only  (this machine)
  ./install.sh --project DIR       project files into DIR (the repository to set up)
  ./install.sh --all DIR           both

  --yes          actually write (nothing is written without it)
  --force        overwrite project files that already exist
  --no-backup    do not keep a copy of the files being replaced
  --keep N       keep at most N backups per file (default 0 = keep them all)

Any file about to be replaced is first copied to <file>.bak-YYYYmmdd-HHMMSS.
USAGE
}

die() { echo "error: $*" >&2; exit 2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) DO_GLOBAL=1; shift ;;
    --project) DO_PROJECT=1; PROJECT_DIR="${2:-}"; [[ -n "$PROJECT_DIR" ]] || die "--project needs a directory"; shift 2 ;;
    --all) DO_GLOBAL=1; DO_PROJECT=1; PROJECT_DIR="${2:-}"; [[ -n "$PROJECT_DIR" ]] || die "--all needs a directory"; shift 2 ;;
    --yes|-y) WRITE=1; shift ;;
    --force) FORCE=1; shift ;;
    --no-backup) BACKUP=0; shift ;;
    --keep) KEEP="${2:-}"; [[ "$KEEP" =~ ^[0-9]+$ ]] || die "--keep needs a number"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
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

# Copy one file out of the way before it is replaced. Only ever called on an existing regular file.
backup_of() {
  local dest="$1" path="$dest.bak-$TS" old n
  cp -p "$dest" "$path"
  ROLLBACKS+=("$path|$dest")
  if [[ "$KEEP" -gt 0 ]]; then
    # Timestamps sort lexicographically, so a plain glob is oldest-first.
    old=()
    while IFS= read -r f; do
      [[ -n "$f" ]] && old+=("$f")
    done < <(ls -1 "$dest".bak-* 2>/dev/null || true)
    n=${#old[@]}
    while [[ $n -gt $KEEP ]]; do
      rm -f "${old[0]}"
      old=("${old[@]:1}")
      n=$((n - 1))
      PRUNED=$((PRUNED + 1))
    done
  fi
}

# replace <src> <dest>: back up first (only if something is actually there), then copy.
replace() {
  local src="$1" dest="$2"
  if [[ $BACKUP -eq 1 && -f "$dest" ]]; then
    backup_of "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

[[ $WRITE -eq 0 ]] && ACTION="would write" || ACTION="writes"

# --- global layer -----------------------------------------------------------------------------

if [[ $DO_GLOBAL -eq 1 ]]; then
  echo "GLOBAL layer — $ACTION:"
  for i in "${!GLOBAL_TARGETS[@]}"; do
    dest="${GLOBAL_TARGETS[$i]}"
    src="$GLOBAL_SRC_AGENTS"
    [[ "$dest" == *code-style.md ]] && src="$GLOBAL_SRC_STYLE"

    if [[ -e "$dest" && ! -f "$dest" ]]; then
      die "$dest exists and is not a regular file"
    fi

    if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
      state="already up to date, untouched"
    elif [[ -f "$dest" ]]; then
      if [[ $BACKUP -eq 1 ]]; then
        state="REPLACED (backup: $(basename "$dest").bak-$TS)"
      else
        state="REPLACED, no backup (--no-backup)"
      fi
      if [[ $WRITE -eq 1 ]]; then replace "$src" "$dest"; fi
    else
      state="created"
      if [[ $WRITE -eq 1 ]]; then replace "$src" "$dest"; fi
    fi
    printf '  %-36s %s\n' "$dest" "$state"
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
      if [[ $WRITE -eq 1 ]]; then replace "$src" "$dest"; fi
    elif cmp -s "$src" "$dest"; then
      state="already identical, untouched"
    elif [[ $FORCE -eq 1 ]]; then
      if [[ $BACKUP -eq 1 ]]; then
        state="OVERWRITTEN (--force, backup: $(basename "$dest").bak-$TS)"
      else
        state="OVERWRITTEN (--force, no backup)"
      fi
      if [[ $WRITE -eq 1 ]]; then replace "$src" "$dest"; fi
    else
      state="EXISTS, skipped (use --force to replace)"
      skipped=$((skipped + 1))
    fi
    printf '  %-36s %s\n' "$dest" "$state"
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

# --- backups and rollback ---------------------------------------------------------------------

if [[ ${#ROLLBACKS[@]} -gt 0 ]]; then
  echo "Backups kept — undo by copying the left path over the right one:"
  for entry in "${ROLLBACKS[@]}"; do
    printf '  cp %s\n     %s\n' "${entry%%|*}" "${entry##*|}"
  done
  echo
fi
if [[ $PRUNED -gt 0 ]]; then
  echo "  ($PRUNED older backup(s) removed by --keep $KEEP; they are gone.)"
  echo
fi

if [[ $WRITE -eq 0 ]]; then
  echo "Dry run. Re-run with --yes to write."
else
  echo "Done. Backups are never deleted unless you pass --keep N."
fi
