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

	-- preferred colorscheme
	use("bluz71/vim-nightfly-guicolors")
	use({ "norcalli/nvim-colorizer.lua" })
	use("nyoom-engineering/nyoom.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("xiyaowong/transparent.nvim")

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

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths
	use("yetone/avante.nvim")
	-- use({ "Exafunction/codeium.vim", requires = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" } })

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
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
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"nvimdev/lspsaga.nvim",
		branch = "main"
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

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
