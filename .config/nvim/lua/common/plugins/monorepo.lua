local status, monorepo = pcall(require, "monorepo")
if not status then
	vim.notify("monorepo is not installed :(")
	return
end

local options = {
  silent = false, -- Supresses vim.notify messages
  autoload_telescope = true, -- Automatically loads the telescope extension at setup
  data_path = vim.fn.stdpath("data"), -- Path that monorepo.json gets saved to
}

monorepo.setup(options)
