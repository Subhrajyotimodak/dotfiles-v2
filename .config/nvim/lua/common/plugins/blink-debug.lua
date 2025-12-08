-- Debug script to test if blink.cmp is working
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			-- Test if blink.cmp loaded
			local blink_ok, blink = pcall(require, "blink.cmp")
			if blink_ok then 
				vim.notify("✓ blink.cmp loaded successfully!", vim.log.levels.INFO)
				vim.notify(blink.get_lsp_capabilities(), vim.log.levels.INFO)

				-- Check if binary exists
				local fuzzy_ok = pcall(require, "blink.cmp.fuzzy")
				if fuzzy_ok then
					vim.notify("✓ blink.cmp fuzzy module loaded", vim.log.levels.INFO)
				else
					vim.notify("✗ blink.cmp fuzzy module failed to load - binary might be missing", vim.log.levels.ERROR)
				end
			else
				vim.notify("✗ blink.cmp failed to load: " .. tostring(blink), vim.log.levels.ERROR)
			end
		end, 500)
	end,
})

