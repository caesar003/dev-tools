if true then return {} end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup {
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              bo = { filetype = { "neo-tree", "neo-tree-popup", "notify" }, buftype = { "terminal", "quickfix" } },
            },
          }
        end,
      },
    },
    config = function()
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
      vim.api.nvim_set_keymap(
      "n",
      "<leader>e",
      ":Neotree toggle<CR>",
      { noremap = true, silent = true, desc = "File Explorer" }
      )
      require("neo-tree").setup {
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          container = { enable_character_fade = true },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = { symbol = "[+]", highlight = "NeoTreeModified" },
          name = { trailing_slash = false, highlight = "NeoTreeFileName" },
          git_status = {
            symbols = {
              added = "✚",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
          file_size = { enabled = true, required_width = 64 },
          type = { enabled = true, required_width = 122 },
          last_modified = { enabled = true, required_width = 88 },
          created = { enabled = true, required_width = 110 },
          symlink_target = { enabled = false },
        },
        commands = {},
        window = {
          position = "left",
          width = 40,
          mapping_options = { noremap = true, nowait = true },
          mappings = {
            ["<space>"] = { "toggle_node", nowait = false },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel",
            ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = { "add", config = { show_path = "none" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          },
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true,
            hide_by_name = { "node_modules" },
            hide_by_pattern = {},
            always_show = {},
            always_show_by_pattern = {},
            never_show = {},
            never_show_by_pattern = {},
          },
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = false,
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["og"] = { "order_by_git_status", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
            fuzzy_finder_mappings = {
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },
          commands = {},
        },
        buffers = {
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
              ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
              ["oc"] = { "order_by_created", nowait = false },
              ["od"] = { "order_by_diagnostics", nowait = false },
              ["om"] = { "order_by_modified", nowait = false },
              ["on"] = { "order_by_name", nowait = false },
              ["os"] = { "order_by_size", nowait = false },
              ["ot"] = { "order_by_type", nowait = false },
            },
          },
        },
      }
      vim.cmd [[nnoremap \ :Neotree reveal<cr>]]
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "justinsgithub/oh-my-monokai.nvim",
    opts = {
      transparent_background = true,
      terminal_colors = true,
      devicons = true,
      palette = "default",
      inc_search = "background",
      background_clear = { "toggleterm", "which-key", "renamer", "neo-tree" },
      plugins = {
        bufferline = { underline_selected = false, underline_visible = false },
        indent_blankline = { context_start_underline = false },
      },
      override = function(c) end,
    },
  },
  {
    "rebelot/heirline.nvim",
    config = function()
      local heirline = require "heirline"
      local conditions = require "heirline.conditions"
      local utils = require "heirline.utils"
      local colors = {
        bright_bg = "#f9fafb", -- Tailwind's `gray-50` for a light background
        bright_fg = "#374151", -- Tailwind's `gray-700` for a more subdued foreground
        red = "#ef4444", -- Tailwind's `red-500` for errors
        dark_red = "#b91c1c", -- Tailwind's `red-800` for a darker red
        green = "#10b981", -- Tailwind's `green-500` for success or positive
        blue = "#3b82f6", -- Tailwind's `blue-500` for functions or primary actions
        gray = "#6b7280", -- Tailwind's `gray-500` for neutral or non-text
        orange = "#f97316", -- Tailwind's `orange-500` for constants
        purple = "#8b5cf6", -- Tailwind's `purple-500` for statements
        cyan = "#06b6d4", -- Tailwind's `cyan-500` for special elements
        diag_warn = "#f59e0b", -- Tailwind's `yellow-500` for warnings
        diag_error = "#ef4444", -- Tailwind's `red-500` for errors
        diag_hint = "#3b82f6", -- Tailwind's `blue-500` for hints
        diag_info = "#10b981", -- Tailwind's `green-500` for informational messages
        git_del = "#ef4444", -- Tailwind's `red-500` for deleted lines
        git_add = "#10b981", -- Tailwind's `green-500` for added lines
        git_change = "#f97316", -- Tailwind's `orange-500` for changed lines
        magenta = "#d946ef", -- Tailwind's `pink-500` for magenta
        light_blue = "#bfdbfe" -- Tailwind's `blue-100` for light blue highlights
      }
      local FileNameBlock = { init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end }
      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
          or self.status_dict.removed ~= 0
          or self.status_dict.changed ~= 0
        end,
        hl = { fg = colors.orange },
        {
          provider = function(self) return " " .. self.status_dict.head end,
          hl = { fg = colors.orange, bold = false },
        },
        { condition = function(self) return self.has_changes end, provider = "(", hl = { fg = colors.gray } },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = colors.git_add },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = colors.git_del },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = colors.git_change },
        },
        { condition = function(self) return self.has_changes end, provider = ")", hl = { fg = colors.gray } },
      }
      local ScrollBar = {
        static = { sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" } },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = colors.gray, bg = colors.bright_bg },
      }
      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self) return self.icon and (self.icon .. " ") end,
        hl = function(self) return { fg = self.icon_color or colors.gray } end,
      }
      local FileName = {
        provider = function(self)
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then return "[No Name]" end
          if not conditions.width_percent_below(#filename, 0.25) then filename = vim.fn.pathshorten(filename) end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }
      local FileEncoding =
      { provider = function() return " " .. vim.bo.fileencoding .. " " end, hl = { fg = colors.gray } }
      local FileFlags = {
        { condition = function() return vim.bo.modified end, provider = "[+]", hl = { fg = colors.light_blue } },
        {
          condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
          provider = "",
          hl = { fg = "Orange" },
        },
      }
      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then return { fg = colors.cyan, bold = true, force = true } end
        end,
      }
      local FileType = {
        provider = function() return " " .. vim.bo.filetype .. " " end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }
      local FileFormat =
      { provider = function() return "[" .. vim.bo.fileformat .. "]" end, hl = { fg = colors.magenta } }
      local Space = { provider = " " }
      local Ruler = { provider = "%7(%l/%3L%):%2c %P" }
      local TablinePicker = {
        condition = function(self) return self._show_picker end,
        init = function(self)
          local bufname = vim.api.nvim_buf_get_name(self.bufnr)
          bufname = vim.fn.fnamemodify(bufname, ":t")
          local label = bufname:sub(1, 1)
          local i = 2
          while self._picker_labels[label] do
            if i > #bufname then break end
            label = bufname:sub(i, i)
            i = i + 1
          end
          self._picker_labels[label] = self.bufnr
          self.label = label
        end,
        provider = function(self) return self.label end,
        hl = { fg = "red", bold = true },
      }
      local TablineFileName = {
        provider = function(self)
          local filename = self.filename
          filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
          return filename
        end,
        hl = function(self) return { bold = self.is_active or self.is_visible, italic = true } end,
      }
      local TablineFileFlags = {
        {
          condition = function(self) return vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) end,
          provider = "[+]",
          hl = { fg = "green" },
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
      local TablineBufnr = { provider = function(self) return tostring(self.bufnr) .. ". " end, hl = "Comment" }
      local ViMode = {
        init = function(self) self.mode = vim.fn.mode(1) end,
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
          mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
          },
        },
        provider = function(self) return self.mode_names[self.mode] end,
        hl = function(self)
          local mode = self.mode:sub(1, 1)
          return { fg = self.mode_colors[mode], bold = true }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function() vim.cmd "redrawstatus" end),
        },
      }
      FileNameBlock =
      utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })
      local StatusLine = {
        ViMode,
        Space,
        FileNameBlock,
        Space,
        FileType,
        Space,
        FileEncoding,
        Space,
        FileFormat,
        { provider = "%=" },
        Git,
        { provider = "%=" },
        Ruler,
        Space,
        ScrollBar,
      }
      local TablineFileNameBlock = {
        init = function(self) self.filename = vim.api.nvim_buf_get_name(self.bufnr) end,
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
              vim.schedule(function() vim.api.nvim_buf_delete(minwid, { force = false }) end)
            else
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,
          minwid = function(self) return self.bufnr end,
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
      local get_bufs = function()
        return vim.tbl_filter(
        function(bufnr) return vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) end,
        vim.api.nvim_list_bufs()
        )
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
      local BufferLine = utils.make_buflist(
      TablineBufferBlock,
      { provider = " ", hl = { fg = "gray" } },
      { provider = " ", hl = { fg = "gray" } },
      function() return buflist_cache end,
      false
      )
      vim.keymap.set("n", "<leader>bb", function()
        local tabline = require("heirline").tabline
        local buflist = tabline._buflist[1]
        buflist._picker_labels = {}
        buflist._show_picker = true
        vim.cmd.redrawtabline()
        local char = vim.fn.getcharstr()
        local bufnr = buflist._picker_labels[char]
        if bufnr then vim.api.nvim_win_set_buf(0, bufnr) end
        buflist._show_picker = false
        vim.cmd.redrawtabline()
      end, { noremap = true, desc = "Go to" })
      heirline.setup { statusline = StatusLine, tabline = BufferLine }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_set_keymap(
      "n",
      "<leader>fw",
      ":Telescope live_grep<CR>",
      { noremap = true, silent = true, desc = "Pattern" }
      )
      vim.api.nvim_set_keymap(
      "n",
      "<leader>fg",
      ":Telescope git_files<CR>",
      { noremap = true, silent = true, desc = "Git files" }
      )
      vim.api.nvim_set_keymap(
      "n",
      "<leader>ff",
      ":Telescope find_files<CR>",
      { noremap = true, silent = true, desc = "Files" }
      )
      vim.api.nvim_set_keymap(
      "n",
      "<leader>bl",
      ":Telescope buffers<CR>",
      { noremap = true, silent = true, desc = "Buffers" }
      )
    end,
  },
  {
    "numtostr/BufOnly.nvim",
    config = function()
      vim.api.nvim_set_keymap(
      "n",
      "<leader>bo",
      ":BufOnly<CR>",
      { noremap = true, silent = true, desc = "Close all but this" }
      )
      vim.api.nvim_set_keymap("n", "<leader>bO", ":BufOnly<space>", { noremap = true, desc = "Close all but ..." })
    end,
  },
  { "machakann/vim-highlightedyank", config = function() vim.g.highlightedyank_highlight_duration = 200 end },
  {
    "tpope/vim-commentary",
    config = function()
      vim.api.nvim_set_keymap(
      "n",
      "<leader>/",
      ":Commentary<CR>",
      { noremap = true, silent = true, desc = "Comment" }
      )
      vim.api.nvim_set_keymap(
      "v",
      "<leader>/",
      ":Commentary<CR>",
      { noremap = true, silent = true, desc = "Comment" }
      )
    end,
  },
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    opts = {
      signs = {
        add = { text = "█|" },
        change = { text = "█⫶" },
        delete = { text = "█▁" },
        topdelete = { text = "█▔" },
        changedelete = { text = "█▟" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "█|" },
        change = { text = "█⫶" },
        delete = { text = "█▁" },
        topdelete = { text = "█▔" },
        changedelete = { text = "█▟" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = { border = "single", style = "minimal", relative = "cursor", row = 0, col = 1 },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {},
    config = function()
      local wk = require "which-key"
      wk.add {
        { "<leader>f", group = "File" },
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "GitGutter Hunk" },
        { "<leader>s", group = "Session" },
        { "<leader>u", group = "UI" },
      }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = { zsh = { icon = "", color = "#428850", cterm_color = "65", name = "Zsh" } },
      color_icons = true,
      default = true,
      strict = true,
      override_by_filename = { [".gitignore"] = { icon = "", color = "#f1502f", name = "Gitignore" } },
      override_by_extension = { ["log"] = { icon = "", color = "#81e043", name = "Log" } },
      override_by_operating_system = {
        ["apple"] = { icon = "", color = "#A2AAAD", cterm_color = "248", name = "Apple" },
      },
    },
  },
  { "echasnovski/mini.icons", style = "gliph" },
  {
    "pangloss/vim-javascript",
    ft = "javascript",
    config = function()
      vim.g.javascript_plugin_jsdoc = 1
      vim.api.nvim_create_augroup("javascript_folding", { clear = true })
      vim.api.nvim_create_autocmd(
      "FileType",
      { 
        group = "javascript_folding", 
        pattern = "javascript", 
        command = "setlocal foldmethod=syntax" 
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
  { "prettier/vim-prettier" },
  { "psliwka/vim-smoothie" },
  { "preservim/vim-markdown" },
  { "jiangmiao/auto-pairs" },
  {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx"
      vim.g.closetag_xhtml_filenames = "*.xhtml,*.jsx,*.tsx"
      vim.g.closetag_xhtml_filetypes = "xhtml,javascript.jsx,jsx"
      vim.g.closetag_filetypes = "html,xhtml,phtml,javascriptreact,typescriptreact"
      vim.g.closetag_emptyTags_caseSensitive = 1
      vim.g.closetag_shortcut = ">"
      vim.g.closetag_close_shortcut = "<leader>>"
      vim.api.nvim_create_autocmd(
      { "BufNewFile", "BufRead" },
      { pattern = { "*.js", "*.jsx" }, callback = function() vim.bo.filetype = "javascript.jsx" end }
      )
    end,
  },
  { "folke/todo-comments.nvim", opts = {} },
  {
    "voldikss/vim-floaterm",
    config = function()
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_title = " Floaterm: ($1|$2) "
      vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
      vim.api.nvim_set_keymap("n", "<F6>", ":FloatermToggle<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F7>", ":FloatermNew<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F8>", ":FloatermPrev<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<F9>", ":FloatermNext<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("t", "<F6>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("t", "<F7>", "<C-\\><C-n>:FloatermNew<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("t", "<F8>", "<C-\\><C-n>:FloatermPrev<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("t", "<F9>", "<C-\\><C-n>:FloatermNext<CR>", { noremap = true, silent = true })
    end,
  },
  { "vim-scripts/loremipsum" },
}
