local local_config = require('local-config')

local config = {
  journal_dir = local_config.notes.journal_path,
}


function journal_today()
  local date_str = os.date('%F')
  local file_name = date_str .. '.md'

  vim.cmd('e ' .. config.journal_dir .. file_name .. ' | w')
end


vim.cmd [[
  command! -buffer JournalToday lua journal_today()
]]
