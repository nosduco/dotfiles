local m = require("monitors")

-- monitors
local laptop = { output = m.main, mode = "highrr", position = "0x0", scale = 1.066667 }
hl.monitor(laptop)

-- workspaces
hl.workspace_rule({ workspace = "1", monitor = m.main, persistent = true, default = true })
hl.workspace_rule({ workspace = "2", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = m.main, persistent = true })

-- keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"))

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
  hl.exec_cmd("gammastep -l 56.6:14.3")
  hl.exec_cmd("libinput-gestures-setup start")
  hl.timer(function()
    hl.exec_cmd("nm-applet --indicator")
  end, { timeout = 1000, type = "oneshot" })
end)
