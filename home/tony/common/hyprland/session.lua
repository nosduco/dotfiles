-- session
local M = {}

function M.start(steps, opts)
  opts = opts or {}
  local timeout = opts.timeout or 15000
  local opened = {}
  local i = 0
  local gen = 0
  local sub

  local function next_step()
    i = i + 1
    gen = gen + 1
    local s = steps[i]
    if not s then
      if sub then
        sub:remove()
      end
      if opts.done then
        opts.done()
      end
      return
    end
    if s.workspace then
      hl.dispatch(hl.dsp.focus({ workspace = s.workspace }))
    end
    if s.focus and opened[s.focus] then
      hl.dispatch(hl.dsp.focus({ window = opened[s.focus] }))
    end
    if s.preselect then
      hl.dispatch(hl.dsp.layout("preselect " .. s.preselect))
    end
    hl.exec_cmd("uwsm app -- " .. s.cmd)
    if not s.class then
      next_step()
      return
    end
    local mine = gen
    hl.timer(function()
      if gen == mine then
        next_step()
      end
    end, { timeout = timeout, type = "oneshot" })
  end

  sub = hl.on("window.open", function(w)
    local s = steps[i]
    if not s or w.class ~= s.class or opened[s.class] then
      return
    end
    opened[s.class] = w
    if s.ratio then
      hl.dispatch(hl.dsp.focus({ window = w }))
      hl.dispatch(hl.dsp.layout("splitratio " .. s.ratio .. " exact"))
    end
    next_step()
  end)

  next_step()
end

return M
