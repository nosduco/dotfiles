local m = require("monitors")
local session = require("session")

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
hl.window_rule({ match = { class = "^(com.anthropic.Claude)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { class = "^(element)$" }, workspace = "right-monitor silent" })
hl.window_rule({ match = { title = "^(Google Meet)" }, tile = true, monitor = m.right })
hl.window_rule({ match = { title = "^(Spotify)" }, workspace = "top-monitor silent" })
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "top-monitor silent" })

-- media
local function osd(arg)
  return hl.dsp.exec_cmd("swayosd-client " .. arg)
end
hl.bind("XF86AudioRaiseVolume", osd("--output-volume raise --max-volume 100"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", osd("--output-volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", osd("--output-volume mute-toggle"), { locked = true })

-- autostart
hl.on("hyprland.start", function()
  session.start({
    { workspace = "name:right-monitor", cmd = "vesktop", class = "vesktop" },
    { focus = "vesktop", preselect = "d", cmd = "ghostty -e btop", class = "com.mitchellh.ghostty", ratio = 1.38 },
    { focus = "vesktop", preselect = "d", cmd = "claude-desktop", class = "com.anthropic.Claude" },
    { focus = "com.anthropic.Claude", preselect = "r", cmd = "element-desktop", class = "element" },
    { workspace = 1, cmd = "firefox", class = "firefox" },
    { focus = "firefox", preselect = "r", cmd = "obsidian", class = "md.obsidian.Obsidian", ratio = 1.02 },
    { focus = "md.obsidian.Obsidian", preselect = "r", cmd = "io.github.alainm23.planify", class = "io.github.alainm23.planify", ratio = 0.86 },
    { focus = "io.github.alainm23.planify", preselect = "d", cmd = "gnome-calendar", class = "org.gnome.Calendar" },
    { cmd = "spotify" },
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
