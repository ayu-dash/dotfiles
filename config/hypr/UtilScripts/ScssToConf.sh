#!/bin/bash

scss_file="$1"
output_file="$HOME/.cache/wal/hypr-colors.conf"
HexToRgba="$HOME/.config/hypr/UtilScripts/HexToRgba.sh"

if [[ ! -f "$HexToRgba" ]]; then
    echo "Error: File fungsi '$HexToRgba' tidak ditemukan."
    exit 1
fi

source "$HexToRgba"

if [[ -z "$scss_file" ]]; then
    echo "Error: Tidak ada file yang diberikan."
    echo "Usage: $0 <nama_file.scss>"
    exit 1
fi

if [[ ! -f "$scss_file" ]]; then
    echo "Error: File '$scss_file' tidak ditemukan."
    exit 1
fi

# Buat atau kosongkan file output
> "$output_file"

# Proses file SCSS baris per baris
while IFS= read -r line; do
    # Hapus tanda ;, ganti : dengan =, dan hilangkan tanda "
    processed_line=$(echo "$line" | sed 's/;//g; s/: /=/g; s/"//g')

    # Jika baris mengandung kode warna HEX, konversi ke RGBA
    if [[ "$processed_line" =~ (#[0-9a-fA-F]{6}) ]]; then
        hex_color="${BASH_REMATCH[1]}"
        rgba_color=$(HexToRgba "$hex_color")
        processed_line=${processed_line//$hex_color/$rgba_color}
    fi

    # Tulis hasilnya ke file output
    echo "$processed_line" >> "$output_file"
done < "$scss_file"
