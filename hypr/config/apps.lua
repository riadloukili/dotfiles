-- Programs and paths the rest of the config refers to.
local home = os.getenv("HOME")
local M = {
  terminal = "kitty",
  files = "thunar",
  menu = "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window",
  search_engine = "https://www.google.com/search?q={}",
  scripts = home .. "/.config/hypr/scripts",
  user_scripts = home .. "/.config/hypr/UserScripts",
  wallpaper = home .. "/.config/hypr/wallpaper.png",
}

function M.script(name)
  return M.scripts .. "/" .. name
end

function M.user_script(name)
  return M.user_scripts .. "/" .. name
end

return M
