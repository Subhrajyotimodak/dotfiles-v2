local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

keymap("n", "<leader>w", ":wa<cr>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- clear search highlights
keymap("n", "<leader>nh", ":nohl<CR>", opts)

-- delete single character without copying into register
keymap("n", "x", '"_x', opts)

-- increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", opts) -- increment
keymap("n", "<leader>-", "<C-x>", opts) -- decrement

------------------------
--   Plugin Keymaps   --
------------------------

-- neo tree keymap
keymap("n", "<leader>e", ":NeoTreeFloatToggle<cr>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", ":Telescope git_files<cr>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<cr>", opts)
keymap("n", "<leader>fs", "<cmd>lua require('common.plugins.telescope').persistent_live_grep()<cr>", opts) -- find string (persistent query)
keymap("n", "<leader>fc", "<cmd>lua require('common.plugins.telescope').persistent_grep_string()<cr>", opts) -- find string under cursor (persistent query)
keymap("n", "<leader><leader>", "<cmd>Guard fmt<cr>", opts)

-- CodeCompanion (ac conflict removed; use ai for inline)
keymap("n", "<leader>ai", "<cmd>CodeCompanionInline<cr>", opts)

-- Avante model switching
keymap("n", "<leader>am", "<cmd>AvanteSwitchModel<cr>", opts)
keymap("n", "<leader>aM", "<cmd>AvanteCurrentModel<cr>", opts)

-- Avante RAG Service
keymap("n", "<leader>ar", "<cmd>AvanteRagStatus<cr>", opts)
keymap("n", "<leader>aR", "<cmd>AvanteRagIndexProject<cr>", opts)

-- Send selection to Claude CLI (cmux right pane)
vim.keymap.set("v", "<D-S-a>", function()
	require("common.ai.claude_send").send_selection_to_claude()
end, { noremap = true, silent = true, desc = "Send selection to Claude CLI" })

-- Fallback for terminals that do not emit <D-S-a>
vim.keymap.set("v", "<leader>as", function()
	require("common.ai.claude_send").send_selection_to_claude()
end, { noremap = true, silent = true, desc = "Send selection to Claude CLI (fallback)" })

-- Send selection to Cursor CLI (kept for Cursor workflow)
vim.keymap.set("v", "<D-S-l>", function()
	require("common.ai.review").send_selection_to_cursor()
end, { noremap = true, silent = true, desc = "Send selection to Cursor CLI" })
vim.keymap.set("v", "<leader>cl", function()
	require("common.ai.review").send_selection_to_cursor()
end, { noremap = true, silent = true, desc = "Send selection to Cursor CLI (fallback)" })

-- Refresh AI sync
vim.keymap.set("n", "<leader>ay", "<cmd>AiSync<cr>", { noremap = true, silent = true, desc = "AI sync: refresh Neo-tree" })

