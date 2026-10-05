-- No hard wrapping in markdown: let lines be as long as the paragraph
vim.opt_local.textwidth = 0
vim.opt_local.formatoptions:remove('t')

-- Soft wrap instead: display long lines on several screen lines
vim.opt_local.wrap = true
vim.opt_local.linebreak = true    -- wrap at word boundaries, not mid-word
vim.opt_local.breakindent = true  -- wrapped part keeps the list/quote indentation

-- Move by screen line when no count is given, so 5j still works with relativenumber
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { buffer = true, expr = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { buffer = true, expr = true })
