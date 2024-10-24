#!/bin/bash

#Installing font
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

# Installing Icon theme
sudo yum install papirus-icon-theme.noarch

# Installing Starship
curl -sS https://starship.rs/install.sh | sh
cp -r ./CustomConf/.configs/* ~/.configs

# Copying .bashrc configurations
cp -r ./CustomConf/.bash* ~/

cd $(dirname $0)