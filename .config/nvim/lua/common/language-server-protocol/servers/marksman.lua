return function(capabilities, on_attach)
	return {
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = {'marksman', 'server'},
		filetypes = {'markdown', 'markdown.mdx'}
	}
end
