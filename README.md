# dotfiles

Optional overrides for [nixos-config](https://github.com/riadloukili/nixos-config), also usable on non-Nix machines.

The NixOS config ships a default for every program it installs. Anything placed here under the same top-level name replaces that default on machines where this repo is checked out at `~/personal/dotfiles` (symlinked, hot-editable, no rebuild):

| entry | program |
|---|---|
| `hypr/` | Hyprland (`hyprland.lua`) |
| `mango/` | Mango (`config.conf`) |
| `waybar/` `rofi/` `swaync/` `wlogout/` | Wayland desktop stack |
| `nvim/` | Neovim (used directly by `nix run nixos-config#nvim`) |
| `tmux/tmux.conf` | tmux (sourced by the `tmux` wrapper; TPM-compatible elsewhere) |
| `zsh/p10k.zsh`, `zsh/zshrc.local` | prompt + local zsh extras for the `zsh` wrapper |

Start from a default by copying it out of nixos-config's `modules/*/defaults/<name>` and editing.
