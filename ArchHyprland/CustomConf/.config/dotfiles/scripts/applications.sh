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

    # Update the waybar browser config
    if [ $key == "browser" ]; then

        # Define file paths
        waybar_config="$HOME/.config/waybar/themes/config"

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
            echo "--enable-features=TouchpadOverscrollHistoryNavigation\n--ozone-platform=wayland" > "$HOME/.config/$browser-flags.conf"
        fi

        # List of supported browsers in the waybar config
        browsers=("custom/firefox" "custom/brave" "custom/chromium")

        # Replace the old browser setting with the new one in the waybar config
        for old_browser in "${browsers[@]}"; do
            sed -i "s|$old_browser|custom/$browser|g" "$waybar_config"
        done

        echo "updated waybar configuration with browser: $browser"

    fi

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
