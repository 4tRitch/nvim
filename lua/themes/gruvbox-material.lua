return{
  'sainnhe/gruvbox-material',
  lazy = false,
config = function()
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_transparent_background = 1  -- Agregar esta línea
    vim.cmd.colorscheme('gruvbox-material')
  end
}
