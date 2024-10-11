return {
	{
		"rebelot/heirline.nvim",
		config = function()
			local heirline = require("heirline")
			local utils = require("heirline.utils")
			local colors = {
				bright_bg = "#f9fafb",
				bright_fg = "#374151",
				red = "#ef4444",
				dark_red = "#b91c1c",
				green = "#10b981",
				blue = "#3b82f6",
				gray = "#6b7280",
				orange = "#f97316",
				purple = "#8b5cf6",
				cyan = "#06b6d4",
				diag_warn = "#f59e0b",
				diag_error = "#ef4444",
				diag_hint = "#3b82f6",
				diag_info = "#10b981",
				git_del = "#ef4444",
				git_add = "#10b981",
				git_change = "#f97316",
				magenta = "#d946ef",
				light_blue = "#bfdbfe",
			}

			local FileIcon = {
				init = function(self)
					local filename = self.filename
					local extension = vim.fn.fnamemodify(filename, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
				end,
				provider = function(self)
					return self.icon and (self.icon .. " ")
				end,
				hl = function(self)
					return { fg = self.icon_color or colors.gray }
				end,
			}

			local TablineFileFlags = {
				{
					condition = function(self)
						return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
					end,
					provider = "[+]",
					hl = { fg = colors.light_blue },
				},
				{
					condition = function(self)
						return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
							or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
					end,
					provider = function(self)
						if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
							return "  "
						else
							return ""
						end
					end,
					hl = { fg = "orange" },
				},
			}

			local TablinePicker = {
				condition = function(self)
					return self._show_picker
				end,
				init = function(self)
					local bufname = vim.api.nvim_buf_get_name(self.bufnr)
					bufname = vim.fn.fnamemodify(bufname, ":t")
					local label = bufname:sub(1, 1)
					local i = 2
					while self._picker_labels[label] do
						if i > #bufname then
							break
						end
						label = bufname:sub(i, i)
						i = i + 1
					end
					self._picker_labels[label] = self.bufnr
					self.label = " " .. label
				end,
				provider = function(self)
					return self.label
				end,
				hl = { fg = colors.red, bold = true },
			}

			local TablineFileName = {
				provider = function(self)
					local filename = self.filename
					filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
					return filename
				end,
				hl = function(self)
					return { bold = self.is_active or self.is_visible, italic = true }
				end,
			}

			local TablineBufnr = {
				provider = function(self)
					return tostring(self.bufnr) .. ". "
				end,
				hl = "Comment",
			}

			local TablineFileNameBlock = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(self.bufnr)
				end,
				hl = function(self)
					if self.is_active then
						return "TabLineSel"
					else
						return "TabLine"
					end
				end,
				on_click = {
					callback = function(_, minwid, _, button)
						if button == "m" then
							vim.schedule(function()
								vim.api.nvim_buf_delete(minwid, { force = false })
							end)
						else
							vim.api.nvim_win_set_buf(0, minwid)
						end
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_buffer_callback",
				},
				TablineBufnr,
				FileIcon,
				TablineFileName,
				TablineFileFlags,
			}

			local TablineBufferBlock = utils.surround({ " ", " " }, function(self)
				if self.is_active then
					return utils.get_highlight("TabLineSel").bg
				else
					return utils.get_highlight("TabLine").bg
				end
			end, { TablineFileNameBlock, TablinePicker })
			local Prev = { provider = " ", hl = { fg = "gray" } }
			local Next = { provider = " ", hl = { fg = "gray" } }

			local get_bufs = function()
				return vim.tbl_filter(function(bufnr)
					return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
				end, vim.api.nvim_list_bufs())
			end
			local buflist_cache = {}
			vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						local buffers = get_bufs()
						for i, v in ipairs(buffers) do
							buflist_cache[i] = v
						end
						for i = #buffers + 1, #buflist_cache do
							buflist_cache[i] = nil
						end
						if #buflist_cache > 1 then
							vim.o.showtabline = 2
						elseif vim.o.showtabline ~= 1 then
							vim.o.showtabline = 1
						end
					end)
				end,
			})

			local BufferLine = utils.make_buflist(TablineBufferBlock, Prev, Next, function()
				return buflist_cache
			end, false)
			vim.keymap.set("n", "<leader>bb", function()
				local tabline = require("heirline").tabline
				local buflist = tabline._buflist[1]
				buflist._picker_labels = {}
				buflist._show_picker = true
				vim.cmd.redrawtabline()
				local char = vim.fn.getcharstr()
				local bufnr = buflist._picker_labels[char]
				if bufnr then
					vim.api.nvim_win_set_buf(0, bufnr)
				end
				buflist._show_picker = false
				vim.cmd.redrawtabline()
			end, { noremap = true, desc = "Go to" })

			heirline.setup({ tabline = BufferLine })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				vim.o.statusline = " "
			else
				vim.o.laststatus = 0
			end
		end,

		opts = {
			theme = "catppuccin",
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {

					function()
						local ok, pomo = pcall(require, "pomo")
						if not ok then
							return ""
						end

						local timer = pomo.get_first_to_finish()
						if timer == nil then
							return ""
						end

						return "󰄉 " .. tostring(timer)
					end,
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = {
					-- "ctime",
					-- "cdate",
					"location",
				},
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = { "neo-tree" },
		},
	},
	{
		"archibate/lualine-time",
	},
}
