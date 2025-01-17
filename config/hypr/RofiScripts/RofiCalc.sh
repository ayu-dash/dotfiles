#! /bin/bash

THEME="$HOME/.config/hypr/RofiThemes/RofiCalc.rasi"

rofi -show calc -modi calc -no-show-match -no-sort -no-persist-history -calc-command "echo -n '{result}' | wl-copy" -theme "$THEME"

