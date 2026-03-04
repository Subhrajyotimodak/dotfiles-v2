#!/usr/bin/env bash
set -euo pipefail

# Run from the shell that should become the left (nvim) pane.
# Result: left 70% = nvim, right 30% = CURSOR_CLI.

# 0. Mark this window so we can focus it after the split
kitty @ set-window-title "DEV_LAYOUT_MAIN"

# 1. Use splits layout so vsplit places the new window to the right (not bottom)
kitty @ goto-layout splits

# 2. Split vertically: left 70% = this window, right 30% = CURSOR_CLI
kitty @ launch --type=window --location=vsplit --bias=30 --title CURSOR_CLI --cwd=current agent

# 3. Focus the left pane and start nvim there
kitty @ focus-window --match "title:DEV_LAYOUT_MAIN"
kitty @ send-text "nvim\n"
