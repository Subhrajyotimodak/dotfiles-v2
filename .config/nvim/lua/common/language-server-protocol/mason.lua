local servers = require("common.language-server-protocol.servers")

local lsp_servers = {}

for key, _ in pairs(servers({}, {})) do
	table.insert(lsp_servers, key)
end

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
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = lsp_servers,
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})
