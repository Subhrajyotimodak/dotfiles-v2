local status_ok, catppuccin = pcall(require, "catppuccin")
if not status_ok then
	return
end
catppuccin.setup()
vim.cmd("colorscheme catppuccin-macchiato")

local status, transparent = pcall(require, "transparent")
if not status then
	return
end

transparent.setup({ -- Optional, you don't have to run setup.
	groups = { -- table: default groups
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLine",
		"CursorLineNr",
		"StatusLine",
		"StatusLineNC",
		"EndOfBuffer",
	},
	extra_groups = {
		"NeoTreeNormal",
		"NeoTreFloat",
		--[[ "BufferLineTabClose", ]]
		--[[ "BufferlineBufferSelected", ]]
		"BufferLineFill",
		--[[ "BufferLineBackground", ]]
		--[[ "BufferLineSeparator", ]]
		--[[ "BufferLineIndicatorSelected", ]]
		--[[ "IndentBlanklineChar", ]]
		--[[ "LspFloatWinNormal", ]]
		"Normal",
		"NormalFloat",
		--[[ "FloatBorder", ]]
		--[[ "TelescopeNormal", ]]
		--[[ "TelescopeBorder", ]]
		--[[ "TelescopePromptBorder", ]]
		--[[ "SagaBorder", ]]
		--[[ "SagaNormal", ]]
	}, -- table: additional groups that should be cleared
	exclude_groups = {}, -- table: groups you don't want to clear
})
