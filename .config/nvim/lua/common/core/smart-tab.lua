-- Smart tab functionality for Neovim (Normal Mode Only)
-- This provides intelligent tab behavior in normal mode:
-- - Tab indents the current line
-- - Shift-Tab unindents the current line
-- - Works with visual selections for multiple lines

local M = {}

-- Smart tab function for normal mode
function M.smart_tab()
	-- Check if buffer is modifiable
	if not vim.bo.modifiable then
		return
	end
	
	-- Get current mode
	local mode = vim.api.nvim_get_mode().mode
	
	-- Handle visual modes (v, V, Ctrl-V)
	if mode == 'v' or mode == 'V' or mode == '\22' then
		-- In visual mode, indent the selected lines
		vim.cmd('normal! >')
		-- Reselect the visual selection
		vim.cmd('normal! gv')
	else
		-- In normal mode, indent the current line
		vim.cmd('normal! >>')
	end
end

-- Smart shift-tab function for normal mode
function M.smart_shift_tab()
	-- Check if buffer is modifiable
	if not vim.bo.modifiable then
		return
	end
	
	-- Get current mode
	local mode = vim.api.nvim_get_mode().mode
	
	-- Handle visual modes (v, V, Ctrl-V)
	if mode == 'v' or mode == 'V' or mode == '\22' then
		-- In visual mode, unindent the selected lines
		vim.cmd('normal! <')
		-- Reselect the visual selection
		vim.cmd('normal! gv')
	else
		-- In normal mode, unindent the current line
		vim.cmd('normal! <<')
	end
end

-- Setup function to configure smart tab
local function setup_mappings()
	-- Clear any existing Tab mappings in insert mode
	pcall(vim.keymap.del, "i", "<Tab>")
	pcall(vim.keymap.del, "i", "<S-Tab>")

	-- Set up key mappings for smart tab in normal and visual modes
	vim.keymap.set({"n", "v"}, "<Tab>", M.smart_tab, {
		desc = "Smart tab: indent line or selection",
		silent = true,
		noremap = true,
	})

	vim.keymap.set({"n", "v"}, "<S-Tab>", M.smart_shift_tab, {
		desc = "Smart shift-tab: unindent line or selection",
		silent = true,
		noremap = true,
	})

	-- Also set up for snippet mode
	vim.keymap.set("s", "<Tab>", function()
		local luasnip = require("luasnip")
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		end
	end, { silent = true })

	vim.keymap.set("s", "<S-Tab>", function()
		local luasnip = require("luasnip")
		if luasnip.jumpable(-1) then
				luasnip.jump(-1)
		end
	end, { silent = true })
end

-- Set up mappings immediately if VimEnter has already passed, otherwise wait for it
if vim.v.vim_did_enter == 1 then
	-- VimEnter has already passed, set up mappings immediately
	vim.schedule(setup_mappings)
else
	-- VimEnter hasn't passed yet, wait for it
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.schedule(setup_mappings)
		end,
		once = true,
	})
end

return M

