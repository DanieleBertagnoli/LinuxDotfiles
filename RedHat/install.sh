#!/bin/bash

#             .MMM..:MMMMMMM               
#           MMMMMMMMMMMMMMMMMM            
#           MMMMMMMMMMMMMMMMMMMM.         
#          MMMMMMMMMMMMMMMMMMMMMM         
#         ,MMMMMMMMMMMMMMMMMMMMMM:        
#         MMMMMMMMMMMMMMMMMMMMMMMM        
#   .MMMM'  MMMMMMMMMMMMMMMMMMMMMM                   _____  _    _ ______ _      
#  MMMMMM    `MMMMMMMMMMMMMMMMMMMM.                 |  __ \| |  | |  ____| |     
# MMMMMMMM      MMMMMMMMMMMMMMMMMM .                | |__) | |__| | |__  | |     
# MMMMMMMMM.       `MMMMMMMMMMMMM' MM.              |  _  /|  __  |  __| | |     
# MMMMMMMMMMM.                     MMMM             | | \ \| |  | | |____| |____ 
# `MMMMMMMMMMMMM.                 ,MMMMM.           |_|  \_\_|  |_|______|______|     
#  `MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.
#     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM  
#       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
#          MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
#             `MMMMMMMMMMMMMMMMMMMMMMMM:
#                 ``MMMMMMMMMMMMMMMMM'        
                              
      

script_dir=$(dirname $(realpath "$0"))

cd $script_dir

echo -e '\n\nInstalling fonts\n\n'

#Installing font
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

echo -e '\n\nFonts installed!\n\n'

cd $script_dir

echo -e '\n\nInstalling themes\n\n'

# Installing Icon theme
sudo yum install papirus-icon-theme.noarch

# Installing breeze cursor
sudo yum install breeze-cursor-theme.noarch

# Installing eza
sudo yum install eza

ls
echo $(pwd)

# Installing Starship
curl -sS https://starship.rs/install.sh | sh
cp -r ./CustomConf/.configs/* ~/.configs

# Copying .bashrc configurations
cp -r ./CustomConf/.bash* ~/

# Apply themes
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
