#!/usr/bin/env bash
# Apply avante patches (diff-view, mcp-mcphub).
# Usage: apply-avante-patch.sh <avante_plugin_path>
AVANTE_DIR="${1:-}"
PATCH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/patches"
if [[ -d "$AVANTE_DIR" ]] && [[ -d "$PATCH_DIR" ]]; then
  for patch in "$PATCH_DIR"/avante-*.patch; do
    [[ -f "$patch" ]] && (cd "$AVANTE_DIR" && patch -p1 --forward < "$patch" 2>/dev/null) || true
  done
fi
