#!/usr/bin/env bash
# toggle_pane.sh — hide/restore a cmux pane by side
# Usage: toggle_pane.sh <left|right>

set -euo pipefail

SIDE="${1:-right}"
STATE_FILE="$HOME/.config/cmux/.pane_state"

# Minimum width below which pane is considered "collapsed"
COLLAPSE_THRESHOLD=5

# Load saved widths
declare -A SAVED
if [[ -f "$STATE_FILE" ]]; then
  while IFS='=' read -r key val; do
    SAVED["$key"]="$val"
  done < "$STATE_FILE"
fi

# Get current pane list: "pane:1 <width>" per line
PANE_INFO="$(cmux list-panes --format '#{pane_id} #{pane_width}' 2>/dev/null || echo '')"

if [[ "$SIDE" == "right" ]]; then
  PANE_ID="pane:2"
  PEER_ID="pane:1"
  EXPAND_DIR="-L"   # expand right pane by pulling boundary left
  COLLAPSE_DIR="-R" # collapse right pane by pushing boundary right
else
  PANE_ID="pane:1"
  PEER_ID="pane:2"
  EXPAND_DIR="-R"
  COLLAPSE_DIR="-L"
fi

# Read current width of the target pane
CURRENT_WIDTH="$(echo "$PANE_INFO" | awk -v id="$PANE_ID" '$1==id{print $2}')"
CURRENT_WIDTH="${CURRENT_WIDTH:-0}"

SAVE_KEY="${SIDE}_width"
SAVED_WIDTH="${SAVED[$SAVE_KEY]:-70}"

if (( CURRENT_WIDTH > COLLAPSE_THRESHOLD )); then
  # Pane is visible — save width and collapse it
  SAVED["$SAVE_KEY"]="$CURRENT_WIDTH"
  # Write back state
  {
    for k in "${!SAVED[@]}"; do printf '%s=%s\n' "$k" "${SAVED[$k]}"; done
  } > "$STATE_FILE"
  # Collapse by pushing pane to near-zero
  COLLAPSE_AMOUNT=$(( CURRENT_WIDTH - 1 ))
  cmux resize-pane --pane "$PANE_ID" "$COLLAPSE_DIR" --amount "$COLLAPSE_AMOUNT"
else
  # Pane is collapsed — restore saved width
  RESTORE_AMOUNT=$(( SAVED_WIDTH - CURRENT_WIDTH ))
  if (( RESTORE_AMOUNT > 0 )); then
    cmux resize-pane --pane "$PANE_ID" "$EXPAND_DIR" --amount "$RESTORE_AMOUNT"
  fi
fi
