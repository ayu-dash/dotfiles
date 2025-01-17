#! /bin/bash

THEME="$HOME/.config/hypr/RofiThemes/RofiClipboard.rasi"

cliphist list | rofi -dmenu -i  -kb-secondary-copy "" -kb-custom-1 Ctrl+c -theme "$THEME" | cliphist decode | wl-copy

