local status_ok, tailwindcss = pcall(require, "tailwind-tools")
if not status_ok then
	vim.notify("tailwind-tools not installed")
	return
end

return function(capabilities, on_attach)
	tailwindcss.setup(
		---@type TailwindTools.Option
		{
			server = {
				override = true, -- setup the server from the plugin if true
				settings = {}, -- shortcut for `settings.tailwindCSS`
				on_attach = on_attach, -- callback triggered when the server attaches to a buffer
				capabilities = capabilities,
			},
			document_color = {
				enabled = true, -- can be toggled by commands
				kind = "inline", -- "inline" | "foreground" | "background"
				inline_symbol = "󰝤 ", -- only used in inline mode
				debounce = 200, -- in milliseconds, only applied in insert mode
			},
			conceal = {
				enabled = false, -- can be toggled by commands
				min_length = nil, -- only conceal classes exceeding the provided length
				symbol = "󱏿", -- only a single character is allowed
				highlight = { -- extmark highlight options, see :h 'highlight'
					fg = "#38BDF8",
				},
			},
			cmp = {
				highlight = "foreground", -- color preview style, "foreground" | "background"
			},
			telescope = {
				utilities = {
					callback = function(name, class) end, -- callback used when selecting an utility class in telescope
				},
			},
			-- see the extension section to learn more
			extension = {
				queries = {
					"javascriptreact",
					"typescriptreact",
				}, -- a list of filetypes having custom `class` queries
				patterns = { -- a map of filetypes to Lua pattern lists
					-- example:
					rust = { "class=[\"']([^\"']+)[\"']" },
					javascript = { "clsx%(([^)]+)%)" },
				},
			},
		}
	)
end
