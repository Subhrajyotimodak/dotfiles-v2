local util = require("lspconfig.util")

-- return function(capabilities, on_attach)
-- 	return {
-- 		disable_commands = false, -- prevent the plugin from creating Vim commands
-- 		debug = false, -- enable debug logging for commands
-- 		go_to_source_definition = {
-- 			fallback = true, -- fall back to standard LSP definition on failure
-- 		},
-- 		root_dir = util.root_pattern(".git", "pnpm-lock.yaml"),
-- 		capabilities = capabilities,
-- 		on_attach = on_attach,
-- 		filetypes = {
-- 			"javascript",
-- 			"typescript",
-- 			"javascript.jsx",
-- 			"typescript.tsx",
-- 		},
-- 	}
-- end

-- return function(capabilities, on_attach)
-- 	return {
-- 		capabilities = capabilities,
-- 		on_attach = on_attach,
-- 		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
-- 	}
-- end

return function(capabilities, on_attach)
	return {
		init_options = { hostInfo = "neovim" },
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
		handlers = {
			-- handle rename request for certain code actions like extracting functions / types
			["_typescript.rename"] = function(_, result, ctx)
				local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
				vim.lsp.util.show_document({
					uri = result.textDocument.uri,
					range = {
						start = result.position,
						["end"] = result.position,
					},
				}, client.offset_encoding)
				vim.lsp.buf.rename()
				return vim.NIL
			end,
		},
		capabilities = capabilities,
		on_attach = on_attach
	}
end
