local status_ok, avante = pcall(require, "avante")
if not status_ok then
	vim.notify("Avante not installed!")
	return
end

-- Enable loading indicator for suggestions
vim.g.avante_loading_indicator = 1
-- Override Avante's window validation if needed
vim.opt.laststatus = 3

avante.setup({
	---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
	provider = "claude", -- Recommend using Claude
	---@alias Mode "agentic" | "legacy"
	---@type Mode
	mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
	-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
	-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
	-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
	auto_suggestions_provider = "claude", -- Using the same provider as main for consistency
	memory_summary_provider = nil,

	providers = {
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-sonnet-4-20250514",
			timeout = 30000, -- Timeout in milliseconds
			context_window = 200000,
			extra_request_body = {
				temperature = 0.75,
				max_tokens = 64000,
			},
		},
	},

	---Specify the special dual_boost mode
	---1. enabled: Whether to enable dual_boost mode. Default to false.
	---2. first_provider: The first provider to generate response. Default to "openai".
	---3. second_provider: The second provider to generate response. Default to "claude".
	---4. prompt: The prompt to generate response based on the two reference outputs.
	---5. timeout: Timeout in milliseconds. Default to 60000.
	---How it works:
	--- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
	---Note: This is an experimental feature and may not work as expected.
	dual_boost = {
		enabled = false,
		first_provider = "openai",
		second_provider = "claude",
		prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
		timeout = 60000, -- Timeout in milliseconds
	},

	behaviour = {
		auto_focus_sidebar = true,
		auto_suggestions = true, -- Enabled for better coding assistance
		auto_suggestions_respect_ignore = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		jump_result_buffer_on_finish = false,
		support_paste_from_clipboard = false,
		minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		enable_token_counting = true, -- Whether to enable token counting. Default to true.
		use_cwd_as_project_root = false,
		auto_focus_on_diff_view = false,
		auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
		auto_check_diagnostics = true,
		show_suggestion_loading_indicator = true, -- Show loading indicator when generating suggestions
		-- Enhanced window management
		safe_window_operations = true, -- Enable safe window operations
		validate_windows_before_operations = true, -- Validate windows before any operations
	},

	-- Enhanced markdown rendering configuration
	markdown = {
		enabled = true, -- Enable markdown rendering
		syntax_highlighting = true, -- Enable syntax highlighting in code blocks
		concealing = true, -- Enable concealing for better markdown appearance
		code_block_style = "full", -- Full styling for code blocks
	},

	prompt_logger = {
		enabled = true,
		log_dir = vim.fn.stdpath("cache") .. "/avante_prompts",
		fortune_cookie_on_success = false,
		next_prompt = {
			normal = "<C-n>",
			insert = "<C-n>",
		},
		prev_prompt = {
			normal = "<C-p>",
			insert = "<C-p>",
		},
	},

	history = {
		max_tokens = 4096,
		carried_entry_count = nil,
		storage_path = vim.fn.stdpath("state") .. "/avante",
		paste = {
			extension = "png",
			filename = "pasted-%Y-%m-%d-%H-%M-%S",
		},
	},

	img_paste = {
		url_encode_path = true,
		template = "\nimage: $FILE_PATH\n",
	},

	mappings = {
		--- @class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		cancel = {
			normal = { "<C-c>", "<Esc>", "q" },
			insert = { "<C-c>" },
		},
		-- NOTE: The following will be safely set by avante.nvim
		ask = "<leader>aa",
		new_ask = "<leader>an",
		edit = "<leader>ae",
		refresh = "<leader>ar",
		focus = "<leader>af",
		stop = "<leader>aS",
		toggle = {
			default = "<leader>at",
			debug = "<leader>ad",
			hint = "<leader>ah",
			suggestion = "<leader>as",
			repomap = "<leader>aR",
		},
		sidebar = {
			next_prompt = "]p",
			prev_prompt = "[p",
			apply_all = "A",
			apply_cursor = "a",
			retry_user_request = "r",
			edit_user_request = "e",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
			remove_file = "d",
			add_file = "@",
			close = { "<Esc>", "q" },
			close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
		},
		files = {
			add_current = "<leader>ac", -- Add current buffer to selected files
			add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
		},
		select_model = "<leader>a?", -- Select model command
		select_history = "<leader>ah", -- Select history command
		confirm = {
			focus_window = "<C-w>f",
			code = "c",
			resp = "r",
			input = "i",
		},
	},

	hints = { enabled = true },

	windows = {
		---@type "right" | "left" | "top" | "bottom" | "smart"
		position = "right", -- the position of the sidebar
		fillchars = "eob: ",
		wrap = true, -- similar to vim.o.wrap
		width = 35, -- increased width for better readability
		height = 35, -- increased height for better content display
		-- Window management fixes
		validate_window = true, -- Validate window before operations
		close_on_exit = true, -- Close windows properly on exit
		-- Additional window validation settings
		safe_mode = true, -- Enable safe mode for window operations
		check_window_validity = true, -- Check window validity before operations
		auto_close_invalid_windows = true, -- Auto close invalid windows
		window_timeout = 5000, -- Timeout for window operations in milliseconds
		sidebar_header = {
			enabled = true, -- true, false to enable/disable the header
			align = "center", -- left, center, right for title
			rounded = true,
		},
		spinner = {
			editing = { "⡀", "⠄", "⠂", "⠁", "⠈", "⠐", "⠠", "⢀", "⣀", "⢄", "⢂", "⢁", "⢈", "⢐", "⢠", "⣠", "⢤", "⢢", "⢡", "⢨", "⢰", "⣰", "⢴", "⢲", "⢱", "⢸", "⣸", "⢼", "⢺", "⢹", "⣹", "⢽", "⢻", "⣻", "⢿", "⣿" },
			generating = { "·", "✢", "✳", "∗", "✻", "✽" },
			thinking = { "🤯", "🙄" },
			-- Enhanced spinner for suggestion loading
			suggestion = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
		},
		input = {
			prefix = "> ",
			height = 12, -- Increased height for better input experience
			wrap = true, -- Enable text wrapping in input field
		},
		edit = {
			border = { " ", " ", " ", " ", " ", " ", " ", " " },
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			border = { " ", " ", " ", " ", " ", " ", " ", " " },
			start_insert = true, -- Start insert mode when opening the ask window
			---@type "ours" | "theirs"
			focus_on_apply = "ours", -- which diff to focus after applying
		},
	},

	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},

	--- @class AvanteConflictUserConfig
	diff = {
		autojump = true,
		--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
		--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
		--- Disable by setting to -1.
		override_timeoutlen = 500,
	},

	repo_map = {
		ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" },
		negate_patterns = {},
	},

  file_selector = {
    provider = nil,
    -- Options override for custom providers
    provider_opts = {},
  },
  selector = {
    ---@alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
    ---@type avante.SelectorProvider
    provider = "telescope",
    provider_opts = {},
    exclude_auto_select = {}, -- List of items to exclude from auto selection
  },

	input = {
		provider = "native",
		provider_opts = {},
	},

	suggestion = {
		debounce = 800, -- Increased to reduce API call frequency
		throttle = 800, -- Increased to improve performance
		-- Enhanced loading indicator settings
		loading_indicator = {
			enabled = true, -- Enable loading indicator for suggestions
			text = "Generating suggestion...", -- Text to show while loading
			hl_group = "Comment", -- Highlight group for loading text
		},
	},

	disabled_tools = {},
	slash_commands = {},

	-- system_prompt as function ensures LLM always has latest MCP server state
	-- This is evaluated for every message, even in existing chats
	system_prompt = function()
		local hub = require("mcphub").get_hub_instance()
		return hub and hub:get_active_servers_prompt() or ""
	end,
	-- Using function prevents requiring mcphub before it's loaded
	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
})




