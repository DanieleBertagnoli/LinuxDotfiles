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

sudo pacman -Syu

install gum yay
install figlet yay

clear

figlet -f big "DOTFILES"

if gum confirm "Do you want to start the dotfiles installation?" ;then
    echo -e "\nLet's go.\n"
elif [ $? -eq 130 ]; then
        exit 130
else
    echo -e "\nUpdate canceled."
    exit;
fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear


###########################
#                         #
#   Installing packages   # 
#                         #
###########################

figlet -f big "INSTALLING PACKAGES"

# Packages to be installed using pacman
pacman_packages=(
    hyprland
    sddm
    alacritty
    nautilus
    waybar
    hyprpaper
    starship
    rofi-wayland
    python-pywal
    hyprlock
    eza
    ttf-font-awesome
    ttf-nerd-fonts-symbols
    gnome-keyring
    breeze
    qt6ct
    gtk4
    gtk3
    nwg-look
    dunst
    fastfetch
    brightnessctl
    xdg-desktop-portal-hyprland
    qt5-graphicaleffects 
    qt5-quickcontrols2 
    qt5-svg
)

# Packages to be installed using yay
yay_packages=(
    wlogout  
    bibata-cursor-theme 
    waypaper 
    timeshift 
    trizen
    grub-btrfs
    aylurs-gtk-shell
    bun-bin
    sddm-sugar-dark
)

for package in "${pacman_packages[@]}"; do
    install $package "pacman"
done

for package in "${yay_packages[@]}"; do
    install $package "yay"
done

echo -e "\n\nPress [ENTER] to continue..."
read
clear


################################
#                              #
#   Copy configuration files   # 
#                              #
################################

figlet -f big "CONFIGURATION FILES"

cp -r ./CustomConf/config/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ ~/Pictures

~/.config/dotfiles/scripts/set_wallpaper.sh ~/Pictures/Wallpapers/wallpaper_1.png &> /dev/null
~/.config/dotfiles/scripts/set_gtk.sh &> /dev/null

echo -e "\n\nPress [ENTER] to continue..."
read
clear


########################
#                      #
#   Setup SDDM theme   # 
#                      #
########################

figlet -f big "SDDM"

# Enable sddm
if [ -f /etc/systemd/system/display-manager.service ]; then
    sudo rm /etc/systemd/system/display-manager.service
fi

sudo systemctl enable sddm.service

if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
fi

sudo cp ~/.config/sddm/sddm.conf /etc/sddm.conf.d/

wget -P ~/Downloads/sddm-sugar-candy https://github.com/Kangie/sddm-sugar-candy/archive/refs/heads/master.zip
unzip -o -q ~/Downloads/sddm-sugar-candy/master.zip -d ~/Downloads/sddm-sugar-candy
sudo cp -r ~/Downloads/sddm-sugar-candy/sddm-sugar-candy-master /usr/share/sddm/themes/sugar-candy

~/.config/dotfiles/scripts/set_sddm_wallpaper.sh ~/Pictures/Wallpapers/wallpaper_1.png &> /dev/null

echo -e "\n\nPress [ENTER] to continue..."
read
clear


######################
#                    #
#   NVIDIA support   # 
#                    #
######################

figlet -f big "NVIDIA"

# Ask if the user is using a proprietary NVIDIA card
echo -e "\n\nAre you using an NVIDIA GPU?"
answer=$(gum choose "Yes" "No")
if [ "$answer" == "Yes" ]; then
    echo # TODO
fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear

################
#              #
#   Programs   # 
#              #
################

clear
figlet -f big "PROGRAMS"

# Ask if the user wants to download programs
if gum confirm "Do you want to download some programs (Visual studio, Discord, etc...)? You can select which one." ;then
    echo
else
    clear
    figlet -f big COMPLETED
    exit 0
fi

# Use gum to create a list where the user can pick which packages to install
packages=$(gum choose --no-limit "Visual Studio Code" "Bitwarden" "Vesktop (Discord for Wayland)")

# Output the selected packages
echo "Selected packages: $packages"

# Save original IFS
OLD_IFS=$IFS

# Use IFS to handle multiple selections properly
IFS=$'\n'

# Install the selected packages
for package in $packages; do
    echo "Installing $package..."
    case "$package" in
        "Visual Studio Code")
            install visual-studio-code-bin yay
            ;;
        "Bitwarden")
            install bitwarden yay
            ;;
        "Vesktop (Discord for Wayland)")
            install vesktop yay
            ;;
    esac
done

IFS=$OLD_IFS

echo -e "\n\nPress [ENTER] to continue..."
read
clear

figlet -f big COMPLETED
