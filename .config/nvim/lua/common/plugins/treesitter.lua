-- Error executing lua: ...0.10.4_1/share/nvim/runtime/lua/vim/treesitter/query.lua:252: Query error at 30:4. Invalid node type "always":
-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	vim.notify("treesitter not found")
	return
end

-- configure treesitter
treesitter.setup({
	-- enable syntax highlighting
	highlight = {
		enable = false,
		additional_vim_regex_highlighting = false,
	},
	-- enable indentation
	indent = { enable = true },
	-- enable autotagging (w/ nvim-ts-autotag plugin)
	autotag = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"json",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"markdown",
		"svelte",
		"graphql",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"nginx",
		"gitignore",
	},
	-- auto install above language parsers
	auto_install = true,
})

vim.treesitter.language.register("markdown", "mdx")
