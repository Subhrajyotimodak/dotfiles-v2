local M = {}

-- Git root for the current buffer or cwd
local function git_root()
	local file = vim.fn.expand("%:p")
	local dir = (#file > 0) and vim.fn.fnamemodify(file, ":h") or vim.loop.cwd()
	local root = vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }):gsub("%s+", "")
	return (#root > 0) and root or nil
end

-- Reload buffer when file changes on disk (e.g. Cursor Agent) and refresh gitsigns
local function reload_and_refresh_gitsigns()
	vim.cmd("checktime")
	local ok, gitsigns = pcall(require, "gitsigns")
	if ok and gitsigns and gitsigns.refresh then
		gitsigns.refresh()
	end
end

function M.setup()
	vim.opt.autoread = true
	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("AiReviewChecktime", { clear = true }),
		callback = reload_and_refresh_gitsigns,
	})
	vim.api.nvim_create_user_command("AiSync", function()
		M.run_ai_sync()
	end, { desc = "Refresh Neo-tree Review (Mine) and Review (Agent) from Cursor DB and git" })
end

function M.send_selection_to_cursor()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	if start_line == 0 or end_line == 0 then
		return
	end

	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local file = vim.fn.expand("%:p")
	local payload = "FILE: " .. file .. "\n"
		.. "LINES: " .. start_line .. "-" .. end_line .. "\n\n"
		.. table.concat(lines, "\n")
		.. "\n"

	vim.fn.system(
		{ "kitty", "@", "send-text", "--match", "title:CURSOR_CLI", "--stdin" },
		payload
	)
end

function M.diff_against_head()
	vim.cmd("Gitsigns diffthis HEAD")
end

-- Refresh Neo-tree Review sources (data is read from Cursor ai-code-tracking.db and git)
function M.run_ai_sync()
	local root = git_root()
	if not root or #root == 0 then
		vim.notify("Not in a git repo", vim.log.levels.WARN)
		return
	end
	local ok, manager = pcall(require, "neo-tree.sources.manager")
	if ok and manager and manager.refresh then
		manager.refresh("ai_review")
		manager.refresh("ai_review_agent")
	end
	vim.notify("Review (Mine) and Review (Agent) refreshed.")
end

return M
