#!/bin/bash
CURRENT=$(hyprctl -j devices | jq -r '.keyboards[] | select(.main==true) | .active_keymap')
notify-send "Layout activo" "$CURRENT"
