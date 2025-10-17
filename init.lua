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
require("mappings.buffermap")

-- vim.api.nvim_set_hl(0, "NormalFloat", {
--   fg = "none",
--   bg = "none",
-- })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1d2021" })  -- fondo hard de gruvbox
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1d2021", fg = "#1d2021" })

-- Erease the search history
opt.shada = ""

-- Buffers line
opt.termguicolors = true
require("bufferline").setup{}


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



require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}



require("config.bufferline")
require("config.lualine")
