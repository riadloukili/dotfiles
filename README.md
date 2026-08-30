# dotfiles

My configs, linked into `~/.config/<name>` by [nixos-config](https://github.com/riadloukili/nixos-config)
(every top-level directory here becomes `~/.config/<name>`, and everything under `home/` becomes `~/<name>` for things that live outside `~/.config`; anything missing falls back to the program's defaults).
Usable on any machine: clone to `~/personal/dotfiles` and symlink what you need.

| entry | program |
|---|---|
| `caelestia/` | caelestia shell: `shell.json`, plus my Hyprland overrides `hypr-vars.lua` / `hypr-user.lua` (the Hyprland config itself is caelestia's, placed by nixos-config) |
| `swappy/` | screenshot editor |
| `kitty/` | kitty + themes; `tmux-auto.sh` is its shell (one tmux session, grouped clients) |
| `tmux/` | tmux.conf + TPM (`prefix + I` installs the other plugins into `tmux/plugins`, gitignored) |
| `nvim/` | Neovim (LazyVim) |
| `zsh/zshrc.local` | personal zsh extras (sourced by home-manager's zsh) |
| `starship/` | prompt, with the `$CLOUD_PROVIDER` icon (`STARSHIP_CONFIG` points here) |
| `bat/` `lazygit/` `fastfetch/` `atuin/` `direnv/` | CLI tools |
