-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	vim.notify("lspsaga is not installed :(")
	return
end

local macchiato = require("catppuccin.palettes").get_palette("macchiato")

-- Diagnostic setting
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
})

saga.setup({
	-- keybinds for navigation in lspsaga window
	scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
	-- use enter to open file with definition preview
	definition = {
		edit = "<CR>",
	},
	diagnostic = {
		show_layout = "float",
		keys = {
			quit = { "q", "<ESC>" },
		},
	},
	finder = {
		layout = "normal",
	},
})
