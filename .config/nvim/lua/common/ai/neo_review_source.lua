local M = {}

-- Cursor's AI code tracking DB (same one Cursor IDE uses)
local function cursor_db_path()
	return os.getenv("CURSOR_AI_TRACKING_DB")
		or (os.getenv("HOME") .. "/.cursor/ai-tracking/ai-code-tracking.db")
end

-- Return set of repo-relative paths that Cursor tracked as AI-written (content or deleted)
local function agent_paths_from_cursor_db()
	local db = cursor_db_path()
	local stat = vim.loop.fs_stat(db)
	if not stat or stat.type ~= "file" then
		return {}
	end
	local query = "SELECT DISTINCT gitPath FROM tracked_file_content UNION SELECT gitPath FROM ai_deleted_files;"
	local out = vim.fn.system({ "sqlite3", db, query })
	if not out or vim.v.shell_error ~= 0 then
		return {}
	end
	local set = {}
	for line in (out or ""):gmatch("[^\r\n]+") do
		local p = line:gsub("^%s+", ""):gsub("%s+$", "")
		if #p > 0 then
			set[p] = true
		end
	end
	return set
end

-- Return list of repo-relative paths that are changed in git (staged + unstaged)
local function git_changed_paths(root)
	local ok1, out1 = pcall(vim.fn.system, { "git", "-C", root, "diff", "--name-only" })
	local ok2, out2 = pcall(vim.fn.system, { "git", "-C", root, "diff", "--name-only", "--staged" })
	if not ok1 or not ok2 then
		return {}
	end
	local set = {}
	for _, out in ipairs({ out1 or "", out2 or "" }) do
		for line in (out):gmatch("[^\r\n]+") do
			local p = line:gsub("^%s+", ""):gsub("%s+$", "")
			if #p > 0 then
				set[p] = true
			end
		end
	end
	local list = {}
	for p, _ in pairs(set) do
		table.insert(list, p)
	end
	return list
end

function M.resolve_root()
	local cwd = vim.loop.cwd()
	local git_dir = vim.fn.finddir(".git", cwd .. ";")
	if git_dir == "" then
		return cwd
	end
	return vim.fn.fnamemodify(git_dir, ":h")
end

local function file_exists(path)
	local stat = vim.loop.fs_stat(path)
	return stat and (stat.type == "file" or stat.type == "link")
end

-- which: "mine" = git changed minus Cursor DB agent paths; "agent" = paths from Cursor DB
function M.build_items(which)
	local root = M.resolve_root()
	local items = {}
	local seen = {}

	if which == "agent" then
		local agent_set = agent_paths_from_cursor_db()
		for rel, _ in pairs(agent_set) do
			if not seen[rel] then
				seen[rel] = true
				local abs = vim.fn.fnamemodify(root .. "/" .. rel, ":p")
				if file_exists(abs) then
					table.insert(items, {
						id = abs,
						name = rel,
						type = "file",
						path = abs,
						extra = { ai_review = true, root_path = root },
					})
				end
			end
		end
	else
		-- "mine" = changed in git but not in Cursor's agent set
		local agent_set = agent_paths_from_cursor_db()
		local changed = git_changed_paths(root)
		for _, rel in ipairs(changed) do
			if not agent_set[rel] and not seen[rel] then
				seen[rel] = true
				local abs = vim.fn.fnamemodify(root .. "/" .. rel, ":p")
				if file_exists(abs) then
					table.insert(items, {
						id = abs,
						name = rel,
						type = "file",
						path = abs,
						extra = { ai_review = true, root_path = root },
					})
				end
			end
		end
	end

	return root, items
end

return M
