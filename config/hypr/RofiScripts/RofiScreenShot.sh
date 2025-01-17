#! /bin/bash

THEME="$HOME/.config/hypr/RofiThemes/RofiScreenShot.rasi"
SCREEN_SHOOTER="$HOME/.config/hypr/Scripts/ScreenShoter.sh"

# Rofi options
s_full="󰊓"
s_region="󰒅"
s_window=""

choice=$(echo -e "$s_full\n$s_region\n$s_window" | rofi -dmenu -theme "$THEME")

case "$choice" in
    "$s_full")
        $SCREEN_SHOOTER --full
        ;;
    "$s_region")
        $SCREEN_SHOOTER --region
        ;;
    "$s_window")
        $SCREEN_SHOOTER --window
        ;;
esac