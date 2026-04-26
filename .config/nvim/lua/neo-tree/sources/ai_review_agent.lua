local renderer = require("neo-tree.ui.renderer")
local review_data = require("common.ai.neo_review_source")

local M = {
	name = "ai_review_agent",
	display_name = " Review (Agent) ",
}

M.navigate = function(state, _path, _path_to_reveal, callback)
	local root, items = review_data.build_items("agent")
	state.path = root
	state.dirty = false
	renderer.show_nodes(items, state)
	if callback then
		callback()
	end
end

M.setup = function(_config, _global_config)
	-- no source-specific subscriptions for now
end

return M
