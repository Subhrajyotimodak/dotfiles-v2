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

local disabled_for = { "markdown", "AvanteInput" }

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
	-- Avante integration with blink.cmp
	providers.avante_commands = {
		name = "avante_commands",
		module = "blink.compat.source",
		score_offset = 90, -- show at a higher priority than lsp
		opts = {},
	}
	providers.avante_files = {
		name = "avante_files",
		module = "blink.compat.source",
		score_offset = 100, -- show at a higher priority than lsp
		opts = {},
	}
	providers.avante_mentions = {
		name = "avante_mentions",
		module = "blink.compat.source",
		score_offset = 1000, -- show at a higher priority than lsp
		opts = {},
	}
	providers.avante_shortcuts = {
		name = "avante_shortcuts",
		module = "blink.compat.source",
		score_offset = 1000, -- show at a higher priority than lsp
		opts = {},
	}
end

cmp.setup({
	enabled = function()
		return not vim.tbl_contains(disabled_for, vim.bo.filetype)
	end,
	keymap = {
		preset = 'default',
		['<C-space>'] = { 'show', 'fallback' },
		['<C-e>'] = { 'hide', 'fallback' },
		['<CR>'] = { 'accept', 'fallback' },
		-- ['<Tab>'] = { 'select_next', 'fallback' },
		-- ['<S-Tab>'] = { 'select_prev', 'fallback' },
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
		transform_items = function(_, items)
			return items
		end,
		default = default_sources,
		providers = providers,
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
