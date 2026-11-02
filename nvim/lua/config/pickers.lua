require('mini.pick').setup({
  mappings = {
    move_down = '<C-j>',
    move_up = '<C-k>',
  },
})
require('mini.extra').setup()

local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
})
