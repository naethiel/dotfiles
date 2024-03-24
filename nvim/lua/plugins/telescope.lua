return {
  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      -- See `:help telescope.builtin`
      vim.keymap.set('n', "<leader>'", require('telescope.builtin').resume, { desc = "['] Open last picker" })
      vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>j', require('telescope.builtin').jumplist, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'open [f]iles picker' })
      vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'open [H]elp picker' })
      vim.keymap.set('n', '<leader>w', require('telescope.builtin').grep_string, { desc = 'Search current [W]ord' })
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep, { desc = 'Global search [/] in workspace' })
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').keymaps, { desc = 'Open keymaps' })
      vim.keymap.set('n', '<leader>d', require("telescope.builtin").diagnostics,{ desc =  'Open [D]iagnostics picker' })
      vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_document_symbols, { desc =  'Open [s]ymbols picker' })
      vim.keymap.set('n', '<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc =  'Open workspace [S]ymbols picker' })
    end

  },
}
