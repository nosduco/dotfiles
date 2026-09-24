local m = require("monitors")

-- monitors
local laptop = { output = m.main, mode = "highrr", position = "0x0", scale = 1.066667 }
hl.monitor(laptop)

-- workspaces
hl.workspace_rule({ workspace = "1", monitor = m.main, persistent = true, default = true })
hl.workspace_rule({ workspace = "2", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = m.main, persistent = true })

-- brightness
local function osd(arg)
  return hl.dsp.exec_cmd("swayosd-client " .. arg)
end
hl.bind("XF86MonBrightnessUp", osd("--brightness raise"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", osd("--brightness lower"), { repeating = true, locked = true })

-- lid
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { locked = true })
hl.bind("switch:on:Lid Switch", function()
  hl.monitor({ output = m.main, disabled = true })
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
  hl.monitor(laptop)
end, { locked = true })

-- autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("libinput-gestures-setup start")
  hl.timer(function()
    hl.exec_cmd("uwsm app -- obsidian")
  end, { timeout = 5000, type = "oneshot" })
  hl.timer(function()
    hl.exec_cmd("nm-applet --indicator")
  end, { timeout = 1000, type = "oneshot" })
end)
