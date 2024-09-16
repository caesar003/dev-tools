-- if true then return {} end
return {
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
}
