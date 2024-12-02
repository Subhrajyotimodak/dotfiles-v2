local wezterm = require("wezterm")

local config = wezterm.config_builder()

local appearance = require("appearance").appearance
local fonts = require("fonts").fonts
local command_palette = require("command_palette")

fonts(config)
appearance(config)
command_palette(config)

return config
