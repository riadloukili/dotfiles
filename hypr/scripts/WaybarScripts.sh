#!/usr/bin/env bash
# Launchers for waybar clicks.
term=kitty
files=thunar

case "$1" in
--btop) $term --title btop sh -c btop ;;
--nmtui) $term nmtui ;;
--term) $term & ;;
--files) $files & ;;
*) echo "Usage: $0 [--btop | --nmtui | --term | --files]" ;;
esac
