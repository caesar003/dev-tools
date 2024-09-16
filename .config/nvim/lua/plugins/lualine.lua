-- if true then return {} end
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,

  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
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
      }
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
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
        'encoding', 
        'fileformat', 
        'filetype'
      },
      lualine_y = {
        'ctime',
        'cdate',
        'location'
      },
      lualine_z = {'progress'},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'neo-tree' }
  }

}



