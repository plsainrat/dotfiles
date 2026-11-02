require('obsidian-tasks').setup({})
require('obsidian').setup({
  workspaces = {
    { name = 'notes', path = '/home/pasainrat/vaults/notes-perso/work-notes' },
  },
  legacy_commands = false,
  ui = { enable = false },          -- render-markdown handles the display

  daily_notes = {
    folder = 'Dailies',             -- relative to the vault root
    date_format = '%Y-%m-%d',
    alias_format = '%A %d %B %Y',
    default_tags = { 'daily-notes' },
    workdays_only = true,
    template = nil,
  },
})
