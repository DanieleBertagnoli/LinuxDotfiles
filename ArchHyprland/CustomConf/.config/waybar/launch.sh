#!/bin/bash 

# By: Daniele Bertagnoli

# __          __ __     ______          _____  
# \ \        / /\\ \   / /  _ \   /\   |  __ \ 
#  \ \  /\  / /  \\ \_/ /| |_) | /  \  | |__) |
#   \ \/  \/ / /\ \\   / |  _ < / /\ \ |  _  / 
#    \  /\  / ____ \| |  | |_) / ____ \| | \ \ 
#     \/  \/_/    \_\_|  |____/_/    \_\_|  \_\
#

# Script used to start (or restart) the waybar

# Stop running instances
killall waybar
pkill waybar
sleep 0.5

config_file="$HOME/.config/waybar/themes/DotfilesTheme/config"
style_file="$HOME/.config/waybar/themes/DotfilesTheme/style.css"

# Start new waybar instance
waybar -c $config_file -s $style_file &
