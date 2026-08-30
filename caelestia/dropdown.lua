-- Dropdown terminal: one floating, pinned terminal parked on a special
-- workspace when hidden.
local CLASS = "kitty-dropterm"
local PARKED = "special:dropdown"
local M = {}

local function parked(w)
  local ok, ws = pcall(function()
    return w.workspace
  end)
  return ok and ws ~= nil and ws.name == PARKED
end

function M.toggle(terminal)
  local w = hl.get_window("class:" .. CLASS)
  if not w then
    hl.exec_cmd(terminal .. " --class " .. CLASS, {
      float = true,
      pin = true,
      size = { "monitor_w*0.5", "monitor_h*0.5" },
      move = { "monitor_w*0.25", "monitor_h*0.05" },
    })
  elseif parked(w) then
    hl.dispatch(hl.dsp.window.move({ window = w, workspace = hl.get_active_workspace() }))
    hl.dispatch(hl.dsp.window.pin({ window = w, action = "on" }))
    hl.dispatch(hl.dsp.focus({ window = w }))
  else
    hl.dispatch(hl.dsp.window.pin({ window = w, action = "off" }))
    hl.dispatch(hl.dsp.window.move({ window = w, workspace = PARKED, follow = false }))
  end
end

return M
