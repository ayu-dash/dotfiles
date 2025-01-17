LAYOUT="$HOME/.config/wlogout/Layout"
STYLE="$HOME/.config/wlogout/Style.css"
BG_OUTPUT="$HOME/.cache/wlogout_bg.png"

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

wlogout --protocol layer-shell -b 2 -R 700 -L 700 -T 300 -B 300 -C $STYLE -l $LAYOUT &
