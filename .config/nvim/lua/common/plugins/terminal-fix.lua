-- Fix terminal key codes for better compatibility
-- This helps with Ctrl+Space and other special keys

-- Map NUL (which terminals send for Ctrl+Space) to a proper key code
vim.keymap.set('', '<NUL>', '<C-Space>', { noremap = true })

