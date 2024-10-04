return {
	{
		"pangloss/vim-javascript",
		ft = "javascript",
		config = function()
			vim.g.javascript_plugin_jsdoc = 1
			vim.api.nvim_create_augroup("javascript_folding", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "javascript_folding",
				pattern = "javascript",
				command = "setlocal foldmethod=syntax",
			})
		end,
	},

	{

		"maxmellon/vim-jsx-pretty",
		config = function()
			vim.g.vim_jsx_pretty_disable_js = 0
			vim.g.vim_jsx_pretty_disable_tsx = 0
			vim.g.vim_jsx_pretty_template_tags = { "html", "jsx" }
			vim.g.vim_jsx_pretty_highlight_close_tag = 0
			vim.g.vim_jsx_pretty_colorful_config = 1
		end,
	},

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

	{
		"leafgarland/typescript-vim",
	},
}
