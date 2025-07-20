local status_ok, mcphub = pcall(require, "mcphub")
if not status_ok then
	vim.notify("MCPHub not installed!")
	return
end

-- Function to merge global and project-specific MCP configurations
local function get_merged_config_path()
	local global_config = vim.fn.expand("~/.config/mcphub/servers.json")
	local project_config = vim.fn.getcwd() .. "/.cursor/mcp.json"

	-- If no project-specific config exists, use global config
	if vim.fn.filereadable(project_config) == 0 then
		return global_config
	end

	-- Create merged config in a temporary location
	local temp_config = vim.fn.stdpath("cache") .. "/mcphub_merged_config.json"

	-- Read global config
	local global_content = "{}"
	if vim.fn.filereadable(global_config) == 1 then
		local global_file = io.open(global_config, "r")
		if global_file then
			global_content = global_file:read("*all")
			global_file:close()
		end
	end

	-- Read project config
	local project_file = io.open(project_config, "r")
	local project_content = "{}"
	if project_file then
		project_content = project_file:read("*all")
		project_file:close()
	end

	-- Parse JSON configs
	local global_data = vim.json.decode(global_content)
	local project_data = vim.json.decode(project_content)

	-- Merge configurations (project-specific servers override global ones with same name)
	local merged_data = vim.deepcopy(global_data)
	if not merged_data.mcpServers then
		merged_data.mcpServers = {}
	end

	if project_data.mcpServers then
		for server_name, server_config in pairs(project_data.mcpServers) do
			merged_data.mcpServers[server_name] = server_config
		end
	end

	-- Merge nativeMCPServers if present
	if project_data.nativeMCPServers then
		if not merged_data.nativeMCPServers then
			merged_data.nativeMCPServers = {}
		end
		for server_name, server_config in pairs(project_data.nativeMCPServers) do
			merged_data.nativeMCPServers[server_name] = server_config
		end
	end

	-- Write merged config to temporary file
	local temp_file = io.open(temp_config, "w")
	if temp_file then
		temp_file:write(vim.json.encode(merged_data))
		temp_file:close()
		vim.notify("MCPHub: Using merged config (global + project-specific)", vim.log.levels.INFO)
		return temp_config
	else
		vim.notify("MCPHub: Failed to create merged config, using global", vim.log.levels.WARN)
		return global_config
	end
end

mcphub.setup({
	--- `mcp-hub` binary related options-------------------
	config = get_merged_config_path(), -- Merged global + project-specific MCP servers config
	port = 37373, -- The port `mcp-hub` server listens to
	shutdown_delay = 60 * 10 * 1000, -- 10 minutes delay before shutting down
	use_bundled_binary = false, -- Use global `mcp-hub` binary
	mcp_request_timeout = 60000, -- 1 minute timeout for MCP operations

	---Chat-plugin related options-----------------
	auto_approve = false, -- Require manual approval for MCP tool calls
	auto_toggle_mcp_servers = true, -- Allow LLMs to start/stop MCP servers automatically

	extensions = {
		avante = {
			make_slash_commands = true, -- Convert MCP prompts to slash commands
		},
	},

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

