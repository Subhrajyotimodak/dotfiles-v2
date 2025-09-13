local status_ok, mcphub = pcall(require, "mcphub")
if not status_ok then
	vim.notify("MCPHub not installed!")
	return
end

mcphub.setup({
	--- `mcp-hub` binary related options-------------------
	port = 3999,
	data_dir = vim.fn.expand("~/.local/share/mcphub"),
	servers_file = vim.fn.expand("~/.config/mcphub/servers.json"), -- create this JSON (see below)
	auto_start = true,
	integrate = {
		codecompanion = true, -- expose :mcp tool to CodeCompanion
	},
	-- config = get_merged_config_path(), -- Merged global + project-specific MCP servers config
	-- port = 3999, -- The port `mcp-hub` server listens to
	-- shutdown_delay = 60 * 10 * 1000, -- 10 minutes delay before shutting down
	-- use_bundled_binary = false, -- Use global `mcp-hub` binary
	-- mcp_request_timeout = 60000, -- 1 minute timeout for MCP operations
	--
	-- ---Chat-plugin related options-----------------
	-- auto_approve = false, -- Require manual approval for MCP tool calls
	-- auto_toggle_mcp_servers = true, -- Allow LLMs to start/stop MCP servers automatically
	--
	-- extensions = {
	-- 	avante = {
	-- 		make_slash_commands = true, -- Convert MCP prompts to slash commands
	-- 	},
	-- },

	--- Plugin specific options-------------------
	native_servers = {}, -- Custom lua native servers

	ui = {
		window = {
			width = 0.8, -- 80% of editor width
			height = 0.8, -- 80% of editor height
			align = "center", -- Center the window
			relative = "editor",
			zindex = 50,
			border = "rounded", -- Rounded border style
		},
		wo = { -- window-scoped options
			winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
		},
	},

	on_ready = function(_)
		-- Called when hub is ready
		vim.notify("MCPHub is ready!", vim.log.levels.INFO)
	end,

	on_error = function(err)
		-- Called on errors
		vim.notify("MCPHub error: " .. tostring(err), vim.log.levels.ERROR)
	end,

	log = {
		level = vim.log.levels.WARN,
		to_file = false,
		file_path = nil,
		prefix = "MCPHub",
	},
})

vim.api.nvim_create_user_command("MCPHub", function()
	require("mcphub.ui").open()
end, {})
