#!/usr/bin/env bash
# Install (or refresh) the user-level agent files on this machine.
#
#   ./install-global.sh            # show what would happen, change nothing
#   ./install-global.sh --yes      # do it
#
# Both tools read the same contract, so the same source is copied to both destinations.
# Run it again after editing global/AGENTS.md or global/code-style.md.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_AGENTS="$HERE/global/AGENTS.md"
SRC_STYLE="$HERE/global/code-style.md"

DEST_AGENTS=("$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md")
DEST_STYLE=("$HOME/.claude/code-style.md")

if [[ ! -f "$SRC_AGENTS" || ! -f "$SRC_STYLE" ]]; then
  echo "error: source files missing under $HERE/global/" >&2
  exit 1
fi

for dest in "${DEST_AGENTS[@]}" "${DEST_STYLE[@]}"; do
  if [[ -e "$dest" && ! -f "$dest" ]]; then
    echo "error: $dest exists and is not a regular file" >&2
    exit 1
  fi
done

echo "Source : $SRC_AGENTS"
echo "         $SRC_STYLE"
echo
for dest in "${DEST_AGENTS[@]}"; do
  [[ -f "$dest" ]] && cmp -s "$SRC_AGENTS" "$dest" && state="already up to date" || state="will be written"
  echo "  $dest  ($state)"
done
for dest in "${DEST_STYLE[@]}"; do
  [[ -f "$dest" ]] && cmp -s "$SRC_STYLE" "$dest" && state="already up to date" || state="will be written"
  echo "  $dest  ($state)"
done
echo

if [[ "${1:-}" != "--yes" ]]; then
  echo "Dry run. Re-run with --yes to write."
  exit 0
fi

mkdir -p "$HOME/.claude" "$HOME/.codex"
for dest in "${DEST_AGENTS[@]}"; do
  cp "$SRC_AGENTS" "$dest"
  echo "written: $dest"
done
for dest in "${DEST_STYLE[@]}"; do
  cp "$SRC_STYLE" "$dest"
  echo "written: $dest"
done
