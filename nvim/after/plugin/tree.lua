require("nvim-tree").setup({
  view = {
    adaptive_size = true,
    mappings = {},
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>v', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

