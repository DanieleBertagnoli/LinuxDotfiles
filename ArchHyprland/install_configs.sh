#!/bin/bash

cd $(dirname $0)

# Copy monitor configurations
cp CustomConf/my_monitors.conf ~/.config/hypr/conf/monitors/

# Copy custom hyprland configurations
cp CustomConf/custom.conf ~/.config/hypr/conf/

# Copy custom .bashrc
cp CustomConf/.bashrc ~/

# Copy custom hook.sh for protecting files
cp CustomConf/hook.sh ~/dotfiles-versions/

# Copy custom post.sh for the post installation
cp CustomConf/post.sh ~/dotfiles-versions/

# Copy wallpapers
cp -r Wallpapers $(xdg-user-dir PICTURES)

# Function to prompt for installation
prompt_install() {
    local package=$1
    local package_name=$2
    local cmd=$3
    echo -e "\n\nDo you want to install $package_name? (y/n) "
    read -r choice
    case "$choice" in 
        y|Y ) sudo $cmd -S --noconfirm "$package";;
        * ) echo "Skipping $package_name installation.";;
    esac
}

# Function to prompt for removal
prompt_remove() {
    local package=$1
    local package_name=$2
    echo -e "\n\nDo you want to remove $package_name? (y/n) "
    read -r choice
    case "$choice" in 
        y|Y ) sudo pacman -R --noconfirm "$package";
            if [[ $package_name == "Starship" ]]; then
                sudo rm -rf ~/.config/starship*
            elif [[ $package_name == "Neovim" ]]; then
                sudo rm -rf ~/.config/nvim*
            fi
        ;;
        * ) echo "Skipping $package_name removal.";;
    esac
}

# Install packages with prompt
prompt_install gnome-keyring "GNOME Os Keyring" pacman
prompt_install spotify-launcher Spotify pacman
prompt_install vescord "Vesktop (Discord Wayland Porting)" yay

# Remove packages with prompt
prompt_remove starship Starship
prompt_remove neovim Neovim

# Replace the line in wallpaper.sh
# sed -i 's/wal -q -i $used_wallpaper/wal -q -i $used_wallpaper --saturate 0.8/' ~/.config/hypr/scripts/wallpaper.sh

# Install packages for enabling screen-sharing
sudo pacman -S --noconfirm pipewire wireplumber 

echo -e "\n\nPress Y to all (also to those part in which the system will ask for conflicts packages removal)"
yay -S xdg-desktop-portal-hyprland-git
sudo pacman -S grim slurp