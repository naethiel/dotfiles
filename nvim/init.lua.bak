-- Leader key (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- Diagnostics (Helix-style)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

-- Helix-isms
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set('n', 'x', 'V', { desc = 'Select line' })
vim.keymap.set('v', 'x', 'j', { desc = 'Select line below' })
vim.keymap.set({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'Go to end of line' })
vim.keymap.set({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Go to start of line' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })

-- incremental selection treesitter/lsp
vim.keymap.set({ 'n', 'x', 'o' }, '<A-Up>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Select parent treesitter node or outer incremental lsp selections' })

vim.keymap.set({ 'n', 'x', 'o' }, '<A-Down>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Select child treesitter node or inner incremental lsp selections' })

-- buffer navigation
vim.keymap.set('n', 'gp', '<cmd>:bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', 'gn', '<cmd>:bnext<CR>', { desc = 'Next buffer' })

-- quickfix navigation
vim.keymap.set('n', '<C-p>', '<cmd>:cprev<CR>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', '<C-n>', '<cmd>:cnext<CR>', { desc = 'Next quickfix item' })

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format + organize imports on save',
  pattern = '*',
  group = vim.api.nvim_create_augroup('format-on-save', { clear = true }),
  callback = function(ev)
    local conform_opts = { bufnr = ev.buf, lsp_format = 'fallback', timeout_ms = 2000 }
    local client = vim.lsp.get_clients({ name = 'vtsls', bufnr = ev.buf })[1]

    if client then
      local result = client:request_sync('workspace/executeCommand', {
        command = 'typescript.organizeImports',
        arguments = { vim.api.nvim_buf_get_name(ev.buf) },
      })
      if result and result.err then
        vim.notify(result.err.message, vim.log.levels.ERROR)
        return
      end
    end

    require('conform').format(conform_opts)
  end,
})

--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
require('lazy').setup({
  -- Utilities
  'NMAC427/guess-indent.nvim',
  'b0o/schemastore.nvim',
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

  -- GitHub Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
          accept_word = '<C-Right>',
          accept_line = '<C-Down>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
    },
  },
  {
    'copilotlsp-nvim/copilot-lsp',
    config = function()
      require('copilot-lsp').setup()
      -- NES keymaps (normal mode)
      vim.keymap.set('n', '<Tab>', function()
        require('copilot-lsp.nes').apply_pending_nes()
      end, { desc = 'Apply Copilot edit' })
      vim.keymap.set('n', '<S-Tab>', function()
        require('copilot-lsp.nes').walk_cursor_start_edit()
      end, { desc = 'Jump to Copilot edit' })
      vim.keymap.set('n', '<C-]>', function()
        require('copilot-lsp.nes').clear_all_nes()
      end, { desc = 'Clear Copilot edits' })
    end,
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
    },
  },

  -- UI
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,

    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      preset = 'helix',
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      require('mini.tabline').setup {
        show_icons = vim.g.have_nerd_font,
        tabpage_section = 'left',
      }
    end,
  },

  -- Navigation
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = { modes = { char = { enabled = false } } },
    keys = {
      {
        'gw',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash jump',
      },
      {
        'gW',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash treesitter',
      },
    },
  },

  ---@type LazySpec
  {
    'mikavilpas/yazi.nvim',
    version = '*', -- use the latest stable version
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>e',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>E',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- mark netrw as loaded so it's not loaded at all.
      --
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = { mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine', ['<C-h>'] = 'which_key' } } },
        extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      -- Helix-style pickers
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'File picker' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffer picker' })
      vim.keymap.set('n', '<leader>j', builtin.jumplist, { desc = 'Jumplist picker' })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Global search' })
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Diagnostics picker' })
      vim.keymap.set('n', "<leader>'", builtin.resume, { desc = 'Resume picker' })
      vim.keymap.set('n', '<leader>?', builtin.help_tags, { desc = 'Help picker' })
      vim.keymap.set('n', '<leader>g', builtin.git_status, { desc = 'Git status' })
      -- Extra pickers
      vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = 'Keymaps' })
      vim.keymap.set('n', '<leader>w', builtin.grep_string, { desc = 'Search word' })
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'typescript',
        'tsx',
        'javascript',
        'go',
        'json',
        'yaml',
        'css',
      }
      require('nvim-treesitter').install(ensure_installed)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- LSP
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'j-hui/fidget.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local ts = require 'telescope.builtin'
          -- Helix-style LSP keymaps -- overriden by default neovim keymaps
          map('<leader>sd', ts.diagnostics, '[S]earch [D]iagnostics')
          map('gd', vim.lsp.buf.definition, 'Go to [d]efinition')
          map('gD', vim.lsp.buf.declaration, 'Go to [D]eclaration')
          map('<leader>sr', ts.lsp_references, '[S]earch [R]eferences')
          map('<leader>si', ts.lsp_implementations, '[S]earch [I]mplementations')
          map('<leader>st', ts.lsp_type_definitions, '[S]earch [T]ype definition')
          map('<leader>k', vim.lsp.buf.signature_help, 'Hover docs')
          map('<leader>ss', ts.lsp_document_symbols, '[S]earch document [s]ymbols')
          map('<leader>sS', ts.lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')

          -- Highlight references on hover
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = hl_group, callback = vim.lsp.buf.document_highlight })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = hl_group, callback = vim.lsp.buf.clear_references })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = ev.buf }
              end,
            })
          end

          -- Inlay hints toggle
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end
        end,
      })

      -- Diagnostics config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      -- Server configs
      local servers = {
        gopls = {},
        yamlls = {
          settings = {
            yaml = { schemaStore = { enable = true, url = 'https://www.schemastore.org/api/json/catalog.json' }, validate = true },
          },
        },
        jsonls = {
          on_new_config = function(config)
            config.settings.json.schemas = config.settings.json.schemas or {}
            vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = { json = { validate = { enable = true } } },
        },
        vtsls = {
          settings = {
            typescript = { preferences = { importModuleSpecifier = 'non-relative' } },
            typescriptreact = { preferences = { importModuleSpecifier = 'non-relative' } },
          },
        },
        biome = {},
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      }

      local autoCompleteCapabilities = require('blink.cmp').get_lsp_capabilities()

      for server_name, server_opts in pairs(servers) do
        server_opts.capabilities = vim.tbl_deep_extend('force', {}, autoCompleteCapabilities, server_opts.capabilities or {})
        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name, true)
      end
    end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        json = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        css = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  -- Completion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1) and 'make install_jsregexp' or nil,
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = { preset = 'enter' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
  {
    'MagicDuck/grug-far.nvim',

    config = function()
      local grug = require 'grug-far'
      grug.setup {}

      vim.keymap.set({ 'n', 'x' }, '<leader>ss', function()
        local search = vim.fn.getreg '/'
        -- surround with \b if "word" search (such as when pressing `*`)
        if search and vim.startswith(search, '\\<') and vim.endswith(search, '\\>') then
          search = '\\b' .. search:sub(3, -3) .. '\\b'
        elseif search and vim.startswith(search, '\\V') then
          search = search:sub(3)
        end
        local inst = grug.open {
          prefills = {
            search = search,
          },
        }
        inst:when_ready(function()
          inst:goto_input 'replacement'
        end)
      end, { desc = 'grug-far: Search using @/ register value or visual selection' })
    end,
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
