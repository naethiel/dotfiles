vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {silent = true, desc = "Open File Tree" })
vim.keymap.set("n", "<leader>o", ":NvimTreeFindFile<CR>", {silent = true, desc = "Find File in Tree" })

-- [[Configure File tree]]
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  config = {}
}
