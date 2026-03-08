#!/bin/bash

STATE_FILE="/tmp/gammastep_state"

if pgrep -x gammastep > /dev/null; then
    pkill gammastep
    rm -f "$STATE_FILE"
    notify-send "🌙 Luz cálida desactivada" "Pantalla restaurada a temperatura normal"
else
    gammastep -O 4500 &
    touch "$STATE_FILE"
    notify-send "☀️ Luz cálida activada" "Temperatura fijada en 4500K"
fi
