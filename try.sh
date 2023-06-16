sudo apt update
sudo apt upgrade

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
declare -a program_array=("Discord" "Visual Studio Code" "Bitwarden" "Remmina" "Docker" "Docker Desktop")

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

        esac

    fi
done

# Restore the original value of IFS
IFS=$OLDIFS

# Delete the tmp directory
cd ..
rm -rf tmp_deb_files