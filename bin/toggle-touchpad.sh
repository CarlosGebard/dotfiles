#!/bin/bash

ID=$(xinput list | grep -i "SYNA8004" | sed 's/.*id=\([0-9]\+\).*/\1/')

STATE=$(xinput list-props "$ID" | grep "Device Enabled" | awk '{print $4}')

if [ "$STATE" = "1" ]; then
    xinput disable "$ID"
    notify-send "Touchpad desactivado"
else
    xinput enable "$ID"
    notify-send "Touchpad activado"
fi
