#!/bin/bash

WALLPAPERS_DIR="$(xdg-user-dir 'PICTURES')/Wallpapers/"
TIMER=600

# Usage function
usage() {
    echo "Usage: $0 [-w <dir>] [-s <seconds>]"
    echo "Options:"
    echo "  -w <dir>   Specify the wallpaper directory. Default value is \"$WALLPAPERS_DIR\"."
    echo "  -s <seconds>   Specify how many seconds the scripts has to wait before setting another wallpaper. Use 0 to avoid that the scripts loops. Default value is \"$TIMER\" seconds."
    echo "  -h   Prints the script usage."
    exit 1
}

set_random_wallpaper() {
    # Get random wallpaper
    cd $WALLPAPERS_DIR
    local picture_path="$WALLPAPERS_DIR$(ls | shuf -n 1)"

    # Set the wallpaper
    gsettings set org.gnome.desktop.background picture-uri "$picture_path"
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w)
            if [[ -n $2 && ! $2 =~ ^- ]]; then
                WALLPAPERS_DIR="$2"
                shift
            else
                echo "Error: -w requires a value."
                usage
            fi
            ;;
        -s)
            if [[ -n $2 && ! $2 =~ '^[0-9]+$' ]]; then
                TIMER="$2"
                shift
            else
                echo "Error: -s requires a number."
                usage
            fi
            ;;
        -h)
            usage
            ;;
        *)
            echo "Unknown parameter passed: $1"
            usage
            ;;
    esac
    shift
done


if [ ! -d $WALLPAPERS_DIR ]; then
    echo "The specified wallpaper directory \"$WALLPAPERS_DIR\" does not exists."
fi

set_random_wallpaper

# No loops
if [ $TIMER -eq 0 ]; then
    exit 0
fi

while true; do
    sleep $TIMER

    set_random_wallpaper

done
 