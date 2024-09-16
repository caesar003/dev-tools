return {
  {
    "justinsgithub/oh-my-monokai.nvim",
    -- name = "oh-my-monokai",
    enabled = true,
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
    "ellisonleao/gruvbox.nvim", 
    priority = 1000 , 
    config = true, 
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
      contrast = "soft", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = true,
      transparent_mode = true,
    }
  },

  {
    'marko-cerovac/material.nvim',
    enabled = false,
    opts = {
      -- darker
      -- lighter
      -- oceanic
      -- palenight
      -- deep ocean
      theme = "darker",
      contrast = {
        terminal = false, -- Enable contrast for the built-in terminal
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        lsp_virtual_text = false, -- Enable contrasted background for lsp virtual text
        non_current_windows = false, -- Enable contrasted background for non-current windows
        filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
      },

      styles = { -- Give comments style such as bold, italic, underline etc.
        comments = { --[[ italic = true ]] },
        strings = { --[[ bold = true ]] },
        keywords = { --[[ underline = true ]] },
        functions = { --[[ bold = true, undercurl = true ]] },
        variables = {},
        operators = {},
        types = {},
      },

      plugins = { -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        -- "coc",
        -- "colorful-winsep",
        -- "dap",
        -- "dashboard",
        -- "eyeliner",
        -- "fidget",
        -- "flash",
        "gitsigns",
        -- "harpoon",
        -- "hop",
        -- "illuminate",
        -- "indent-blankline",
        -- "lspsaga",
        -- "mini",
        -- "neogit",
        -- "neotest",
        "neo-tree",
        -- "neorg",
        -- "noice",
        -- "nvim-cmp",
        -- "nvim-navic",
        -- "nvim-tree",
        "nvim-web-devicons",
        -- "rainbow-delimiters",
        -- "sneak",
        "telescope",
        -- "trouble",
        "which-key",
        -- "nvim-notify",
      },

      disable = {
        colored_cursor = false, -- Disable the colored cursor
        borders = false, -- Disable borders between vertically split windows
        background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        term_colors = false, -- Prevent the theme from setting terminal colors
        eob_lines = false -- Hide the end-of-buffer lines
      },

      high_visibility = {
        lighter = false, -- Enable higher contrast text for lighter style
        darker = false -- Enable higher contrast text for darker style
      },

      lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
      async_loading = true, -- Load parts of the theme asynchronously for faster startup (turned on by default)
      custom_colors = nil, -- If you want to override the default colors, set this to a function
      custom_highlights = {}, -- Overwrite highlights with your own
    }
  },


  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      dark_style_background = "transparent", -- default, dark, transparent, #color
      light_style_background = "transparent", -- default, dark, transparent, #color
    }
  },

  {
    'rmehri01/onenord.nvim',
    opts = {
      theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
      borders = true, -- Split window borders
      fade_nc = false, -- Fade non-current windows, making them more distinguishable
      -- Style that is applied to various groups: see `highlight-args` for options
      styles = {
        comments = "NONE",
        strings = "NONE",
        keywords = "NONE",
        functions = "NONE",
        variables = "NONE",
        diagnostics = "underline",
      },
      disable = {
        background = false, -- Disable setting the background color
        float_background = false, -- Disable setting the background color for floating windows
        cursorline = false, -- Disable the cursorline
        eob_lines = true, -- Hide the end-of-buffer lines
      },
      -- Inverse highlight for different groups
      inverse = {
        match_paren = false,
      },
      custom_highlights = {}, -- Overwrite default highlight groups
      custom_colors = {}, -- Overwrite default colors
    }
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "auto", -- auto, main, moon, or dawn
      dark_variant = "dawn", -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },

      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },

      pallete = {
        -- Override the builtin palette per variant
        -- moon = {
          --     base = '#18191a',
          --     overlay = '#363738',
          -- },
        },

        highlight_groups = {
          -- Comment = { fg = "foam" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },

        before_highlight = function(group, highlight, palette)
          -- Disable all undercurls
          -- if highlight.undercurl then
          --     highlight.undercurl = false
          -- end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      }
    },
    {
      'mustardfrog/pinkish_day',
      lazy = true,
      dependencies = { 'rktjmp/lush.nvim' },
    }


  }

