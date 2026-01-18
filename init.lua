-- Replace empty lines in the rendering
vim.opt.fillchars = { eob = " " }

-- Variables
local opt = vim.opt
local opt_local = vim.opt_local
local api = vim.api
local indent = vim.o

-- Config
require("config.lazy")

-- Mappings
require("mappings.genmap")
require("mappings.lspmap")
require("mappings.treemap")
require("mappings.telemap")

-- Erease the search history
opt.shada = ""

--Indentation Config
indent.expandtab = true   -- expand tab input with spaces characters
indent.smartindent = true -- syntax aware indentations for newline inserts
indent.tabstop = 2        -- num of space characters per tab
indent.shiftwidth = 2     -- spaces per indentation level

api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    opt_local.shiftwidth = 2
    opt_local.tabstop = 2
    opt_local.softtabstop = 2
    opt_local.expandtab = true
  end,
})



-- Copy to Clipboard
api.nvim_set_option("clipboard","unnamed")



-- Treesitter Config
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}



-- Own Implementations
require("config.lualine")
require("ownp")



