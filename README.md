# dotfiles

My configs, linked into `~/.config/<name>` by [nixos-config](https://github.com/riadloukili/nixos-config)
(every top-level directory here becomes `~/.config/<name>`; anything missing falls back to the program's defaults).
Usable on any machine: clone to `~/personal/dotfiles` and symlink what you need.

| entry | program |
|---|---|
| `hypr/` | Hyprland (JaKooLit-based; NVIDIA env lines are commented out, uncomment on an NVIDIA box) |
| `waybar/` `rofi/` `swaync/` `wlogout/` `wallust/` `swappy/` | Wayland desktop stack |
| `kitty/` | kitty + themes; `tmux-auto.sh` is its shell (one tmux session, grouped clients) |
| `tmux/` | tmux.conf + TPM (`prefix + I` installs the other plugins into `tmux/plugins`, gitignored) |
| `nvim/` | Neovim (LazyVim) |
| `zsh/p10k.zsh`, `zsh/zshrc.local` | powerlevel10k prompt (with the `$CLOUD_PROVIDER` icon segment) and personal zsh extras |
| `bat/` `btop/` `lazygit/` `fastfetch/` `atuin/` `direnv/` `cava/` | CLI tools |
| `qt5ct/` `qt6ct/` `Kvantum/` `gtk-3.0/` `gtk-4.0/` `nwg-look/` | theming |
