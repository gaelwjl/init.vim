local buffer_number = -1
-- fzf's window height is 3/4 of the max height, but not more than 30
--   -- get the editor's max width and height
local width = vim.api.nvim_get_option("columns")
local height = vim.api.nvim_get_option("lines")
local win_height = math.min(math.ceil(height * 3 / 4), 30)
local win_width

-- if the width is small
if (width < 150) then
  -- just subtract 8 from the editor's width
  win_width = math.ceil(width - 8)
else
  -- use 90% of the editor's width
  win_width = math.ceil(width * 0.9)
end

local window_opts = {
  relative = "editor",
  width = win_width,
  height = win_height,
  row = math.ceil((height - win_height) / 2),
  col = math.ceil((width - win_width) / 2)
}

local function log(_, data)
  if (buffer_number == -1) then
    buffer_number = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buffer_number, 'buftype', 'nofile')
  end
  if data then
    vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)
  end
end


vim.api.nvim_create_user_command(
  'CompileRun',
  function()
    local file_path = vim.api.nvim_buf_get_name(0)
    local relative_filepath = vim.fn.expand("%:h")
    local file_name = file_path:match("^.+/(.+)$"):gsub("%..+$", "") -- get the file name without extension
    -- Construct the Bazel target name using the file name
    local target_name = relative_filepath..":" .. file_name

    -- Construct the Bazel command to run the target
    local bazel_cmd = "bazel run " .. target_name .. " < input.txt"
    print("running command: " .. bazel_cmd)
    vim.fn.jobstart(bazel_cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = log,
      on_stderr = log,
    })
    vim.api.nvim_open_win(buffer_number, true,
      window_opts)
  end, {}
)

-- run the command :CompileRun
vim.keymap.set('n', '<leader>cr', ':CompileRun<CR>')
