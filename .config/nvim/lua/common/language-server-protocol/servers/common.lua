return function(capabilities, on_attach)
	local util = require("lspconfig.util")

	return {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = {
			"aspnetcorerazor",
			"astro",
			"astro-markdown",
			"blade",
			"clojure",
			"django-html",
			"htmldjango",
			"edge",
			"eelixir",
			"elixir",
			"ejs",
			"erb",
			"eruby",
			"gohtml",
			"gohtmltmpl",
			"haml",
			"handlebars",
			"hbs",
			"html",
			"htmlangular",
			"html-eex",
			"heex",
			"jade",
			"leaf",
			"liquid",
			"markdown",
			"mdx",
			"mustache",
			"njk",
			"nunjucks",
			"php",
			"razor",
			"slim",
			"twig",
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
			"templ",
		},
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
			},
		},
	}
end
