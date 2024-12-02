local wezterm = require("wezterm")

local font = wezterm.font("JetBrainsMono Nerd Font Propo", {
	weight = "Bold",
	--[[ font_size = 14, ]]
	--[[ font_shaper = "Harfbuzz", ]]
})

local function fonts(config)
	config.font = font
	config.font_size = 14
	config.bold_brightens_ansi_colors = true
	config.dpi = 144.0
	config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

	config.window_frame = {
	}
end


return { fonts = fonts, font = font }
