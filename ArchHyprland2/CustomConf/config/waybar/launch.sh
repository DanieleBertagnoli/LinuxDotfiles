#!/bin/bash 

killall waybar
pkill waybar
sleep 0.5

config_file='~/.config/waybar/config'
style_file='~/.config/waybar/style.css'

waybar -c $config_file -s $style_file &
