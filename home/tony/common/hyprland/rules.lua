-- windows
hl.window_rule({ match = { title = "^(waybar)" }, float = true, border_size = 0 })
hl.window_rule({ match = { title = "^(FileChooser)" }, float = true, size = "60% 70%", center = true })
hl.window_rule({ match = { title = "^(Obsidian)" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^()$" }, stay_focused = true, min_size = { 1, 1 } })
hl.window_rule({ match = { class = "^(spotify)$" }, tile = true })

-- layers
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "walker" }, blur = true })
