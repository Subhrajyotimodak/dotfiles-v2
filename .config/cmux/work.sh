#!/usr/bin/env bash
# work.sh — open a focused dev layout in cmux
# Usage: work.sh [directory]

set -euo pipefail

DIR="${1:-.}"
DIR="$(cd "$DIR" && pwd)"

STATE_FILE="$HOME/.config/cmux/.work_state"

# Open directory in new workspace; capture workspace ref from output ("OK workspace:N")
WORKSPACE="$(cmux "$DIR" | grep -o 'workspace:[^ ]*')"
if [[ -z "$WORKSPACE" ]]; then
  echo "Error: could not get workspace ref from cmux open" >&2
  exit 1
fi
echo "Workspace: $WORKSPACE"

# Brief pause for workspace to initialize
sleep 0.5

# Find the initial pane in the new workspace
LEFT_PANE="$(cmux list-panes --workspace "$WORKSPACE" | grep -o 'pane:[^ ]*' | head -1)"
if [[ -z "$LEFT_PANE" ]]; then
  echo "Error: could not find initial pane in $WORKSPACE" >&2
  exit 1
fi
echo "Left pane: $LEFT_PANE"

# Find the initial surface in the left pane
LEFT_SURFACE="$(cmux list-pane-surfaces --workspace "$WORKSPACE" --pane "$LEFT_PANE" \
  | grep -o 'surface:[^ ]*' | head -1)"
echo "Left surface: $LEFT_SURFACE"

# Create right pane; output is "OK surface:N pane:N workspace:N"
RIGHT_OUT="$(cmux new-pane --type terminal --direction right --workspace "$WORKSPACE")"
RIGHT_PANE="$(echo "$RIGHT_OUT"   | grep -o 'pane:[^ ]*')"
RIGHT_SURFACE="$(echo "$RIGHT_OUT" | grep -o 'surface:[^ ]*')"
echo "Right pane: $RIGHT_PANE, surface: $RIGHT_SURFACE"

# Resize: shrink right pane to ~30% by pulling its left edge right
cmux resize-pane --pane "$RIGHT_PANE" --workspace "$WORKSPACE" -L --amount 20

# Left pane surface 1: start neovim (\n = Enter per cmux send docs)
cmux send --surface "$LEFT_SURFACE" --workspace "$WORKSPACE" "nvim .\n"

# Left pane surface 2: browser tab
cmux new-surface --type browser --pane "$LEFT_PANE" --workspace "$WORKSPACE"

# Right pane surface 1: start claude CLI
cmux send --surface "$RIGHT_SURFACE" --workspace "$WORKSPACE" "claude\n"
CLAUDE_SURFACE="$RIGHT_SURFACE"

# Right pane surface 2: spare terminal
cmux new-surface --type terminal --pane "$RIGHT_PANE" --workspace "$WORKSPACE"

# Collapse sidebar if visible
SIDEBAR="$(cmux sidebar-state 2>/dev/null || echo '')"
if [[ "$SIDEBAR" == "visible" ]]; then
  cmux sidebar-state hide
fi

# Persist state so neovim can find the claude surface
mkdir -p "$(dirname "$STATE_FILE")"
printf 'CLAUDE_SURFACE=%s\nWORKSPACE=%s\nRIGHT_PANE=%s\n' \
  "$CLAUDE_SURFACE" "$WORKSPACE" "$RIGHT_PANE" \
  > "$STATE_FILE"

echo "Work layout opened in: $DIR"
echo "Claude surface: $CLAUDE_SURFACE"
