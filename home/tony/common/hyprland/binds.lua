local mod = "SUPER"

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"), { description = "Terminal" })
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mod .. " + M", hl.dsp.exec_cmd("walker -m menus:power"), { description = "Power menu" })
hl.bind(mod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"), { description = "Lock" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd("EDITOR=vim ghostty -e yazi"), { description = "Files (yazi)" })
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm app -- nautilus"), { description = "Files (nautilus)" })
hl.bind(mod .. " + B", hl.dsp.exec_cmd("ghostty -e btop"), { description = "btop" })
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("walker"), { description = "Launcher" })
hl.bind(mod .. " + slash", hl.dsp.exec_cmd("keybinds"), { description = "Keybinds" })

-- layout
hl.bind(mod .. " + F", hl.dsp.window.float(), { description = "Float window" })
hl.bind(mod .. " + U", hl.dsp.window.fullscreen(), { description = "Fullscreen" })
hl.bind(mod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudotile" })
hl.bind(mod .. " + O", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mod .. " + ESCAPE", function()
  local win = hl.get_active_window()
  if not win then
    return
  end
  if win.pinned then
    hl.dispatch(hl.dsp.window.pin({ action = "unset" }))
    hl.dispatch(hl.dsp.window.float({ action = "unset" }))
  else
    hl.dispatch(hl.dsp.window.float({ action = "set" }))
    hl.dispatch(hl.dsp.window.resize({ x = 1280, y = 720 }))
    hl.dispatch(hl.dsp.window.move({ direction = "r" }))
    hl.dispatch(hl.dsp.window.move({ direction = "u" }))
    hl.dispatch(hl.dsp.window.pin({ action = "set" }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
  end
end, { description = "Pop window out" })

-- media
local osd = require("osd").run
hl.bind("XF86AudioRaiseVolume", osd("--output-volume raise"), { repeating = true, locked = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", osd("--output-volume lower"), { repeating = true, locked = true, description = "Volume down" })
hl.bind("XF86AudioMute", osd("--output-volume mute-toggle"), { locked = true, description = "Mute" })
hl.bind("XF86AudioMicMute", osd("--input-volume mute-toggle"), { locked = true, description = "Mute mic" })
hl.bind("XF86AudioPlay", osd("--playerctl play-pause"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioPause", osd("--playerctl play-pause"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioNext", osd("--playerctl next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", osd("--playerctl prev"), { locked = true, description = "Previous track" })

-- screenshots
hl.bind(mod .. " + S", hl.dsp.exec_cmd("grimblast --freeze copy area"), { description = "Screenshot area to clipboard" })
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot"), { description = "Screenshot area and edit" })
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("screenshot active"), { description = "Screenshot window and edit" })
hl.bind(mod .. " + SHIFT + I", hl.dsp.exec_cmd("grimblast copy output"), { description = "Screenshot monitor to clipboard" })
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Color picker" })
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd("scan text"), { description = "Copy text from screen (OCR)" })
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("scan qr"), { description = "Copy QR code from screen" })
hl.bind(mod .. " + N", hl.dsp.exec_cmd("systemctl --user restart hyprpaper"), { description = "Next wallpaper" })

-- recording
hl.bind(mod .. " + R", hl.dsp.exec_cmd("record"), { description = "Start/stop recording" })
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("record replay"), { description = "Replay on/off" })
hl.bind(mod .. " + CTRL + R", hl.dsp.exec_cmd("record save"), { description = "Save last 60s replay" })

-- dictation
local dictating = false
hl.bind(mod .. " + V", function()
  dictating = true
  hl.exec_cmd("voxtype record start")
end, { description = "Dictate (hold)" })
hl.bind(mod .. " + V", function()
  if dictating then
    dictating = false
    hl.exec_cmd("voxtype record stop")
  end
end, { release = true, ignore_mods = true, transparent = true, non_consuming = true })
hl.define_submap("voxtype_suppress", function()
  for _, key in ipairs({ "Super_L", "Super_R", "Control_L", "Control_R", "Alt_L", "Alt_R", "Shift_L", "Shift_R" }) do
    hl.bind(key, hl.dsp.no_op())
  end
  hl.bind("F12", hl.dsp.submap("reset"))
end)

-- focus
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- move
hl.bind("CTRL + SHIFT + h", hl.dsp.window.move({ direction = "l", group_aware = true }), { description = "Move window left" })
hl.bind("CTRL + SHIFT + l", hl.dsp.window.move({ direction = "r", group_aware = true }), { description = "Move window right" })
hl.bind("CTRL + SHIFT + k", hl.dsp.window.move({ direction = "u", group_aware = true }), { description = "Move window up" })
hl.bind("CTRL + SHIFT + j", hl.dsp.window.move({ direction = "d", group_aware = true }), { description = "Move window down" })

-- groups
hl.bind(mod .. " + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(mod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Move window out of group" })
hl.bind(mod .. " + Tab", hl.dsp.group.next(), { description = "Next tab in group" })
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.group.prev(), { description = "Previous tab in group" })

-- resize
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true, description = "Shrink width" })
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true, description = "Grow width" })
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true, description = "Shrink height" })
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true, description = "Grow height" })

-- workspaces
for i = 1, 4 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- notifications
hl.bind(mod .. " + D", hl.dsp.exec_cmd("dunstctl history-pop"), { description = "Show last notification" })
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("dunstctl close-all"), { description = "Clear notifications" })
