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
declare -a StringArray=("Discord" "Visual Studio Code" "Bitwarden")

# Create the tmp directory where the .deb file will be temporary stored
mkdir tmp_deb_files
cd tmp_deb_files

# Iterate the string array using for loop
for val in ${StringArray[@]}; do
    echo $val
    check_for_input $val
    response=$?
    if [ $response -eq 0 ]; then 

        # Install the programs
        case $val in

            "Discord") wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb" ; sudo apt install ./discord.deb -y ;;
            "Visual Studio Code") wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" ; sudo apt install ./vscode.deb -y ;;
            "Bitwarden") sudo snap install bitwarden ;;
            ""

        esac

    fi
done

# Delete the tmp directory
rm -rf tmp_deb_files