#!/bin/bash 

# By: Daniele Bertagnoli

#   _____ ______ _______ _    _ _____     _____  _____ _____  _____ _____ _______ 
#  / ____|  ____|__   __| |  | |  __ \   / ____|/ ____|  __ \|_   _|  __ \__   __|
# | (___ | |__     | |  | |  | | |__) | | (___ | |    | |__) | | | | |__) | | |   
#  \___ \|  __|    | |  | |  | |  ___/   \___ \| |    |  _  /  | | |  ___/  | |   
#  ____) | |____   | |  | |__| | |       ____) | |____| | \ \ _| |_| |      | |   
# |_____/|______|  |_|   \____/|_|      |_____/ \_____|_|  \_\_____|_|      |_|   
#

cd $(dirname $0)


#############
#           #
#   Start   # 
#           #
#############

sudo pacman -Syu

yay -S --noconfirm gum figlet
sudo pacman -S --noconfirm wget

clear

figlet -f big "DOTFILES"

if ! gum confirm "Do you want to start the dotfiles installation?" ;then
    exit 0
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
    waybar
    hyprpaper
    starship
    rofi-wayland
    python-pywal
    hyprlock
    eza
    otf-font-awesome
    ttf-nerd-fonts-symbols
    archlinux-keyring
    breeze
    qt6ct
    gtk4
    gtk3
    nwg-look
    dunst
    fastfetch
    brightnessctl
    qt5-graphicaleffects 
    qt5-quickcontrols2 
    qt5-svg
    grim
    slurp
    cliphist
    vlc
    wireplumber
    pipewire
    xdg-desktop-portal-hyprland
    jq
    htop
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
    grimblast
    qiv
)

# Install all pacman packages at once
sudo pacman -S --noconfirm "${pacman_packages[@]}"

# Install all yay packages at once
yay -S --noconfirm "${yay_packages[@]}"


echo -e "\n\nPress [ENTER] to continue..."
read
clear


################################
#                              #
#   Copy configuration files   # 
#                              #
################################

figlet -f big "CONFIGURATION FILES"

pictures_folder=$(xdg-user-dir PICTURES)

cp -r ./CustomConf/.config/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ $pictures_folder
sudo cp -r GTKThemes/* /usr/share/themes

printf "file://$HOME/Desktop\nfile://$HOME/Documents\nfile://$HOME/Downloads\nfile://$HOME/Music\nfile://$HOME/Pictures\nfile://$HOME/Videos\n" > ~/.config/gtk-3.0/bookmarks

echo -e "\n\nPress [ENTER] to continue..."
read
clear


#############################
#                           #
#   Configurable Packages   # 
#                           #
#############################

figlet -f big "OTHER PACKAGES"

# Terminal
echo -e "\n\nPick your terminal emulator"
answer=$(gum choose "Alacritty" "Kitty" "ZSH")
if [ $answer == "Alacritty" ]; then
    answer="alacritty"
    cp -r ./CustomConf/.config-optional/alacritty ~/.config

elif [ $answer == "Kitty" ]; then
    answer="kitty"
elif [ $answer == "ZSH" ]; then
    answer="zsh"
else
    echo -e "\n\nERROR OPTION $answer NOT VALID"
    exit 1
fi

sudo pacman -S --noconfirm $answer

~/.config/dotfiles/scripts/applications.sh "set" "terminal" $answer 

# Browser
echo -e "\n\nPick your browser"
answer=$(gum choose "Firefox" "Brave" "Chromium")
if [ $answer == "Firefox" ]; then
    answer="firefox"
    from="sudopacman"

elif [ $answer == "Brave" ]; then
    answer="brave"
    from="yay"
    cp -r ./CustomConf/.config-optional/chromium-flags.conf ~/.config/brave-flags.conf

elif [ $answer == "Chromium" ]; then
    answer="chromium"
    from="yay"
    cp -r ./CustomConf/.config-optional/chromium-flags.conf ~/.config/

else
    echo -e "\n\nERROR OPTION $answer NOT VALID"
    exit 1
fi

$from -S --noconfirm $answer

~/.config/dotfiles/scripts/applications.sh "set" "browser" $answer 

# File manager
echo -e "\n\nPick your browser"
answer=$(gum choose "Nautilus" "Dolphin")
if [ $answer == "Nautilus" ]; then
    answer="nautilus"
elif [ $answer == "Dolphin" ]; then
    answer="dolphin"
else
    echo -e "\n\nERROR OPTION $answer NOT VALID"
    exit 1
fi

sudo pacman -S --noconfirm $answer

if [ $answer == "Nautilus" ]; then
    sudo glib-compile-schemas /usr/share/glib-2.0/schemas
    terminal=$(~/.config/dotfiles/scripts/applications.sh "get" "terminal")
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal alacritty
fi

~/.config/dotfiles/scripts/applications.sh "set" "filemanager" $answer 

echo -e "\n\nPress [ENTER] to continue..."
read
clear


########################
#                      #
#   Setup SDDM theme   # 
#                      #
########################

figlet -f big "SDDM"

downloads_folder=$(xdg-user-dir DOWNLOAD)

echo -e "\n\nDo you want to use SDDM?"
answer=$(gum choose "Yes" "No")
if [ "$answer" == "Yes" ]; then

    # Install sddm
    sudo pacman -S --noconfirm sddm

    # Copy configuration files
    cp -r ./CustomConf/.config-optional/sddm ~/.config/

    # Enable sddm
    if [ -f /etc/systemd/system/display-manager.service ]; then
        sudo rm /etc/systemd/system/display-manager.service
    fi

    sudo systemctl enable sddm.service

    if [ ! -d /etc/sddm.conf.d/ ]; then
        sudo mkdir /etc/sddm.conf.d
    fi

    sudo cp ~/.config/sddm/sddm.conf /etc/sddm.conf.d/

    echo -e "\n\nDo you want to use sugar-candy as SDDM theme?"
    answer=$(gum choose "Yes" "No")
    if [ "$answer" == "Yes" ]; then

        # Download the theme
        wget -P $downloads_folder/sddm-sugar-candy https://github.com/Kangie/sddm-sugar-candy/archive/refs/heads/master.zip
        unzip -o -q $downloads_folder/sddm-sugar-candy/master.zip -d $downloads_folder/sddm-sugar-candy

        # Set the theme
        sudo cp -r $downloads_folder/sddm-sugar-candy/sddm-sugar-candy-master /usr/share/sddm/themes/sugar-candy
        rm -rf $downloads_folder/sddm-sugar-candy

        # Update the wallpaper
        ~/.config/dotfiles/scripts/set_sddm_wallpaper.sh $pictures_folder/Wallpapers/wallpaper_1.png &> /dev/null
    fi
fi

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
echo -e "\n\nSetting environment variables"
if [ "$answer" == "Yes" ]; then
    cat ~/.config/hypr/configs/environments/nvidia.conf > ~/.config/hypr/configs/environment_vars.conf 
    sudo pacman -Sy --noconfirm libva-nvidia-driver
else
    cat ~/.config/hypr/configs/environments/default.conf > ~/.config/hypr/configs/environment_vars.conf
fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear


#########################
#                       #
#   Bluetooth support   # 
#                       #
#########################

figlet -f big "Bluetooth"

# Ask if the user is using a bluetooth adapter
echo -e "\n\nDo you have a bluetooth adapter?"
answer=$(gum choose "Yes" "No")
if [ "$answer" == "Yes" ]; then
    echo -e "\n\nInstalling bluetooth modules"
    sudo pacman -S --noconfirm bluez bluez-utils blueman
    sudo systemctl enable bluetooth.service
fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear


############################
#                          #
#   Laptop configuration   # 
#                          #
############################

figlet -f big "Laptop"

# Ask if the user is using a laptop
echo -e "\n\nAre you using a laptop?"
answer=$(gum choose "Yes" "No")
if [ "$answer" == "Yes" ]; then
    echo -e "\n\nUsing laptop configuration"
    cat ~/.config/hypr/configs/keyboards/laptop.conf > ~/.config/hypr/configs/keyboard.conf
else
    echo -e "\n\nUsing desktop configuration"
    cat ~/.config/hypr/configs/keyboards/desktop.conf > ~/.config/hypr/configs/keyboard.conf
fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear


#######################
#                     #
#   Keyboard Layout   # 
#                     #
#######################

figlet -f big "KEYBOARD"

# Default values
kb_layout="us"
kb_variant=""

# Ask for keyboard layout
if gum confirm "Do you want to specify the keyboard layout? (Default: us)" ; then
    kb_layout=$(gum input --placeholder "Enter keyboard layout (e.g. us, uk, de)" --value "")
fi

# Ask for keyboard variant if a layout was provided
if gum confirm "Do you want to specify the keyboard variant? (Leave empty for default)" ; then
    kb_variant=$(gum input --placeholder "Enter keyboard variant (e.g. dvorak, intl, etc.)" --value "")
fi

# Replace the placeholders LAYOUT and VARIANT using sed
sed -i "s/LAYOUT/$kb_layout/" ~/.config/hypr/configs/keyboard.conf
sed -i "s/VARIANT/$kb_variant/" ~/.config/hypr/configs/keyboard.conf

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

    # Use gum to create a list where the user can pick which packages to install
    echo -e "\n\nPress [X] on the keyboard to select/unselect and then [ENTER] to confirm.\n"
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
                yay -S --noconfirm visual-studio-code-bin
                ;;
            "Bitwarden")
                yay -S --noconfirm bitwarden
                ;;
            "Vesktop (Discord for Wayland)")
                yay -S --noconfirm vesktop
                ;;
        esac
    done

    IFS=$OLD_IFS

fi

echo -e "\n\nPress [ENTER] to continue..."
read
clear

figlet -f big COMPLETED

touch ~/.config/dotfiles/cache/do_post_install

echo -e "\n\nDo you want to reboot the system now?"
if ! gum confirm "" ;then
    exit 0    
fi

reboot
