-- Hyprland entry point. Each module under config/ configures one area and
-- lib/ holds the functions binds call into. Per-machine files written by
-- nwg-displays (monitors.lua, workspaces.lua) are loaded when present.
require("config.env")
require("config.input")
require("config.look")
require("config.animations")
require("config.behaviour")
require("config.rules")
require("config.autostart")
require("config.binds")

-- Any output without a rule of its own: preferred mode, placed to the right.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
pcall(require, "monitors")
pcall(require, "workspaces")
