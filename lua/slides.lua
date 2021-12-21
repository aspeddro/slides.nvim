local M = {}

local state = {
  win = nil
}

local config = {
  bin = 'slides',
  fullscreen = false
}

function M.close()
  if state.win ~= nil then
    vim.api.nvim_win_close(state.win, true)
  end
end

function M.setup(user_config)
  config = vim.tbl_deep_extend('force', {}, config, user_config or {})

  vim.cmd [[command! -nargs=? -complete=file Slides :lua require"slides".show('<f-args>')]]
end

function M.show(file)

  -- local col = vim.api.nvim_get_option('columns')
  -- local lin = vim.api.nvim_get_option('lines')

  local pos = vim.api.nvim_win_get_position(0)
  local line = pos[1]
  local col = pos[2]

  local opts = {
    style = 'minimal',
    relative = 'win',
    focusable = true,
    width = vim.api.nvim_win_get_width(0),
    height = vim.api.nvim_win_get_height(0),
    row = 0,
    col = 0,
    border = 'none',
    zindex = 400
  }

  local is_file = type(file) == 'string' and file:len() > 0
  local filetype = is_file and vim.fn.fnamemodify(file, ':e'):gsub('\"', '') or vim.api.nvim_buf_get_option(0, 'filetype')

  local input = is_file and file:gsub('\"', '') or vim.api.nvim_buf_get_name(0)

  if not vim.tbl_contains({'md', 'markdown'}, filetype) then
    vim.api.nvim_err_writeln('Invalid filetype')
    return
  end

  if vim.fn.executable(config.bin) ~= 1 then
    vim.api.nvim_err_writeln('Executable not found')
    return
  end


  local bufnr = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(bufnr, true, opts)

  local winnr = vim.api.nvim_get_current_win()
  -- vim.api.nvim_replace_termcodes(str: string, from_part: boolean, do_lt: boolean, special: boolean)
  if not config.fullscreen then
    -- local win = vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
    -- vim.api.nvim_win_set_option(winnr, 'number', false)
    -- vim.api.nvim_win_set_option(winnr, 'relativenumber', false)
  end

  state.win = win

  vim.cmd [[augroup slides]]
  vim.cmd [[autocmd!]]
  -- vim.cmd [[autocmd BufWinEnter,WinEnter,BufEnter term://* startinsert!]]
  vim.cmd(string.format('autocmd BufEnter <buffer=%d> startinsert', bufnr))
  vim.cmd [[augroup END]]

  vim.fn.termopen(config.bin .. ' ' .. input, {
    on_exit = function()
      M.close()
    end
  })
  vim.cmd('startinsert!')
end

return M
