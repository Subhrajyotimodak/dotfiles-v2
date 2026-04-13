# Telescope Grep Persistence + Ghost Text On-Demand

**Date:** 2026-04-14  
**Status:** Approved

---

## Problem Statement

Three issues to address:

1. **Persistent grep string** — When using `<leader>fs` (live_grep) or `<leader>fc` (grep_string), the search string is lost when a file is opened. Users want the last query pre-filled the next time they open either picker within a session.
2. **live_grep shows no results** — `rg` (ripgrep) is not installed as a standalone binary; it only exists bundled inside Cursor IDE. Neovim cannot find it at runtime, so live_grep produces no results.
3. **Ghost text always visible** — Codeium and blink.cmp both show ghost text automatically. User wants ghost text to appear only on demand via the Option key.

---

## Design

### 1. Persistent Grep String

**Where:** `lua/common/plugins/telescope.lua`

A module-level variable `last_grep_string` (empty string by default) stores the last query for the session.

Two wrapper functions replace the raw telescope keymap calls:

- `persistent_live_grep()` — calls `builtin.live_grep` with `default_text = last_grep_string` and `attach_mappings` that wraps `actions.select_default` to read `action_state.get_current_line()` and save it before opening the file.
- `persistent_grep_string()` — calls `builtin.grep_string` with `default_text = last_grep_string` and the same save-on-select hook.

The keymaps `<leader>fs` and `<leader>fc` in `lua/common/core/keymaps.lua` are updated to call these functions via `lua require(...)`.

**Data flow:**
```
User opens picker → default_text = last_grep_string
User types query  → prompt updated in picker
User presses Enter → hook saves prompt → last_grep_string updated → file opens
Next picker open  → default_text = saved query (pre-filled)
```

No disk persistence — resets on neovim restart, which is the desired scope.

### 2. Fix live_grep (Install ripgrep)

**Action:** Install ripgrep via Homebrew.

```sh
brew install ripgrep
```

No config change required — telescope auto-detects `rg` from PATH once installed. This is a one-time system dependency, not a code change.

### 3. Ghost Text On-Demand via Option Key

**Where:** `lua/common/plugins/codeium.lua` and `lua/common/plugins/blink.lua`

Ghost text is disabled by default across both systems:

- **Codeium** (`codeium.lua`): Set `virtual_text.manual = true` — auto-show is disabled. Codeium suggestions appear only when the user explicitly cycles through them.
- **blink.cmp** (`blink.lua`): Set `ghost_text = { enabled = false }` — removes the completion preview ghost text.

The existing Codeium keybinding `<M-]>` (already configured as `next`) acts as the "Option key to show" gesture — pressing `⌥]` fetches and displays the next Codeium suggestion as ghost text. `<Tab>` accepts it.

**Result:** No ghost text appears while typing normally. Pressing `⌥]` shows a Codeium suggestion inline; `<Tab>` accepts, `⌥[` cycles back, or simply continue typing to dismiss.

---

## Files to Change

| File | Change |
|------|--------|
| `lua/common/plugins/telescope.lua` | Add `last_grep_string` variable + two wrapper functions |
| `lua/common/core/keymaps.lua` | Update `<leader>fs` and `<leader>fc` to call wrappers |
| `lua/common/plugins/codeium.lua` | Set `manual = true` in `virtual_text` |
| `lua/common/plugins/blink.lua` | Set `ghost_text = { enabled = false }` |
| System (one-time) | `brew install ripgrep` |

---

## Out of Scope

- Cross-session persistence of grep string (not requested)
- Telescope `fzf` native extension (currently commented out, left as-is)
- Modifying Codeium's CMP source behavior (only virtual_text mode affected)
