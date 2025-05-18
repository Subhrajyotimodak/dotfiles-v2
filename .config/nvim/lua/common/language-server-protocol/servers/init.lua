local common = require("common.language-server-protocol.servers.common")
local emmet_ls = require("common.language-server-protocol.servers.emmet_ls")
local lua_ls = require("common.language-server-protocol.servers.lua_ls")
local marksman = require("common.language-server-protocol.servers.marksman")
local svelte = require("common.language-server-protocol.servers.svelte")
local typescript = require("common.language-server-protocol.servers.typescript")
local mdx_analyzer = require("common.language-server-protocol.servers.mdx_analyzer")
local tailwindcss = require("common.language-server-protocol.servers.tailwindcss")

return function(capabilities, on_attach)
	return {
		html = common(capabilities, on_attach),
		jsonls = common(capabilities, on_attach),
		cssls = common(capabilities, on_attach),
		clangd = common(capabilities, on_attach),
		pyright = common(capabilities, on_attach),
		tailwindcss = tailwindcss(capabilities, on_attach),
		emmet_ls = emmet_ls(capabilities, on_attach),
		lua_ls = lua_ls(capabilities, on_attach),
		marksman = marksman(capabilities, on_attach),
		ts_ls = typescript(capabilities, on_attach),
		mdx_analyzer = mdx_analyzer(capabilities, on_attach),
	}
end

		-- svelte = svelte(capabilities, on_attach),
