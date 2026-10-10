-- Claude Code keymaps (<leader>a is taken by treesitter swap)
local map = vim.keymap.set
map('n', '<leader>ic', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
map('n', '<leader>if', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
map('n', '<leader>ib', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add buffer to Claude' })
map('v', '<leader>is', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send selection to Claude' })
map('n', '<leader>ia', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept Claude diff' })
map('n', '<leader>id', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Reject Claude diff' })

-- Let <Esc> reach Claude instead of leaving terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*claude*',
  callback = function(ev)
    vim.keymap.set('t', '<Esc>', '<Esc>', { buffer = ev.buf, noremap = true })
  end,
})

-- Reload buffers that Claude changed on disk
vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'FocusGained' }, {
  command = 'silent! checktime',
})
