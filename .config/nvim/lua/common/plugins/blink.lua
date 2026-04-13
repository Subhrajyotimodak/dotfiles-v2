local cmp_status, cmp = pcall(require, "blink.cmp")
if not cmp_status then
	vim.notify("blink is not installed :(")

	return
end

-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

-- Avante input: blink.cmp provides /commands, @mentions, #shortcuts via avante sources
local disabled_for = { "markdown" }

-- Check if blink.compat.source is available (requires blink-compat plugin)
local compat_source_ok, _ = pcall(require, "blink.compat.source")

-- Build default sources list conditionally
local default_sources = { "lsp", "path", "snippets", "buffer" }
if compat_source_ok then
	table.insert(default_sources, "avante_commands")
	table.insert(default_sources, "avante_mentions")
	table.insert(default_sources, "avante_shortcuts")
	table.insert(default_sources, "avante_files")
end

-- Build providers table conditionally
local providers = {}
if compat_source_ok then
	-- Codeium integration with blink.cmp (requires blink-compat)
	-- Uncomment if you have blink-compat installed and want codeium completions
	-- providers.codeium = {
	-- 	name = "codeium",
	-- 	module = "blink.compat.source",
	-- 	score_offset = -3,
	-- }
	-- Avante integration: / commands, @ mentions (incl. @file → file selector), # shortcuts
	providers.avante_commands = {
		name = "avante_commands",
		module = "blink.compat.source",
		score_offset = 90,
		min_keyword_length = 0, -- trigger on "/" alone
		opts = {},
	}
	providers.avante_files = {
		name = "avante_files",
		module = "blink.compat.source",
		score_offset = 100,
		min_keyword_length = 0,
		opts = {},
	}
	providers.avante_mentions = {
		name = "avante_mentions",
		module = "blink.compat.source",
		score_offset = 1000,
		min_keyword_length = 0, -- trigger on "@" alone
		opts = {},
	}
	providers.avante_shortcuts = {
		name = "avante_shortcuts",
		module = "blink.compat.source",
		score_offset = 1000,
		min_keyword_length = 0, -- trigger on "#" alone
		opts = {},
	}
end

-- Trigger completion when / or @ is typed in Avante input (commands after /, mentions including @file after @)
local avante_ft = { "Avante", "AvanteInput" }
local avante_providers = { "avante_commands", "avante_mentions", "avante_shortcuts", "avante_files" }
local function is_avante_buffer()
	local ft = vim.bo.filetype
	local bufname = vim.api.nvim_buf_get_name(0):lower()
	return vim.tbl_contains(avante_ft, ft) or bufname:find("avante")
end

vim.api.nvim_create_autocmd("InsertCharPre", {
	callback = function()
		if not is_avante_buffer() then
			return
		end
		local char = vim.v.char
		if (char == "/" or char == "@" or char == "#") and compat_source_ok then
			vim.defer_fn(function()
				if cmp and cmp.show then
					cmp.show({ providers = avante_providers })
				end
			end, 10)
		end
	end,
})

-- Avante buffers: buffer-local keymaps so completion nav takes precedence over Avante's.
-- When completion menu is visible, submit key must accept (not send to AI).
local function get_avante_submit_keys()
	local ok, cfg = pcall(require, "avante.config")
	if ok and cfg and cfg.mappings and cfg.mappings.submit then
		return cfg.mappings.submit.insert, cfg.mappings.submit.normal
	end
	return "<C-s>", "<CR>"
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	callback = function()
		if not is_avante_buffer() or not cmp then
			return
		end
		local opts = { noremap = true, silent = true, buffer = 0 }
		vim.keymap.set("i", "<Up>", function() cmp.select_prev() end, opts)
		vim.keymap.set("i", "<Down>", function() cmp.select_next() end, opts)
		vim.keymap.set("i", "<C-n>", function() cmp.select_next() end, opts)
		vim.keymap.set("i", "<C-p>", function() cmp.select_prev() end, opts)
		-- When menu visible, submit key should accept completion (not send to AI)
		local submit_i, submit_n = get_avante_submit_keys()
		local sidebar = require("avante").get()
		local function do_submit()
			if sidebar then sidebar:submit_input() end
		end
		vim.keymap.set("i", submit_i, function()
			if cmp.is_menu_visible() then
				cmp.select_and_accept()
			else
				do_submit()
			end
		end, opts)
		vim.keymap.set("n", submit_n, function()
			if cmp.is_menu_visible() then
				cmp.select_and_accept()
			else
				do_submit()
			end
		end, opts)
	end,
})

cmp.setup({
	enabled = function()
		return not vim.tbl_contains(disabled_for, vim.bo.filetype)
	end,
	keymap = {
		preset = 'enter', -- CR to accept, Up/Down for navigation
		['<C-space>'] = { 'show', 'fallback' },
		['<C-e>'] = { 'hide', 'fallback' },
		['<Up>'] = { 'select_prev', 'fallback' },
		['<Down>'] = { 'select_next', 'fallback' },
		['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
		['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
		['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
		-- C-y accepts without requiring explicit selection (select_and_accept)
		['<C-y>'] = { 'select_and_accept', 'fallback' },
	},

	completion = {
		-- 'prefix' will fuzzy match on the text before the cursor
		-- 'full' will fuzzy match on the text before _and_ after the cursor
		-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
		keyword = { range = "full" },

		-- Preselect first item so Enter can accept it
		list = { selection = { preselect = true, auto_insert = false } },
		-- or set via a function

		menu = {
			-- Don't automatically show the completion menu
			auto_show = true,
			border = "single",
			-- nvim-cmp style menu
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
					{ "source_name" },
				},
			},
		},

		-- Show documentation when selecting a completion item
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			window = { border = "single" },
		},

		-- Display a preview of the selected item on the current line
		ghost_text = { enabled = false },
	},
	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's highlight groups
		-- Useful for when your theme doesn't support blink.cmp
		-- Will be removed in a future release
		use_nvim_cmp_as_default = true,
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	sources = {
		transform_items = function(_, items)
			return items
		end,
		default = default_sources,
		providers = vim.tbl_extend("force", providers, {
			-- Disable path in Avante buffers (path was showing "Variable der Path" instead of commands)
			path = {
				enabled = function()
					local ft = vim.bo.filetype
					local bufname = vim.api.nvim_buf_get_name(0):lower()
					if vim.tbl_contains(avante_ft, ft) or bufname:find("avante") then
						return false
					end
					return true
				end,
			},
			buffer = {
				enabled = function()
					local ft = vim.bo.filetype
					local bufname = vim.api.nvim_buf_get_name(0):lower()
					if vim.tbl_contains(avante_ft, ft) or bufname:find("avante") then
						return false
					end
					return true
				end,
			},
		}),
		-- Avante: only avante sources; also apply when buffer name contains "avante"
		per_filetype = compat_source_ok and setmetatable({
			Avante = { "avante_commands", "avante_mentions", "avante_shortcuts", "avante_files" },
			AvanteInput = { "avante_commands", "avante_mentions", "avante_shortcuts", "avante_files" },
		}, {
			__index = function(_, ft)
				if is_avante_buffer() then
					return { "avante_commands", "avante_mentions", "avante_shortcuts", "avante_files" }
				end
				return nil
			end,
		}) or nil,
	},

	-- Use a preset for snippets, check the snippets documentation for more information
	snippets = { preset = "luasnip" },

	-- Experimental signature help support
	signature = {
		enabled = true,
		window = { border = "single" },
	},
	-- Prefer Rust matcher when available, but silently fall back to Lua.
	fuzzy = {
		implementation = "prefer_rust",
		-- Force a release version so prebuilt binaries are used when not on a git tag (e.g. packer clone)
		prebuilt_binaries = {
			force_version = "1.9.1",
		},
	},
})
