local keymap = vim.keymap -- for conciseness

local setloclist = function()
	vim.diagnostic.setloclist({ open = false }) -- don't open and focus
	local window = vim.api.nvim_get_current_win()
	vim.cmd.lwindow() -- open+focus loclist if has entries, else close -- this is the magic toggle command
	-- vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
end

return function(opts)
	-- show definition, references
	keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

	-- see definition and make edits in window
	keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

	-- go to implementation
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

	-- see available code actions
	keymap.set("n", "<leader>t", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

	-- smart rename
	keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	-- show diagnostics for line
	keymap.set("n", "<leader>x", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	-- show diagnostics for cursor
	keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float(nil, { scope = 'cursor' })<CR>", opts)

	-- jump to previous diagnostic in buffer
	keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)

	-- jump to next diagnostic in buffer
	keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

	-- show documentation for what is under cursor
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

	-- see outline on right hand side (No direct built-in, consider using `:SymbolsOutline` plugin)
	-- If you need a built-in alternative, you can open the quickfix list with symbols:
	-- vim.keymap.set("n", "<leader>o", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)

	-- show buffer diagnostics
	-- keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	keymap.set("n", "<leader>q", setloclist, opts)
end
