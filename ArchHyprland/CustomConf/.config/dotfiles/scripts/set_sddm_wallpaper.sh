#!/bin/bash

# By: Daniele Bertagnoli

#   _____ _____  _____  __  __  __          __     _      _      _____        _____  ______ _____  
#  / ____|  __ \|  __ \|  \/  | \ \        / /\   | |    | |    |  __ \ /\   |  __ \|  ____|  __ \ 
# | (___ | |  | | |  | | \  / |  \ \  /\  / /  \  | |    | |    | |__) /  \  | |__) | |__  | |__) |
#  \___ \| |  | | |  | | |\/| |   \ \/  \/ / /\ \ | |    | |    |  ___/ /\ \ |  ___/|  __| |  _  / 
#  ____) | |__| | |__| | |  | |    \  /\  / ____ \| |____| |____| |  / ____ \| |    | |____| | \ \ 
# |_____/|_____/|_____/|_|  |_|     \/  \/_/    \_\______|______|_| /_/    \_\_|    |______|_|  \_\
#

# This script is used to set the SDDM wallpaper

# Function to print usage
function print_usage() {
    echo "Usage: $0 <path_to_image>"
    echo "Supported formats: .png, .jpg, .jpeg"
    exit 1
}

current_wallpaper=$1

# Check if argument is provided
if [ -z "$current_wallpaper" ]; then
    echo "Error: No file provided."
    print_usage
fi

# Check if the file exists
if [ ! -f "$current_wallpaper" ]; then
    echo "Error: File '$current_wallpaper' does not exist."
    print_usage
fi

# Check if the file is a valid image (png, jpg, jpeg)
if [[ "$current_wallpaper" != *.png && "$current_wallpaper" != *.jpg && "$current_wallpaper" != *.jpeg ]]; then
    echo "Error: File '$current_wallpaper' is not a valid image format."
    print_usage
fi

# Copy the wallpaper to the SDDM theme directory
sudo cp "$current_wallpaper" /usr/share/sddm/themes/sugar-candy/Backgrounds/Background.png

# Update the theme.conf file to use the new background
sudo sed -i 's|^Background=.*|Background="Backgrounds/Background.png"|' /usr/share/sddm/themes/sugar-candy/theme.conf

echo "Wallpaper successfully updated."
