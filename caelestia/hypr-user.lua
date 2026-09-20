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

-- Swipe only between workspaces that exist. Hyprland destroys a workspace once
-- its last window goes, and the swipe walks the monitor's open workspaces
-- (m+1/m-1), so empty ones are skipped already -- except the one at the end,
-- which create_new conjures on every overswipe. caelestia's gestures.lua turns
-- that on; this is the only key of its gestures block being changed.
hl.config({
  gestures = {
    workspace_swipe_create_new = false,
  },
})

-- Volume keys, with the change made audible. caelestia's keybinds.lua changes
-- the level silently; volume-step (users/riad/home.nix) does the same wpctl
-- call and then plays the freedesktop volume-change sound, but only when the
-- level actually moved -- at the ceiling wpctl clamps to a no-op and a blip
-- would claim a change the OSD correctly does not show.
--
-- Rebound rather than added to, since a second bind on a key would fire
-- alongside caelestia's and step the volume twice. volumeMax and volumeStep
-- are passed in so hypr-vars.lua stays the one place they are set: require
-- returns the table hyprland.lua has already merged the overrides into.
local vars = require("variables")
local volOpts = { locked = true, repeating = true }

hl.unbind("XF86AudioRaiseVolume")
hl.unbind("XF86AudioLowerVolume")

hl.bind("XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("volume-step up " .. (vars.volumeMax / 100) .. " " .. vars.volumeStep), volOpts)
hl.bind("XF86AudioLowerVolume",
  hl.dsp.exec_cmd("volume-step down " .. (vars.volumeMax / 100) .. " " .. vars.volumeStep), volOpts)

-- Mute goes through the same script so unmuting sounds and muting does not.
hl.unbind("XF86AudioMute")
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume-step mute"), { locked = true })

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

-- KeePassXC floats: it is reached for mid-task, from whatever is already on
-- screen, and tiling it would reshuffle the windows being worked in. Matching
-- the class alone covers the unlock prompt and the browser-access dialog too,
-- which are the ones that most want to be in the middle.
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, float = true })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, center = true })

-- FreeCAD, in the spirit of caelestia's fusion360 rule: a CAD viewport is
-- unreadable through the shell's transparency and blur, and the splash screen
-- (titled just "FreeCAD", before the versioned main window appears) otherwise
-- takes a tile of its own.
hl.window_rule({ match = { class = "org.freecad.FreeCAD" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "org.freecad.FreeCAD" }, no_blur = true })
hl.window_rule({
  match = { class = "org.freecad.FreeCAD", title = "^FreeCAD$" },
  float = true,
  center = true,
  -- A splash is meant to be undecorated; floating it would otherwise hand it
  -- the shell's border, rounding and shadow.
  border_size = 0,
  rounding = 0,
  no_shadow = true,
})

-- Session services (caelestia's execs.lua starts the shell and cliphist).
-- Hyprland runs under uwsm (the SDDM default), which imports the env into
-- systemd and activates graphical-session.target: portals and user services
-- hang off that.
hl.on("hyprland.start", function()
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("shikane")
  -- KeePassXC: the browser extension talks to the running process over a
  -- socket, so it has to be up for autofill to work at all. It starts hidden
  -- in the tray with the database locked (MinimizeOnStartup, MinimizeToTray
  -- and ShowTrayIcon in keepassxc.ini, which is app state and not in here),
  -- so the password is asked for on the first click, not at every login.
  --
  -- keepassxc-tray, not keepassxc: Qt registers the tray icon once and never
  -- retries, so starting before caelestia's bar owns the
  -- StatusNotifierWatcher leaves it running with no icon -- indistinguishable
  -- from not having started. The wrapper waits for the bus name first.
  hl.exec_cmd("keepassxc-tray")
  -- First login on a machine: pick a wallpaper (and scheme) from ~/Pictures/Wallpapers.
  hl.exec_cmd("test -e ~/.local/state/caelestia/wallpaper/path.txt || caelestia wallpaper -r")
end)

-- nwg-displays writes ~/.config/hypr/monitors.lua
pcall(require, "monitors")
