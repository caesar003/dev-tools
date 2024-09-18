-- if true then return {} end
return {
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
}
