#!/bin/bash
# ------------------------------------------------------
# Don't edit this section
# Include scripts.sh with helper functions
source library/scripts.sh
# ------------------------------------------------------

# Show Current version
echo ":: Running hook for ML4W Dotfiles $version"

# Install packages
sudo pacman -S gnome-keyring

# Remove installed packages
sudo pacman -R starship
sudo pacman -R neovim
sudo rm -rf ~/.config/starship* ~/.config/nvim*

