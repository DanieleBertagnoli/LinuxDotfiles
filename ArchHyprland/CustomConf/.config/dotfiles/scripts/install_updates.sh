#!/bin/bash

# By: Stephan Raabe

#  _    _ _____  _____       _______ ______  _____ 
# | |  | |  __ \|  __ \   /\|__   __|  ____|/ ____|
# | |  | | |__) | |  | | /  \  | |  | |__  | (___  
# | |  | |  ___/| |  | |/ /\ \ | |  |  __|  \___ \ 
# | |__| | |    | |__| / ____ \| |  | |____ ____) |
#  \____/|_|    |_____/_/    \_\_|  |______|_____/ 
#

# This script is used to update the whole system

is_installed() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

figlet -f big "Updates"

if gum confirm "Do you want to start the updates?" ;then
    echo -e "\nUpdate started."
elif [ $? -eq 130 ]; then
        exit 130
else
    echo -e "\nUpdate canceled."
    exit;
fi

# Create a snapshot
if gum confirm "Do you want to create a snapshot?" ;then
    c=$(gum input --placeholder "Enter a comment for the snapshot...")
    sudo timeshift --create --comments "$c"
    sudo timeshift --list
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo "Snapshot $c created!"
elif [ $? -eq 130 ]; then
    echo "Snapshot canceled."
    exit 130
else
    echo "Snapshot canceled."
fi

# Check if flatpak is installed
if [[ $(is_installed "flatpak") == "0" ]] ;then
    flatpak upgrade
fi

# Run the pacman updates
sudo pacman -Su --noconfirm

# Run the AUR updates 
yay --noconfirm

notify-send "Update complete"

echo -e "\nUpdate complete"

echo "Press [ENTER] to close."
read
