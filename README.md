# dotfiles
My dotfiles

# Wallpaper
https://wall.alphacoders.com/big.php?i=1318416

# Usefull commands
- find ./ -type f -exec sed -i '' -e 's/watchbook/feedkeep/g' {} \;

## Desktop Setup
- Desktop: Hyprland
    - Bar: Waybar
    - Notifications: [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- Menus: rofi
- File Manager: [Thunar](https://wiki.archlinux.org/title/Thunar)

### Maybe
- [awww](https://codeberg.org/LGFae/awww)
- [hyprwm/hyprpaper](https://github.com/hyprwm/hyprpaper)
- [hyprwm/hyprlauncher](https://github.com/hyprwm/hyprlauncher)

### Inspiration
- [hyprdots](https://github.com/erdajt/hyprdots)
- [Narsell/dotfiles](https://github.com/Narsell/dotfiles)
- [mastermach50/Hyprland-Waybar-Dots](https://github.com/mastermach50/Hyprland-Waybar-Dots)
- [harsh-m-patil/.dotfiles](https://github.com/harsh-m-patil/.dotfiles)
- [Jan-Aarela/dotfiles](https://github.com/Jan-Aarela/dotfiles)
- [Zilero232/arch-install-kit](https://github.com/Zilero232/arch-install-kit)
- [newemperor221/hyprland-dotfiles](https://github.com/newemperor221/hyprland-dotfiles)
- [Alexays/Waybar/Examples](https://github.com/Alexays/Waybar/wiki/Examples)

## TODO
- Setup kenshi

```bash
# kenshi example config for steam deck

# Profile 1: Only the Steam Deck (Undocked)
profile {
    output eDP-1 enable mode auto position 0,0 transform 270 scale 1.0
}

# Profile 2: External Monitor Connected (Docked)
profile {
    output eDP-1 disable
    output * enable mode auto position auto scale 1.0
}
```
