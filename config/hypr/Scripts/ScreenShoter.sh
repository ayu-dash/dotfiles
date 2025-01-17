#! /bin/bash

case "$1" in
    --full)
        hyprshot -m output
        ;;
    --window)
        hyprshot -m window
        ;;
    --region)
        hyprshot -m region
        ;;
esac