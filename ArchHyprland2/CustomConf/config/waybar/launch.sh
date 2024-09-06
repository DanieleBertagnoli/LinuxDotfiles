#!/bin/bash 

killall waybar
pkill waybar
sleep 0.5

config_file="$HOME/.config/waybar/themes/ml4w-blur/config"
style_file="$HOME/.config/waybar/themes/ml4w-blur/white/style.css"

cat $config_file

waybar -c $config_file -s $style_file &
