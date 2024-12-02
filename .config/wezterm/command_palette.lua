local colors = require("appearance").colors

local function command_palette(config)
	config.command_palette_bg_color = colors.background
	config.command_palette_fg_color = colors.foreground
	config.command_palette_font_size = 16.0
	config.command_palette_rows = 10
end

return command_palette
