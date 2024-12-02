local status_ok, flutter_tools = pcall(require, "flutter-tools")
if not status_ok then
	vim.notify("flutter-tools not installed")
	return
end

return function(capabilities, on_attach)
	flutter_tools.setup({
		lsp = {
			capabilities = capabilities,
			on_attach = on_attach,
		},
	})
end
