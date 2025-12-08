-- VSCode-compatible keybinds for vscode-neovim
local opts = { noremap = true, silent = true }

-- Helper function to call VSCode commands
local function vscode_call(command)
	-- return "<Cmd>call VSCodeNotify('" .. command .. "')<CR>"
    return "<cmd>lua require('vscode').call('" .. command .. "')<CR>"
end

local function vscode_notify(command)
	return "<Cmd>call VSCodeNotify('" .. command .. "')<CR>"
end

local function vscode_call_range(command)
	return "<Cmd>lua require('vscode').call('" .. command .. "', line('v'), line('.'), 1)<CR>"
end

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Basic keymaps
vim.keymap.set("n", "<leader>w", vscode_call("workbench.action.files.saveAll"), opts)

-- Window navigation (VSCode editor groups)
vim.keymap.set("n", "<C-h>", vscode_call("workbench.action.focusLeftGroup"), opts)
vim.keymap.set("n", "<C-j>", vscode_call("workbench.action.focusBelowGroup"), opts)
vim.keymap.set("n", "<C-k>", vscode_call("workbench.action.focusAboveGroup"), opts)
vim.keymap.set("n", "<C-l>", vscode_call("workbench.action.focusRightGroup"), opts)

-- Resize editor groups (VSCode doesn't have direct resize commands like vim, so we use increase/decrease)
vim.keymap.set("n", "<C-Up>", vscode_call("workbench.action.decreaseViewHeight"), opts)
vim.keymap.set("n", "<C-Down>", vscode_call("workbench.action.increaseViewHeight"), opts)
vim.keymap.set("n", "<C-Left>", vscode_call("workbench.action.decreaseViewWidth"), opts)
vim.keymap.set("n", "<C-Right>", vscode_call("workbench.action.increaseViewWidth"), opts)

-- Navigate buffers/tabs
vim.keymap.set("n", "<S-l>", vscode_call("workbench.action.nextEditor"), opts)
vim.keymap.set("n", "<S-h>", vscode_call("workbench.action.previousEditor"), opts)

-- Move text up and down (VSCode has built-in commands for this)
vim.keymap.set("n", "<A-j>", vscode_call("editor.action.moveLinesDownAction"), opts)
vim.keymap.set("n", "<A-k>", vscode_call("editor.action.moveLinesUpAction"), opts)
vim.keymap.set("v", "<A-j>", vscode_call_range("editor.action.moveLinesDownAction"), opts)
vim.keymap.set("v", "<A-k>", vscode_call_range("editor.action.moveLinesUpAction"), opts)

-- Clear search highlights (native vim command, works in vscode-neovim)
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", opts)

-- Delete single character without copying into register (native vim, works as-is)
vim.keymap.set("n", "x", '"_x', opts)

-- Increment/decrement numbers (native vim commands, work as-is)
vim.keymap.set("n", "<leader>+", "<C-a>", opts)
vim.keymap.set("n", "<leader>-", "<C-x>", opts)

-- Code completion
vim.keymap.set("i", "<C-s>", vscode_notify("editor.action.triggerSuggest"), opts)


------------------------
--   VSCode Actions   --
------------------------

-- File explorer (sidebar)
vim.keymap.set("n", "<leader>e", vscode_call("workbench.action.toggleSidebarVisibility"), opts)

-- Toggle terminal
vim.keymap.set("n", "<leader>q", vscode_call("workbench.action.terminal.toggleTerminal"), opts)

-- File navigation (Telescope equivalents in VSCode)
vim.keymap.set("n", "<leader>ff", vscode_call("workbench.action.quickOpen"), opts) -- Find files
vim.keymap.set("n", "<leader>fg", vscode_call("workbench.action.quickOpen"), opts) -- Git files (VSCode quick open includes git files)
vim.keymap.set("n", "<leader>fb", vscode_call("workbench.action.showAllEditors"), opts) -- Show all open editors/buffers

-- Search (Telescope grep equivalents)
vim.keymap.set("n", "<leader>fs", vscode_call("workbench.action.findInFiles"), opts) -- Live grep
vim.keymap.set("n", "<leader>fc", vscode_call("editor.action.addSelectionToNextFindMatch"), opts) -- Find string under cursor
vim.keymap.set(
	"v",
	"<leader>fc",
	vscode_call_range("workbench.action.findInFiles") .. "<Cmd>call VSCodeNotify('editor.action.insertCursorAtEndOfEachLineSelected')<CR>",
	opts
) -- Find selected text in files

-- Format document
vim.keymap.set("n", "<leader><leader>", vscode_call("editor.action.formatDocument"), opts)
vim.keymap.set("v", "<leader><leader>", vscode_call_range("editor.action.formatSelection"), opts)

-- AI/Copilot commands
vim.keymap.set("n", "<leader>aa", vscode_call("workbench.action.chat.open"), opts) -- Toggle AI chat

-- Additional useful VSCode commands
vim.keymap.set("n", "<leader>p", vscode_call("workbench.action.showCommands"), opts) -- Command palette
vim.keymap.set("n", "<leader>r", vscode_call("editor.action.rename"), opts) -- Rename symbol
vim.keymap.set("n", "gd", vscode_call("editor.action.revealDefinition"), opts) -- Go to definition
vim.keymap.set("n", "gr", vscode_call("editor.action.goToReferences"), opts) -- Go to references
vim.keymap.set("n", "gi", vscode_call("editor.action.goToImplementation"), opts) -- Go to implementation
vim.keymap.set("n", "K", vscode_call("editor.action.showHover"), opts) -- Show hover
vim.keymap.set("n", "<leader>t", vscode_call("editor.action.quickFix"), opts) -- Code actions

