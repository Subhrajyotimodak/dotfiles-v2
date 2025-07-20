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

-- import lspkind plugin safely
local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
	return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local disabled_for = { "markdown" }

cmp.setup({
	fuzzy = { implementation = "lua", sort = { "sort_text" } },
	enabled = function()
		return not vim.tbl_contains(disabled_for, vim.bo.filetype)
	end,
	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "select_and_accept", "fallback" },

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-n>"] = { "select_next", "fallback_to_mappings" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		-- Tab and Shift-Tab are handled by smart-tab.lua
	},

	completion = {
		-- 'prefix' will fuzzy match on the text before the cursor
		-- 'full' will fuzzy match on the text before _and_ after the cursor
		-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
		keyword = { range = "full" },

		-- Don't select by default, auto insert on selection
		list = { selection = { preselect = false, auto_insert = false } },
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
		ghost_text = { enabled = true },
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
		-- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
  transform_items = function(_, items) return items end,
		default = { "codeium", "lsp", "path", "snippets", "buffer", },
		providers = {
			codeium = {
				name = "codeium", -- IMPORTANT: use the same name as you would for nvim-cmp
				module = "blink.compat.source",

				-- all blink.cmp source config options work as normal:
				--score_offset = -3,

				opts = {
					-- options passed to the completion source
					-- equivalent to `option` field of nvim-cmp source config

					cache_digraphs_on_start = true,
				},
			},
		},
	},

	-- Use a preset for snippets, check the snippets documentation for more information
	snippets = { preset = "luasnip" },

	-- Experimental signature help support
	signature = {
		enabled = true,
		window = { border = "single" },
	},
})
