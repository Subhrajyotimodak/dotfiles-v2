-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	vim.notify("lualine is not installed :(")
	return
end

local kanagawa = require("lualine.themes.kanagawa")

local function get_next_two_subfolders()
	-- 1. Get full path of current buffer and derive its parent directory
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return "" -- no file associated
	end
	local parent_dir = vim.fn.fnamemodify(bufname, ":h")

	-- 2. Scan directory for entries
	local handle = vim.loop.fs_scandir_next(parent_dir)
	if not handle then
		return "" -- could not open directory
	end

	-- 3. Collect only subdirectories
	local subdirs = {}
	while true do
		local name, t = vim.loop.fs_scandir_next(handle)
		vim.notify_once(handle)
		if not name then
			break
		end
		if t == "directory" then
			table.insert(subdirs, name)
		end
	end

	-- 4. Sort alphabetically and return up to two
	table.sort(subdirs)
	return table.concat(subdirs, "/")
end

-- configure lualine with modified theme
lualine.setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = " ", right = " " },
		globalstatus = true,
		theme = kanagawa,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { get_next_two_subfolders, "filename", "diff" },
		lualine_x = { "diagnostics", "lsp_status" },
		lualine_y = { 'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")' },
		lualine_z = { "os.date('%d %b, %Y at %I:%M %p')" },
	},
})
