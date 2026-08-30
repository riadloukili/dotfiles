-- Window and layer rules. Windows are tagged by class first, then rules
-- apply per tag; dynamic tags are matched with a trailing "*".
local function tag_classes(tag, patterns)
  for _, class in ipairs(patterns) do
    hl.window_rule({ match = { class = class }, tag = "+" .. tag })
  end
end

local function for_tag(tag, effects)
  local rule = { match = { tag = tag .. "*" } }
  for k, v in pairs(effects) do
    rule[k] = v
  end
  hl.window_rule(rule)
end

local function rule(match, effects)
  local r = { match = match }
  for k, v in pairs(effects) do
    r[k] = v
  end
  hl.window_rule(r)
end

local function pct(w, h)
  return { ("monitor_w*%s"):format(w), ("monitor_h*%s"):format(h) }
end

-- Tags
tag_classes("browser", {
  "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr|[Ff]irefox-bin)$",
  "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
  "^(chrome-.+-Default)$",
  "^([Cc]hromium)$",
  "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable))$",
  "^(Brave-browser(-beta|-dev|-unstable)?)$",
  "^([Tt]horium-browser|[Cc]achy-browser)$",
  "^(zen-alpha|zen)$",
})
tag_classes("notif", { "^(swaync-control-center|swaync-notification-window|swaync-client|class)$" })
tag_classes("nwg", { "^(nwg-displays|nwg-look)$" })
tag_classes("terminal", { "^(Alacritty|kitty|kitty-dropterm)$" })
tag_classes("email", { "^([Tt]hunderbird|org.gnome.Evolution)$", "^(eu.betterbird.Betterbird)$" })
tag_classes("projects", {
  "^(codium|codium-url-handler|VSCodium)$",
  "^(VSCode|code-url-handler)$",
  "^(jetbrains-.+)$",
})
tag_classes("screenshare", { "^(com.obsproject.Studio)$" })
tag_classes("im", {
  "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
  "^([Ff]erdium)$",
  "^([Ww]hatsapp-for-linux)$",
  "^(ZapZap|com.rtosta.zapzap)$",
  "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$",
  "^(teams-for-linux)$",
  "^(im.riot.Riot|Element)$",
})
tag_classes("games", { "^(gamescope)$", "^(steam_app_\\d+)$" })
tag_classes("gamestore", { "^([Ss]team)$", "^(com.heroicgameslauncher.hgl)$" })
rule({ title = "^([Ll]utris)$" }, { tag = "+gamestore" })
tag_classes("file-manager", { "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$", "^(app.drey.Warp)$" })
tag_classes("multimedia", { "^([Aa]udacious)$" })
tag_classes("multimedia_video", { "^([Mm]pv|vlc)$" })
tag_classes("settings", {
  "^(wihotspot(-gui)?)$",
  "^([Bb]aobab|org.gnome.[Bb]aobab)$",
  "^(gnome-disks|wihotspot(-gui)?)$",
  "^(file-roller|org.gnome.FileRoller)$",
  "^(nm-applet|nm-connection-editor|blueman-manager)$",
  "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$",
  "^(qt5ct|qt6ct|[Yy]ad)$",
  "(xdg-desktop-portal-gtk)",
  "^(org.kde.polkit-kde-authentication-agent-1)$",
  "^([Rr]ofi)$",
})
rule({ title = "(Kvantum Manager)" }, { tag = "+settings" })
tag_classes("viewer", {
  "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$",
  "^(evince)$",
  "^(eog|org.gnome.Loupe)$",
})

-- Per tag
for_tag("multimedia_video", { no_blur = true, opacity = "1.0" })
for_tag("nwg", { float = true, center = true })
for_tag("email", { workspace = "1" })
for_tag("browser", { workspace = "2", opacity = "0.9 0.7" })
for_tag("gamestore", { workspace = "5" })
for_tag("im", { workspace = "7", opacity = "0.94 0.86" })
for_tag("games", { workspace = "8", no_blur = true, fullscreen = true })
for_tag("screenshare", { workspace = "4 silent" })
for_tag("multimedia", { workspace = "9 silent", opacity = "0.94 0.86" })
for_tag("settings", { float = true, size = pct(0.7, 0.7), opacity = "0.8 0.7" })
for_tag("viewer", { float = true, opacity = "0.82 0.75" })
for_tag("projects", { opacity = "0.9 0.8" })
for_tag("file-manager", { opacity = "0.9 0.8" })
for_tag("terminal", { opacity = "0.8 0.7" })

-- Specific windows
rule({ fullscreen = true }, { idle_inhibit = "fullscreen" })
rule({ class = "^(virt-manager)$" }, { workspace = "6 silent" })
rule({ class = "^(.virt-manager-wrapped)$" }, { workspace = "6 silent" })
rule({ class = "([Tt]hunar)", title = "negative:(.*[Tt]hunar.*)" }, { float = true, center = true })
rule({ title = "^(Keybindings)$" }, { center = true })
rule({ class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" }, { center = true })
rule({ class = "^([Ww]hatsapp-for-linux|ZapZap|com.rtosta.zapzap)$" }, { center = true, size = pct(0.6, 0.7) })
rule({ class = "^([Ff]erdium)$" }, { float = true, center = true, size = pct(0.6, 0.7) })
rule({ title = "^(Picture-in-Picture)$" }, {
  float = true,
  pin = true,
  keep_aspect_ratio = true,
  move = pct(0.72, 0.07),
  opacity = "0.95 0.75",
})
rule({ class = "([Zz]oom|onedriver|onedriver-launcher)$" }, { float = true })
rule({ class = "(org.gnome.Calculator)", title = "(Calculator)" }, { float = true })
rule({ class = "^(mpv|com.github.rafostar.Clapper)$" }, { float = true })
rule({ class = "^([Qq]alculate-gtk)$" }, { float = true })
rule({ title = "^(Authentication Required)$" }, { float = true, center = true })
rule({ class = "(codium|codium-url-handler|VSCodium)", title = "negative:(.*codium.*|.*VSCodium.*)" }, { float = true })
rule({ class = "^(com.heroicgameslauncher.hgl)$", title = "negative:(Heroic Games Launcher)" }, { float = true })
rule({ class = "^([Ss]team)$", title = "negative:^([Ss]team)$" }, { float = true })
rule({ title = "^(Add Folder to Workspace)$" }, { float = true, center = true, size = pct(0.7, 0.6) })
rule({ title = "^(Save As)$" }, { float = true, center = true, size = pct(0.7, 0.6) })
rule({ initial_title = "(Open Files)" }, { float = true, size = pct(0.7, 0.6) })
rule({ class = "^(gedit|org.gnome.TextEditor|mousepad)$" }, { opacity = "0.8 0.7" })
rule({ class = "^(deluge)$" }, { opacity = "0.9 0.8" })
rule({ class = "^(seahorse)$" }, { opacity = "0.9 0.8" })
rule({ class = "^(jetbrains-*)" }, { no_initial_focus = true })
rule({ title = "^(wind.*)$" }, { no_initial_focus = true })
rule({ class = "^(code)$" }, { opacity = "0.8" })
rule({ title = "^(Cisco Secure Client.*)$" }, { float = true, center = true, size = { 900, 650 } })
rule({ initial_title = "^(Cisco Secure Client.*)$" }, { float = true })
rule({ class = "^(vpnui|Cisco Secure Client)$" }, { float = true })

-- Layers
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true, ignore_alpha = 0 })
