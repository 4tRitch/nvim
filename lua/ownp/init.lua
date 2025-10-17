-- Cargar el módulo
local ritchline = require("ownp.ritchline")

-- Buffer Manager
vim.keymap.set("n", "<Tab>", function()
  ritchline.toggle()
end, { desc = "Toggle buffer manager flotante" })

-- New Buffer
vim.keymap.set('n', '<leader>bn', ':enew<CR>', { desc = 'Nuevo buffer' })


-- Delete Current Buffer
vim.keymap.set('n', '<leader>bx', ':bdelete<CR>', { desc = 'Cerrar buffer actual' })
