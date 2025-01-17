#!/bin/bash

STATE_FILE="/tmp/screen-keep-on"

get_status() {
    if [ -f "$STATE_FILE" ]; then
        echo '{"text": "ON", "class": "active"}'
    else
        echo '{"text": "OFF", "class": "inactive"}'
    fi   
}

toggle() {
    if [ -f "$STATE_FILE" ]; then
        # Jika file status ada, matikan mode dan hapus file status
        hypridle &
        rm "$STATE_FILE"
        echo '{"text": "ON", "class": "active"}'
    else
        # Jika file status tidak ada, aktifkan mode dan buat file status
        killall hypridle
        touch "$STATE_FILE"
        echo '{"text": "OFF", "class": "inactive"}'
    fi
}

case "$1" in
    --status) get_status;;
    --toggle) toggle;;
esac
