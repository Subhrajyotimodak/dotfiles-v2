local util = require("lspconfig.util")

return function(capabilities, on_attach)
	return {
		disable_commands = false, -- prevent the plugin from creating Vim commands
		debug = false, -- enable debug logging for commands
		go_to_source_definition = {
			fallback = true, -- fall back to standard LSP definition on failure
		},
		server = {
			root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		},
	}
end
