#!/bin/bash

#               .-. 
#         .-'``(|||) 
#      ,`\ \    `-`.                 88                         88 
#     /   \ '``-.   `                88                         88 
#   .-.  ,       `___:      88   88  88,888,  88   88  ,88888, 88888  88   88 
#  (:::) :        ___       88   88  88   88  88   88  88   88  88    88   88 
#   `-`  `       ,   :      88   88  88   88  88   88  88   88  88    88   88 
#     \   / ,..-`   ,       88   88  88   88  88   88  88   88  88    88   88 
#      `./ /    .-.`        '88888'  '88888'  '88888'  88   88  '8888 '88888' 
#         `-..-(   ) 
#               `-` 

# Switch to X11
# echo "It's recommended to switch from Wayland to X11 to achieve a better compatibility. Uncomment the option 'WaylandEnable' and set it to 'false'."
# sudo gedit /etc/gdm3/custom.conf 2&>/etc/null

cd $(dirname $0)

sudo apt update
sudo apt upgrade -y

echo -e "\n\n\n SYSTEM FULLY UPDATED... Wait 3 seconds"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
clear

###################
#                 #
#   Remove snap   #
#                 #
###################

echo -e "Do you want remove snap and all its packages? [y/n]\nWARNING: This option is recommended only to expert users."
while true; do
    read -n 1 response
    case $response in 
        [yY]) response=0 ;;
        [nN]) response=1 ;;
        *) echo "Invalid input $response, enter [y/n]" ;;
    esac
done

while [ $response -eq 1 ]; do

    # List all installed snap packages
    snap_list=$(snap list | awk 'NR>1 {print $1}')
        
    if [ -z "$snap_list" ]; then
        echo "No more snap packages to remove."
        break
    fi
        
    # Attempt to remove each snap package
    for snap in $snap_list; do
        echo "Attempting to remove snap package: $snap"
        sudo snap remove --purge "$snap"
        if [ $? -eq 0 ]; then
            echo "Successfully removed: $snap"
        fi
    done

done

# Remove snapd
sudo apt remove --autoremove snapd

sudo echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" >>/etc/apt/preferences.d/nosnap.pref

sudo apt update

# Install Firefox using the APT repository
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt install -t 'o=LP-PPA-mozillateam' firefox

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

sudo echo "Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501" >>/etc/apt/preferences.d/mozillateamppa



####################
#                  #
#   Themes Setup   #
#                  #
####################

# Install Gnome-Tweaks and Gnome-Shell-Extension
sudo add-apt-repository universe
sudo apt install gnome-tweaks -y
sudo apt install gnome-shell-extension-manager -y

# Set the UUID for the extension you want to install
EXTENSION_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"

# Get the GNOME Shell version
GNOME_VERSION=$(gnome-shell --version | awk '{print $3}')

# Create the extensions directory if it doesn't exist
mkdir -p ~/.local/share/gnome-shell/extensions

# Get the extension metadata URL
METADATA_URL="https://extensions.gnome.org/extension-info/?uuid=${EXTENSION_UUID}&shell_version=${GNOME_VERSION}"

# Fetch the extension metadata
METADATA=$(curl -s "$METADATA_URL")

# Extract the download URL from the metadata
DOWNLOAD_URL=$(echo "$METADATA" | grep -oP '(?<="download_url": ")[^"]+')

# Download and extract the extension
if [ -n "$DOWNLOAD_URL" ]; then
  EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions-brutte/$EXTENSION_UUID"
  mkdir -p $EXTENSION_DIR
  wget -O $EXTENSION_DIR/ext.zip "https://extensions.gnome.org$DOWNLOAD_URL"
  unzip $EXTENSION_DIR/ext.zip
  rm $EXTENSION_DIR/ext.zip
  echo "Extension installed to $EXTENSION_DIR"
else
  echo "Failed to retrieve the download URL."
fi

# Restart GNOME Shell (this may log you out, use with caution)
gnome-shell --replace &

# # Wait that all the manual steps are completed
# echo "Hi! Now you have to complete the manual steps specified in the README.md file. Don't worry, it takes up to 2 minutes."
# echo "Please press ANY key to contiue..."
# read -n 1

# Copy the themes into the system's folders
sudo cp -r icons/* /usr/share/icons
sudo cp -r themes/* /usr/share/themes

# Apply themes
dconf write /org/gnome/desktop/interface/cursor-theme "'Qogir-cursors'"
dconf write /org/gnome/desktop/interface/icon-theme "'Kora'"
dconf write /org/gnome/desktop/interface/gtk-theme "'Tokyo'"
dconf write /org/gnome/shell/extensions/user-theme/name "'Sweet-Dark'"

DIR="$(pwd)/wallpapers"
PIC=$(ls $DIR/wallpaper_1.png | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$PIC"



#######################
#                     #
#   Useful Programs   #
#                     #
#######################

check_for_input()
{
    local program_name=$1
    echo -e "\nDo you want to install $program_name ? [y/n]"
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
declare -a program_array=("Discord" "Visual Studio Code" "Bitwarden" "Docker" "Spotify" "Tailscale" "Latex Compiler")

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
            
            "Bitwarden") wget "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" -O bitwarden.deb ; sudo apt install ./bitwarden.deb -y ;;
            
            "Docker") sudo apt-get install ca-certificates curl gnupg -y ; sudo install -m 0755 -d /etc/apt/keyrings ; curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg ; sudo chmod a+r /etc/apt/keyrings/docker.gpg ; echo \
                        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
                        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ; sudo apt-get update ; sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y ;;
            
            "Spotify") curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg ; echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list ; sudo apt-get update && sudo apt-get install spotify-client ;;
            
            "Tailscale") curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null ; curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list ; sudo apt-get update ; sudo apt-get install tailscale ;;
            
            "Latex Compiler") sudo apt install texlive-science texlive-latex-extra texlive-extra-utils latexmk texlive-publishers -y ;;
        esac

    fi
done

# Restore the original value of IFS
IFS=$OLDIFS

# Delete the tmp directory
cd ..
rm -rf tmp_deb_files



########################
#                      #
#   Dotfiles Aliases   #
#                      #
########################

sudo bash -c 'echo "########################\n#                      #\n#   Dotfiles Aliases   #\n#                      #\n########################\n\n" >> ~/.bashrc'

sudo echo "alias c='clear'" >> ~/.bashrc
sudo echo "alias dw='cd ~/Downloads'" >> ~/.bashrc
sudo echo "alias up='sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get autoclean -y; sudo apt-get autoremove -y;'" >> ~/.bashrc