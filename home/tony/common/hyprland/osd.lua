-- osd
local M = {}

function M.run(arg)
  return function()
    local target = M.monitor and (" --monitor " .. M.monitor) or ""
    hl.exec_cmd("swayosd-client" .. target .. " " .. arg)
  end
end

return M
