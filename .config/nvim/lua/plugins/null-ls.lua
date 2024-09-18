return {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- PHP formatting using php-cs-fixer
				null_ls.builtins.formatting.phpcsfixer.with({
					command = "php-cs-fixer", -- Ensure it's in your $PATH
				}),
				-- Blade formatting using blade-formatter
				null_ls.builtins.formatting.blade_formatter.with({
					command = "blade-formatter", -- Ensure it's in your $PATH
				}),
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
			},
		})
	end,
}
