--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "catppuccin"
-- to disable icons and use a minimalist setup, uncomment the following
lvim.use_icons = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = false
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false


-- Some keymaps rebinding
lvim.keys.normal_mode["<C-Left>"] = "<C-w>h"
lvim.keys.normal_mode["<C-Right>"] = "<C-w>l"
lvim.keys.normal_mode["<C-Up>"] = "<C-w>k"
lvim.keys.normal_mode["<C-Down>"] = "<C-w>j"
lvim.keys.normal_mode["<C-H>"] = ":vertical resize +2<CR>"
lvim.keys.normal_mode["<C-L>"] = ":vertical resize -2<CR>"
lvim.keys.normal_mode["<C-K>"] = ":resize -2<CR>"
lvim.keys.normal_mode["<C-J>"] = ":resize +2<CR>"

local function filepath()
  return vim.fn.expand("%")
end
-- Add location to LUALine
lvim.builtin.lualine.sections.lualine_c = { filepath }

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "go",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "yaml",
}

lvim.builtin.treesitter.highlight.enable = true

lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<c-space>',
    node_incremental = '<c-space>',
    scope_incremental = '<c-s>',
    node_decremental = '<c-backspace>',
  },
}

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "sumneko_lua",
  "jsonls",
  "tsserver",
  "gopls",
}

-- ---@usage disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- [[ Custom typescript handling - using typescript.nvim for better ts support instead of builtin lsp config ]]
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })


-- set formatters, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html", "css", "json", "scss",
      "markdown" },
  }
}

-- set additional code actions sources (besides language server)
local ca = require "lvim.lsp.null-ls.code_actions"
ca.setup {
  {
    command = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }
  }
}

vim.list_extend(lvim.builtin.cmp.sources, { name = "nvim_lsp_signature_help" })

-- Additional Plugins
lvim.plugins = {
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  -- improved typescript support with file renaming etc
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      require("typescript").setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = false,            -- enable debug logging for commands
        go_to_source_definition = {
          fallback = true,        -- fall back to standard LSP definition on failure
        },
        server = {                -- pass options to lspconfig's setup method
          on_attach = require("lvim.lsp").common_on_attach
        },
      })
      -- add custom code actions provided by the Typescript plugin
      require("null-ls").setup({
        sources = {
          require("typescript.extensions.null-ls.code-actions"),
        }
      })
    end
  },
  { "catppuccin/nvim",                    as = "catppuccin" }
}
