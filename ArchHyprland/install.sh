#!/bin/bash 

# By: Daniele Bertagnoli

#   _____ ______ _______ _    _ _____     _____  _____ _____  _____ _____ _______ 
#  / ____|  ____|__   __| |  | |  __ \   / ____|/ ____|  __ \|_   _|  __ \__   __|
# | (___ | |__     | |  | |  | | |__) | | (___ | |    | |__) | | | | |__) | | |   
#  \___ \|  __|    | |  | |  | |  ___/   \___ \| |    |  _  /  | | |  ___/  | |   
#  ____) | |____   | |  | |__| | |       ____) | |____| | \ \ _| |_| |      | |   
# |_____/|______|  |_|   \____/|_|      |_____/ \_____|_|  \_\_____|_|      |_|   
#

# Function to install a package using the appropriate command
install() {
    package=$1
    install_cmd=$2

    if [ "$install_cmd" == "pacman" ]; then
        install_cmd="sudo $install_cmd"
    fi

    $install_cmd -S --noconfirm $package
}

cd $(dirname $0)

#############
#           #
#   Start   # 
#           #
#############

figlet -f big "Dotfiles"

if gum confirm "Do you want to start the dotfiles installation?" ;then
    echo -e "\nLet's go.\n"
elif [ $? -eq 130 ]; then
        exit 130
else
    echo -e "\nUpdate canceled."
    exit;
fi

sudo pacman -Syu

install gum yay
install figlet yay

clear


###########################
#                         #
#   Installing packages   # 
#                         #
###########################

figlet -f big "Installing packages"

# Packages to be installed using pacman
pacman_packages=(
    hyprland
    alacritty
    nautilus
    waybar
    hyprpaper
    starship
    rofi-wayland
    python-pywal
    hyprlock
    eza
    ttf-nerd-fonts-symbols
    gnome-keyring
    breeze
    qt6ct
    gtk4
    gtk3
    nwg-look
    dunst
    fastfetch
)

# Packages to be installed using yay
yay_packages=(
    wlogout 
    ags 
    bibata-cursor-theme 
    waypaper 
    timeshift 
    trizen
    sddm-sugar-candy
    grub-btrfs
    aylurs-gtk-shell
    bun-bin
)

#for package in "${pacman_packages[@]}"; do
#    install $package "pacman"
#done

#for package in "${yay_packages[@]}"; do
#    install $package "yay"
#done

clear


################################
#                              #
#   Copy configuration files   # 
#                              #
################################

cp -r ./CustomConf/config/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ ~/Pictures

~/.config/dotfiles/scripts/set_wallpaper.sh ~/Pictures/Wallpapers/wallpaper_1.png
~/.config/dotfiles/scripts/set_gtk.sh

clear


########################
#                      #
#   Setup SDDM theme   # 
#                      #
########################

sudo systemctl enable sddm.service

if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
fi

sudo cp ~/.config/sddm/sddm.conf /etc/sddm.conf.d/
sudo cp ~/.config/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/

clear


######################
#                    #
#   NVIDIA support   # 
#                    #
######################

# Ask if the user is using a proprietary NVIDIA card
echo -e "\n\nAre you using an NVIDIA GPU?"
answer=$(gum choose "Yes" "No")
if [ "$answer" == "Yes" ]; then
    # TODO
fi
