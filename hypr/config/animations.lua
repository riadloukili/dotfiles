-- Curves and per-element animations.
hl.config({ animations = { enabled = true } })

local beziers = {
  linear = { { 0, 0 }, { 1, 1 } },
  md3_standard = { { 0.2, 0 }, { 0, 1 } },
  md3_decel = { { 0.05, 0.7 }, { 0.1, 1 } },
  md3_accel = { { 0.3, 0 }, { 0.8, 0.15 } },
  overshot = { { 0.05, 0.9 }, { 0.1, 1.1 } },
  crazyshot = { { 0.1, 1.5 }, { 0.76, 0.92 } },
  hyprnostretch = { { 0.05, 0.9 }, { 0.1, 1.0 } },
  fluent_decel = { { 0.1, 1 }, { 0, 1 } },
  easeInOutCirc = { { 0.85, 0 }, { 0.15, 1 } },
  easeOutCirc = { { 0, 0.55 }, { 0.45, 1 } },
  easeOutExpo = { { 0.16, 1 }, { 0.3, 1 } },
}
for name, points in pairs(beziers) do
  hl.curve(name, { type = "bezier", points = points })
end

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "easeOutExpo", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidevert" })
