return {
  -- theme
  {
    'catppuccin/nvim', lazy = false, config = function ()
      require("catppuccin").setup({
        transparent_background = true,
        integrations = {
          mini = {
            enabled = true
          }
        }
      })
      vim.cmd("colorscheme catppuccin")
    end
  },
  -- basic plugins
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
}
