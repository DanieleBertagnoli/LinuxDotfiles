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
squared_wallpaper=~/.config/dotfiles/cache/squared_wallpaper.png

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


tpl="$HOME/.config/hypr/hyprpaper.tpl"
conf="$HOME/.config/hypr/hyprpaper.conf"

# Extract monitor names from hyprctl
monitors=$(hyprctl monitors | awk '/Monitor/ {print $2}')

# Read template
tpl_content=$(cat "$tpl")

# Separate wallpaper block and splash line
wallpaper_block=$(echo "$tpl_content" | sed '/splash = false/,$d')
splash_line=$(echo "$tpl_content" | sed -n '/splash = false/p')

# Build output
output=""

for monitor in $monitors; do
    block="$wallpaper_block"
    block="${block//MONITOR/$monitor}"
    block="${block//WALLPAPER/$wallpaper}"
    output+="$block"$'\n'
done

# Append splash line once
output+="$splash_line"$'\n'

# Write final config
echo "$output" > "$conf"
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

# Create the squared version of the wallpaper (used in hyprlock)
magick $wallpaper -gravity Center -extent 1:1 $squared_wallpaper

# Create the rasi file
if [ ! -f $rasi_file ] ;then
    touch $rasi_file
fi
echo "* { current-image: url(\"$blurred_wallpaper\", height); }" > $rasi_file
