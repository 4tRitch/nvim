-- Cargar el módulo
local ritchline = require("ownp.ritchline")

-- Crear un mapping para abrir/cerrar la ventana flotante
-- Por ejemplo, con <leader>b
vim.keymap.set("n", "<Tab>", function()
  ritchline.toggle()
end, { desc = "Toggle buffer manager flotante" })

