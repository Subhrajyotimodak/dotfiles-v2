-- import lspconfig plugin safely
local servers = require("common.language-server-protocol.servers")
local typescript = require("common.language-server-protocol.servers.typescript")
local flutter = require("common.language-server-protocol.servers.flutter")

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	vim.notify("lspconfig is not installed :(")
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	vim.notify("cmp_nvim_lsp is not installed :(")
	return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }
	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
	keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>Lspsaga finder imp<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>t", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>x", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>k", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<leader>q", "<cmd>Lspsaga show_buf_diagnostics ++normal<CR>", opts)

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

for key, value in pairs(servers(capabilities, on_attach)) do
	lspconfig[key].setup(value)
end

typescript(capabilities, on_attach)
flutter(capabilities, on_attach)

-- configure html server
--[[ lspconfig["html"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure svelte server
--[[ lspconfig["svelte"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ 	filetypes = { "svelte", "html" }, ]]
--[[ }) ]]

-- json ls
--[[ lspconfig["jsonls"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure typescript server with plugin

-- configure css server
--[[ lspconfig["cssls"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

--[[ lspconfig["clangd"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure go server
--[[ lspconfig["gopls"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure python server
--[[ lspconfig["pyright"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure tailwindcss server
--[[ lspconfig["tailwindcss"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ }) ]]

-- configure emmet language server
--[[ lspconfig["emmet_ls"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ 	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" }, ]]
--[[ }) ]]

-- configure lua server (with special settings)
--[[ lspconfig["lua_ls"].setup({ ]]
--[[ 	capabilities = capabilities, ]]
--[[ 	on_attach = on_attach, ]]
--[[ 	settings = { -- custom settings for lua ]]
--[[ 		Lua = { ]]
--[[ 			-- make the language server recognize "vim" global ]]
--[[ 			diagnostics = { ]]
--[[ 				globals = { "vim" }, ]]
--[[ 			}, ]]
--[[ 			workspace = { ]]
--[[ 				-- make language server aware of runtime files ]]
--[[ 				library = { ]]
--[[ 					[vim.fn.expand("$VIMRUNTIME/lua")] = true, ]]
--[[ 					[vim.fn.stdpath("config") .. "/lua"] = true, ]]
--[[ 				}, ]]
--[[ 			}, ]]
--[[ 		}, ]]
--[[ 	}, ]]
--[[ }) ]]
