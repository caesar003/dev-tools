return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "auto",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = { "bold" },
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		opts = {
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = true,
		},
	},
	{
		"justinsgithub/oh-my-monokai.nvim",
		name = "oh-my-monokai",
		opts = {
			transparent_background = true,
			terminal_colors = true,
			devicons = true, -- highlight the icons of `nvim-web-devicons`
			palette = "default", -- or create your own ^^ e.g. justinsgithub
			inc_search = "background", -- underline | background
			background_clear = {
				-- "float_win",
				"toggleterm",
				"telescope",
				"which-key",
				"renamer",
				"neo-tree",
			}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
			plugins = {
				bufferline = {
					underline_selected = false,
					underline_visible = false,
				},
				indent_blankline = {
					context_start_underline = false,
				},
			},
			---@param c Colorscheme
			override = function(c) end,
		},
	},
	{
		"Reewr/vim-monokai-phoenix",
	},
}
