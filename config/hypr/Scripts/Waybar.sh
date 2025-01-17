#! /bin/bash

CONFIG="$HOME/.config/waybar/Configs/Dec.jsonc"
STYLE="$HOME/.config/waybar/Styles/Dec.css"


run_waybar() {
    if [[ ! $(pidof waybar) ]]; then
        waybar --log-level error --config ${CONFIG} --style ${STYLE}
    fi
}

kill_waybar() {
    killall waybar 2>/dev/null
}

reload_waybar() {
    kill_waybar
    run_waybar
}

case "$1" in
    --run) run_waybar;;
    --kill) kill_waybar;;
    --reload) reload_waybar;;
esac


