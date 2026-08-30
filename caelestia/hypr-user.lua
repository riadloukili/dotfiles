-- Loaded last by caelestia's ~/.config/hypr/hyprland.lua: everything of mine
-- that has no variable in hypr-vars.lua.
local dropdown = require("dropdown")

-- Input: two layouts, switched by XKB itself; touch screen and pen as they are.
hl.config({
  input = {
    kb_layout = "us,ca",
    kb_variant = ",multix",
    kb_options = "grp:alt_shift_toggle",
    numlock_by_default = true,
    touchpad = { tap_to_click = true },
    touchdevice = { enabled = true },
    tablet = { transform = 0 },
  },
})

-- Cursor (caelestia's env.lua sets XCURSOR_* from hypr-vars)
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

-- Binds
hl.bind("CTRL + ALT + Delete", hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind("SUPER + SHIFT + D", hl.dsp.global("caelestia:dashboard"), { description = "Dashboard" })
hl.bind("SUPER + SHIFT + Return", function()
  dropdown.toggle("kitty")
end, { description = "Dropdown terminal" })
for i = 1, 10 do
  hl.bind("CTRL + SUPER + " .. (i % 10), hl.dsp.window.move({ workspace = i, follow = false }), {
    description = "Send window to workspace " .. i,
  })
end

-- Session services (caelestia's execs.lua starts the shell and cliphist).
-- Hyprland runs under uwsm (the SDDM default), which imports the env into
-- systemd and activates graphical-session.target: portals and user services
-- hang off that.
hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("shikane")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")
  -- First login on a machine: pick a wallpaper (and scheme) from ~/Pictures/Wallpapers.
  hl.exec_cmd("test -e ~/.local/state/caelestia/wallpaper/path.txt || caelestia wallpaper -r")
end)

-- nwg-displays writes ~/.config/hypr/monitors.lua
pcall(require, "monitors")
