local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	vim.notify("bufferline is not installed :(")
	return
end

vim.opt.termguicolors = true

local kanagawa_colors = require("kanagawa.colors").setup({ theme = "wave" }).theme

local config = {
	options = {
		style_preset = bufferline.style_preset.default,
		themable = true,
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "bd! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "bd! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		-- NOTE: this plugin is designed with this icon in mind,
		-- and so changing this is NOT recommended, this is intended
		-- as an escape hatch for people who cannot bear it for whatever reason
		indicator = { style = "underline" },
		--[[ buffer_close_icon = "", ]]
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		-- close_icon = '',
		left_trunc_marker = "",
		right_trunc_marker = "",
		--- name_formatter can be used to change the buffer's label in the bufferline.
		--- Please note some names can/will break the
		--- bufferline so use this at your discretion knowing that it has
		-- some limitations that will *NOT* be fixed.
		name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
			-- remove extension from markdown files for example
			if buf.name:match("%.md") then
				return vim.fn.fnamemodify(buf.name, ":t:r")
			end
		end,
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		tab_size = 21,
		diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		-- NOTE: this will be called a lot so don't do any heavy processing here
		-- custom_filter = function(buf_number)
		--   -- filter out filetypes you don't want to see
		--   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
		--     return true
		--   end
		--   -- filter out by buffer name
		--   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
		--     return true
		--   end
		--   -- filter out based on arbitrary rules
		--   -- e.g. filter out vim wiki buffer from tabline in your work repo
		--   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
		--     return true
		--   end
		-- end,
		-- offsets = { { filetype = "NeoTree", text = "", padding = 1 } },
		color_icons = true,
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = true,
		show_duplicate_prefix = false,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thick", -- | "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
		--   -- add custom logic
		--   return buffer_a.modified > buffer_b.modified
		-- end
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		get_element_icon = function(element)
			-- element consists of {filetype: string, path: string, extension: string, directory: string}
			-- This can be used to change how bufferline fetches the icon
			-- for an element e.g. a buffer or a tab.
			-- e.g.
			local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
			return icon, hl
		end,
	},
	-- highlights = kanagawa_colors,
}

bufferline.setup(config)
