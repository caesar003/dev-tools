return {
	{
		"numtostr/BufOnly.nvim",
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>bo",
				":BufOnly<CR>",
				{ noremap = true, silent = true, desc = "Close all but this" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>bO",
				":BufOnly<space>",
				{ noremap = true, desc = "Close all but ..." }
			)
		end,
	},
}
