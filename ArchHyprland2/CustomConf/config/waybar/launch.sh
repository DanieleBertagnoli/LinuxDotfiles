#!/bin/bash 

killall waybar
pkill waybar
sleep 0.5

config_file="$HOME/.config/waybar/themes/config"
style_file="$HOME/.config/waybar/themes/white-blur/style.css"

waybar -c $config_file -s $style_file &
