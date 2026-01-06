local M = require("lsp.utils")

local bin_ext = M.get_bin_ext()
local bin_path = M.get_bin_path()
local path = bin_path .. "postgres-language-server" .. bin_ext

---@type vim.lsp.Config
return {
  cmd = { path, 'lsp-proxy' },
  filetypes = {
    'sql',
  },
  root_markers = { 'postgres-language-server.jsonc' }
  -- workspace_required = true,
}
