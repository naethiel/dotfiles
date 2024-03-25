return {
  { 'echasnovski/mini.nvim', version = false, 
    config = function() 
      -- better text objects: `ii`, `ai`, `aI`, `ii`, `aP`, `iP`, `aB`, `iB`, `a{`, `i{`, `a}`, `i}`...
      require("mini.ai").setup()
      -- auto "surround" with s: sa" to surround with "...
      require("mini.surround").setup()
      -- toggle comments
      require("mini.comment").setup({
        mappings = {
          -- Toggle comment for both
          -- Normal and Visual modes
          comment = '<c-c>',

          -- Toggle comment on current line
          comment_line = '<c-c>',

          -- Toggle comment on visual selection
          comment_visual = '<c-c>',

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          textobject = 'gc',
        },
      })
      -- helix-like help panel to highlight keybinds
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          config = {
            width = "auto"
          }
        }
      })
      -- move selection around
      require("mini.move").setup()
      -- highlight word under cursor
      require("mini.cursorword").setup()
      -- auto bracket pairs {, [, (, ", ', `
      require("mini.pairs").setup() 
      -- buffer tabs
      require("mini.tabline").setup({
        show_icons = false
      })
      -- basic statusline
      require("mini.statusline").setup({
        use_icons = false
      })
      -- auto-completion
      require("mini.completion").setup()
      -- Use `<Tab>` and `<S-Tab>` to navigate through popup menu items
      -- see https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-completion.txt#L99
      vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
      vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

      -- Use `<CR>` to confirm completion item or add new line
      local keys = {
        ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
        ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
        ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
      }

      -- Define custom action for `<CR>` key
      _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
          -- If popup is visible, confirm selected item or add new line otherwise
          local item_selected = vim.fn.complete_info()['selected'] ~= -1
          return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
        else
          -- If popup is not visible, use plain `<CR>`. You might want to customize
          -- according to other plugins. For example, to use 'mini.pairs', replace
          -- next line with `return require('mini.pairs').cr()`
          return keys['cr']
        end
      end

      -- Set custom action for `<CR>` key
      vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
    end
  },
}
