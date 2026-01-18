---@diagnostic disable: undefined-global
return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              bindingModeHints = { enable = true },
              chainingHints = { enable = true },
              -- closingBraceHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              -- lifetimeElisionHints = { enable = "always", useParameterNames = true },
              maxLength = 25,
              parameterHints = { enable = true },
              -- reborrowHints = { enable = "always" },
              typeHints = { enable = true },
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      },
    }

    -- 🔹 habilitar inlay hints automáticamente
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
      end,
    })
  end,
}
