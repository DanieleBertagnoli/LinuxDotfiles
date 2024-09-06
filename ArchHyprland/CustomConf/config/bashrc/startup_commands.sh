#!/bin/bash

# By: Daniele Bertagnoli

#   _____ _______       _____ _______ _    _ _____     _____ ____  __  __ __  __          _   _ _____   _____ 
#  / ____|__   __|/\   |  __ \__   __| |  | |  __ \   / ____/ __ \|  \/  |  \/  |   /\   | \ | |  __ \ / ____|
# | (___    | |  /  \  | |__) | | |  | |  | | |__) | | |   | |  | | \  / | \  / |  /  \  |  \| | |  | | (___  
#  \___ \   | | / /\ \ |  _  /  | |  | |  | |  ___/  | |   | |  | | |\/| | |\/| | / /\ \ | . ` | |  | |\___ \ 
#  ____) |  | |/ ____ \| | \ \  | |  | |__| | |      | |___| |__| | |  | | |  | |/ ____ \| |\  | |__| |____) |
# |_____/   |_/_/    \_\_|  \_\ |_|   \____/|_|       \_____\____/|_|  |_|_|  |_/_/    \_\_| \_|_____/|_____/ 
#

# This script will be run every time that a new bash is opened

fastfetch --config examples/13

if ! pgrep -f gnome-keyring-daemon > /dev/null ; then
    eval $(gnome-keyring-daemon --start)
fi

eval "$(starship init bash)"
