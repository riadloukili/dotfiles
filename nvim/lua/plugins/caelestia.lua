-- caelestia's colourscheme: follows the current wallpaper scheme
-- (~/.local/state/caelestia/scheme.json) live. The files come from the
-- caelestia-dots flake input; nixos-config exports its path as $CAELESTIA_DOTS.
local dots = os.getenv("CAELESTIA_DOTS")
if not dots then
  return {}
end

return {
  { dir = dots .. "/nvim", name = "caelestia", lazy = false, priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "caelestia" } },
}
