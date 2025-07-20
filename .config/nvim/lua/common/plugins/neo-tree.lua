local status_ok, neo_tree = pcall(require, "neo-tree")
if not status_ok then
	vim.notify("neotree not found")
	return
end

-- over write default 'delete' command to 'trash'.
local delete = function(state)
	local inputs = require("neo-tree.ui.inputs")
	local path = state.tree:get_node().path
	local msg = "Are you sure you want to trash " .. path
	inputs.confirm(msg, function(confirmed)
		if not confirmed then
			return
		end

		vim.fn.system({ "trash", vim.fn.fnameescape(path) })
		require("neo-tree.sources.manager").refresh(state.name)
	end)
end

-- over write default 'delete_visual' command to 'trash' x n.
local delete_visual = function(state, selected_nodes)
	local inputs = require("neo-tree.ui.inputs")

	-- get table items count
	function GetTableLen(tbl)
		local len = 0
		for n in pairs(tbl) do
			len = len + 1
		end
		return len
	end

	local count = GetTableLen(selected_nodes)
	local msg = "Are you sure you want to trash " .. count .. " files ?"
	inputs.confirm(msg, function(confirmed)
		if not confirmed then
			return
		end
		for _, node in ipairs(selected_nodes) do
			vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
		end
		require("neo-tree.sources.manager").refresh(state.name)
	end)
end
local avante_add_files = function(state)
	local node = state.tree:get_node()
	local filepath = node:get_id()
	local relative_path = require("avante.utils").relative_path(filepath)

	local sidebar = require("avante").get()

	local open = sidebar:is_open()
	-- ensure avante sidebar is open
	if not open then
		require("avante.api").ask()
		sidebar = require("avante").get()
	end

	sidebar.file_selector:add_selected_file(relative_path)

	-- remove neo tree buffer
	if not open then
		sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
	end
end

local config = {
mode = "legacy",
	close_if_last_window = true,
	enable_diagnostics = true,
	popup_border_style = "rounded",
	source_selector = {
		winbar = false,
		content_layout = "center",
	},
	default_component_configs = {
		indent = { padding = 0 },
		container = {
			enable_character_fade = true,
		},
		icon = {
			folder_default = "",
			folder_open = "",
			folder_empty = "",
			folder_empty_open = "",
			default = "",
			symlink = "",
		},
		git_status = {
			symbols = {
				conflict = "",
				unstaged = "",
				staged = "S",
				unmerged = "",
				renamed = "➜",
				deleted = "",
				untracked = "U",
				ignored = "◌",
			},
		},
	},
	window = {
		width = 30,
		mappings = {
			["<space>"] = false, -- disable space until we figure out which-key disabling
			o = "open",
			--[[ O = function(state) astronvim.system_open(state.tree:get_node():get_id()) end, ]]
			H = "prev_source",
			L = "next_source",
			v = "toggle_node",
			["oa"] = 'avante_add_files'
		},
	},
	filesystem = {
		follow_current_file = true,
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
		commands = {
			delete = delete,
			delete_visual = delete_visual,
			avante_add_files = avante_add_files,
		},
		window = {
			mappings = { h = "toggle_hidden" },
		},
	},
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function(_)
				vim.opt_local.signcolumn = "auto"
			end,
		},
	},
}

neo_tree.setup(config)
