#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WALLPAPER_SCRIPT="$HOME/.config/hypr/Scripts/Wallpaper.sh"

THEME="$HOME/.config/hypr/RofiThemes/RofiWallpaperSelector.rasi"

# Cari file gambar dengan ekstensi yang sesuai
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \)))

# Fungsi untuk menampilkan daftar wallpaper
menu() {
    for i in ${!WALLPAPERS[@]}; do
        file_name=$(basename "${WALLPAPERS[$i]}")
        file_path="${WALLPAPERS[$i]}"
        # Tambahkan ikon dengan markup Rofi
        echo -e "$i. $file_name\0icon\x1f$file_path"
    done
}

# Tampilkan menu dengan Rofi
choice=$(menu | rofi -dmenu -theme "$THEME" -markup-rows -i -p "Select Wallpaper")

# Pastikan ada pilihan yang dipilih
if [[ -n $choice ]]; then
    # Ambil indeks wallpaper yang dipilih
    pic_index=$(echo "$choice" | cut -d. -f1)
    wallpaper_path="${WALLPAPERS[$pic_index]}"
    echo ${wallpaper_path}
    # Ganti wallpaper menggunakan skrip eksternal
    exec "$WALLPAPER_SCRIPT" --set "$wallpaper_path"
fi


