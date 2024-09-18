-- if true then return {} end
return {
	{
		"prettier/vim-prettier",
		build = "yarn install",
		ft = {
			"javascript",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"javascript.jsx",
			"javascriptreact",
			"css",
			"less",
			"scss",
			"json",
			"graphql",
			"markdown",
			"vue",
			"yaml",
			"html",
		},
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>lp",
				":Prettier <CR>",
				{ noremap = true, silent = true, desc = "Prettier" }
			)
		end,
	},
}
