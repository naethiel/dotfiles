-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      require("formatter.filetypes.lua").stylua,
     },
    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },
    typescriptreact = {
      require("formatter.filetypes.typescript").prettier,
    },
    javascript = {
      require("formatter.filetypes.typescript").prettier,
    },
    javascriptreact = {
      require("formatter.filetypes.typescript").prettier,
    },
    css = {
      require("formatter.defaults.prettier"),
    },
    scss = {
      require("formatter.defaults.prettier"),
    },
    html = {
      require("formatter.defaults.prettier"),
    },
    json = {
      require("formatter.defaults.prettier"),
    },
    go = {
      require("formatter.filetypes.go").gofmt,
      require("formatter.filetypes.go").goimports,
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
    }
  }
}

-- Automatically source and re-compile packer whenever you save this init.lua
local fmt = vim.api.nvim_create_augroup('fmt', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'FormatWrite',
  group = fmt,
  pattern = "*",
})

