local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
	vim.notify("codecompanion not installed")
	return
end

local model = "x-ai/grok-code-fast-1"

local adapters = require("codecompanion.adapters")

local openrouter = adapters.extend("openai_compatible", {
	name = "openrouter",
	env = {
		url = "https://openrouter.ai/api",
		api_key = "OPENROUTER_API_KEY",
	},
	schema = {
		model = { default = model }, -- pick any OpenRouter model slug
		temperature = { default = 0.4 },
		max_tokens = { default = 2048 },
	},
})

codecompanion.setup({
	strategies = {
		-- Chat uses OpenRouter by default
		chat = {
			adapter = { name = "openrouter", model = model },
			-- Allow tool calling (VectorCode + MCP tools)
			enable_tools = true,
		},
		-- Inline/ask/completion strategies can also point to OpenRouter if desired
		inline = { adapter = { name = "openrouter" } },
		command = { adapter = { name = "openrouter" } },
	},
	adapters = {
		http = {
			openrouter = function()
				return openrouter
			end,
		},
	},
	tools = {
		-- Register VectorCode and MCPHub tools with CodeCompanion
		-- These names must match the providers from the respective plugins below
		vectorcode = { enabled = false }, -- provided by vectorcode.nvim
		mcp = { enabled = true }, -- provided by mcphub.nvim’s integration
	},
})
