-- :CompileRun (mapped to <leader>cr in remap.lua)
-- Saves, compiles if needed, and runs the current file in a bottom terminal split.
-- If an input.txt exists in the file's directory or any parent, it is piped to stdin.

local build_dir = vim.fn.stdpath('cache') .. '/compilerun'
local term_buf = nil

local function q(s) return vim.fn.shellescape(s) end

-- Shell command that builds and/or runs `file`, or nil if the filetype is unsupported
local function run_cmd(file, stdin)
  local name = vim.fn.fnamemodify(file, ':t:r')
  local bin = build_dir .. '/' .. name
  local ft = vim.bo.filetype

  if ft == 'cpp' then
    return ('/usr/bin/clang++ -std=c++20 -O2 -Wall -o %s %s && %s%s'):format(q(bin), q(file), q(bin), stdin)
  elseif ft == 'c' then
    return ('/usr/bin/clang -O2 -Wall -o %s %s && %s%s'):format(q(bin), q(file), q(bin), stdin)
  elseif ft == 'python' then
    -- Prefer a project .venv if there is one
    local venv = vim.fs.find('.venv', { upward = true, type = 'directory', path = vim.fs.dirname(file) })[1]
    local py = venv and (venv .. '/bin/python') or 'python3'
    return ('%s %s%s'):format(q(py), q(file), stdin)
  elseif ft == 'go' then
    return ('go run %s%s'):format(q(file), stdin)
  elseif ft == 'haskell' then
    return ('ghc -O2 -v0 -outputdir %s -o %s %s && %s%s'):format(
      q(build_dir .. '/hs'), q(bin), q(file), q(bin), stdin)
  elseif ft == 'rust' then
    local cargo = vim.fs.find('Cargo.toml', { upward = true, path = vim.fs.dirname(file) })[1]
    if cargo then
      local in_bin = file:find('/src/bin/', 1, true) and (' --bin ' .. q(name)) or ''
      return ('cargo run -q --release --manifest-path %s%s%s'):format(q(cargo), in_bin, stdin)
    end
    return ('rustc -O -o %s %s && %s%s'):format(q(bin), q(file), q(bin), stdin)
  elseif ft == 'scala' then
    return ('scala run -q %s%s'):format(q(file), stdin)
  end
end

vim.api.nvim_create_user_command('CompileRun', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('CompileRun: buffer has no file', vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then vim.cmd('silent write') end
  vim.fn.mkdir(build_dir, 'p')

  local input = vim.fs.find('input.txt', { upward = true, path = vim.fs.dirname(file) })[1]
  local cmd = run_cmd(file, input and (' < ' .. q(input)) or '')
  if not cmd then
    vim.notify('CompileRun: unsupported filetype "' .. vim.bo.filetype .. '"', vim.log.levels.WARN)
    return
  end

  -- Reuse a single output split: drop the previous run's terminal
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_buf_delete(term_buf, { force = true })
  end

  vim.cmd('botright 15split | enew')
  term_buf = vim.api.nvim_get_current_buf()
  vim.bo[term_buf].bufhidden = 'wipe'
  vim.fn.jobstart(cmd, { term = true, cwd = vim.fs.dirname(file) })

  if input then
    vim.cmd('wincmd p') -- input is piped: stay in the code window
  else
    vim.cmd('startinsert') -- no input.txt: type stdin interactively
  end
end, { desc = 'Compile and run the current file' })
