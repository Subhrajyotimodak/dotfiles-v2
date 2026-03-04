local status, cursor_agent = pcall(require, "cursor-agent")
if not status then
	vim.notify("cursor-agent.nvim is not installed", vim.log.levels.WARN)
	return
end

-- Setup cursor-agent
cursor_agent.setup({
	-- Executable or argv table. Example: "cursor-agent" or {"/usr/local/bin/cursor-agent"}
	cmd = "cursor-agent",
	-- Additional arguments always passed to the CLI
	args = {},
})

local review_ok, review = pcall(require, "common.ai.review")
if review_ok then
	review.setup()
end

-- Keymaps for cursor-agent
local opts = { noremap = true, silent = true }

-- Toggle the interactive terminal
vim.keymap.set("n", "<leader>ca", ":CursorAgent<CR>", vim.tbl_extend("force", opts, { desc = "Cursor Agent: Toggle terminal" }))

-- Send visual selection to cursor agent
vim.keymap.set("v", "<leader>ca", ":CursorAgentSelection<CR>", vim.tbl_extend("force", opts, { desc = "Cursor Agent: Send selection" }))

-- Send current buffer to cursor agent
vim.keymap.set("n", "<leader>cA", ":CursorAgentBuffer<CR>", vim.tbl_extend("force", opts, { desc = "Cursor Agent: Send buffer" }))
