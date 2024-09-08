#!/bin/bash

# By: Stephan Raabe

# __          __     _      _      _____        _____  ______ _____  
# \ \        / /\   | |    | |    |  __ \ /\   |  __ \|  ____|  __ \ 
#  \ \  /\  / /  \  | |    | |    | |__) /  \  | |__) | |__  | |__) |
#   \ \/  \/ / /\ \ | |    | |    |  ___/ /\ \ |  ___/|  __| |  _  / 
#    \  /\  / ____ \| |____| |____| |  / ____ \| |    | |____| | \ \ 
#     \/  \/_/    \_\______|______|_| /_/    \_\_|    |______|_|  \_\
#

# This script is used to set the wallpaper

# Function to print usage
function print_usage() {
    echo "Usage: $0 <path_to_image>"
    echo "Supported formats: .png, .jpg, .jpeg"
    exit 1
}

blurred_wallpaper=~/.config/dotfiles/cache/blurred_wallpaper.png

if [ ! -d ~/.config/dotfiles/cache ]; then
    mkdir -p ~/.config/dotfiles/cache
fi

rasi_file=~/.cache/wal/current_wallpaper.rasi
blur="50x30"

if [ -z $1 ] ;then
    print_usage
fi

wallpaper=$1

# Run pywal to change the color scheme
wal -q -i $wallpaper
source $HOME/.cache/wal/colors.sh

# Restart hyprpaper
killall -e hyprpaper & 
sleep 1; 
wal_tpl=$(cat ~/.config/hypr/hyprpaper.tpl)
output=${wal_tpl//WALLPAPER/$wallpaper}
echo "$output" > ~/.config/hypr/hyprpaper.conf
hyprpaper & > /dev/null 2>&1

# Reload ags
killall ags
ags &

~/.config/waybar/launch.sh

# Create the blurred version of the wallpaper (used in wlogout)
magick $wallpaper -resize 75% $blurred_wallpaper
if [ ! "$blur" == "0x0" ] ;then
    magick $blurred_wallpaper -blur $blur $blurred_wallpaper
fi

# Create the rasi file
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
fi
echo "* { current-image: url(\"$blurred_wallpaper\", height); }" > $rasi_file
