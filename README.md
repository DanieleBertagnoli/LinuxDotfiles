# Linux Dotfiles 🐧
These are my personal dotfiles for setting up fastly my systems after a fresh installation. In each distribution's folder a `install.sh` file is available, these are designed to guide you step-by-step during the installation as some manual steps may be required. These dotfiles are useful to install quickly some essential programs and themes to make your system prettier.

Please feel free to open issues or contact me to discuss about possible bugs, problems or improvements. 

## Ubuntu dotfiles &nbsp; <img src="Images/ubuntu.png" width="30">
These dotfiles are used to set up Ubuntu-GNOME systems (you can slightly modify some commands to adapt it to any Debian-based distribution). To run the setup, simply run the commands:

```ssh
# Clone the repository
git clone https://github.com/DanieleBertagnoli/LinuxDotfiles
cd LinuxDotfiles

# Make the script executable
sudo chmod +x Ubuntu/install.sh

# Run the script
./Ubuntu/install.sh
```

### **Select Themes**

This step can be skipped since is performed by the script, however if you don't like the installed themes, you can manually change them through this step. Open *Gnome Tweaks* and select from the left menu: "Appearance". 
Now you can select the theme for each element in the list:
- Applications: Folder /usr/share/themes
- Cursor: /usr/share/icons
- Icons: /usr/share/icons
- Shell: /usr/share/themes (if you cannot edit this field, be sure that all the previous steps have been followed!) 


## Arch - Hyprland dotfiles &nbsp; <img src="Images/arch.png" width="30"> + <img src="Images/hyprland.png" width="80">

These dotfiles are built upon the huge GitHub project [ML4FW Dotfiles](https://github.com/mylinuxforwork/dotfiles). Indeed, I strongly recommend to see the detailed [wiki](https://github.com/mylinuxforwork/dotfiles/wiki) written by the author to customize and modify the system. My dotfiles are done to remove some unwanted packages and to install some useful packages. I also ship some custom configurations such as the monitors one and a modified .bashrc file. To run the installation script (shortcut to the ML4W installtion command), run the following commands:

```ssh
# Clone the repository
git clone https://github.com/DanieleBertagnoli/LinuxDotfiles
cd LinuxDotfiles

# Make the script executable
sudo chmod +x ArchHyprland/install*

# Run the script
./ArchHyprland/install.sh
```

After that you can run the post-installation script that allows you to install/remove additional packages and custom configurations:

```ssh
# Run the script
./ArchHyprland/install_configs.sh
```

After that, run the ML4W Welcome application and go to `Settings>System>Monitor Variations>System` and from `Monitor Variations` choose `my_monitors.conf`. You can also modify the monitors resolutions and setup (if you have more than one monitor) by modifying that configuration file (follow the official [Hyprland Wiki](https://wiki.hyprland.org/Configuring/Monitors/)).


## Issues 🚨
Feel free to contact me or open a public issue. Help me improve the project!