return {
  -- theme
  {
    'catppuccin/nvim', lazy = false, config = function ()
      vim.cmd("colorscheme catppuccin")
    end
  },
  -- basic plugins
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
}
