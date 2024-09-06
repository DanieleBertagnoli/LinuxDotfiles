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
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias l='eza --icons'
alias lt='eza -a --tree --level=1 --icons'
alias shutdown='systemctl poweroff'
alias ts='~/.config/ml4w/scripts/snapshot.sh'
alias wifi='nmtui'
alias autoclean='sudo pacman -Rcns $(pacman -Qdtq)'
