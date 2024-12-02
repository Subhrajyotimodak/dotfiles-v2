return function(capabilities, on_attach)
	return {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
	}
end
