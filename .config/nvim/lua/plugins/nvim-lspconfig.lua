-- if true then return {} end

-- ~/.config/nvim/lua/plugins/nvim-lspconfig.lua
return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      -- Import the lspconfig module
      local lspconfig = require('lspconfig')

      -- Function to set keymaps with dynamic options
      local function set_keymap(bufnr, mode, lhs, rhs, opts)
        local default_opts = { noremap = true, silent = true }  -- Default options
        opts = vim.tbl_extend('force', default_opts, opts or {}) -- Merge with passed opts
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
      end

      -- Setup the TypeScript and JavaScript language server
      lspconfig.ts_ls.setup({
        on_attach = function(client, bufnr)
          -- Disable tsserver's formatting capability if you use a different formatter
          client.server_capabilities.document_formatting = false

          -- Key mappings for LSP functions
          set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {
            desc = "Go to definition"
          })
          set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
          set_keymap(bufnr, 'n', '<leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', {
            desc = "Rename symbol"
          })
          set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {
            desc = "Go to reference"
          })
          set_keymap(bufnr, 'n', 'gl', '<Cmd>lua vim.diagnostic.open_float()<CR>', {
            desc = "Open diagnostic float"
          })
          set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', {
            desc = "Next diagnostic"
          })
          set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', {
            desc = "Prev diagnostic"
          })
        end,
      })
    end
  },
  {
    "williamboman/mason.nvim", -- Optional: to manage LSP servers automatically
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim", -- Bridges mason with lspconfig
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "ts_ls" }, -- Automatically install tsserver
      }
    end
  }
}

