-- Configuración de Terminal Flotante para Neovim
-- Guarda este código en: ~/.config/nvim/lua/floating-terminal.lua
-- Y luego requiérelo en tu init.lua con: require('floating-terminal')

local M = {}
local api = vim.api
local buf

-- Configuración por defecto
M.config = {
  -- Shell a usar (se puede sobrescribir con setup)
  shell = nil,
  -- Dimensiones de la ventana (porcentaje)
  width_percent = 0.75,
  height_percent = 0.7,
  -- Estilo del borde
  border = "rounded",
}

-- Variables para mantener la ventana y buffer persistentes
local term_buf = nil
local term_win = nil

-- Detectar sistema operativo y configurar shell por defecto
local function detect_os_and_shell()
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local is_wsl = vim.fn.has("wsl") == 1

  if M.config.shell then
    return M.config.shell
  end

  if is_wsl then
    -- En WSL, preferir zsh si existe, sino bash
    if vim.fn.executable("zsh") == 1 then
      return "zsh"
    else
      return "bash"
    end
  elseif is_windows then
    -- En Windows, preferir PowerShell 7, luego PowerShell 5, luego cmd
    if vim.fn.executable("pwsh") == 1 then
      return "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      return "powershell"
    else
      return "cmd"
    end
  else
    -- En Unix/Linux/Mac, usar el shell por defecto del sistema
    return vim.o.shell
  end
end

-- Función para crear la ventana flotante
local function create_floating_window()
  -- Window dimensions (same as nvim-tree)
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local width = math.floor(screen_w * 0.75)
  local height = math.floor(screen_h * 0.7)

  -- Centered position (same as nvim-tree)
  local row = ((vim.opt.lines:get() - height) / 2) - vim.opt.cmdheight:get()
  local col = (screen_w - width) / 2

  -- Configure highlights before creating window
  vim.api.nvim_set_hl(0, "BufferFloatNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "BufferFloatBorder", { bg = "", fg = "NONE" })


  -- Configuración del borde (estilo similar a nvim-tree)
  local border_opts = {
    relative = "editor",
    style = "minimal",
    width = width,
    height = height,
    row = row,
    col = col,
    border = M.config.border
  }

  -- Crear el buffer si no existe
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true) -- No listed, scratch buffer
  end

  -- Crear la ventana flotante
  term_win = vim.api.nvim_open_win(term_buf, true, border_opts)

   -- Configurar opciones de la ventana con highlights personalizados
  api.nvim_win_set_option(term_win, "winhl", "Normal:BufferFloatNormal,FloatBorder:BufferFloatBorder")
  api.nvim_win_set_option(term_win, "cursorline", true)



  -- Configurar opciones de la ventana
  vim.api.nvim_win_set_option(term_win, 'winblend', 0)
  vim.api.nvim_win_set_option(term_win, 'number', false)
  vim.api.nvim_win_set_option(term_win, 'relativenumber', false)
  vim.api.nvim_win_set_option(term_win, 'cursorline', false)

  -- Si el buffer no tiene terminal, crearlo con el shell detectado
  if vim.fn.getbufvar(term_buf, '&buftype') ~= 'terminal' then
    local shell = detect_os_and_shell()
    vim.fn.termopen(shell)
  end



  -- Entrar automáticamente en modo insert/terminal
  vim.cmd('startinsert')
end

-- Función para toggle (mostrar/ocultar) la terminal
function M.toggle()
  -- Si la ventana existe y es válida, cerrarla
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
  else
    -- Si no existe, crearla
    create_floating_window()
  end
end

-- Función para cerrar permanentemente la terminal
function M.close()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  end
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_buf_delete(term_buf, { force = true })
    term_buf = nil
  end
end

-- Función para cambiar el shell de manera dinámica
function M.set_shell(shell)
  M.config.shell = shell
  -- Cerrar terminal actual si existe
  M.close()
  -- Mensaje de confirmación
  vim.notify("Shell cambiado a: " .. shell, vim.log.levels.INFO)
end

-- Función para abrir una nueva terminal con un shell específico
function M.open_with_shell(shell)
  -- Guardar shell actual
  local original_shell = M.config.shell
  -- Cambiar temporalmente el shell
  M.config.shell = shell
  -- Cerrar terminal actual
  M.close()
  -- Abrir con nuevo shell
  create_floating_window()
  -- Restaurar shell original para futuras aperturas
  M.config.shell = original_shell
end

-- Configurar atajos de teclado
local function setup_keymaps()
  -- Toggle terminal flotante con <leader>tf
  vim.keymap.set('n', '<leader>tt', M.toggle, { desc = 'Toggle Terminal Flotante' })

  -- En modo terminal, usar <Esc><Esc> para salir al modo normal
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Salir de modo terminal' })

  -- En modo terminal, usar <C-x> para ocultar (pero mantener activa)
  vim.keymap.set('t', '<leader>tt', function()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_hide(term_win)
      term_win = nil
    end
  end, { desc = 'Ocultar terminal flotante' })

end

-- Comandos de usuario para cambiar shell
local function setup_commands()
  -- Comando para cambiar el shell por defecto
  vim.api.nvim_create_user_command('TermSetShell', function(opts)
    M.set_shell(opts.args)
  end, {
    nargs = 1,
    desc = 'Establecer shell para terminal flotante',
    complete = function()
      return { 'pwsh', 'powershell', 'cmd', 'bash', 'zsh', 'fish', 'sh' }
    end
  })

  -- Comando para abrir terminal con shell específico (una vez)
  vim.api.nvim_create_user_command('TermOpen', function(opts)
    M.open_with_shell(opts.args)
  end, {
    nargs = 1,
    desc = 'Abrir terminal flotante con shell específico',
    complete = function()
      return { 'pwsh', 'powershell', 'cmd', 'bash', 'zsh', 'fish', 'sh' }
    end
  })
end

-- Función de setup para configurar el módulo
function M.setup(opts)
  opts = opts or {}

  -- Merge de configuración
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  -- Configurar keymaps y comandos
  setup_keymaps()
  setup_commands()

  -- Mostrar información del shell detectado
  local shell = detect_os_and_shell()
end


return M
