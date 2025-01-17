#! /bin/bash

SCRIPT_DIR="$HOME/.config/hypr/RofiScripts"

main() {
    case "$1" in
        --menu) 
            "$SCRIPT_DIR/RofiMenuLauncher.sh"
            ;;
        --wall) 
            "$SCRIPT_DIR/RofiWallpaperPicker.sh"
            ;;
        --calc) 
            "$SCRIPT_DIR/RofiCalc.sh"            
            ;;
        --emoji) 
            "$SCRIPT_DIR/RofiEmojiPicker.sh"
            ;;
        --clip)
            "$SCRIPT_DIR/RofiClipboard.sh"
            ;;
        --cap)
            "$SCRIPT_DIR/RofiScreenShot.sh"
            ;;
    esac
}

if pidof rofi >/dev/null; then
    killall rofi
    exit 0
else
    main "$1"
fi