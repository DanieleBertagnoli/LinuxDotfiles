#!/bin/bash

#   _____  _____ _____  ______ ______ _   _  _____ _    _  ____ _______ 
#  / ____|/ ____|  __ \|  ____|  ____| \ | |/ ____| |  | |/ __ \__   __|
# | (___ | |    | |__) | |__  | |__  |  \| | (___ | |__| | |  | | | |   
#  \___ \| |    |  _  /|  __| |  __| | . ` |\___ \|  __  | |  | | | |   
#  ____) | |____| | \ \| |____| |____| |\  |____) | |  | | |__| | | |   
# |_____/ \_____|_|  \_\______|______|_| \_|_____/|_|  |_|\____/  |_|   
#

# Based on https://github.com/hyprwm/contrib/blob/main/grimblast/screenshot.sh 

# Screenshots will be stored in $HOME by default.
# The screenshot will be moved into the screenshot directory

screenshot_folder=$(xdg-user-dir PICTURES)/Screenshot

prompt='Screenshot'
mesg="DIR: $screenshot_folder"

# Screenshot Filename
NAME="screenshot_$(date +%d%m%Y_%H%M%S).jpg"

# Screenshot Folder
if [ ! -d $screenshot_folder ]; then
    mkdir -p $screenshot_folder
fi

# Screenshot Editor
export GRIMBLAST_EDITOR="pinta"

# Options
option_1="Immediate"
option_2="Delayed"

option_capture_1="Capture Everything"
option_capture_2="Capture Active Display"
option_capture_3="Capture Selection"

option_time_1="5s"
option_time_2="10s"
option_time_3="20s"
option_time_4="30s"
option_time_5="60s"

list_col='1'
list_row='2'

copy='Copy'
save='Save'
copy_save='Copy & Save'
edit='Edit'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 2 -width 30 -p "Take screenshot"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2" | rofi_cmd
}

####
# Choose Timer
# CMD
timer_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 5 -width 30 -p "Choose timer"
}

# Ask for confirmation
timer_exit() {
    echo -e "$option_time_1\n$option_time_2\n$option_time_3\n$option_time_4\n$option_time_5" | timer_cmd
}

# Confirm and execute
timer_run() {
    selected_timer="$(timer_exit)"
    if [[ "$selected_timer" == "$option_time_1" ]]; then
        countdown=5
        ${1}
    elif [[ "$selected_timer" == "$option_time_2" ]]; then
        countdown=10
        ${1}
    elif [[ "$selected_timer" == "$option_time_3" ]]; then
        countdown=20
        ${1}
    elif [[ "$selected_timer" == "$option_time_4" ]]; then
        countdown=30
        ${1}
    elif [[ "$selected_timer" == "$option_time_5" ]]; then
        countdown=60
        ${1}
    else
        exit
    fi
}
###

####
# Chose Screenshot Type
# CMD
type_screenshot_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 3 -width 30 -p "Type of screenshot"
}

# Ask for confirmation
type_screenshot_exit() {
  echo -e "$option_capture_1\n$option_capture_2\n$option_capture_3" | type_screenshot_cmd
}

# Confirm and execute
type_screenshot_run() {
    selected_type_screenshot="$(type_screenshot_exit)"
    if [[ "$selected_type_screenshot" == "$option_capture_1" ]]; then
        option_type_screenshot=screen
        ${1}
    elif [[ "$selected_type_screenshot" == "$option_capture_2" ]]; then
        option_type_screenshot=output
        ${1}
    elif [[ "$selected_type_screenshot" == "$option_capture_3" ]]; then
        option_type_screenshot=area
        ${1}
    else
        exit
    fi
}
###

####
# Choose to save or copy photo
# CMD
copy_save_editor_cmd() {
    rofi -dmenu -replace -config ~/.config/rofi/config-screenshot.rasi -i -no-show-icons -l 4 -width 30 -p "How to save"
}

# Ask for confirmation
copy_save_editor_exit() {
    echo -e "$copy\n$save\n$copy_save\n$edit" | copy_save_editor_cmd
}

# Confirm and execute
copy_save_editor_run() {
    selected_chosen="$(copy_save_editor_exit)"
    if [[ "$selected_chosen" == "$copy" ]]; then
        option_chosen=copy
        ${1}
    elif [[ "$selected_chosen" == "$save" ]]; then
        option_chosen=save
        ${1}
    elif [[ "$selected_chosen" == "$copy_save" ]]; then
        option_chosen=copysave
        ${1}
    elif [[ "$selected_chosen" == "$edit" ]]; then
        option_chosen=edit
        ${1}
    else
        exit
    fi
}
###

timer() {
    if [[ $countdown -gt 10 ]]; then
        notify-send -t 1000 "Taking screenshot in ${countdown} seconds"
        countdown_less_10=$((countdown - 10))
        sleep $countdown_less_10
        countdown=10
    fi
    while [[ $countdown -ne 0 ]]; do
        notify-send -t 1000 "Taking screenshot in ${countdown} seconds"
        countdown=$((countdown - 1))
        sleep 1
    done
}

# take shots
takescreenshot() {
    sleep 1
    grimblast --notify "$option_chosen" "$option_type_screenshot" $NAME
    if [ -f $HOME/$NAME ] ;then
        if [ -d $screenshot_folder ] ;then
            mv $HOME/$NAME $screenshot_folder/
        fi
    fi
}

takescreenshot_timer() {
    sleep 1
    timer
    grimblast --notify "$option_chosen" "$option_type_screenshot" $NAME
    if [ -f $HOME/$NAME ] ;then
        if [ -d $screenshot_folder ] ;then
            mv $HOME/$NAME $screenshot_folder/
        fi
    fi
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        type_screenshot_run
        copy_save_editor_run "takescreenshot"
    elif [[ "$1" == '--opt2' ]]; then
        timer_run
        type_screenshot_run
        copy_save_editor_run "takescreenshot_timer"
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
    run_cmd --opt1
    ;;
$option_2)
    run_cmd --opt2
    ;;
esac