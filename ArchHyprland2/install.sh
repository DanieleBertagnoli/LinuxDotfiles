#!/bin/bash 

cd $(dirname $0)

sudo pacman -Syu

sudo pacman -S hyprland alacritty nautilus waybar hyprpaper starship rofi-wayland python-pywal hyprlock

sudo pacman -S eza ttf-nerd-fonts-symbols gnome-keyring breeze gtk4 nwg-look dunst

yay -S wlogout ags bibata-cursor-theme waypaper figlet gum timeshift trizen

cp -r ./CustomConf/config/* ~/.config
cp ./CustomConf/.bashrc ~/.bashrc
cp -r Wallpapers/ ~/Pictures

~/.config/dotfiles-scripts/set_gtk_themes.sh

sudo systemctl enable sddm.service

if [ ! -d /etc/sddm.conf.d/ ]; then
    sudo mkdir /etc/sddm.conf.d
    echo "Folder /etc/sddm.conf.d created."
fi

sudo cp $HOME/.config/sddm/sddm.conf /etc/sddm.conf.d/
# TODO download of sugar-candy
# sudo cp $HOME/.config/sddm/theme.conf /usr/share/sddm/themes/sugar-candy/
