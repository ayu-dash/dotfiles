#! /bin/bash

THEME="$HOME/.config/hypr/RofiThemes/RofiEmojiPicker.rasi"

rofi -modi emoji -show emoji -emoji-format "{emoji}" -kb-secondary-copy "" -kb-custom-1 Ctrl+c -theme "$THEME"