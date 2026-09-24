local function later(ms, cmd)
  hl.timer(function()
    hl.exec_cmd(cmd)
  end, { timeout = ms, type = "oneshot" })
end

hl.on("hyprland.start", function()
  hl.dispatch(hl.dsp.focus({ workspace = 1 }))
  later(5000, "uwsm app -- /opt/KopiaUI/kopia-ui")
end)
