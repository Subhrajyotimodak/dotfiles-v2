local ok, avante = pcall(require, "avante")
if not ok then
	vim.notify("avante.nvim is not installed", vim.log.levels.WARN)
	return
end

-- MCP via mcphub: ACP agents use unified endpoint (Claude Code compatible)
-- Function evaluated at session create; use static URL (workspace hub uses different port)
local MCPHUB_MCP_SERVERS = {
	{ type = "http", name = "Hub", url = "http://localhost:37373/mcp", headers = {} },
}
local function get_mcphub_mcp_servers()
	return MCPHUB_MCP_SERVERS
end

avante.setup({
	instructions_file = "avante.md",
	provider = "claude-code",
	system_prompt = function()
		local ok, mcphub = pcall(require, "mcphub")
		if not ok or not mcphub then return "" end
		local hub = mcphub.get_hub_instance()
		return hub and hub:get_active_servers_prompt() or ""
	end,
	custom_tools = function()
		local ok, ext = pcall(require, "mcphub.extensions.avante")
		if ok and ext and ext.mcp_tool then
			return { ext.mcp_tool() }
		end
		return {}
	end,
	behaviour = {
		acp_follow_agent_locations = true,
		auto_approve_tool_permissions = true,
	},
	input = {
		provider = "dressing",
		provider_opts = {
			title = "Avante Input",
			placeholder = "Enter your prompt...",
		},
	},
	selector = {
		provider = "telescope",
	},
	windows = {
		edit = { border = "rounded", start_insert = true },
		ask = { border = "rounded", start_insert = true },
	},
	acp_providers = {
		["gemini-cli"] = {
			command = "gemini",
			args = { "--experimental-acp" },
			env = {
				NODE_NO_WARNINGS = "1",
				GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
			},
			mcp_servers = get_mcphub_mcp_servers,
		},
		["claude-code"] = {
			command = "npx",
			args = { "@zed-industries/claude-code-acp" },
			env = {
				NODE_NO_WARNINGS = "1",
				ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
			},
			mcp_servers = get_mcphub_mcp_servers,
		},
		["codex"] = {
			command = "npx",
			args = { "@zed-industries/codex-acp" },
			env = {
				NODE_NO_WARNINGS = "1",
				OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
			},
			mcp_servers = get_mcphub_mcp_servers,
		},
		["goose"] = {
			command = "goose",
			args = { "acp" },
			mcp_servers = get_mcphub_mcp_servers,
		},
		["kimi-cli"] = {
			command = "kimi",
			args = { "acp" },
			mcp_servers = get_mcphub_mcp_servers,
		},
		["cursor-agent"] = {
			command = "npx",
			args = { "@blowmage/cursor-agent-acp" },
			env = {
				NODE_NO_WARNINGS = "1",
			},
			mcp_servers = get_mcphub_mcp_servers,
		},
	},
})

-- Beautify Avante UI highlights (Kanagawa-compatible palette)
vim.defer_fn(function()
	local h = vim.api.nvim_set_hl
	local bg = vim.o.background
	local is_dark = bg == "dark"
	-- Kanagawa wave-inspired: soft blues, peach, muted greens
	local palette = is_dark and {
		title_fg = "#1f1f28",
		title_bg = "#98BB6C",
		subtitle_fg = "#1f1f28",
		subtitle_bg = "#7E9CD8",
		third_fg = "#C0A36E",
		third_bg = "#363646",
		btn_default = "#727169",
		btn_primary = "#7E9CD8",
		btn_danger = "#E46876",
		spinner_gen = "#957FB8",
		spinner_ok = "#98BB6C",
		spinner_fail = "#E46876",
		input_border = "#54546D",
	} or {
		title_fg = "#1f1f28",
		title_bg = "#76946A",
		subtitle_fg = "#1f1f28",
		subtitle_bg = "#7E9CD8",
		third_fg = "#6F675E",
		third_bg = "#E6C384",
		btn_default = "#727169",
		btn_primary = "#7E9CD8",
		btn_danger = "#E46876",
		spinner_gen = "#957FB8",
		spinner_ok = "#76946A",
		spinner_fail = "#E46876",
		input_border = "#54546D",
	}
	local p = palette
	h(0, "AvanteTitle", { fg = p.title_fg, bg = p.title_bg, bold = true })
	h(0, "AvanteSubtitle", { fg = p.subtitle_fg, bg = p.subtitle_bg, bold = true })
	h(0, "AvanteThirdTitle", { fg = p.third_fg, bg = p.third_bg })
	h(0, "AvanteButtonDefault", { fg = "#1f1f28", bg = p.btn_default })
	h(0, "AvanteButtonPrimary", { fg = "#1f1f28", bg = p.btn_primary })
	h(0, "AvanteButtonDanger", { fg = "#1f1f28", bg = p.btn_danger })
	h(0, "AvanteStateSpinnerGenerating", { fg = "#1f1f28", bg = p.spinner_gen })
	h(0, "AvanteStateSpinnerSucceeded", { fg = "#1f1f28", bg = p.spinner_ok })
	h(0, "AvanteStateSpinnerFailed", { fg = "#1f1f28", bg = p.spinner_fail })
	h(0, "AvantePromptInputBorder", { fg = p.input_border })
end, 50)
