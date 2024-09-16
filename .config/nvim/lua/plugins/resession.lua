return {
  {
    "stevearc/resession.nvim",
    opts = {
      autosave = {
        enabled = true,
        interval = 60,  -- Interval in seconds for autosaving
        notify = true,  -- Notify when autosave occurs
      },
    },
    config = function ()
      local resession = require("resession")
      resession.setup()

      -- Key mappings for session management
      vim.keymap.set("n", "<leader>ss", function()
        local ok, err = pcall(resession.save)
        if not ok then
          print("Error saving session: " .. err)
        end
      end, { desc = "Save session" })

      vim.keymap.set("n", "<leader>sl", function()
        local ok, err = pcall(resession.load)
        if not ok then
          print("Error loading session: " .. err)
        end
      end, { desc = "Load session" })

      vim.keymap.set("n", "<leader>sd", function()
        local ok, err = pcall(resession.delete)
        if not ok then
          print("Error deleting session: " .. err)
        end
      end, { desc = "Delete session" })

      -- Autocommands for session management
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Load session only if nvim was started with no arguments
          if vim.fn.argc(-1) == 0 then
            local ok, err = pcall(resession.load, vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            if not ok then
              print("Error loading session: " .. err)
            end
          end
        end,
        nested = true,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          local ok, err = pcall(resession.save, vim.fn.getcwd(), { dir = "dirsession", notify = false })
          if not ok then
            print("Error saving session: " .. err)
          end
        end,
      })
    end
  }
}
