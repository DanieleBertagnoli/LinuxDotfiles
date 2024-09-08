# Linux Dotfiles 🐧
These are my personal dotfiles for quickly setting up my systems after a fresh installation. In each distribution's folder, you'll find an `install.sh` file, designed to guide you step-by-step through the installation process. These dotfiles help install essential programs and themes to enhance both functionality and appearance.

Feel free to open issues or contact me to discuss any bugs, problems, or potential improvements.

## Roadmap
- [ ] Refactor Ubuntu dotfiles
- [ ] Adapt Arch dotfiles to clean Arch installtions (up to now works only for EndevourOS)
- [x] ArchHyprland: Add Bluetooth support and laptop configuration
- [ ] Update Wiki

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

### Select Themes

This step can be automatically done through the script, however if you don't like the installed themes, you can manually change them through this step. Open *Gnome Tweaks* and select from the left menu: "Appearance". 
Now you can select the theme for each element in the list:
- Applications: `/usr/share/themes`
- Cursor: `/usr/share/icons`
- Icons: `/usr/share/icons`
- Shell: `/usr/share/themes`

If you want to add more themes, just download them from [Gnome Look Official Website](https://www.gnome-look.org/) and place the elements in the right folder as indicated in the list. 

### Wallpapers

We also ship a set of wallpapers that will be copied into `~/Pictures/Wallpapers`. 

## Arch - Hyprland dotfiles &nbsp; <img src="Images/arch.png" width="30"> + <img src="Images/hyprland.png" width="80">

These dotfiles are built inspired by the huge GitHub project [ML4FW Dotfiles](https://github.com/mylinuxforwork/dotfiles). My dotfiles are developed to reduce the useless packages, providing a lighter installation, yet fully configured and customizable. To start, run the following commands
```ssh
# Clone the repository
git clone https://github.com/DanieleBertagnoli/LinuxDotfiles
cd LinuxDotfiles/ArchHyprland

# Run the script
./install.sh
```

For all the settings and customizations, follow the Wiki.


## Issues 🚨
Feel free to contact me or open a public issue. Help me improve the project!

## Changelog
For the full changelog, see [CHANGELOG.md](CHANGELOG.md).
