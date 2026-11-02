-- ~/.config/nvim/lua/toc.lua
-- Markdown table of contents in a Telescope popup.
-- Load it from init.vim (inside the lua << EOF block) with:
--     require('toc').setup()

local M = {} -- the module table: everything we put in M is "exported"

-- 1. Scan the buffer and return a list of { lnum, level, title } tables.
--    Only ATX headings (#, ##, ...) are detected, and lines inside fenced
--    code blocks are skipped so that "# comment" in a bash block is ignored.
local function collect_headings(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- 0-based, end-exclusive, -1 = last
  local headings = {}
  local in_code = false

  for lnum, line in ipairs(lines) do -- ipairs gives 1-based indexes = real line numbers
    if line:match('^%s*```') or line:match('^%s*~~~') then
      in_code = not in_code
    elseif not in_code then
      -- Lua patterns (not regex): ^ anchor, (#+) capture 1+ '#', %s+ spaces, (.-) lazy capture
      local hashes, title = line:match('^(#+)%s+(.-)%s*#*%s*$')
      if hashes and #hashes <= 6 then -- #str is the length operator
        table.insert(headings, { lnum = lnum, level = #hashes, title = title })
      end
    end
  end

  return headings
end

-- 2. Open the picker.
function M.open()
  local pickers      = require('telescope.pickers')
  local finders      = require('telescope.finders')
  local conf         = require('telescope.config').values
  local actions      = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local themes       = require('telescope.themes')

  local bufnr = vim.api.nvim_get_current_buf()
  local headings = collect_headings(bufnr)

  if #headings == 0 then
    vim.notify('Toc: no headings in this buffer', vim.log.levels.INFO)
    return
  end

  -- pickers.new(opts, defaults): opts (here the dropdown theme) override defaults
  pickers.new(themes.get_dropdown({ winblend = 10 }), {
    prompt_title = 'Table of Contents',

    -- FINDER: produces the entries. new_table turns a Lua list into entries.
    finder = finders.new_table({
      results = headings,
      entry_maker = function(h)
        return {
          value   = h,                                          -- the raw data, kept for later
          display = string.rep('  ', h.level - 1) .. h.title,   -- what you SEE (indented)
          ordinal = h.title,                                    -- what the SORTER matches against
          lnum    = h.lnum,
        }
      end,
    }),

    -- SORTER: fuzzy-scores each entry's ordinal against what you type.
    sorter = conf.generic_sorter({}),

    -- ACTIONS: what happens on <CR>. We replace the default "open file" action.
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr) -- focus goes back to the original window
        if not entry then return end
        vim.api.nvim_win_set_cursor(0, { entry.lnum, 0 }) -- {row (1-based), col (0-based)}
        vim.cmd('normal! zvzt') -- zv: open folds around cursor, zt: scroll line to top
      end)
      return true -- true = keep all the other default mappings (<C-n>, <C-p>, <Esc>...)
    end,
  }):find() -- :find() actually opens the UI
end

-- 3. Register :Toc as a BUFFER-LOCAL command in every markdown buffer.
function M.setup()
  local group = vim.api.nvim_create_augroup('PaulToc', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'markdown',
    callback = function(args)
      -- vim.schedule defers this until the current event is fully handled,
      -- so we run AFTER vim-markdown's ftplugin has defined its own :Toc.
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(args.buf) then return end
        vim.api.nvim_buf_create_user_command(args.buf, 'Toc', M.open, {
          desc = 'Markdown TOC in a Telescope popup',
        })
      end)
    end,
  })
end

return M -- this table is what require('toc') gives back
