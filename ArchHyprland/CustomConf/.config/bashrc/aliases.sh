#!/bin/bash

# By: Daniele Bertagnoli

#           _      _____           _____ ______  _____ 
#     /\   | |    |_   _|   /\    / ____|  ____|/ ____|
#    /  \  | |      | |    /  \  | (___ | |__  | (___  
#   / /\ \ | |      | |   / /\ \  \___ \|  __|  \___ \ 
#  / ____ \| |____ _| |_ / ____ \ ____) | |____ ____) |
# /_/    \_\______|_____/_/    \_\_____/|______|_____/ 
#

# This script defines the bash aliases

alias c='clear'
alias ls='eza --icons -a'
alias ll='eza --icons -al'
alias l='eza --icons=always'
alias lt='eza -a --icons --tree --level=3'
alias shutdown='systemctl poweroff'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias wifi='nmtui'
alias autoclean='sudo pacman -Rcns $(pacman -Qdtq)'

alias set_sddm_wallpaper='~/.config/dotfiles/scripts/set_sddm_wallpaper.sh'

alias dw='cd ~/Downloads'

alias rasp_connect='ssh -p 700 pi@192.168.1.168'
