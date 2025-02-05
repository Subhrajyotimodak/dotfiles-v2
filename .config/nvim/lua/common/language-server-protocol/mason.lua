local lsp_servers = {
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"emmet_ls",
	"pyright",
	"svelte",
	"clangd",
	"zls"
}

-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	vim.notify("mason is not installed :(")
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	vim.notify("mason_lspconfig is not installed :(")
	return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = lsp_servers,
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})
