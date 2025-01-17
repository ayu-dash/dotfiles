#! /bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
ScssToConf="$HOME/.config/hypr/UtilScripts/ScssToConf.sh"

FPS=60
TYPE="wipe"
DURATION=1
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

start_daemon() {
   if [[ ! $(pidof swww-daemon) ]]; then
        swww-daemon
    fi
}

swww_startup() {
    start_daemon
    swww restore
}

set_wallpaper() {   
    start_daemon
    swww img "$@" $SWWW_PARAMS
    cp "$@" "$HOME/.cache/.wal"
    convert "$@" -resize 20% "$HOME/.cache/.rofi-image"
    # wal -i "$@" -n -t -s
    # wal_content=$(< "${HOME}/.cache/wal/wal")
    # $ScssToConf "$HOME/.cache/wal/colors.scss"
}

case "$1" in
    --set) set_wallpaper "$2";;
    --startup) swww_startup;;
esac