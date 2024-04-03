return {
  'stevearc/conform.nvim',
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        -- Use a sub-list to run only the first available formatter
        javascript = { { "biome", "prettierd", "prettier" } },
        typescript = { { "biome", "prettierd", "prettier" } },
        typescriptreact = { { "biome", "prettierd", "prettier" } },
        javascriptreact = { { "biome", "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        
        go = { "gofmt" }
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      }
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end
}
