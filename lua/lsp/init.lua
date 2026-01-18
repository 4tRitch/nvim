-- Global Configuration of diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  severity_sort = true,
  signs = false,
})

-- Load each configuration of LSP

-- Golang
-- local golang = require("lsp.go")
-- vim.lsp.config('gopls', golang)
-- vim.lsp.enable("gopls")

-- Lua
-- local lua = require("lsp.lua_lsp")
-- vim.lsp.config('', lua)
-- vim.lsp.enable("")

-- CSharp
-- local cs = require("lsp.csharp")
-- vim.lsp.config('csharp_ls', cs)
-- vim.lsp.enable("csharp_ls")

-- Powershell
-- local pws = require("lsp.pws")
-- vim.lsp.config('powershell_es', pws)
-- vim.lsp.enable("powershell_es")


-- Lua
-- require("lsp.lua_lsp")
-- vim.lsp.config('postgres_lsp', psql)
-- vim.lsp.enable("postgres_lsp")


-- Postgres
-- local psql = require("lsp.psql")
-- vim.lsp.config('postgres_lsp', psql)
-- vim.lsp.enable("postgres_lsp")


-- Web
-- local ts = require("lsp.ts")
-- local html = require("lsp.html")
-- local css = require("lsp.css")
-- local svlt = require("lsp.svlt")
--
-- vim.lsp.config('ts_ls', ts)
-- vim.lsp.config('html', html)
-- vim.lsp.config('cssls', css)
-- vim.lsp.config('svelte', svlt)
--
-- vim.lsp.enable("ts_ls")
-- vim.lsp.enable("html")
-- vim.lsp.enable("cssls")
-- vim.lsp.enable("svelte")


-- C/CPP
-- local clangd = require("lsp.clangd")
-- vim.lsp.config('clangd', clangd)
-- vim.lsp.enable("clangd")


-- lua print(vim.inspect(vim.lsp.get_clients()))



