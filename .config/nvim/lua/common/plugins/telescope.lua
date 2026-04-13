-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	vim.notify("telescope not found")
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end


-- configure telescope
telescope.setup({
	defaults = {
		-- Avoid ft_to_lang nil error (Neovim 0.10+ treesitter API change); use regex/syntax preview instead
		preview = {
			treesitter = { enable = false },
		},
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
})

telescope.load_extension("media_files")
telescope.load_extension("monorepo")
--[[ telescope.load_extension("fzf") ]]

-- Persistent grep: remembers the last query for the session
local last_grep_string = ""

local function persistent_live_grep()
	local builtin = require("telescope.builtin")
	local action_state = require("telescope.actions.state")
	local actions_mod = require("telescope.actions")
	builtin.live_grep({
		default_text = last_grep_string,
		attach_mappings = function(_, map)
			local function save_and_select(prompt_bufnr)
				last_grep_string = action_state.get_current_line(prompt_bufnr)
				actions_mod.select_default(prompt_bufnr)
			end
			map("i", "<CR>", save_and_select)
			map("n", "<CR>", save_and_select)
			return true
		end,
	})
end

local function persistent_grep_string()
	local builtin = require("telescope.builtin")
	local action_state = require("telescope.actions.state")
	local actions_mod = require("telescope.actions")
	local opts = {
		attach_mappings = function(_, map)
			local function save_and_select(prompt_bufnr)
				last_grep_string = action_state.get_current_line(prompt_bufnr)
				actions_mod.select_default(prompt_bufnr)
			end
			map("i", "<CR>", save_and_select)
			map("n", "<CR>", save_and_select)
			return true
		end,
	}
	if last_grep_string ~= "" then
		opts.search = last_grep_string
	end
	builtin.grep_string(opts)
end

-- Export for use in keymaps
return {
	persistent_live_grep = persistent_live_grep,
	persistent_grep_string = persistent_grep_string,
}
