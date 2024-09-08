#!/bin/bash 

# By: Daniele Bertagnoli

#  _____   ____   _____ _______ 
# |  __ \ / __ \ / ____|__   __|
# | |__) | |  | | (___    | |   
# |  ___/| |  | |\___ \   | |   
# | |    | |__| |____) |  | |   
# |_|     \____/|_____/   |_|   
#

if ! -f ~/.config/dotfiles/cache/do_post_install ; then
    exit 0
fi

hyprctl_output=$(hyprctl monitors)

# Use awk to process the output and extract the required fields
echo "$hyprctl_output" | awk '
/Monitor/ { 
    monitor_name=$2 
}
/availableModes/ { 
    # Print monitor name and fixed preferred, auto, 1
    print "monitor=" monitor_name ",preferred,auto,1"
}' >> ~/.config/hypr/configs/monitors.conf

$pictures_folder=$(xdg-user-dirs PICTURES)

# Set random wallpaper
waypaper --random
 
rm ~/.config/dotfiles/cache/do_post_install


