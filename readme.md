# dotfiles

## Palette switching

- Waybar palette entrypoint: `waybar/style/palette.css`
- Hyprland palette entrypoint: `hypr/config/palette/current.conf`
- Waybar themes: `waybar/style/palettes/`
- Hyprland themes: `hypr/config/palette/`

The entrypoint files each point to one active theme file.

Switch options:

- Edit one line in each entrypoint file.
- Or use: `~/.config/hypr/scripts/palette-switch.sh olive --reload`
- Or use: `~/.config/hypr/scripts/palette-switch.sh mocha --reload`
- Or use: `~/.config/hypr/scripts/palette-switch.sh blue-grotto --reload`
