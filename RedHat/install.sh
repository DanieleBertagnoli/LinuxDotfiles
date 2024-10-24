#!/bin/bash

cd $(dirname $0)

#Installing font
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

# Installing Icon theme
sudo yum install papirus-icon-theme.noarch

# Installing breeze cursor
sudo yum install breeze-cursor-theme.noarch

# Installing eza
sudo yum install eza

# Installing Starship
curl -sS https://starship.rs/install.sh | sh
cp -r ./CustomConf/.configs/* ~/.configs

# Copying .bashrc configurations
cp -r ./CustomConf/.bash* ~/

# Apply themes
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
