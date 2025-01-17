#!/bin/bash

clear
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
TEMP_DIR="$HOME/.temp"
ERROR_LOG="$HOME/RiceError.log"

# colors
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
INFO="$(tput setaf 4)[INFO]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4) 
RESET=$(tput sgr0)

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

cat << EOF

                         __                __
 .---.-..--.--..--.--..--|  |.---.-..-----.|  |--.
 |  _  ||  |  ||  |  ||  _  ||  _  ||__ --||     |
 |___._||___  ||_____||_____||___._||_____||__|__|
        |_____|
             
EOF

print_color() {
    printf "%b%s%b \n" "$1" "$2" "$RESET"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$ERROR_LOG"
}

LOG="Copy-Logs/install-$(date +%d-%H%M%S)_dotfiles.log"

print_color $WARN " This process will replace your previous configurations."
read -p "${CAT} Do you want to continue with the process? [y/N]: " choice
choice=${choice:-n}
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

if [[ "$choice" == "n" ]]; then
    exit 0
fi

# print_color $NOTE " Installing required packages"
sudo pacman -Sy waybar swaync git rofi-wayland rofi-calc rofi-emoji cronie xdg-user-dirs thunar gvfs tumbler kitty swww hyprlock hypridle cliphist bluez bluez-utils blueman nm-connection-editor network-manager-applet gtk3 vlc viewnior qt5-wayland qt6-wayland udiskie udisks2 ly nwg-look firefox btop base-devel imagemagick zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search fastfetch networkmanager unrar unzip dconf-editor geany

# # update home folders
xdg-user-dirs-update 2>&1 | tee -a "$LOG" || true

# installing AUR helper
print_color $NOTE " Installing AUR helper (yay)"
git clone "https://aur.archlinux.org/yay-git.git" "$TEMP_DIR/yay"

# copying configs
cd "$TEMP_DIR/yay"
makepkg -si
cd "-"

print_color $NOTE " Installing required packages"
yay -Sy wlogout hyprshot nerdfetch

# install font
print_color $NOTE " Installing fonts"
yay -Sy noto-fonts noto-fonts-emoji ttf-material-design-icons-webfont ttf-font-awesome nerd-fonts

# install theme
print_color $NOTE " Installing themes"
yay -Sy catppuccin-gtk-theme-mocha bibata-cursor-theme 

# copying configs
cd "$TEMP_DIR/yay"
makepkg -si
cd "-"

print_color $NOTE " Installing dotfiles"
print_color $INFO " Copying files to respective directories"

[ ! -d $CONFIG_DIR ] && mkdir -p "$CONFIG_DIR"
[ ! -d $BIN_DIR ] && mkdir -p "$BIN_DIR"

for dir in $DOTFILES_DIR/config/*; do
    dir_name=$(basename "$dir")

    if [[ $dir_name == "nvim" && $try_nvim != "y" ]]; then
        continue
    fi

    if cp -R "${dir}" "$CONFIG_DIR" 2>> RiceError.log; then
        print_color $OK " Configuration installed succesfully ${dir_name}"
        sleep 1
    else
        printf "%s%s%s %sconfiguration failed to been installed, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 1
    fi
done

for dir in $DOTFILES_DIR/bin; do
    dir_name=$(basename "$dir")

    if cp -R "${dir}" "$BIN_DIR" 2>> RiceError.log; then
        print_color $OK " Configuration installed succesfully ${dir_name}"
        sleep 1
    else
        printf "%s%s%s %sconfiguration failed to been installed, see %sRiceError.log %sfor more details.%s\n" "${BLD}" "${CYE}" "${dir_name}" "${CRE}" "${CBL}" "${CRE}" "${CNC}"
        sleep 1
    fi
done

cp -f "$DOTFILES_DIR/.gtkrc-2.0" "$HOME_DIR"
cp -f "$DOTFILES_DIR/.zshrc" "$HOME_DIR"
fc-cache -rv >/dev/null 2>&1

# disable other dm
print_color $NOTE " Disabling other display managers"
for dm in gdm.service sddm.service lightdm.service xdm.service; do
    if systemctl is-enabled $dm &>/dev/null; then
        sudo systemctl disable $dm
        print_color $INFO " Disabled $dm"
    fi
done

# enable service
print_color $NOTE " Enabling service"
sudo systemctl enable ly
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager
sudo systemctl enable cronie
sudo systemctl enable udisks2

# download wallpaper
print_color $NOTE "  Downloading wallpapers"
read -p "${CAT} Dowload wallpapers? [Y/n]: " choice
choice=${choice:-y}
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]'

if [[ "$choice" == "y" ]]; then
    git clone "https://github.com/ayu-dash/wallpapers.git" "$HOME/Pictures/wallpapers"
else
    continue
fi

# changing shell to zsh
print_color $NOTE " Changing your shell to zsh"

if [[ $SHELL != "/usr/bin/zsh" ]]; then
    if chsh -s /usr/bin/zsh 2> >(tee -a "$ERROR_LOG"); then
        print_color $OK " Shell changed to zsh successfully"
    else
        print_color $ERROR " Error changing your shell to zsh. Please check RiceError.log"
    fi
else
    print_color $INFO " Your shell is already zsh"
fi
sleep 3

if [ -d "$HOME_DIR/.config/hypr/Scripts" ]; then
    chmod +x "$HOME_DIR/.config/hypr/Scripts/*"
else
    print_color $WARN " Directory $HOME_DIR/.config/hypr/Scripts does not exist"
fi

if [ -d "$HOME_DIR/.config/hypr/RofiScripts" ]; then
    chmod +x "$HOME_DIR/.config/hypr/RofiScripts/*"
else
    print_color $WARN " Directory $HOME_DIR/.config/hypr/RofiScripts does not exist"
fi

if [ -d "$HOME_DIR/.config/hypr/UtilScripts" ]; then
    chmod +x "$HOME_DIR/.config/hypr/UtilScripts/*"
else
    print_color $WARN " Directory $HOME_DIR/.config/hypr/UtilScripts does not exist"
fi

if [ -d "$HOME_DIR/.local/bin" ]; then
    chmod +x "$HOME_DIR/.local/bin/*"
else
    print_color $WARN " Directory $HOME_DIR/.local/bin does not exist"
fi

# install oh-my-zsh
print_color $NOTE "  Installing oh my zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

########## --------- exit ---------- ##########
print_color $WARN " Installation complete"

read -p "${CAT} Reboot Now? [Y/n]: " choice
choice=${choice:-n}
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]'

if [[ "$choice" == "n" ]]; then
    exit 0
else
    systemctl reboot
fi
