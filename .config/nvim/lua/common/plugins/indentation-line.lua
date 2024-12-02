local status_ok, ibl = pcall(require, "ibl")

if not status_ok then
	vim.notify("indent-blankline is not installed :(")

	return
end

ibl.setup()
