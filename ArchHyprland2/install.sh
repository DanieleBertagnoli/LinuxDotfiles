#!/bin/bash 

cd $(dirname $0)

sudo pacman -Syu

sudo pacman -S hyprland alacritty nautilus waybar hyprpaper starship rofi python-pywal

sudo pacman -S eza ttf-nerd-fonts-symbols gnome-keyring

yay -S wlogout ags

cp -r ./CustomConf/configs/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ ~/Pictures
