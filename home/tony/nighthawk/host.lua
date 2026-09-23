local m = require("monitors")

-- monitors
hl.monitor({ output = m.main, mode = "highrr", position = "0x0", scale = 1 })
hl.monitor({ output = m.right, mode = "preferred", position = "-2160x-1100", scale = 1, transform = 3 })
hl.monitor({ output = m.top, mode = "highrr", position = "0x-1440", scale = 1 })

-- workspaces
hl.workspace_rule({ workspace = "name:1", monitor = m.main, persistent = true, default = true })
hl.workspace_rule({ workspace = "name:2", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "name:3", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "name:4", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "name:right-monitor", monitor = m.right, persistent = true, default = true })
hl.workspace_rule({ workspace = "name:top-monitor", monitor = m.top, persistent = true, default = true })

-- windows
hl.window_rule({ match = { class = "^(vesktop)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { class = "^(claude-desktop)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { class = "^(Element)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { title = "^(Google Meet)" }, tile = true, monitor = m.right })
hl.window_rule({ match = { title = "^(Spotify)" }, workspace = "top-monitor silent" })
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "top-monitor silent" })

-- autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("gammastep -l 39.962:-82.996")
  hl.timer(function()
    hl.exec_cmd(os.getenv("HOME") .. "/.dotfiles/scripts/nighthawk-layout.sh")
  end, { timeout = 3000, type = "oneshot" })
  hl.timer(function()
    hl.exec_cmd("streamcontroller -b")
    hl.exec_cmd("xrandr --output " .. m.main .. " --primary")
  end, { timeout = 5000, type = "oneshot" })
end)
