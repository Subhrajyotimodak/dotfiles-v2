local lspsaga_enabled = pcall(require, "lspsaga")
local lspsaga = require("common.language-server-protocol.keymaps.lspsaga")
local builtins = require("common.language-server-protocol.keymaps.built-in")

return function(opts)
	if lspsaga_enabled then
		lspsaga(opts)
		return
	end

	builtins(opts)
end
