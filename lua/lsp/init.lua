-- Global Configuration of diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  severity_sort = true,
  signs = false,
})

-- Load each configuration of LSP

-- Not Use
-- require("lsp.csharp")
-- require("lsp.pws")
-- require("lsp.go")

-- In Use
-- require("lsp.lua_lsp")
-- require("lsp.psql")

-- Web
-- require("lsp.ts")
-- require("lsp.svlt")
-- require("lsp.html")
-- require("lsp.css")


-- C/CPP
-- require("lsp.cpp")
require("lsp.clang")
-- require("lsp.cmake")


-- Start each LSP

-- Not Use
-- vim.lsp.enable("csharp_ls")
-- vim.lsp.enable("powershell_es")
-- vim.lsp.enable("gopls")


-- In Use
-- vim.lsp.enable("postgres_lsp")
vim.lsp.enable("clangd")


--Web
-- vim.lsp.enable("ts_ls")
-- vim.lsp.enable("html")
-- vim.lsp.enable("cssls")
-- vim.lsp.enable("svelte")







-- lua print(vim.inspect(vim.lsp.get_clients()))



