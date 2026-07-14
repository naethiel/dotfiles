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
-- Keymaps (Helix-style)
--------------------------------------------------------------------------------
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- Helix-style core keymaps
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set('n', 'x', 'V', { desc = 'Select line' })
vim.keymap.set('v', 'x', 'j', { desc = 'Extend selection down' })
vim.keymap.set({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'Go to end of line' })
vim.keymap.set({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Go to start of line' })

-- Clipboard (Helix space-y/p)
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from clipboard' })

-- Incremental selection (treesitter/lsp)
vim.keymap.set({ 'n', 'x', 'o' }, '<A-Up>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = 'Expand selection' })

vim.keymap.set({ 'n', 'x', 'o' }, '<A-Down>', function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require('vim.treesitter._select').select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = 'Shrink selection' })

-- Buffer navigation (Helix g-n/g-p)
vim.keymap.set('n', 'gn', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', 'gp', '<cmd>bprev<CR>', { desc = 'Previous buffer' })

-- Quickfix navigation
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>', { desc = 'Previous quickfix' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix diagnostics' })

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
  desc = 'Format on save',
  pattern = '*',
  group = vim.api.nvim_create_augroup('format-on-save', { clear = true }),
  callback = function(ev)
    require('conform').format { bufnr = ev.buf, lsp_format = 'fallback', timeout_ms = 2000 }
  end,
})

--------------------------------------------------------------------------------
-- Package management helpers
--------------------------------------------------------------------------------
local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.api.nvim_create_user_command('PackInstall', function()
  -- Re-run vim.pack.add() to install any missing plugins
  vim.cmd 'source $MYVIMRC'
  vim.notify('Plugins installed', vim.log.levels.INFO)
end, { desc = 'Install missing plugins' })

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  -- Update all or specific plugins
  if opts.args ~= '' then
    vim.cmd('packupdate ' .. opts.args)
  else
    vim.cmd 'packupdate'
  end
end, { nargs = '*', desc = 'Update plugins' })

vim.api.nvim_create_user_command('PackDelete', function(opts)
  if opts.args ~= '' then
    -- Delete specific plugin
    vim.cmd('packdel ' .. opts.args)
  else
    -- Delete all inactive/unused plugins
    vim.cmd 'packdel ++all'
  end
end, { nargs = '*', desc = 'Delete unused plugins (or specific plugin)' })

vim.api.nvim_create_user_command('PackStatus', function()
  -- Show current plugin status
  local plugins = vim.pack.get()
  local lines = { 'Installed plugins:' }
  for _, p in ipairs(plugins) do
    table.insert(lines, string.format('  %s (%s)', p.name, p.rev or 'unknown'))
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, { desc = 'Show plugin status' })

--------------------------------------------------------------------------------
-- Plugin hooks (for build steps)
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    -- Build treesitter parsers after install/update
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      vim.cmd 'TSUpdate'
    end
  end,
})

--------------------------------------------------------------------------------
-- Plugins (vim.pack - Neovim 0.12 built-in)
--------------------------------------------------------------------------------
vim.pack.add {
  -- Snacks: picker, lazygit, notifier, indent, etc.
  gh 'folke/snacks.nvim',

  -- Mini: statusline, tabline, surround
  gh 'echasnovski/mini.nvim',

  -- Colorscheme
  gh 'catppuccin/nvim',

  -- Treesitter
  gh 'nvim-treesitter/nvim-treesitter',

  -- Completion
  gh 'saghen/blink.cmp',
  gh 'L3MON4D3/LuaSnip',

  -- Formatting
  gh 'stevearc/conform.nvim',

  -- Flash: jump/motion
  gh 'folke/flash.nvim',

  -- Which-key
  gh 'folke/which-key.nvim',

  -- Yazi: file manager
  gh 'mikavilpas/yazi.nvim',
  gh 'nvim-lua/plenary.nvim',

  -- Git signs
  gh 'lewis6991/gitsigns.nvim',

  -- Lazydev: Lua LSP enhancements
  gh 'folke/lazydev.nvim',

  -- Schemastore for JSON/YAML
  gh 'b0o/schemastore.nvim',

  -- LSP configs (provides default cmd, filetypes, root_dir for servers)
  gh 'neovim/nvim-lspconfig',
}

--------------------------------------------------------------------------------
-- Plugin configurations
--------------------------------------------------------------------------------

-- Colorscheme
require('catppuccin').setup { flavour = 'mocha' }
vim.cmd.colorscheme 'catppuccin'

-- Snacks
require('snacks').setup {
  bigfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  -- Disabled
  bufdelete = { enabled = false },
  dashboard = { enabled = false },
  debug = { enabled = false },
  gh = { enabled = false },
  git = { enabled = false },
  gitbrowse = { enabled = false },
  profiler = { enabled = false },
  rename = { enabled = false },
  scratch = { enabled = false },
  win = { enabled = false },
  zen = { enabled = false },
}

-- Snacks keymaps (Helix space-mode pickers)
vim.keymap.set('n', '<leader>f', function()
  Snacks.picker.files()
end, { desc = 'File picker' })
vim.keymap.set('n', '<leader>F', function()
  Snacks.picker.files { cwd = vim.fn.getcwd() }
end, { desc = 'File picker (cwd)' })
vim.keymap.set('n', '<leader>b', function()
  Snacks.picker.buffers()
end, { desc = 'Buffer picker' })
vim.keymap.set('n', '<leader>j', function()
  Snacks.picker.jumps()
end, { desc = 'Jumplist picker' })
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.grep()
end, { desc = 'Global search' })
vim.keymap.set('n', '<leader>d', function()
  Snacks.picker.diagnostics()
end, { desc = 'Diagnostics picker' })
vim.keymap.set('n', "<leader>'", function()
  Snacks.picker.resume()
end, { desc = 'Resume picker' })
vim.keymap.set('n', '<leader>?', function()
  Snacks.picker.help()
end, { desc = 'Help picker' })
vim.keymap.set('n', '<leader>:', function()
  Snacks.picker.command_history()
end, { desc = 'Command history' })
vim.keymap.set('n', '<leader>K', function()
  Snacks.picker.keymaps()
end, { desc = 'Keymaps' })
vim.keymap.set({ 'n', 'x' }, '<leader>w', function()
  Snacks.picker.grep_word()
end, { desc = 'Search word' })

-- Git
vim.keymap.set('n', '<leader>g', function()
  Snacks.picker.git_status()
end, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

-- LSP pickers
vim.keymap.set('n', '<leader>s', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>S', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'Workspace symbols' })

-- Other
vim.keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification history' })
vim.keymap.set('n', '<c-/>', function()
  Snacks.terminal()
end, { desc = 'Toggle terminal' })
vim.keymap.set({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next reference' })
vim.keymap.set({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Prev reference' })

-- Toggles (via VeryLazy pattern)
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tl'
    Snacks.toggle.diagnostics():map '<leader>td'
    Snacks.toggle.inlay_hints():map '<leader>th'
    Snacks.toggle.indent():map '<leader>ti'
  end,
})

-- Mini
require('mini.pairs').setup()
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

-- Treesitter
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
  'graphql',
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

-- Completion (blink.cmp)
require('blink.cmp').setup {
  keymap = {
    preset = 'enter',
    ['<Tab>'] = {},
    ['<S-Tab>'] = {},
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev' },
    providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

-- LuaSnip
require('luasnip').setup {}

-- Formatting (conform)
require('conform').setup {
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    go = { 'gofumpt', 'gofmt', stop_after_first = true },
    typescript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    json = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    css = { 'biome-check', 'prettierd', 'prettier', stop_after_first = true },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
  },
}

-- Flash
require('flash').setup { modes = { char = { enabled = false } } }
vim.keymap.set({ 'n', 'x', 'o' }, 'gw', function()
  require('flash').jump()
end, { desc = 'flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'gW', function()
  require('flash').treesitter()
end, { desc = 'Flash treesitter' })

-- Which-key
require('which-key').setup {
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
    { '<leader>t', group = 'Toggle' },
    { '<leader>g', group = 'Git' },
  },
}

-- Yazi
require('yazi').setup {
  open_for_directories = false,
  keymaps = { show_help = '<f1>' },
  highlight_hovered_buffers_in_same_directory = false,
}
vim.g.loaded_netrwPlugin = 1
vim.keymap.set({ 'n', 'v' }, '<leader>e', '<cmd>Yazi<cr>', { desc = 'Yazi (current file)' })
vim.keymap.set('n', '<leader>E', '<cmd>Yazi cwd<cr>', { desc = 'Yazi (cwd)' })

-- Git signs
require('gitsigns').setup {
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
}

-- Lazydev (Lua LSP enhancements)
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

--------------------------------------------------------------------------------
-- LSP Configuration
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Helix-style goto keymaps
    map('gd', function()
      Snacks.picker.lsp_definitions()
    end, 'Go to definition')
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('gr', function()
      Snacks.picker.lsp_references()
    end, 'Go to references')
    map('gi', function()
      Snacks.picker.lsp_implementations()
    end, 'Go to implementation')
    map('gy', function()
      Snacks.picker.lsp_type_definitions()
    end, 'Go to type definition')

    -- Helix space-mode LSP keymaps
    map('<leader>r', vim.lsp.buf.rename, 'Rename symbol')
    map('<leader>a', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
    map('K', function()
      vim.lsp.buf.hover {
        border = 'single',
        max_height = 25,
        max_width = 120,
      }
    end, 'Hover docs')

    -- Highlight references on hover
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(ev)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = ev.buf }
        end,
      })
    end
  end,
})

-- Diagnostics config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = { source = 'if_many', spacing = 2, current_line = false },
  virtual_lines = { current_line = true },
}

-- LSP server configurations
local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
  gopls = {},
  ts_ls = {
    init_options = {
      hostInfo = 'neovim',
      preferences = {
        importModuleSpecifier = 'non-relative',
        importModuleSpecifierPreference = 'non-relative',
      },
    },
    -- -- for vtsls
    -- settings = {
    --   typescript = {
    --     preferences = {
    --       importModuleSpecifier = 'non-relative',
    --     },
    --   },
    --   javascript = {
    --     preferences = {
    --       importModuleSpecifier = 'non-relative',
    --     },
    --   },
    -- },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = { enable = true, url = 'https://www.schemastore.org/api/json/catalog.json' },
        validate = true,
      },
    },
  },
  jsonls = {
    on_new_config = function(config)
      config.settings.json.schemas = config.settings.json.schemas or {}
      vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
    end,
    settings = { json = { validate = { enable = true } } },
  },
  cssls = {},
  lua_ls = {
    settings = {
      Lua = { completion = { callSnippet = 'Replace' } },
    },
  },
  graphql = {},
  biome = {},
}

for server_name, server_opts in pairs(servers) do
  server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
  vim.lsp.config(server_name, server_opts)
  vim.lsp.enable(server_name)
end
