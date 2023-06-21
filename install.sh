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
sudo cp -r themes/* /usr/share/themes

# Apply themes
dconf write /org/gnome/desktop/interface/cursor-theme "'Qogir-cursors'"
dconf write /org/gnome/desktop/interface/icon-theme "'Kora'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyo'"
dconf write /org/gnome/shell/extensions/user-theme/name "'Sweet-Dark'"

# Edit Dock
echo "Do you want to edit the dock (WARNING: YOU CAN DO IT ONLY IF YOU HAVE INSTALLED DASH TO DOCK) ? [y/n]"
while true; do
    read -n 1 response
    case $response in 
        [yY]) echo ;;
        [nN]) echo ;;
        *) echo ; echo "Invalid input, enter [y/n]" ;;
    esac
done

if [ $response -eq 0 ]; then 
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 50
    gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8
fi

DIR="$(pwd)/wallpapers"
PIC=$(ls $DIR/wallpaper_1.png | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$PIC"


######################
#                    #
#   Programs Setup   #
#                    #
######################

sudo apt update
sudo apt upgrade -y

check_for_input()
{
    local program_name=$1
    echo "Do you want to install $program_name ? [y/n]"
    while true; do
        read -n 1 response
        case $response in 
            [yY]) echo ; return 0 ;;
            [nN]) echo ; return 1 ;;
            *) echo ; echo "Invalid input, enter [y/n]" ;;
        esac
    done

}

# Declare all the programs
declare -a program_array=("Discord" "Visual Studio Code" "Bitwarden" "Remmina" "Docker" "Docker Desktop" "Spotify" "Telegram Desktop" "Tailscale")

# Create the tmp directory where the .deb file will be temporary stored
mkdir tmp_deb_files
cd tmp_deb_files

# Save the current value of IFS
OLDIFS=$IFS

# Set IFS to only newline character
IFS=$'\n'

# Iterate the string array using for loop
for val in ${program_array[@]}; do
    echo $val
    check_for_input $val
    response=$?
    if [ $response -eq 0 ]; then 

        # Install the programs
        case $val in

            "Discord") wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb" ; sudo apt install ./discord.deb -y ;;
            "Visual Studio Code") wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" ; sudo apt install ./vscode.deb -y ;;
            "Bitwarden") sudo snap install bitwarden ;;
            "Remmina") sudo snap install remmina ;;
            "Docker") sudo apt-get install ca-certificates curl gnupg -y ; sudo install -m 0755 -d /etc/apt/keyrings ; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg ; sudo chmod a+r /etc/apt/keyrings/docker.gpg ; echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ; sudo apt-get update ; sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y ;;
            
            "Docker Desktop") wget -O docker_desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.20.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64" ; sudo apt install ./docker_desktop.deb -y;;
            "Spotify") sudo snap install spotify ;;
            "Telegram Desktop") sudo snap install telegram-desktop ;;
            "Tailscale") curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null ; curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list ; sudo apt-get update ; sudo apt-get install tailscale ;;

        esac

    fi
done

# Restore the original value of IFS
IFS=$OLDIFS

# Delete the tmp directory
cd ..
rm -rf tmp_deb_files