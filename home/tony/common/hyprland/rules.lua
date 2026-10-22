-- windows
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { title = "^(waybar)" }, float = true, border_size = 0 })
hl.window_rule({ match = { title = "^(FileChooser)" }, float = true, size = { "(monitor_w*0.6)", "(monitor_h*0.7)" }, center = true })
hl.window_rule({ match = { title = "^(wiremix|bluetui)$" }, float = true, size = { 800, 600 }, center = true })
hl.window_rule({ match = { title = "^(Obsidian)" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^()$" }, stay_focused = true, min_size = { 1, 1 } })
hl.window_rule({ match = { class = "^(steam_app_[0-9]+)$" }, idle_inhibit = "focus" })
hl.window_rule({ match = { class = "^(spotify)$" }, tile = true })
hl.window_rule({ match = { title = "^(Picture.?in.?[Pp]icture)$" }, float = true, pin = true, size = { 600, 338 }, keep_aspect_ratio = true, move = { "(monitor_w-640)", "(monitor_h*0.04)" } })

-- layers
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "walker" }, blur = true })
