local font = require("fonts").font
local wezterm = require("wezterm")

local colors = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

local function appearance(config)
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.window_background_opacity = 0.80
	config.macos_window_background_blur = 20
	config.window_background_opacity = 0.8
	config.macos_window_background_blur = 10
	config.colors = colors
	config.tab_max_width = 100
	config.max_fps = 120
	config.window_frame = {
		inactive_titlebar_bg = colors.brights[1],
		active_titlebar_bg = colors.background,
		font = font,
		font_size = 10.0,
	}

	config.window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	}
end

return { appearance = appearance, colors = colors }
