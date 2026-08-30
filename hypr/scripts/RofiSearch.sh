#!/usr/bin/env bash
# Web search: type a query in rofi, it opens in the default browser.
search_engine="https://www.google.com/search?q={}"
rofi_theme="$HOME/.config/rofi/config-search.rasi"

pkill rofi && exit 0
echo "" | rofi -dmenu -config "$rofi_theme" -mesg "search via default web browser" | xargs -I{} xdg-open "$search_engine"
