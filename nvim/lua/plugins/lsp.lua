local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>a', vim.lsp.buf.code_action, 'code [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ld', vim.diagnostic.open_float, 'Show [L]ine [D]iagnostics')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  if client.server_capabilities.documentFormattingProvider then
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    -- auto format on save
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    config = function ()

      local lsp = require('lspconfig')
      lsp["gopls"].setup {
        on_attach = on_attach,
        root_dir = lsp.util.root_pattern('.git', 'src/go.mod', 'go.mod'),
      }
      lsp["denols"].setup {
        on_attach = on_attach,
        root_dir = lsp.util.root_pattern("deno.json", "deno.jsonc"),
      }
      lsp["lua_ls"].setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      local lsp = require("lspconfig")
      require("typescript").setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = false, -- enable debug logging for commands
        go_to_source_definition = {
          fallback = true, -- fall back to standard LSP definition on failure
        },
        server = { -- pass options to lspconfig's setup method
          on_attach = function (client, bufnr)
            client.server_capabilities.documentFormattingProvider = false

            on_attach(client, bufnr)
          end,
          root_dir = lsp.util.root_pattern("package.json"),
          single_file_support = false,
        },
      })
    end
  }
}



