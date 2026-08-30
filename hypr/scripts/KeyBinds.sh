#!/usr/bin/env bash
# Searchable list of the active keybinds (from hyprctl), via rofi.
pkill yad || true
pkill rofi && exit 0

hyprctl binds -j | jq -r '
  def mods: [ (if .modmask % 2 >= 1 then "SHIFT" else empty end),
              (if (.modmask / 4 | floor) % 2 >= 1 then "CTRL" else empty end),
              (if (.modmask / 8 | floor) % 2 >= 1 then "ALT" else empty end),
              (if (.modmask / 64 | floor) % 2 >= 1 then "SUPER" else empty end) ]
            | join(" + ");
  .[] | select(.submap == "")
      | "\(if mods == "" then "" else mods + " + " end)\(.key)\t\(if .has_description then .description else .dispatcher + " " + .arg end)"' |
	column -t -s $'\t' |
	rofi -dmenu -i -config "$HOME/.config/rofi/config-keybinds.rasi" -mesg "Keybinds (Enter does nothing)"
