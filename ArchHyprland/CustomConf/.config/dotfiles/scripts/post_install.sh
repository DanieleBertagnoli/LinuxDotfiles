#!/bin/bash 

# By: Daniele Bertagnoli

#  _____   ____   _____ _______ 
# |  __ \ / __ \ / ____|__   __|
# | |__) | |  | | (___    | |   
# |  ___/| |  | |\___ \   | |   
# | |    | |__| |____) |  | |   
# |_|     \____/|_____/   |_|   
#

if [ ! -f ~/.config/dotfiles/cache/do_post_install ]; then
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
    print "\n\nmonitor=" monitor_name ",preferred,auto,1"
}' >> ~/.config/hypr/configs/monitors.conf

$pictures_folder=$(xdg-user-dir PICTURES)

# Set random wallpaper
waypaper --random

# Number of workspaces you want to distribute
TOTAL_WS=9

# Get a list of connected monitors from hyprctl
MONITORS=($(hyprctl monitors -j | jq -r '.[].name'))
NUM_MON=${#MONITORS[@]}

if [[ $NUM_MON -eq 0 ]]; then
    echo "No monitors detected!"
    exit 1
fi

# Workspaces per monitor (rounded up)
WS_PER_MON=$(( (TOTAL_WS + NUM_MON - 1) / NUM_MON ))

# Clear previous workspace assignments (optional)
echo "# Auto-generated workspace config" >> ~/.config/hypr/configs/workspaces.conf

ws=1
for mon in "${MONITORS[@]}"; do
    for ((i=0; i<$WS_PER_MON && $ws<=$TOTAL_WS; i++)); do
        # First workspace on the first monitor is default
        if [[ $ws -eq 1 ]]; then
            echo "workspace = $ws, default:true, monitor:$mon" >> ~/.config/hypr/configs/workspaces.conf
        else
            echo "workspace = $ws, monitor:$mon" >> ~/.config/hypr/configs/workspaces.conf
        fi
        ((ws++))
    done
done
 
rm ~/.config/dotfiles/cache/do_post_install

sleep 10
reboot
