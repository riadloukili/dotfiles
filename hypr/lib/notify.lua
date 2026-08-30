-- Desktop notification through swaync, with the dots' icons.
local icons = os.getenv("HOME") .. "/.config/swaync/images"

return function(title, body, icon)
  hl.exec_cmd(("notify-send -e -u low -i %s/%s.png %q %q"):format(icons, icon or "ja", title, body or ""))
end
