-- ~/.config/nvim/lua/bufferfloat.lua
local M = {}
local api = vim.api
local buf, win

-- Function to close floating window
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

-- Function to get short buffer name
local function get_buffer_name(bufnr)
  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then
    return "[Empty]"
  end
  return vim.fn.fnamemodify(name, ":~:.")
end

-- Function to get icon by filetype
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

-- Function to list buffers
local function list_buffers()
  local buffers = {}
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

-- Function to update window content
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

  -- Save buffer reference for mappings
  vim.b[buf].buffer_list = buffers
end

-- Function to get buffer at cursor
local function get_buffer_at_cursor()
  local line = api.nvim_win_get_cursor(win)[1]
  local buffers = vim.b[buf].buffer_list or {}

  if line >= 1 and line <= #buffers then
    return buffers[line].bufnr
  end
  return nil
end

-- Function to open selected buffer
local function open_buffer()
  local bufnr = get_buffer_at_cursor()
  if bufnr then
    close_window()
    api.nvim_set_current_buf(bufnr)
  end
end

-- Function to delete selected buffer
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

-- Function to create floating window
local function create_window()
  -- Window dimensions (same as nvim-tree)
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local width = math.floor(screen_w * 0.6)
  local height = math.floor(screen_h * 0.7)

  -- Centered position (same as nvim-tree)
  local row = ((vim.opt.lines:get() - height) / 2) - vim.opt.cmdheight:get()
  local col = (screen_w - width) / 2

  -- Configure highlights before creating window
  vim.api.nvim_set_hl(0, "BufferFloatNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferFloatBorder", { bg = "", fg = "NONE" })

  -- Create buffer
  buf = api.nvim_create_buf(false, true)

  -- Configure buffer options
  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "filetype", "bufferfloat")

  -- Floating window options
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

  -- Create floating window
  win = api.nvim_open_win(buf, true, opts)

  -- Configure window options with custom highlights
  api.nvim_win_set_option(win, "winhl", "Normal:BufferFloatNormal,FloatBorder:BufferFloatBorder")
  api.nvim_win_set_option(win, "cursorline", true)

  -- Configure mappings
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

  -- Move cursor to first buffer line
  api.nvim_win_set_cursor(win, {1, 0})
end

-- Main function to toggle window
function M.toggle()
  if win and api.nvim_win_is_valid(win) then
    close_window()
  else
    create_window()
  end
end

-- Configurar atajos de teclado
local function setup_keymaps()
  -- Buffer Manager
  vim.keymap.set("n", "<Tab>", function()
    M.toggle()
  end, { desc = "Toggle buffer manager flotante" })

  -- New Buffer
  vim.keymap.set('n', '<leader>bn', ':enew<CR>', { desc = 'Nuevo buffer' })

  -- Delete Current Buffer
  vim.keymap.set('n', '<leader>bx', ':bdelete<CR>', { desc = 'Cerrar buffer actual' })
end


setup_keymaps()

return M
