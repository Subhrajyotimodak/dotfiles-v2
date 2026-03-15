-- MCP Hub: manage MCP servers, Claude Code compatible
-- Config: ~/.config/mcphub/servers.json (or .vscode/mcp.json, .cursor/mcp.json)
-- Unified endpoint: http://localhost:37373/mcp (used by Avante ACP agents)
local ok, mcphub = pcall(require, "mcphub")
if not ok then
	return
end

mcphub.setup({
	port = 37373,
	extensions = {
		avante = {
			make_slash_commands = true, -- /mcp:server:prompt in Avante chat
		},
	},
	auto_approve = false, -- Toggle with `ga` in :MCPHub UI
})
