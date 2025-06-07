return function(capabilities, on_attach)
	return {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "html", "typescript.tsx", "javascript.tsx", "css", "sass", "scss", "less", "svelte", "typescript", "javascript" },
	}
end
