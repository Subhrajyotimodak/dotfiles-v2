-- import comment plugin safely
local setup, comment = pcall(require, "Comment")
if not setup then
	vim.notify("comment is not installed :(")

	return
end

-- enable comment
comment.setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
