-- Keybinds. Every bind carries a description; scripts/KeyBinds.sh lists them.
local apps = require("config.apps")
local toggles = require("lib.toggles")
local dropdown = require("lib.dropdown")
local keyboard = require("lib.keyboard")

local mod = "SUPER"
local function bind(keys, action, description, flags)
  flags = flags or {}
  flags.description = description
  hl.bind(keys, action, flags)
end
local function exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end
local function script(name, args)
  return exec(apps.script(name) .. (args and " " .. args or ""))
end

-- Apps
bind(mod .. " + Return", exec(apps.terminal), "Terminal")
bind(mod .. " + SHIFT + Return", function()
  dropdown.toggle(apps.terminal)
end, "Dropdown terminal")
bind(mod .. " + E", exec(apps.files), "File manager")
bind(mod .. " + B", exec('xdg-open "https://"'), "Browser")
bind(mod .. " + D", exec(apps.menu), "App launcher")
bind(mod .. " + S", script("RofiSearch.sh"), "Web search")
bind(mod .. " + ALT + E", script("RofiEmoji.sh"), "Emoji picker")
bind(mod .. " + ALT + C", exec(apps.user_script("RofiCalc.sh")), "Calculator")
bind(mod .. " + ALT + V", script("ClipManager.sh"), "Clipboard history")
bind(mod .. " + SHIFT + M", exec(apps.user_script("RofiBeats.sh")), "Online radio")
bind(mod .. " + H", script("KeyBinds.sh"), "Search keybinds")
bind(mod .. " + SHIFT + K", script("KeyBinds.sh"), "Search keybinds")
bind(mod .. " + SHIFT + P", exec([[sh -c '"$HOME/bin/proofread-fr" "$(wl-paste)" | wl-copy && notify-send -u low "Copied proofread version!"']]), "Proofread clipboard")

-- Session
bind("CTRL + ALT + Delete", hl.dsp.exit(), "Exit Hyprland")
bind("CTRL + ALT + L", script("LockScreen.sh"), "Lock screen")
bind("CTRL + ALT + P", script("Wlogout.sh"), "Power menu")
bind(mod .. " + SHIFT + N", exec("swaync-client -t -sw"), "Notification panel")
bind(mod .. " + ALT + R", script("Refresh.sh"), "Restart waybar and swaync")
bind(mod .. " + CTRL + ALT + B", exec("pkill -SIGUSR1 waybar"), "Toggle waybar")

-- Toggles
bind(mod .. " + ALT + O", toggles.blur, "Toggle blur strength")
bind(mod .. " + SHIFT + G", toggles.gamemode, "Toggle game mode")
bind(mod .. " + ALT + L", toggles.layout, "Toggle dwindle/master layout")
bind(mod .. " + CTRL + O", toggles.opaque, "Toggle window opacity")
bind(mod .. " + ALT + mouse_down", toggles.zoom(2), "Zoom in")
bind(mod .. " + ALT + mouse_up", toggles.zoom(0.5), "Zoom out")
bind("ALT_L + SHIFT_L", keyboard.cycle, "Next keyboard layout", { locked = true, non_consuming = true })
bind("SHIFT_L + ALT_L", keyboard.cycle_window, "Next keyboard layout (this window)", { locked = true, non_consuming = true })

-- Windows
bind(mod .. " + Q", hl.dsp.window.close(), "Close window")
bind(mod .. " + SHIFT + Q", hl.dsp.window.kill(), "Kill window process")
bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen(), "Fullscreen")
bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized" }), "Maximize")
bind(mod .. " + SPACE", hl.dsp.window.float(), "Toggle floating")
bind(mod .. " + P", hl.dsp.window.pseudo(), "Pseudo-tile")
bind(mod .. " + G", hl.dsp.group.toggle(), "Toggle group")
bind(mod .. " + CTRL + Tab", hl.dsp.group.next(), "Next window in group")
bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.bring_to_top())
end, "Cycle windows")
bind(mod .. " + J", toggles.cycle("next"), "Next window")
bind(mod .. " + K", toggles.cycle("prev"), "Previous window")
bind(mod .. " + I", hl.dsp.layout("addmaster"), "Add master")
bind(mod .. " + CTRL + D", hl.dsp.layout("removemaster"), "Remove master")
bind(mod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"), "Swap with master")
bind(mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"), "Toggle split")
bind(mod .. " + M", hl.dsp.layout("splitratio 0.3"), "Split ratio 0.3")
bind(mod .. " + mouse:272", hl.dsp.window.drag(), "Move window", { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })

local directions = { left = "left", right = "right", up = "up", down = "down" }
local resize = { left = { -50, 0 }, right = { 50, 0 }, up = { 0, -50 }, down = { 0, 50 } }
for key, dir in pairs(directions) do
  bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }), "Focus " .. dir)
  bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = dir }), "Move window " .. dir)
  bind(mod .. " + ALT + " .. key, hl.dsp.window.swap({ direction = dir }), "Swap window " .. dir)
  bind(mod .. " + SHIFT + " .. key, hl.dsp.window.resize({ x = resize[key][1], y = resize[key][2], relative = true }), "Resize " .. dir, { repeating = true })
end

-- Workspaces
for i = 1, 10 do
  local key = "code:" .. (9 + i) -- number row, layout independent
  bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }), "Workspace " .. i)
  bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move window to workspace " .. i)
  bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }), "Send window to workspace " .. i)
end
bind(mod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }), "Next workspace")
bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), "Previous workspace")
bind(mod .. " + period", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + comma", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(mod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }), "Move window to previous workspace")
bind(mod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }), "Move window to next workspace")
bind(mod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }), "Send window to previous workspace")
bind(mod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }), "Send window to next workspace")
bind(mod .. " + U", hl.dsp.workspace.toggle_special(), "Toggle scratchpad")
bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }), "Move window to scratchpad")
local monitors = { F9 = "l", F10 = "r", F11 = "u", F12 = "d" }
for key, dir in pairs(monitors) do
  bind(mod .. " + CTRL + " .. key, hl.dsp.workspace.move({ monitor = dir }), "Move workspace to monitor " .. dir)
end

-- Screenshots
local shots = {
  { "Print", "--now", "Screenshot" },
  { "SHIFT + Print", "--area", "Screenshot area" },
  { "CTRL + Print", "--in5", "Screenshot in 5s" },
  { "CTRL + SHIFT + Print", "--in10", "Screenshot in 10s" },
  { "SHIFT + S", "--swappy", "Screenshot area, edit" },
}
for _, s in ipairs(shots) do
  bind(mod .. " + " .. s[1], script("ScreenShot.sh", s[2]), s[3])
end
bind("ALT + Print", script("ScreenShot.sh", "--active"), "Screenshot window")

-- Media and hardware keys
local locked = { locked = true }
local held = { locked = true, repeating = true }
bind("XF86AudioRaiseVolume", script("Volume.sh", "--inc"), "Volume up", held)
bind("XF86AudioLowerVolume", script("Volume.sh", "--dec"), "Volume down", held)
bind("XF86AudioMute", script("Volume.sh", "--toggle"), "Mute", locked)
bind("XF86AudioMicMute", script("Volume.sh", "--toggle-mic"), "Mute mic", locked)
bind("XF86AudioPause", script("MediaCtrl.sh", "--pause"), "Play/pause", locked)
bind("XF86AudioPlay", script("MediaCtrl.sh", "--pause"), "Play/pause", locked)
bind("XF86AudioNext", script("MediaCtrl.sh", "--nxt"), "Next track", locked)
bind("XF86AudioPrev", script("MediaCtrl.sh", "--prv"), "Previous track", locked)
bind("XF86AudioStop", script("MediaCtrl.sh", "--stop"), "Stop", locked)
bind("XF86MonBrightnessUp", script("Brightness.sh", "--inc"), "Brightness up", { repeating = true })
bind("XF86MonBrightnessDown", script("Brightness.sh", "--dec"), "Brightness down", { repeating = true })
bind("XF86KbdBrightnessUp", script("BrightnessKbd.sh", "--inc"), "Keyboard backlight up", { repeating = true })
bind("XF86KbdBrightnessDown", script("BrightnessKbd.sh", "--dec"), "Keyboard backlight down", { repeating = true })
bind("XF86TouchpadToggle", toggles.touchpad, "Toggle touchpad")
bind("XF86Sleep", exec("systemctl suspend"), "Suspend", locked)
bind("XF86RFKill", script("AirplaneMode.sh"), "Airplane mode", locked)
