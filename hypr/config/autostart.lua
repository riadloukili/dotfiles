-- Session services and tray apps, started once per session.
local apps = require("config.apps")

hl.on("hyprland.start", function()
  hl.exec_cmd("awww-daemon --format argb && awww img " .. apps.wallpaper)
  hl.exec_cmd("shikane")
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE"
      .. " && systemctl --user start hyprland-session.target"
  )
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("swaync")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("waybar")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("hypridle")
end)
