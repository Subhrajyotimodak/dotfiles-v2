local status_ok, tailwindcss = pcall(require, "tailwind-tools")
if not status_ok then
	vim.notify("tailwind-tools not installed")
	return
end

return function(capabilities, on_attach)
	local util = require("lspconfig.util")
	local filetypes = {
		"html",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	}

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
				queries = filetypes, -- a list of filetypes having custom `class` queries
				patterns = { -- a map of filetypes to Lua pattern lists
					-- example:
					typescriptreact = { "className=[\"']([^\"']+)[\"']" },
					javascriptreact = { "className=[\"']([^\"']+)[\"']" },
					rust = { "class=[\"']([^\"']+)[\"']" },
					javascript = { "clsx%(([^)]+)%)" },
				},
			},
		}
	)

	return {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = filetypes,
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			tailwindCSS = {
				validate = true,
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidScreen = "error",
					invalidVariant = "error",
					invalidConfigPath = "error",
					invalidTailwindDirective = "error",
					recommendedVariantOrder = "warning",
				},
				classAttributes = {
					"class",
					"className",
					"class:list",
					"classList",
					"ngClass",
				},
				includeLanguages = {
					eelixir = "html-eex",
					eruby = "erb",
					templ = "html",
					htmlangular = "html",
				},
			},
		},
		before_init = function(_, config)
			if not config.settings then
				config.settings = {}
			end
			if not config.settings.editor then
				config.settings.editor = {}
			end
			if not config.settings.editor.tabSize then
				config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
			end
		end,
		workspace_required = true,
		root_dir = function(bufnr, on_dir)
			local root_files = {
				"tailwind.config.js",
				"tailwind.config.cjs",
				"tailwind.config.mjs",
				"tailwind.config.ts",
				"postcss.config.js",
				"postcss.config.cjs",
				"postcss.config.mjs",
				"postcss.config.ts",
			}
			local fname = vim.api.nvim_buf_get_name(bufnr)
			root_files = util.insert_package_json(root_files, "tailwindcss", fname)
			root_files = util.root_markers_with_field(root_files, { "mix.lock" }, "tailwind", fname)
			on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
		end,
	}
end
