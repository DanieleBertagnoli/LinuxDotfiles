#!/bin/bash

# Update the system
sudo pacman -Sy

# Install yay


#  _    _                  _                 _ 
# | |  | |                | |               | |
# | |__| |_   _ _ __  _ __| | __ _ _ __   __| |
# |  __  | | | | '_ \| '__| |/ _` | '_ \ / _` |
# | |  | | |_| | |_) | |  | | (_| | | | | (_| |
# |_|  |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|
#          __/ | |                             
#         |___/|_|                             

# Helper functions
function install_from_pacman() {
    pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        sudo pacman -S --noconfirm $pkg
    done
}

function install_from_aur() {
    pkgs=("$@")
    for pkg in "${pkgs[@]}"; do
        sudo yay -S --noconfirm $pkg
    done
}


packages_pacman=(
    "hyprland" # Hyprland
    "hyprpaper" # Wallpaper utility
    # "hyprlock" # Locking menu
    "hypridle" # Idle daemon
    "xdg-desktop-portal-hyprland" # Portal backend for Hyprland
    "waybar" # Top bar
    "grim" # Screenshot utility
    "slurp" # Helper for grim
    "cliphist" # Clipboard manager
    "nwg-look" # GTK3 themes 
    "dunst" # Notification manager
    "python-pywal" # Theme adapter
    "papirus-icon-theme" # Custom GTK icons
    "rofi-wayland" # Application launcher
);

install_from_pacman "${packages_pacman[@]}"

packages_aur=(
    "wlogout" # Logout manager
    "hyprshade" # Shader utility
    "waypaper" # Wallpaper utility
    "grimblast" # Helper for grim in Hyprland
    "bun-bin"
    "aylurs-gtk-shell" # Styling utility (used in waybar and rofi)
    "bibata-cursor-theme" # Cursor theme
);

install_from_aur "${packages_aur[@]}"





# Remove useless packages
./remove_useless.sh