return function(use)
  -- Claude Code IDE integration
  use {
    'coder/claudecode.nvim',
    config = function() require('claudecode').setup() end,
  }
end
