# Telescope Grep Persistence + Ghost Text On-Demand Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix live_grep (install ripgrep), make grep search strings persist across picker invocations for the session, and disable ghost text auto-show so it only appears when triggered with ⌥].

**Architecture:** Three independent changes — a system dependency install, a module-level variable + wrapper functions in `telescope.lua` with updated keymaps, and two one-line config changes in `codeium.lua` and `blink.lua`.

**Tech Stack:** Neovim (Lua config), Telescope.nvim, Codeium.nvim, blink.cmp, Homebrew

---

## File Map

| File | Change |
|------|--------|
| System | `brew install ripgrep` — makes `rg` available to Neovim |
| `lua/common/plugins/telescope.lua` | Add `last_grep_string` variable + `persistent_live_grep()` + `persistent_grep_string()` functions |
| `lua/common/core/keymaps.lua` | Update `<leader>fs` and `<leader>fc` to call wrapper functions |
| `lua/common/plugins/codeium.lua` | Set `manual = true` inside `virtual_text` block |
| `lua/common/plugins/blink.lua` | Set `ghost_text = { enabled = false }` |

---

### Task 1: Install ripgrep

**Files:**
- System only — no Lua files changed

- [ ] **Step 1: Install ripgrep via Homebrew**

```bash
brew install ripgrep
```

Expected output ends with: `🍺 /opt/homebrew/Cellar/ripgrep/...` (or similar brew success line)

- [ ] **Step 2: Verify rg is on PATH**

```bash
rg --version
```

Expected: `ripgrep 14.x.x ...`

- [ ] **Step 3: Smoke-test in Neovim**

Open Neovim, press `<leader>fs`, type any word that exists in your project (e.g. `telescope`). Results should now populate in the picker.

---

### Task 2: Add persistent grep string wrappers to telescope.lua

**Files:**
- Modify: `lua/common/plugins/telescope.lua`

Current file ends at line 34. We'll add the module-level variable and two wrapper functions after the `telescope.setup({...})` block and the extension loads.

- [ ] **Step 1: Read the current file to confirm line numbers**

Open `lua/common/plugins/telescope.lua`. Confirm the last line is:
```lua
--[[ telescope.load_extension("fzf") ]]
```
(currently line 34)

- [ ] **Step 2: Append the persistent grep module to the file**

Add the following after the existing content (after line 34):

```lua

-- Persistent grep: remembers the last query for the session
local last_grep_string = ""

local function persistent_live_grep()
	local builtin = require("telescope.builtin")
	local action_state = require("telescope.actions.state")
	local actions_mod = require("telescope.actions")
	builtin.live_grep({
		default_text = last_grep_string,
		attach_mappings = function(_, map)
			local function save_and_select(prompt_bufnr)
				last_grep_string = action_state.get_current_line(prompt_bufnr)
				actions_mod.select_default(prompt_bufnr)
			end
			map("i", "<CR>", save_and_select)
			map("n", "<CR>", save_and_select)
			return true
		end,
	})
end

local function persistent_grep_string()
	local builtin = require("telescope.builtin")
	local action_state = require("telescope.actions.state")
	local actions_mod = require("telescope.actions")
	builtin.grep_string({
		default_text = last_grep_string,
		attach_mappings = function(_, map)
			local function save_and_select(prompt_bufnr)
				last_grep_string = action_state.get_current_line(prompt_bufnr)
				actions_mod.select_default(prompt_bufnr)
			end
			map("i", "<CR>", save_and_select)
			map("n", "<CR>", save_and_select)
			return true
		end,
	})
end

-- Export for use in keymaps
return {
	persistent_live_grep = persistent_live_grep,
	persistent_grep_string = persistent_grep_string,
}
```

- [ ] **Step 3: Verify the file has no syntax errors**

In Neovim run:
```
:luafile lua/common/plugins/telescope.lua
```
Expected: no error messages.

Alternatively from the shell:
```bash
nvim --headless -c "luafile /Users/ani/dotfiles/.config/nvim/lua/common/plugins/telescope.lua" -c "qa" 2>&1
```
Expected: no output (silent = no errors).

---

### Task 3: Update keymaps to call persistent wrappers

**Files:**
- Modify: `lua/common/core/keymaps.lua` lines 59–60

- [ ] **Step 1: Replace the two telescope grep keymaps**

Find this block in `lua/common/core/keymaps.lua`:
```lua
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", opts) -- find string in current working directory as you type
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts) -- find string under cursor in current working directory
```

Replace with:
```lua
keymap("n", "<leader>fs", "<cmd>lua require('common.plugins.telescope').persistent_live_grep()<cr>", opts) -- find string (persistent query)
keymap("n", "<leader>fc", "<cmd>lua require('common.plugins.telescope').persistent_grep_string()<cr>", opts) -- find string under cursor (persistent query)
```

- [ ] **Step 2: Verify no syntax errors**

```bash
nvim --headless -c "luafile /Users/ani/dotfiles/.config/nvim/lua/common/core/keymaps.lua" -c "qa" 2>&1
```
Expected: no output.

- [ ] **Step 3: Manual smoke test**

Open Neovim. Press `<leader>fs`, type `telescope`, select any result with `<CR>`. Close the file, press `<leader>fs` again. The search box should be pre-filled with `telescope`.

- [ ] **Step 4: Commit**

```bash
cd /Users/ani/dotfiles
git add .config/nvim/lua/common/plugins/telescope.lua .config/nvim/lua/common/core/keymaps.lua
git commit -m "feat(telescope): persistent grep string across picker invocations"
```

---

### Task 4: Disable Codeium ghost text auto-show

**Files:**
- Modify: `lua/common/plugins/codeium.lua` line 27

- [ ] **Step 1: Change manual = false to manual = true**

Find this block in `lua/common/plugins/codeium.lua`:
```lua
		-- Set to true if you never want completions to be shown automatically.
		manual = false,
```

Replace with:
```lua
		-- Set to true if you never want completions to be shown automatically.
		manual = true,
```

- [ ] **Step 2: Verify in Neovim**

Restart Neovim (or `:source %` on the file). Open any code file and start typing. Codeium ghost text should NOT appear automatically.

Press `<M-]>` (⌥]) — a Codeium suggestion should appear as ghost text. Press `<Tab>` to accept or keep typing to dismiss.

- [ ] **Step 3: Commit**

```bash
cd /Users/ani/dotfiles
git add .config/nvim/lua/common/plugins/codeium.lua
git commit -m "feat(codeium): disable auto ghost text, show only on opt+]"
```

---

### Task 5: Disable blink.cmp ghost text

**Files:**
- Modify: `lua/common/plugins/blink.lua` line 193

- [ ] **Step 1: Disable ghost_text in blink.cmp**

Find this line in `lua/common/plugins/blink.lua`:
```lua
		ghost_text = { enabled = true },
```

Replace with:
```lua
		ghost_text = { enabled = false },
```

- [ ] **Step 2: Verify in Neovim**

Restart Neovim. Open any code file and start typing. The blink.cmp ghost text preview (the grey inline text showing the top completion) should no longer appear. The completion dropdown menu itself should still work normally.

- [ ] **Step 3: Commit**

```bash
cd /Users/ani/dotfiles
git add .config/nvim/lua/common/plugins/blink.lua
git commit -m "feat(blink): disable ghost text auto-show"
```

---

## Verification Checklist

After all tasks:

- [ ] `rg --version` works in shell
- [ ] `<leader>fs` opens live_grep with last query pre-filled
- [ ] `<leader>fc` opens grep_string with last query pre-filled
- [ ] After selecting a result, re-opening either picker shows the previous search
- [ ] No ghost text appears while typing normally in any file
- [ ] `⌥]` shows a Codeium suggestion as ghost text on demand
- [ ] `<Tab>` accepts the Codeium suggestion
- [ ] blink.cmp dropdown menu still works normally (no regression)
