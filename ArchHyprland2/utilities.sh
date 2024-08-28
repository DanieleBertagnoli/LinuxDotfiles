#!/bin/bash

#   _    _ _   _ _ _ _   _           
#  | |  | | | (_) (_) | (_)          
#  | |  | | |_ _| |_| |_ _  ___  ___ 
#  | |  | | __| | | | __| |/ _ \/ __|
#  | |__| | |_| | | | |_| |  __/\__ \
#   \____/ \__|_|_|_|\__|_|\___||___/

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
    "pacman-contrib"
    "bluez" # Bluetooth
    "bluez-utils"
    "wget"
    "unzip"
    "alacritty" # Alacritty 
    "noto-fonts" # Additional fonts
    "otf-font-awesome" # Additional fonts
    "ttf-fira-sans" # Additional fonts
    "ttf-fira-code" # Additional fonts
    "ttf-firacode-nerd" # Additional fonts
    "vlc" 
    "eza" # Faster ls command
    "python-pip" # Pip
    "pavucontrol" # Audio controller
    "tumbler" 
    "polkit-gnome"
    "brightnessctl" # Display dimmer
    "man-pages"
    "nm-connection-editor" # Wifi connection editor
    "gvfs"
    "xdg-user-dirs"
    "networkmanager"
    "network-manager-applet"
    "xarchiver"
    "zip"
    "fuse2"
    "gtk4"
    "libadwaita"
    "xdg-desktop-portal"
    "imagemagick"
    "guvcview"
    "jq"
    "fastfetch"
    "blueman"
    "xclip"
    "pinta"
    "breeze"
    "qt6ct"
    "stow"
    "fzf"
);

install_from_pacman "${packages_pacman[@]}"

packages_aur=(
    "trizen"
    "pacseek"
    "oh-my-posh"
);

install_from_aur "${packages_aur[@]}"