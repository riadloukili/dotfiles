-- Keyboard, touchpad, touch screen, gestures.
local M = {
  layouts = { "us", "ca" }, -- lib/keyboard.lua cycles these
  variants = { "", "multix" },
  touchpad = "gxtp5100:00-27c6:01e0-touchpad", -- `hyprctl devices`; lib/toggles.lua switches it
}

hl.config({
  input = {
    kb_layout = table.concat(M.layouts, ","),
    kb_variant = table.concat(M.variants, ","),
    repeat_rate = 50,
    repeat_delay = 300,
    sensitivity = 0,
    numlock_by_default = true,
    follow_mouse = 1,
    float_switch_override_focus = false,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      ["tap-to-click"] = true,
    },
    touchdevice = { enabled = true },
    tablet = { transform = 0 },
  },
  gestures = {
    workspace_swipe_distance = 500,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 30,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_create_new = true,
    workspace_swipe_forever = true,
  },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

return M
