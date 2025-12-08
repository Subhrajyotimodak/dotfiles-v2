local wezterm = require("wezterm")

local config = wezterm.config_builder()

local appearance = require("appearance").appearance
local fonts = require("fonts").fonts
local command_palette = require("command_palette")

fonts(config)
appearance(config)
command_palette(config)

-- Enable CSI-u protocol for better keyboard handling
config.enable_csi_u_key_encoding = true

return config
