-- Keyboard layout switching: globally, or remembered per window.
local notify = require("lib.notify")
local layouts = require("config.input").layouts
local M = { current = 1 }
local per_window = {}

local function apply(index)
  M.current = index
  hl.exec_cmd(("hyprctl switchxkblayout all %d"):format(index - 1))
  notify(" kb_layout: " .. layouts[index])
end

function M.cycle()
  apply(M.current % #layouts + 1)
end

function M.cycle_window()
  local w = hl.get_active_window()
  if not w then
    return
  end
  per_window[w.address] = (per_window[w.address] or M.current) % #layouts + 1
  apply(per_window[w.address])
end

hl.on("window.active", function(w)
  local wanted = w and per_window[w.address]
  if wanted and wanted ~= M.current then
    apply(wanted)
  end
end)

hl.on("window.close", function(w)
  if w then
    per_window[w.address] = nil
  end
end)

return M
