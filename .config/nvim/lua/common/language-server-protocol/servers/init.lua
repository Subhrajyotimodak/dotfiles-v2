local common = require("common.language-server-protocol.servers.common")
local emmet_ls = require("common.language-server-protocol.servers.emmet_ls")
local lua_ls = require("common.language-server-protocol.servers.lua_ls")
local marksman = require("common.language-server-protocol.servers.marksman")
local svelte   = require("common.language-server-protocol.servers.svelte")
local typescript = require("common.language-server-protocol.servers.typescript")

return function(capabilities, on_attach)
	return {
		html = common(capabilities, on_attach),
		jsonls = common(capabilities, on_attach),
		cssls = common(capabilities, on_attach),
		clangd = common(capabilities, on_attach),
		gopls = common(capabilities, on_attach),
		pyright = common(capabilities, on_attach),
		tailwindcss = common(capabilities, on_attach),
		emmet_ls = emmet_ls(capabilities, on_attach),
		lua_ls = lua_ls(capabilities, on_attach),
		marksman = marksman(capabilities, on_attach),
		svelte = svelte(capabilities, on_attach),
		ts_ls = typescript(capabilities, on_attach),
	}
end
