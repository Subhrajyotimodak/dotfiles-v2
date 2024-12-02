local status_ok, dressing = pcall(require, "dressing")

if not status_ok then
	vim.notify("dressing not installed")
end

dressing.setup({
	input = {
		enabled = true,
		default_prompt = "➤ ",
	},
	select = {
		enabled = true,
		backend = { "telescope", "builtin", "treesitter" },
	},
})
