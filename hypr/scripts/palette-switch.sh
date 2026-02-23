#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

theme="${1:-}"

if [[ -z "$theme" ]]; then
    echo "Usage: $0 <olive|mocha|blue-grotto|liquid-glass> [--reload]" >&2
    exit 1
fi

reload="false"
if [[ "${2:-}" == "--reload" || "${1:-}" == "--reload" ]]; then
    reload="true"
fi

waybar_palette_file="$HOME/.config/waybar/style/palette.css"
hypr_palette_file="$HOME/.config/hypr/config/palette/current.conf"

case "$theme" in
    olive)
        waybar_theme="olive"
        hypr_theme="olive"
        ;;
    mocha)
        waybar_theme="mocha"
        hypr_theme="legacy"
        ;;
    blue-grotto)
        waybar_theme="blue-grotto"
        hypr_theme="blue-grotto"
        ;;
    liquid-glass)
        waybar_theme="liquid-glass"
        hypr_theme="liquid-glass"
        ;;
    *)
        echo "Unknown theme: $theme" >&2
        echo "Supported themes: olive, mocha, blue-grotto, liquid-glass" >&2
        exit 1
        ;;
esac

printf '@import "palettes/%s.css";\n' "$waybar_theme" > "$waybar_palette_file"
printf 'source = ~/.config/hypr/config/palette/%s.conf\n' "$hypr_theme" > "$hypr_palette_file"

echo "Switched theme: $theme"
echo "Waybar palette -> $waybar_theme"
echo "Hyprland palette -> $hypr_theme"

if [[ "$reload" == "true" ]]; then
    bash "$HOME/.config/hypr/scripts/waybar-reload.sh" --reload
fi
