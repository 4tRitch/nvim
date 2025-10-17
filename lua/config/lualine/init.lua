local lineconf = require("config.lualine.conf")
local api = vim.api

require('lualine').setup(lineconf.get_config())

-- AutoCmds para cambiar la config según el buffer activo
api.nvim_create_autocmd("BufEnter", {
  pattern = "NvimTree_*",
  callback = function()
    require('lualine').setup(lineconf.get_nvtree_config())
  end
})

api.nvim_create_autocmd("BufLeave", {
  pattern = "NvimTree_*",
  callback = function()
    require('lualine').setup(lineconf.get_config())
  end
})
