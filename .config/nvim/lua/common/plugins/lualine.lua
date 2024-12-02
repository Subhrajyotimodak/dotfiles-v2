-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	vim.notify("lualine is not installed :(")
	return
end

local macchiato = require("catppuccin.palettes").get_palette("macchiato")

-- get lualine nightfly theme
local lualine_nightfly = require("lualine.themes.nightfly")

-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = macchiato.sky
lualine_nightfly.insert.a.bg = macchiato.teal
lualine_nightfly.visual.a.bg = macchiato.pink
lualine_nightfly.command = {
	a = {
		gui = "bold",
		bg = macchiato.yellow,
		fg = macchiato.base, -- black
	},
}

-- configure lualine with modified theme
lualine.setup({
	options = {
		theme = "catppuccin",
	},
})
