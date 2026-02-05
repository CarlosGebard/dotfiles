#!/bin/bash

options=(
  "Pantalla Principal"
  "Segunda Pantalla 1080p"
  "Segunda Pantalla 2K"
  "Extendido"
  "Duplicado"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Pantallas:")

case "$choice" in
  "Pantalla Principal")
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    hyprctl keyword monitor "HDMI-A-1,disable"
    ;;

  "Segunda Pantalla 1080p")
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1"
    hyprctl keyword monitor "eDP-1,disable"
    ;;

  "Segunda Pantalla 2K")
    hyprctl keyword monitor "HDMI-A-1,2560x1440@60,0x0,1"
    hyprctl keyword monitor "eDP-1,disable"
    ;;

   "Extendido")
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,3840x0,1"
    ;;

  "Duplicado")
    hyprctl keyword monitor "eDP-1,3840x2160@60,0x0,2"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1"
    ;;

  *)
    exit 0
    ;;
esac
