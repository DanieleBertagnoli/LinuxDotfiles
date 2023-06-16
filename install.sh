#!/bin/bash

# Switch to X11
echo "It's recommended to switch from Wayland to X11 to achieve a better compatibility"
sudo gedit /etc/gdm3/custom.conf

####################
#                  #
#   Themes Setup   #
#                  #
####################


# Install Gnome-Tweaks and Gnome-Shell-Extension
sudo add-apt-repository universe
sudo apt install gnome-tweaks -y
sudo apt install gnome-shell-extension-manager -y

# Wait that all the manual steps are completed
echo "Hi! Now you have to complete the manual steps specified in the README.md file. Don't worry, it takes up to 2 minutes :)"
echo "Please press ANY key to contiue..."
read  -n 1

# Copy the themes into the system's folders
sudo cp -r icons/* /usr/share/icons
sudo cp -r themes/* /usr/share/

# Apply themes
dconf write /org/gnome/desktop/interface/cursor-theme "'Qogir-cursors'"
dconf write /org/gnome/desktop/interface/icon-theme "'Kora'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyo'"
dconf write /org/gnome/shell/extensions/user-theme/name "'Sweet-Dark'"

# Edit Dock
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 50
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8


######################
#                    #
#   Programs Setup   #
#                    #
######################

check_for_input(program_name)
{
    echo "Do you want to install" . $program_name . " ? [y/n]"
    while true; do
        read -n 1 response
        case $response in 
            [yY]) echo ; return 0 ;;
            [nN]) echo ; return 1 ;;
            *) echo "Invalid input, enter [y/n]" ;;
        esac
    done

}

# Declare all the programs
declare -a StringArray=("Linux Mint" "Fedora" "Red Hat Linux" "Ubuntu" "Debian" )

# Iterate the string array using for loop
for val in ${StringArray[@]}; do
    echo $val
    check_for_input($val)
done