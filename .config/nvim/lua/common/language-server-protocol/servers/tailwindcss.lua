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

	return {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = filetypes,
		on_attach = on_attach,
		capabilities = capabilities,
		on_new_config = function(new_config)
			if not new_config.settings then
				new_config.settings = {}
			end
			if not new_config.settings.editor then
				new_config.settings.editor = {}
			end
			if not new_config.settings.editor.tabSize then
				-- set tab size for hover
				new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
			end
		end,
		root_dir = function(fname)
			return util.root_pattern(
				"tailwind.config.js",
				"tailwind.config.cjs",
				"tailwind.config.mjs",
				"tailwind.config.ts",
				"postcss.config.js",
				"postcss.config.cjs",
				"postcss.config.mjs",
				"postcss.config.ts"
			)(fname) or vim.fs.dirname(vim.fs.find("package.json", { path = fname, upward = true })[1]) or vim.fs.dirname(
				vim.fs.find("node_modules", { path = fname, upward = true })[1]
			) or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
		end,

		settings = {
			tailwindCSS = {
				classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
				includeLanguages = {
					eelixir = "html-eex",
					eruby = "erb",
					htmlangular = "html",
					templ = "html",
				},
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidConfigPath = "error",
					invalidScreen = "error",
					invalidTailwindDirective = "error",
					invalidVariant = "error",
					recommendedVariantOrder = "warning",
				},
				validate = true,
			},
		},
	}
end
