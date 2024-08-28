# Credits to ML4W https://github.com/mylinuxforwork/dotfiles/blob/main/lib/install/packages/remove.sh

is_installed_pacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

is_installed_aur() {
    package="$1";
    check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "\." | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Remove Rofi Calc
if [[ $(is_installed_pacman "rofi-calc") == 0 ]]; then
    sudo pacman --noconfirm -Rns rofi-calc
    echo "rofi-calc removed"
    echo
fi

# Remove Rofi
if [[ $(is_installed_pacman "rofi") == 0 ]]; then
    sudo pacman --noconfirm -Rns rofi
    echo "rofi removed"
    echo
fi

# Remove Swayidle
if [[ $(is_installed_pacman "swayidle") == 0 ]]; then
    sudo pacman --noconfirm -Rns swayidle
    echo "swayidle removed"
    echo
fi

# Remove Swaylock
if [[ $(is_installed_aur "swaylock-effects-git") == 0 ]]; then
    $aur_helper --noconfirm -Rns swaylock-effects-git
    echo "swaylock removed"
    echo
fi

# Remove rofi-lbonn-wayland
if [[ $(is_installed_aur "rofi-lbonn-wayland") == 0 ]]; then
    $aur_helper --noconfirm -Rns rofi-lbonn-wayland
    echo "rofi-lbonn-wayland removed"
    echo
fi

# Remove hypridle-bin
if [[ $(is_installed_aur "hypridle-git") == 0 ]]; then
    $aur_helper --noconfirm -Rns hypridle-git
    if [ -f /usr/lib/debug/usr/bin/hypridle.debug ] ;then
        sudo rm /usr/lib/debug/usr/bin/hypridle.debug
        echo "/usr/lib/debug/usr/bin/hypridle.debug removed"
    fi
    echo "hypridle-git uninstalled."
    echo "hypridle can now be installed."
    echo 
fi

# Remove hyprlock-bin
if [[ $(is_installed_aur "hyprlock-git") == 0 ]]; then
    $aur_helper --noconfirm -Rns hyprlock-git
    if [ -f /usr/lib/debug/usr/bin/hyprlock.debug ] ;then
        sudo rm /usr/lib/debug/usr/bin/hyprlock.debug
        echo "/usr/lib/debug/usr/bin/hyprlock.debug removed"
    fi
    echo "hyprlock-git uninstalled."
    echo "hyprlock can now be installed."
    echo
fi