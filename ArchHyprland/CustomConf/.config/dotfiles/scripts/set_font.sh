#!/bin/bash

# By: Daniele Bertagnoli

#  ______ ____  _   _ _______ 
# |  ____/ __ \| \ | |__   __|
# | |__ | |  | |  \| |  | |   
# |  __|| |  | | . ` |  | |   
# | |   | |__| | |\  |  | |   
# |_|    \____/|_| \_|  |_|   
#

# This script is used to change the font to all the system components, applications, waybar, wlogout, etc...

# Check if a font name is passed as an argument
if [ -z "$1" ]; then
  echo -e "Usage: $0 <font-name>\nHint: you can list the available themes using 'fc-list' command."
  exit 1
fi

# Get the old font name
old_font_name=$(cat ~/.config/dotfiles/cache/actual_font.txt)

# Font name passed as argument
new_font_name="$1"

# Check if the font is installed
if ! fc-list | grep -i "$new_font_name" > /dev/null 2>&1; then
  echo "Font '$new_font_name' not installed."
  exit
fi

# Apply the font
files=(
    ~/.config/gtk-3.0/settings.ini # GTK Applications
    ~/.config/alacritty/alacritty.toml # Alacritty
    ~/.config/rofi/config.rasi # Rofi
    ~/.config/sddm/theme.conf # SDDM
    ~/.config/waybar/themes/white-blur/main-style.css # Waybar
    ~/.config/waybar/themes/white/main-style.css # Waybar
    ~/.config/wlogout/style.css # Wlogout
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        sed -i "s/$old_font_name/$new_font_name/g" "$file"
        echo "Updated font in $file"
    else
        echo "$file does not exist."
    fi
done

# Save the new font name to the cache
echo "$new_font_name" > ~/.config/dotfiles/cache/actual_font.txt

echo "Font changed to '$new_font_name'."
