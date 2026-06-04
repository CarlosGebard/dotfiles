#!/bin/bash

set -u

notify_error() {
  local message="$1"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Screen Manager" "$message"
  fi

  printf '%s\n' "$message" >&2
}

require_command() {
  local cmd="$1"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    notify_error "Falta dependencia requerida: $cmd"
    exit 1
  fi
}

apply_layout() {
  local layout_name="$1"
  shift

  local commands=()
  local command_string=""
  local exit_code=0
  local output
  local status

  for monitor_rule in "$@"; do
    commands+=("keyword monitor $monitor_rule")
  done

  command_string=$(printf ' ; %s' "${commands[@]}")
  command_string=${command_string#' ; '}

  output=$(hyprctl --batch "$command_string" 2>&1)
  status=$?

  if [ $status -ne 0 ] || [[ "$output" == error* ]] || [[ "$output" == *$'\nerror'* ]]; then
    exit_code=$status
    if [ $exit_code -eq 0 ]; then
      exit_code=1
    fi
    notify_error "No se pudo aplicar '$layout_name': $output"
    exit $exit_code
  fi
}

require_command rofi
require_command hyprctl

options=(
  "Pantalla Principal"
  "Segunda Pantalla 1080p"
  "Segunda Pantalla 2K"
  "Segunda Pantalla 4K"
  "UltraWide"
  "Extendido"
  "Stream"
  "Duplicado"
)

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Pantallas:")

if [ $? -ne 0 ] || [ -z "${choice:-}" ]; then
  exit 0
fi

case "$choice" in
"Pantalla Principal")
  apply_layout "$choice" \
    "eDP-1,2560x1440@60,0x0,1.25" \
    "DP-2,disable"
  ;;

"Segunda Pantalla 1080p")
  apply_layout "$choice" \
    "HDMI-A-1,1920x1080@60,0x0,1" \
    "eDP-1,disable"
  ;;

"Segunda Pantalla 2K")
  apply_layout "$choice" \
    "HDMI-A-1,2560x1440@60,0x0,1" \
    "eDP-1,disable"
  ;;

"Segunda Pantalla 4K")
  apply_layout "$choice" \
    "HDMI-A-1,3840x2160@60,0x0,2" \
    "eDP-1,disable"
  ;;

"UltraWide")
  apply_layout "$choice" \
    "eDP-1,disable" \
    "HDMI-A-1,2560x1080@60,0x0,1"
  ;;

"Extendido")
  apply_layout "$choice" \
    "eDP-1,1920x1080@60,0x0,1" \
    "DP-2,1920x1080@60,5000x0,1"
  ;;

"Stream")
  apply_layout "$choice" \
    "eDP-1,1280x720@60,0x0,1" \
    "HDMI-A-1,1920x1080@60,5000x0,1"
  ;;

"Duplicado")
  apply_layout "$choice" \
    "eDP-1,3840x2160@60,0x0,2" \
    "HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1"
  ;;

*)
  notify_error "Opcion de pantalla no reconocida: $choice"
  exit 1
  ;;
esac
