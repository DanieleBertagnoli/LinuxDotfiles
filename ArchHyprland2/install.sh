#!/bin/bash 

cd $(dirname $0)

sudo pacman -Syu

sudo pacman -S hyprland alacritty nautilus waybar hyprpaper starship rofi-wayland python-pywal

sudo pacman -S eza ttf-nerd-fonts-symbols gnome-keyring breeze gtk4 nwg-look

yay -S wlogout ags bibata-cursor-theme

cp -r ./CustomConf/config/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ ~/Pictures

~/.config/dotfiles-scripts/set_gtk_themes.sh
