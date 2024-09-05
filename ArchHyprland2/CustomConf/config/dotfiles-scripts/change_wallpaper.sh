#!/bin/bash
#                _ _                              
# __      ____ _| | |_ __   __ _ _ __   ___ _ __  
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                   |_|         |_|               
#  
# ----------------------------------------------------- 
# Check to use wallpaper cache
# ----------------------------------------------------- 


# ----------------------------------------------------- 
# Set defaults
# ----------------------------------------------------- 

blurred_wallpaper="$HOME/.config/wlogout/blurred_wallpaper.png"
rasi_file="$HOME/.cache/wal/current_wallpaper.rasi"
blur="50x30"


# ----------------------------------------------------- 
# Get selected wallpaper
# ----------------------------------------------------- 

if [ -z $1 ] ;then
    echo "TODO error"
else
    wallpaper=$1
fi

# ----------------------------------------------------- 
# Get wallpaper filename
# ----------------------------------------------------- 
wallpaper_filename=$(basename $wallpaper)
echo ":: Wallpaper Filename: $wallpaper_filename"

# ----------------------------------------------------- 
# Wallpaper Effects
# -----------------------------------------------------

# Execute pywal
# ----------------------------------------------------- 

echo ":: Execute pywal with $used_wallpaper"
wal -q -i $wallpaper
source "$HOME/.cache/wal/colors.sh"

# ----------------------------------------------------- 
# Write hyprpaper.conf
# -----------------------------------------------------

# TODO change hyprpaper conf

# ----------------------------------------------------- 
# Reload Waybar
# -----------------------------------------------------
~/.config/waybar/launch.sh

# ----------------------------------------------------- 
# Reload AGS
# -----------------------------------------------------
killall ags
ags &

# ----------------------------------------------------- 
# Created blurred wallpaper
# -----------------------------------------------------

echo ":: Generate new cached wallpaper blur-$blur-$wallpaper_filename with blur $blur"
magick $wallpaper -resize 75% $blurred_wallpaper
echo ":: Resized to 75%"
if [ ! "$blur" == "0x0" ] ;then
    magick $blurred_wallpaper -blur $blur $blurred_wallpaper
    echo ":: Blurred"
fi

# ----------------------------------------------------- 
# Create rasi file
# ----------------------------------------------------- 

if [ ! -f $rasi_file ] ;then
    touch $rasi_file
fi
echo "* { current-image: url(\"$blurred_wallpaper\", height); }" > "$rasi_file"
