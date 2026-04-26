-- install plugins here
local packer_install = function(use)
	use("wbthomason/packer.nvim")

	-- toast notification --
	use("rcarriga/nvim-notify")

	-- custom ui --
	use("stevearc/dressing.nvim")

	-- lua functions that many plugins use
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")

	use("edluffy/hologram.nvim")

	-- alpha screen
	use("goolord/alpha-nvim")
	use("ahmedkhalf/project.nvim")
	use("imNel/monorepo.nvim")

	-- preferred colorscheme
	use({ "norcalli/nvim-colorizer.lua" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("rebelot/kanagawa.nvim")

	-- tmux & split window navigation
	use("christoomey/vim-tmux-navigator")

	-----------------------
	-- essential plugins --
	-----------------------

	-- indent line --
	use("lukas-reineke/indent-blankline.nvim")

	-- add, delete, change surroundings (it's awesome)
	use("tpope/vim-surround")

	-- replace with register contents using motion (gr + motion)
	use("inkarkat/vim-ReplaceWithRegister")

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- file explorer
	use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x", requires = { "MunifTanjim/nui.nvim" } })
	use("akinsho/bufferline.nvim")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding w/ telescope
	use("nvim-telescope/telescope-media-files.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion (blink downloads prebuilts on first load; remove run to avoid PackerSync cargo failures)
	use({
		'saghen/blink.cmp',
		requires = { 'rafamadriz/friendly-snippets', 'Saghen/blink.compat',--[[  'Kaiser-Yang/blink-cmp-avante' ]] },
		tag = 'v1.9.1',
	})
	-- use("hrsh7th/nvim-cmp") -- completion plugin
	-- use("hrsh7th/cmp-buffer") -- source for text in buffer
	-- use("hrsh7th/cmp-path") -- source for file system paths
	-- use({
	-- 	"azorng/goose.nvim",
	-- 	requires = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MeanderingProgrammer/render-markdown.nvim",
	-- 	},
	-- })
	use("MeanderingProgrammer/render-markdown.nvim")
	-- Optional dependencies
	use("HakonHarnes/img-clip.nvim")
	use("folke/snacks.nvim") -- for modern input UI

	-- snippets
use({
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!:).
	run = "make install_jsregexp"
})
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use({
		"nvimdev/guard.nvim",
		requires = {
			"nvimdev/guard-collection",
		},
	})

	--[[ use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters ]]
	--[[ use("jay-babu/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls ]]

	-- managing outlines
	use("simrat39/symbols-outline.nvim")

	-- configuring lsp servers
	-- use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"nvimdev/lspsaga.nvim",
		branch = "main",
	}) -- enhanced lsp uis
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- treesitter configuration (run :TSUpdate after install/update to fetch parsers)
	use("nvim-treesitter/nvim-treesitter")

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	----------
	-- Rust --
	----------

	use("simrat39/rust-tools.nvim")

	---------------------
	-- Markdown and ZK --
	---------------------

	use({
		"Pocco81/TrueZen.nvim",
		ft = { "md", "markdown", "txt" },
	})
	use({
		"folke/zen-mode.nvim",
		ft = { "md", "markdown", "txt" },
	})
	use("mickael-menu/zk-nvim")

	----------------
	-- Typescript --
	----------------

	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)

	----------------------
	-- Dart and Flutter --
	----------------------
	use({
		"akinsho/flutter-tools.nvim",
	})
	--[[ use("dart-lang/dart-vim-plugin") ]]
	--[[ use("thosakwe/vim-flutter") ]]
	--[[ use("natebosch/vim-lsc") ]]
	--[[ use("natebosch/vim-lsc-dart") ]]

	------------
	-- Svelte --
	------------
	use("evanleck/vim-svelte")

	------------
	-- TailwindCSS --
	------------
	use({
		"luckasRanarison/tailwind-tools.nvim",
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		run = function()
			vim.cmd(":UpdateRemotePlugins")
		end,
	})

	-----------------
	-- AI Features --
	-----------------
	-- MCP Hub: manage MCP servers, unified endpoint for Avante ACP agents (Claude Code compatible)
	-- use({
	-- 	"ravitemer/mcphub.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	build = "npm install -g mcp-hub@latest",
	-- })
	-- Avante (AI assistant with ACP/Zen Mode)
	-- use({
	-- 	"yetone/avante.nvim",
	-- 	branch = "main",
	-- 	run = {
	-- 		"make",
	-- 		function(plugin)
	-- 			local patch = vim.fn.stdpath("config") .. "/patches/avante-diff-view.patch"
	-- 			local script = vim.fn.stdpath("config") .. "/scripts/apply-avante-patch.sh"
	-- 			if vim.fn.filereadable(patch) == 1 and plugin and plugin.install_path then
	-- 				vim.fn.system({ "bash", script, plugin.install_path })
	-- 			end
	-- 		end,
	-- 	},

	-- use({
	-- 	"xTacobaco/cursor-agent.nvim",
	-- })

	-- Code Companion
	-- use({
	--  "olimorris/codecompanion.nvim",
	--    dependencies = {
	--      "nvim-lua/plenary.nvim",
	--    },
	-- })

	use({ "Exafunction/windsurf.nvim", requires = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" } })
	-- use({
	-- 	"davidyz/vectorcode",
	-- })

	use({
		"coder/claudecode.nvim",
		requires= {"folke/snacks.nvim"}
	})



end

-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

-- true if packer was just installed
local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugin_manager.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	packer_install(use)
	if packer_bootstrap then
		require("packer").sync()
	end
end)
