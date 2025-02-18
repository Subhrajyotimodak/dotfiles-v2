return function(capabilities, on_attach)
	local lsp_utils = require("lspconfig.util")

	vim.filetype.add({
		extension = {
			mdx = "mdx",
		},
	})
	local function get_typescript_server_path(root_dir)
		local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
		return project_root and (project_root .. "/node_modules/typescript/lib") or ""
	end

	return {
		cmd = { "mdx-language-server", "--stdio" },
		filetypes = { "mdx" },
		init_options = {
			typescript = {},
		},
		root_dir = lsp_utils.root_pattern(".git", "package.json"),
		settings = {},
		on_new_config = function(new_config, new_root_dir)
			if vim.tbl_get(new_config.init_options, "typescript") and not new_config.init_options.typescript.tsdk then
				new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
			end
		end,
	}
end
