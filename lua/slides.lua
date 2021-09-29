local M = {}

local state = {
  win = nil
}

local config = {
  bin = 'slides',
  fullscreen = true
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

  local window = vim.api.nvim_get_current_win()

  local opts = {
    style = "minimal",
    relative = "editor",
    width = config.fullscreen and vim.api.nvim_get_option("columns") or vim.api.nvim_win_get_width(window),
    height = config.fullscreen and vim.api.nvim_get_option("lines") or vim.api.nvim_win_get_height(window),
    row = 1,
    col = 1,
    border = "shadow",
  }

  local input = string.len(file) == 0 and vim.api.nvim_get_current_buf() or file
  local is_file = type(input) == 'string'
  local filetype = is_file and vim.fn.fnamemodify(input, ':e'):gsub("\"", "") or vim.api.nvim_buf_get_option(input, 'filetype')

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

  state.win = win

  vim.cmd('startinsert!')

  vim.fn.termopen(config.bin .. ' ' .. (is_file and input or vim.api.nvim_buf_get_name(input)), {
    on_exit = function()
      M.close()
    end
  })

end

return M
