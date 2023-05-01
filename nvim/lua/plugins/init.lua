return {
  -- theme
  {
    'catppuccin/nvim', lazy = false, config = function ()
      vim.cmd("colorscheme catppuccin")
    end
  },
  -- basic plugins
  {'numToStr/Comment.nvim', opts = {}}, -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
}
