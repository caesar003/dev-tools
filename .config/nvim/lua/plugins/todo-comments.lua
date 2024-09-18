-- FIX: there's huge error here
-- TODO: take care of error handling here
-- HACK: there's actually a better way of writing it but I prefer this cleaner option
-- WARN: be cautious when using this built-in method as it often leads to unexpected behaviour
-- PERF: consider writing
-- NOTE: this is important to
-- TEST:

return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
