local mod = "SUPER"
local scripts = os.getenv("HOME") .. "/.dotfiles/scripts"
local monitors = require("monitors")

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("EDITOR=vim ghostty -e yazi"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm app -- nautilus"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("ghostty -e btop"))
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("walker"))

-- layout
hl.bind(mod .. " + F", hl.dsp.window.float())
hl.bind(mod .. " + U", hl.dsp.window.fullscreen())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + O", hl.dsp.layout("togglesplit"))

-- screenshots
hl.bind(mod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(scripts .. "/screenshot.sh window"))
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("grim -o " .. monitors.main .. " | wl-copy"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd(scripts .. "/next-wallpaper.sh"))

-- focus
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))

-- move
hl.bind("CTRL + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("CTRL + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("CTRL + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("CTRL + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- resize
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- workspaces
for i = 1, 4 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + ESCAPE", hl.dsp.workspace.toggle_special())
hl.bind(mod .. " + SHIFT + ESCAPE", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scripts .. "/change_volume.sh increase"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scripts .. "/change_volume.sh decrease"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scripts .. "/change_volume.sh mute"))

-- notifications
hl.bind(mod .. " + D", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("dunstctl close-all"))

-- vpn
hl.bind(mod .. " + V", hl.dsp.exec_cmd(scripts .. "/vpn/vpn-toggle.sh"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(scripts .. "/vpn/vpn-menu.sh"))

-- dictation
hl.bind(mod .. " + Y", hl.dsp.exec_cmd(scripts .. "/voxtype-ptt.sh start"), { description = "Dictation" })
hl.bind(mod .. " + Y", hl.dsp.exec_cmd(scripts .. "/voxtype-ptt.sh stop"), { release = true })
