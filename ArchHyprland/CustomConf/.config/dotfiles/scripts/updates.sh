#!/bin/bash

# By: Daniele Bertagnoli

#  _   _           _       _             
# | | | |_ __   __| | __ _| |_ ___  ___  
# | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
# | |_| | |_) | (_| | (_| | ||  __/\__ \ 
#  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#       |_|                              
#  

# This script is used to check whether there are updates available for AUR packages

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(yay -Qu --aur --quiet | wc -l); then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

# This print is used in the waybar module
printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system"}' "$updates" "$updates" "$updates"

