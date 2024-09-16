#!/bin/bash 

# By: Daniele Bertagnoli

#           _____  _____   _____ 
#     /\   |  __ \|  __ \ / ____|
#    /  \  | |__) | |__) | (___  
#   / /\ \ |  ___/|  ___/ \___ \ 
#  / ____ \| |    | |     ____) |
# /_/    \_\_|    |_|    |_____/ 
#

# This script is used to set the user preferences about some apps or run them

# Function to display usage
usage() {
    echo "Usage: $0 <set|run> <key> [value]"
    echo "Examples:"
    echo "  $0 set browser brave"
    echo "  $0 run browser"
    exit 1
}

# Configuration file path
config_file=~/.config/hypr/app_preferences.conf

# Check if at least two arguments are passed
if [ "$#" -lt 2 ]; then
    echo "Error: Invalid number of arguments."
    usage
fi

# Extract arguments
action=$1
key=$2
value=$3

# Check if the key is valid (only allow alphanumeric and underscores)
if [[ ! "$key" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Error: Invalid key. Only alphanumeric characters and underscores are allowed."
    exit 1
fi

# Check if the value is a valid command
if ! command -v $value >/dev/null 2>&1; then
    echo "$value is not installed."
    exit 1
fi


# Ensure the config file exists, create it if not
if [ ! -f "$config_file" ]; then
    touch "$config_file"
fi

if [ "$action" == "set" ]; then
    # Check if three arguments are passed
    if [ "$#" -ne 3 ]; then
        echo "Error: 'set' requires a key and value."
        usage
    fi
    
    # Use sed to search for the key and replace its value, if it exists
    if grep -q "^$key=" "$config_file"; then
        # Key exists, update the value
        sed -i "s/^$key=.*/$key=$value/" "$config_file"
        echo "Updated: $key=$value in $config_file"
    else
        # Key doesn't exist, append it
        echo "$key=$value" >> "$config_file"
        echo "Added: $key=$value to $config_file"
    fi
    
    if [ "$key" == "browser" ]; then

        # Define paths for the themes directory
        themes_dir="$HOME/.config/waybar/themes"
        
        # Read the preferred browser from app_preferences.conf
        browser=$(grep -i 'browser=' "$config_file" | cut -d'=' -f2)

        # Check if browser is set and not empty
        if [ -z "$browser" ]; then
            echo "browser is not specified in $config_file"
            exit 1
        fi

        # Check for chromium-based.conf
        if [ "$browser" = "brave" ] || { [ "$browser" = "chromium" ] && [ ! -f "$HOME/.config/$browser-flags.conf" ]; }; then
            echo "Creating flags file"
            echo -e "--enable-features=TouchpadOverscrollHistoryNavigation\n--ozone-platform=wayland" > "$HOME/.config/$browser-flags.conf"
        fi

        # Loop through all theme directories
        for theme_dir in "$themes_dir"/*; do
            modules_file="$theme_dir/modules.json"
            temp_file="$modules_file.tmp"

            # Check if modules.json exists for the current theme
            if [ -f "$modules_file" ]; then
                # Backup the original file
                cp "$modules_file" "$modules_file.bak"

                # Remove comments and process JSON
                sed '/^\s*\/\//d' "$modules_file" | jq --arg new_browser "custom/$browser" '
                    .["group/group-apps"].modules |= map(if test("custom/(chromium|brave|firefox)") then $new_browser else . end)
                ' > "$temp_file"

                # Check if jq succeeded and restore the file
                if [ $? -eq 0 ]; then
                    mv "$temp_file" "$modules_file"
                    echo "Updated Waybar modules.json in theme: $theme_dir with browser: $browser"
                else
                    echo "Failed to update modules.json in theme: $theme_dir"
                    exit 1
                fi
            else
                echo "$modules_file not found in theme: $theme_dir"
            fi
        done
    fi


    ~/.config/waybar/launch.sh

elif [ "$action" == "run" ]; then
    # Check if the key exists in the config file
    if grep -q "^$key=" "$config_file"; then
        # Extract the value for the key
        command=$(grep "^$key=" "$config_file" | cut -d'=' -f2-)
        
        # Shift the first two arguments (action and key) and pass the rest to the command
        shift 2

        echo "Running: $command $@"

        # Run the command
        $command "$@"
    else
        echo "Error: Key '$key' not found in $config_file."
        exit 1
    fi
else
    echo "Error: Invalid action '$action'. Only 'set' or 'run' are allowed."
    usage
fi
