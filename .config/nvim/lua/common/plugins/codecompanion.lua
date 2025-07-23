local status, codecompanion = pcall(require, "codecompanion")
if not status then
	vim.notify("Code Companion Not Found")
	return
end

codecompanion.setup({
	adapters = {
		anthropic = function()
			return require("codecompanion.adapters").extend("anthropic", {
				env = {
					api_key = os.getenv("ANTHROPIC_API_KEY"),
				},
				model = "claude-3-5-sonnet-20241022",
			})
		end,
		openai = function()
			return require("codecompanion.adapters").extend("openai", {
				env = {
					api_key = os.getenv("OPENAI_API_KEY"),
				},
				model = "gpt-4o-mini",
			})
		end,
	},

	strategies = {
		chat = {
			adapter = "anthropic",
		},
		inline = {
			adapter = "openai",
		},
	},
	display = {
		diff = {
			provider = "mini_diff",
		},
	},

	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				make_vars = true,
				make_slash_commands = true,
				show_result_in_chat = true,
			},
		},
	},
})
