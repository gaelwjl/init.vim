vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local api = vim.api

-- toggle file browser extensions
-- api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fb",
-- 	":Telescope file_browser<CR>",
-- 	{ noremap = true })
-- open file_browser with the path of the current buffer
-- api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>fb",
-- 	":telescope file_browser path=%:p:h select_buffer=true<CR>",
-- 	{ noremap = true }
-- )

------ file search and find in project command mappings ------
-- map Ctrl-q (terminals don't recognize ctrl-tab) (recent files) to show all
-- files in the buffer
-- Ctrl-I maps to tab
-- But it destroys the C-i mapping in vim. Which is used to kind of go in and
-- used in conjunction with C-o.
-- map ctrlp to open file search
-- go to next buffer
api.nvim_set_keymap("n", "gn", ":bn<cr>", { noremap = true })
-- go to previous buffer
api.nvim_set_keymap("n", "gp", ":bp<cr>", { noremap = true })

-- Better Esc
api.nvim_set_keymap("i", "jk", "<esc>", { noremap = true })
api.nvim_set_keymap("c", "jk", "<esc>", { noremap = true })
api.nvim_set_keymap("v", "jk", "<esc>", { noremap = true })

-- run the command :CompileRun
api.nvim_set_keymap('n', '<leader>cr', ':CompileRun<CR>', { noremap = true })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<leader>t', ':terminal<CR>', { noremap = true })

api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- To use ALT +{h,j,k,l} to navigate windows from any mode:
api.nvim_set_keymap('t', '˙', "<C-\\><C-N><C-w>h", { noremap = true })
api.nvim_set_keymap('t', '∆', "<C-\\><C-N><C-w>j", { noremap = true })
api.nvim_set_keymap('t', '¬', "<C-\\><C-N><C-w>l", { noremap = true })
api.nvim_set_keymap('t', '˚', "<C-\\><C-N><C-w>k", { noremap = true })
--
api.nvim_set_keymap('i', '˙', "<C-\\><C-N><C-w>h", { noremap = true })
api.nvim_set_keymap('i', '∆', "<C-\\><C-N><C-w>j", { noremap = true })
api.nvim_set_keymap('i', '¬', "<C-\\><C-N><C-w>l", { noremap = true })
api.nvim_set_keymap('i', '˚', "<C-\\><C-N><C-w>k", { noremap = true })
--
api.nvim_set_keymap('n', '˙', "<C-w>h", { noremap = true })
api.nvim_set_keymap('n', '∆', "<C-w>j", { noremap = true })
api.nvim_set_keymap('n', '¬', "<C-w>l", { noremap = true })
api.nvim_set_keymap('n', '˚', "<C-w>k", { noremap = true })

api.nvim_set_keymap('n', '§', ':Vista!!<CR>', { noremap = true })
