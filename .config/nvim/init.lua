-- if vim.g.vscode then
-- 	require("common.vs-code.keybinds")
-- 	return
-- end
--
require("common.plugin_manager")
require("common.core.keymaps")
require("common.core.options")
require("common.core.colorscheme")
require("common.plugins.treesitter")
require("common.plugins.notify")
require("common.plugins.terminal-fix")

-- require("common.plugins.cmp")
require("common.plugins.blink")
-- require("common.plugins.blink-debug")
require("common.plugins.comment")
require("common.plugins.lualine")
require("common.plugins.neo-tree")
require("common.plugins.telescope")
require("common.plugins.auto-pairs")
require("common.plugins.autocommands")
require("common.plugins.colorizer")
require("common.plugins.bufferline")
require("common.plugins.alpha")
require("common.plugins.project")
require("common.plugins.monorepo")
require("common.plugins.gitsigns")
require("common.plugins.indentation-line")
require("common.plugins.symbol-outline")
require("common.plugins.dressing")
require("common.plugins.hologram")
require("common.plugins.render-markdown")

require("common.language-server-protocol.mason")
require("common.language-server-protocol.lspconfig")
require("common.language-server-protocol.lspsaga")
require("common.language-server-protocol.guard")

-- require("common.plugins.goose")
require("common.plugins.codeium")
-- require("common.plugins.mcphub")
-- require("common.plugins.avante")
-- require("common.plugins.claudecode")

-- AI Providers
-- require("common.ai.cursor-agent")

-- -- Review (AiSync, checktime, send-to-cursor): load so :AiSync and autocmds exist even if cursor-agent failed
-- local review_ok, review = pcall(require, "common.ai.review")
-- if review_ok and review and review.setup then
-- 	review.setup()
-- end
