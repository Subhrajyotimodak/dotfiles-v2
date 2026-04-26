-- Render markdown in Avante chat output and markdown files
local ok, render_md = pcall(require, "render-markdown")
if not ok then
	return
end

render_md.setup({
	file_types = { "markdown", "Avante" },
})
