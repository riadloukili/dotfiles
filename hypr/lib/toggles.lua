-- Things that used to be shell scripts poking `hyprctl keyword`.
local notify = require("lib.notify")
local look = require("config.look")
local input = require("config.input")
local apps = require("config.apps")
local M = {}

function M.layout()
  local new = hl.get_config("general.layout") == "master" and "dwindle" or "master"
  hl.config({ general = { layout = new } })
  notify(" " .. new:gsub("^%l", string.upper) .. " layout")
end

-- SUPER+J/K follow the layout: dwindle cycles windows, master cycles the stack.
function M.cycle(direction)
  return function()
    if hl.get_config("general.layout") == "master" then
      hl.dispatch(hl.dsp.layout(direction == "next" and "cyclenext" or "cycleprev"))
    else
      hl.dispatch(hl.dsp.window.cycle_next({ next = direction == "next" }))
    end
  end
end

function M.blur()
  if hl.get_config("decoration.blur.passes") == 2 then
    hl.config({ decoration = { blur = { size = 2, passes = 1 } } })
    notify(" Less blur", nil, "note")
  else
    hl.config({ decoration = { blur = { size = 5, passes = 2 } } })
    notify(" Normal blur")
  end
end

function M.gamemode()
  if hl.get_config("animations.enabled") then
    hl.config({
      animations = { enabled = false },
      decoration = { rounding = 0, shadow = { enabled = false }, blur = { enabled = false } },
      general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
    })
    hl.exec_cmd("awww kill")
    notify(" Gamemode", "enabled")
  else
    hl.config({ animations = { enabled = true } })
    look.apply()
    hl.exec_cmd("awww-daemon --format argb && awww img " .. apps.wallpaper)
    notify(" Gamemode", "disabled")
  end
end

local touchpad_enabled = true
function M.touchpad()
  touchpad_enabled = not touchpad_enabled
  hl.device({ name = input.touchpad, enabled = touchpad_enabled })
  notify(touchpad_enabled and " Enabling touchpad" or " Disabling touchpad")
end

local opaque = {}
function M.opaque()
  local w = hl.get_active_window()
  if not w then
    return
  end
  opaque[w.address] = not opaque[w.address]
  hl.dispatch(hl.dsp.window.set_prop({ prop = "opaque", value = opaque[w.address] and "1" or "0" }))
end

function M.zoom(factor)
  return function()
    local current = hl.get_config("cursor.zoom_factor")
    hl.config({ cursor = { zoom_factor = math.max(1, current * factor) } })
  end
end

return M
