local M = {}

local STATE_FILE = vim.fn.expand("~/.config/cmux/.work_state")

-- Read a key from the work state file
local function read_state(key)
	if vim.fn.filereadable(STATE_FILE) == 0 then
		return nil
	end
	for _, line in ipairs(vim.fn.readfile(STATE_FILE)) do
		local k, v = line:match("^([^=]+)=(.+)$")
		if k == key then
			return v
		end
	end
	return nil
end

-- Send the current visual selection to the claude CLI surface in cmux
function M.send_selection_to_claude()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	if start_line == 0 or end_line == 0 then
		vim.notify("No visual selection", vim.log.levels.WARN)
		return
	end

	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local surface = read_state("CLAUDE_SURFACE")
	if not surface then
		vim.notify("No work state found — run `work <dir>` first", vim.log.levels.WARN)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local file = vim.fn.expand("%:p")
	local payload = "FILE: " .. file .. "\n"
		.. "LINES: " .. start_line .. "-" .. end_line .. "\n\n"
		.. table.concat(lines, "\n")
		.. "\n"

	vim.fn.system({ "cmux", "send", "--surface", surface, payload })

	-- Focus the claude pane
	local right_pane = read_state("RIGHT_PANE")
	if right_pane then
		vim.fn.system({ "cmux", "focus-pane", "--pane", right_pane })
	end
end

return M
