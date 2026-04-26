local ok, claudecode = pcall(require, "claudecode")
if not ok then
	vim.notify("claudecode.nvim is not installed", vim.log.levels.WARN)
	return
end

claudecode.setup({
	auto_start = true,
	log_level = "info",
	terminal = {
		split_side = "right",
		split_width_percentage = 0.35,
		provider = "snacks",
		auto_close = true,
	},
	diff_opts = {
		layout = "vertical",
		open_in_new_tab = false,
		keep_terminal_focus = false,
	},
})

local keymaps = {
	{ "<leader>a",  nil,                          desc = "AI/Claude Code" },
	{ "<leader>ac", "<cmd>ClaudeCode<cr>",         desc = "Toggle Claude" },
	{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",    desc = "Focus Claude" },
	{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
	{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
	{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
	{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",    desc = "Add current buffer" },
	{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
	{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
}

for _, map in ipairs(keymaps) do
	if map.desc and map[2] then
		vim.keymap.set(map.mode or "n", map[1], map[2], { desc = map.desc, silent = true })
	end
end

-- Visual mode: send selection to Claude
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude", silent = true })

-- File tree: add file to Claude context
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
	callback = function()
		vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
			{ desc = "Add file to Claude", silent = true, buffer = true })
	end,
})
