-- ~/.config/nvim/lua/bufferfloat.lua
local M = {}
local api = vim.api
local buf, win

-- Función para cerrar la ventana flotante
local function close_window()
  if win and api.nvim_win_is_valid(win) then
    api.nvim_win_close(win, true)
  end
  if buf and api.nvim_buf_is_valid(buf) then
    api.nvim_buf_delete(buf, { force = true })
  end
  buf = nil
  win = nil
end

-- Función para obtener el nombre corto del buffer
local function get_buffer_name(bufnr)
  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[Empty]"
  end
  return vim.fn.fnamemodify(name, ":~:.")
end

-- Función para obtener el icono según el tipo de archivo
local function get_filetype_icon(bufnr)
  local ft = vim.bo[bufnr].filetype
  local icons = {
    lua = "",
    python = "",
    javascript = "",
    typescript = "",
    html = "",
    css = "",
    json = "",
    markdown = "",
    vim = "",
    sh = "",
    git = "",
    text = "",
  }
  return icons[ft] or ""
end

-- Función para listar buffers
local function list_buffers()
  local buffers = { }
  local buffer_list = api.nvim_list_bufs()

  for _, bufnr in ipairs(buffer_list) do
    if api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local modified = vim.bo[bufnr].modified and " [+]" or ""
      local icon = get_filetype_icon(bufnr)
      local name = get_buffer_name(bufnr)
      local current = bufnr == api.nvim_get_current_buf() and " " or "  "

      table.insert(buffers, {
        bufnr = bufnr,
        display = string.format("%s%s %s%s", current, icon, name, modified)
      })
    end
  end

  return buffers
end

-- Función para actualizar el contenido de la ventana
local function update_view()
  if not buf or not api.nvim_buf_is_valid(buf) then
    return
  end

  local buffers = list_buffers()
  local lines = {}

  if #buffers == 0 then
    table.insert(lines, "  No Active Buffers")
  else
    for _, buffer_info in ipairs(buffers) do
      table.insert(lines, buffer_info.display)
    end
  end

  api.nvim_buf_set_option(buf, "modifiable", true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, "modifiable", false)

  -- Guardar referencia de buffers para mappings
  vim.b[buf].buffer_list = buffers
end

-- Función para obtener el buffer en la línea actual
local function get_buffer_at_cursor()
  local line = api.nvim_win_get_cursor(win)[1]
  local buffers = vim.b[buf].buffer_list or {}

  -- Ajustar por las líneas de encabezado
  local index = line

  if index >= 1 and index <= #buffers then
    return buffers[index].bufnr
  end
  return nil
end

-- Función para abrir buffer seleccionado
local function open_buffer()
  local bufnr = get_buffer_at_cursor()
  if bufnr then
    close_window()
    api.nvim_set_current_buf(bufnr)
  end
end

-- Función para cerrar buffer seleccionado
local function delete_buffer()
  local bufnr = get_buffer_at_cursor()
  if bufnr then
    local ok = pcall(api.nvim_buf_delete, bufnr, { force = false })
    if ok then
      update_view()
    else
      vim.notify("Buffer has unsave changes. Use :bdelete! to force it", vim.log.levels.WARN)
    end
  end
end

-- Función para crear la ventana flotante
local function create_window()
  -- Dimensiones de la ventana
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)

  -- Posición centrada
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Crear buffer
  buf = api.nvim_create_buf(false, true)

  -- Configurar opciones del buffer
  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "filetype", "bufferfloat")

  -- Opciones de la ventana flotante
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Buffer Manager ",
    title_pos = "center",
    footer = " <CR>: Open | d: Close | q: Quit ",
    footer_pos = "center"
  }

  -- Crear ventana flotante
  win = api.nvim_open_win(buf, true, opts)

  -- Configurar opciones de la ventana
  api.nvim_win_set_option(win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")
  api.nvim_win_set_option(win, "cursorline", true)

  -- Configurar mappings
  local keymaps = {
    ["q"] = close_window,
    ["<Esc>"] = close_window,
    ["<CR>"] = open_buffer,
    ["d"] = delete_buffer,
    ["<C-r>"] = update_view,
  }

  for key, func in pairs(keymaps) do
    api.nvim_buf_set_keymap(buf, "n", key, "", {
      nowait = true,
      noremap = true,
      silent = true,
      callback = func
    })
  end

  update_view()

  -- Mover cursor a la primera línea de buffers
  api.nvim_win_set_cursor(win, {1, 0})
end

-- Función principal para toggle la ventana
function M.toggle()
  if win and api.nvim_win_is_valid(win) then
    close_window()
  else
    create_window()
  end
end

return M
