-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	vim.notify("typescript is not installed :(")
	return
end

return function(capabilities, on_attach)
	typescript.setup({
		disable_commands = false, -- prevent the plugin from creating Vim commands
		debug = false, -- enable debug logging for commands
		go_to_source_definition = {
			fallback = true, -- fall back to standard LSP definition on failure
		},
		server = {
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "typescript", "typescriptreact" },
		},
	})
end
