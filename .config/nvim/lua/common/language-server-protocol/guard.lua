local lint = require("guard.lint")
local ft_status_ok, ft = pcall(require, "guard.filetype")
if not ft_status_ok then
	vim.notify("guard.filetype is not installed :(")
	return
end

-- local guard_status_ok, guard = pcall(require, "guard")
-- if not guard_status_ok then
-- 	vim.notify("guard is not installed :(")
-- 	return
-- end

ft("lua"):fmt("lsp"):append("stylua")

ft("typescript,javascript,typescriptreact,svelte,css"):fmt("prettier")
--[[ :lint("eslint_d") ]]

ft("python"):fmt("black")

ft("html,htmldjango,svelte"):fmt("prettier")

ft("json"):fmt("prettier"):lint({
	cmd = "misspell",
	stdin = true,
	parse = function(result, bufnr)
		local diags = {}
		local t = vim.split(result, "\n")
		for i, e in ipairs(t) do
			vim.notify(i .. " " .. e)
			local lnum = e:match("^%d+")
			if lnum then
				diags[#diags + 1] = lint.diag_fmt(bufnr, tonumber(lnum) - 1, 0, t[i + 1]:gsub("\t", ""), 2, "misspell")
			end
		end
		return diags
	end,
})

ft("md,mdx"):fmt("prettier"):lint({
	cmd = "misspell",
	stdin = true,
	parse = function(result, bufnr)
		local diags = {}
		local t = vim.split(result, "\n")
		for i, e in ipairs(t) do
			vim.notify(i .. " " .. e)
			local lnum = e:match("^%d+")
			if lnum then
				diags[#diags + 1] = lint.diag_fmt(bufnr, tonumber(lnum) - 1, 0, t[i + 1]:gsub("\t", ""), 2, "misspell")
			end
		end
		return diags
	end,
})

vim.g.guard_config = {
	-- the only options for the setup function

	fmt_on_save = false,
	-- Use lsp if no formatter was defined for this filetype
	lsp_as_default_formatter = false,
}
