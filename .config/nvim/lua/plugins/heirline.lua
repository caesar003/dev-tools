-- if true then return {} end
return {
  {
    "rebelot/heirline.nvim",
    config = function()
      local heirline = require "heirline"
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

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, {default = true})
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return {fg = self.icon_color or colors.gray}
        end
      }

      local TablineFileFlags = {
        {
          condition = function(self)
            return vim.api.nvim_get_option_value("modified", {buf = self.bufnr})
          end,
          provider = "[+]",
          hl = {fg = colors.light_blue}
        },
        {
          condition = function(self)
            return not vim.api.nvim_get_option_value("modifiable", {buf = self.bufnr}) or
              vim.api.nvim_get_option_value("readonly", {buf = self.bufnr})
          end,
          provider = function(self)
            if vim.api.nvim_get_option_value("buftype", {buf = self.bufnr}) == "terminal" then
              return "  "
            else
              return ""
            end
          end,
          hl = { fg = "orange" }
        }
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
          self.label =  " " .. label 
        end,
        provider = function(self)
          return self.label
        end,
        hl = {fg = colors.red, bold = true}
      }

      local TablineFileName = {
        provider = function(self)
          local filename = self.filename
          filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
          return filename
        end,
        hl = function(self)
          return {bold = self.is_active or self.is_visible, italic = true}
        end
      }

      local TablineBufnr = {
        provider = function(self)
          return tostring(self.bufnr) .. ". "
        end,
        hl = "Comment"
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
              vim.schedule(
                function()
                  vim.api.nvim_buf_delete(minwid, {force = false})
                end
              )
            else
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = "heirline_tabline_buffer_callback"
        },
        TablineBufnr,
        FileIcon,
        TablineFileName,
        TablineFileFlags
      }

      local TablineBufferBlock =
        utils.surround(
        {" ", " "},
        function(self)
          if self.is_active then
            return utils.get_highlight("TabLineSel").bg
          else
            return utils.get_highlight("TabLine").bg
          end
        end,
        {TablineFileNameBlock, TablinePicker}
      )
      local Prev = {provider = " ", hl = {fg = "gray"}}
      local Next = {provider = " ", hl = {fg = "gray"}}
      local get_bufs = function()
        return vim.tbl_filter(
          function(bufnr)
            return vim.api.nvim_get_option_value("buflisted", {buf = bufnr})
          end,
          vim.api.nvim_list_bufs()
        )
      end
      local buflist_cache = {}
      vim.api.nvim_create_autocmd(
        {"VimEnter", "UIEnter", "BufAdd", "BufDelete"},
        {
          callback = function()
            vim.schedule(
              function()
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
              end
            )
          end
        }
      )

      local BufferLine =
        utils.make_buflist(
        TablineBufferBlock,
        Prev,
        Next,
        function()
          return buflist_cache
        end,
        false
      )
      vim.keymap.set(
        "n",
        "<leader>bb",
        function()
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
        end,
        {noremap = true, desc = "Go to"}
      )

      heirline.setup {tabline = BufferLine}
    end
  }
}
