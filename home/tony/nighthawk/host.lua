local m = require("monitors")
local session = require("session")

-- monitors
hl.monitor({ output = m.main, mode = "highrr", position = "0x0", scale = 1 })
hl.monitor({ output = m.right, mode = "preferred", position = "-2160x-1100", scale = 1, transform = 3 })
hl.monitor({ output = m.top, mode = "highrr", position = "0x-1440", scale = 1 })

-- osd
require("osd").monitor = m.main

-- workspaces
hl.workspace_rule({ workspace = "1", monitor = m.main, persistent = true, default = true })
hl.workspace_rule({ workspace = "2", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = m.main, persistent = true })
hl.workspace_rule({ workspace = "name:right-monitor", monitor = m.right, persistent = true, default = true })
hl.workspace_rule({ workspace = "name:top-monitor", monitor = m.top, persistent = true, default = true })

-- windows
hl.window_rule({ match = { class = "^(vesktop)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { class = "^(com.anthropic.Claude)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { class = "^(slack)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { title = "^(Google Meet)" }, tile = true, monitor = m.right })
hl.window_rule({ match = { title = "^(Spotify)" }, workspace = "top-monitor silent" })
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "top-monitor silent" })
hl.window_rule({ match = { class = "^(io.github.alainm23.planify|org.gnome.Calendar)$" }, workspace = "top-monitor silent" })

-- autostart
hl.on("hyprland.start", function()
  session.start({
    { workspace = "name:right-monitor", cmd = "vesktop", class = "vesktop" },
    { focus = "vesktop", preselect = "d", cmd = "ghostty -e btop", class = "com.mitchellh.ghostty", ratio = 1.38 },
    { focus = "vesktop", preselect = "d", cmd = "claude-desktop", class = "com.anthropic.Claude" },
    { focus = "vesktop", group = true, cmd = "slack", class = "slack" },
    { workspace = 1, cmd = "firefox", class = "firefox" },
    { focus = "firefox", preselect = "r", cmd = "obsidian", class = "md.obsidian.Obsidian", ratio = 1.333 },
    { workspace = "name:top-monitor", cmd = "spotify", class = "spotify" },
    { focus = "spotify", preselect = "r", cmd = "io.github.alainm23.planify", class = "io.github.alainm23.planify" },
    { focus = "io.github.alainm23.planify", preselect = "d", cmd = "gnome-calendar", class = "org.gnome.Calendar" },
  }, {
    done = function()
      hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    end,
  })
  hl.timer(function()
    hl.exec_cmd("streamcontroller -b")
    hl.exec_cmd("xrandr --output " .. m.main .. " --primary")
  end, { timeout = 5000, type = "oneshot" })
end)
