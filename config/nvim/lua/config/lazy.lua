-- ~/.config/nvim/lua/config/lazy.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local comm = vim.cmd

require("config.commands")
require("config.options")
require("config.keymaps")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	change_detection = {
		notify = false,
	},
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"nertw",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- here I get the theme

require("config.theme")

if vim.fn.exists("+termguicolors") == 1 and vim.opt.termguicolors:get() then
	vim.cmd("hi Visual guifg=#000000 guibg=#FFA500")
	vim.cmd("hi Search guifg=#000000 guibg=#FFA500")
	vim.cmd("hi Cursor guifg=#FFA500 guibg=#1a1a1a")
else
	vim.cmd("hi Visual ctermfg=208 ctermbg=234")
	vim.cmd("hi Search ctermfg=208 ctermbg=234")
	vim.cmd("hi Cursor ctermfg=208 ctermbg=234")
end

comm("highlight Comment cterm=italic")
comm("highlight String cterm=italic gui=italic")
comm("highlight Function cterm=italic gui=italic")
comm("highlight Keyword cterm=italic gui=italic")
comm("hi Normal guibg=NONE ctermbg=NONE")
comm("hi NonText ctermbg=NONE")
comm("hi SignColumn ctermbg=NONE guibg=NONE")
comm("hi LineNr ctermbg=NONE guibg=NONE")
comm("hi Floaterm guibg=NONE")
comm("hi FloatermBorder guibg=NONE guifg=white")
