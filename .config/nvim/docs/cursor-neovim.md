## Goal

Make Cursor feel like your Neovim setup (leader key, relative numbers, buffer-ish tabs, splits, etc.).

This folder includes:
- `.vscode/settings.json`: Neovim-ish editor defaults + **VSCodeVim** leader mappings.
- `cursor-keybindings.json`: a **copy/paste** template for Cursor **User** keybindings.

## Option A (recommended for “close enough”): VSCodeVim

1. Install the extension: **Vim** (`vscodevim.vim`)
2. Open this folder in Cursor so `.vscode/settings.json` is applied.
3. Open **Keyboard Shortcuts (JSON)** in Cursor and paste `cursor-keybindings.json`.

### What you get
- Relative line numbers, no preview tabs (buffers feel more stable)
- `<space>` leader mappings:
  - `<leader>ff` quick open
  - `<leader>fg` find in files
  - `<leader>fb` editor list
  - `<leader>e` explorer
  - `<leader>gs` source control
  - `<leader>t` terminal
  - `<leader>w` save, `<leader>q` close
  - `<leader>sv` / `<leader>ss` splits
- `jk` to escape insert mode (remove if you don’t want it)

## Option B (closest to your real Neovim config): VSCode Neovim

If you want Cursor to use your *actual* Neovim + your existing `init.lua`, use:
- **VSCode Neovim** (`asvetliakov.vscode-neovim`)

You’ll need `nvim` installed, then configure these (in Cursor user settings):
- `vscode-neovim.neovimExecutablePaths.darwin` (example: `/opt/homebrew/bin/nvim`)
- `vscode-neovim.neovimInitVimPaths.darwin` (point at your `init.lua` or `init.vim`)

This option makes “conversion” mostly unnecessary because your Neovim keymaps run directly.

## To truly match your config

If you want this baseline tailored to your exact muscle memory, match mappings from:
- `lua/common/core/keymaps.lua`
- `lua/common/vs-code/keybinds.lua`

