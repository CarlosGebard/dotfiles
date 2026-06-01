# Waybar Wallpaper Palette

## Goal
Generate Waybar colors from the current wallpaper and apply them to the active bar.

## Scope
- Add a local Waybar script for palette generation.
- Make Waybar CSS consume generated color variables.
- Keep modules square and the main bar transparent.
- Validate JSON, script syntax, and generated CSS.

## Assumptions
- Hyprpaper is the wallpaper source.
- ImageMagick is available as `magick`.
- The configured wallpaper path may move between local media folders, so the script should resolve common path drift.

## Steps
1. Detect the wallpaper path from Hyprpaper config.
2. Extract a compact palette with ImageMagick.
3. Write `.config/waybar/colors.css`.
4. Update `style.css` to import variables and apply them to all configured Waybar modules.
5. Add a reload option for Waybar.

## Validation
- `jq empty .config/waybar/config`
- `bash -n .config/waybar/scripts/waybar-wallpaper-colors`
- Run the script and inspect generated `.config/waybar/colors.css`.

## Risks
- Wallpaper paths with spaces need careful parsing.
- Some icon colors are embedded in Waybar JSON spans and cannot be changed from CSS without editing config formats.
