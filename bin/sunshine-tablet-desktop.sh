#!/bin/bash

set -u

APP_NAME="Sunshine Tablet Desktop"

PHYSICAL_OUTPUT="${SUNSHINE_PHYSICAL_OUTPUT:-}"
PHYSICAL_MODE="${SUNSHINE_PHYSICAL_MODE:-preferred}"
PHYSICAL_POSITION="${SUNSHINE_PHYSICAL_POSITION:-0x0}"
PHYSICAL_SCALE="${SUNSHINE_PHYSICAL_SCALE:-auto}"
PHYSICAL_WORKSPACE="${SUNSHINE_PHYSICAL_WORKSPACE:-1}"

LAPTOP_OUTPUT="${SUNSHINE_LAPTOP_OUTPUT:-eDP-1}"
DISABLE_LAPTOP="${SUNSHINE_DISABLE_LAPTOP:-0}"

TABLET_OUTPUT="${SUNSHINE_TABLET_OUTPUT:-HEADLESS-2}"
TABLET_WIDTH="${SUNSHINE_CLIENT_WIDTH:-1280}"
TABLET_HEIGHT="${SUNSHINE_CLIENT_HEIGHT:-720}"
TABLET_FPS="${SUNSHINE_CLIENT_FPS:-30}"
TABLET_MODE="${TABLET_WIDTH}x${TABLET_HEIGHT}@${TABLET_FPS}"
TABLET_POSITION="${SUNSHINE_TABLET_POSITION:-5000x0}"
TABLET_SCALE="${SUNSHINE_TABLET_SCALE:-1}"
TABLET_WORKSPACES="${SUNSHINE_TABLET_WORKSPACES:-3 4}"
TABLET_WORKSPACE="${SUNSHINE_TABLET_WORKSPACE:-3}"

bootstrap_hyprland_env() {
  local sig

  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    return
  fi

  if [ ! -d /tmp/hypr ]; then
    return
  fi

  sig=$(find /tmp/hypr -mindepth 1 -maxdepth 1 -type d -printf '%T@ %f\n' 2>/dev/null | sort -nr | awk 'NR == 1 {print $2}')

  if [ -n "$sig" ]; then
    export HYPRLAND_INSTANCE_SIGNATURE="$sig"
  fi
}

notify_error() {
  local message="$1"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$APP_NAME" "$message" >/dev/null 2>&1 || true
  fi

  printf '%s\n' "$message" >&2
}

notify_info() {
  local message="$1"

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$APP_NAME" "$message" >/dev/null 2>&1 || true
  fi

  printf '%s\n' "$message"
}

require_command() {
  local cmd="$1"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    notify_error "Falta dependencia requerida: $cmd"
    exit 1
  fi
}

run_hyprctl_batch() {
  local action="$1"
  local command_string="$2"
  local output
  local status

  output=$(hyprctl --batch "$command_string" 2>&1)
  status=$?

  if [ $status -ne 0 ] || [[ "$output" == error* ]] || [[ "$output" == *$'\nerror'* ]]; then
    if [ $status -eq 0 ]; then
      status=1
    fi

    notify_error "No se pudo ${action}: $output"
    exit $status
  fi
}

headless_known() {
  hyprctl monitors all | grep -q "^Monitor ${TABLET_OUTPUT} "
}

tablet_active() {
  hyprctl monitors | grep -q "^Monitor ${TABLET_OUTPUT} "
}

ensure_headless() {
  if ! headless_known; then
    hyprctl output create headless "$TABLET_OUTPUT" >/dev/null 2>&1 || true
  fi
}

focused_monitor() {
  hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name' 2>/dev/null
}

first_active_monitor() {
  hyprctl monitors -j | jq -r '.[0].name' 2>/dev/null
}

resolve_physical_output() {
  if [ -n "$PHYSICAL_OUTPUT" ]; then
    return
  fi

  PHYSICAL_OUTPUT=$(focused_monitor)

  if [ -z "$PHYSICAL_OUTPUT" ] || [ "$PHYSICAL_OUTPUT" = "null" ]; then
    PHYSICAL_OUTPUT=$(first_active_monitor)
  fi

  if [ -z "$PHYSICAL_OUTPUT" ] || [ "$PHYSICAL_OUTPUT" = "null" ]; then
    notify_error "No se pudo detectar el monitor fisico. Define SUNSHINE_PHYSICAL_OUTPUT."
    exit 1
  fi
}

monitor_rules() {
  local rules

  rules="keyword monitor ${PHYSICAL_OUTPUT},${PHYSICAL_MODE},${PHYSICAL_POSITION},${PHYSICAL_SCALE}"
  rules="${rules} ; keyword monitor ${TABLET_OUTPUT},${TABLET_MODE},${TABLET_POSITION},${TABLET_SCALE}"

  if [ "$DISABLE_LAPTOP" = "1" ]; then
    rules="${rules} ; keyword monitor ${LAPTOP_OUTPUT},disable"
  fi

  printf '%s\n' "$rules"
}

tablet_workspace_rules() {
  local rules=""
  local workspace

  for workspace in $TABLET_WORKSPACES; do
    if [ -z "$rules" ]; then
      rules="keyword workspace ${workspace},monitor:${TABLET_OUTPUT},default:true"
    else
      rules="${rules} ; keyword workspace ${workspace},monitor:${TABLET_OUTPUT}"
    fi
  done

  printf '%s\n' "$rules"
}

return_tablet_workspaces_rule() {
  local rules=""
  local workspace

  for workspace in $TABLET_WORKSPACES; do
    if [ -z "$rules" ]; then
      rules="dispatch moveworkspacetomonitor ${workspace} ${PHYSICAL_OUTPUT}"
    else
      rules="${rules} ; dispatch moveworkspacetomonitor ${workspace} ${PHYSICAL_OUTPUT}"
    fi
  done

  printf '%s\n' "$rules"
}

tablet_on() {
  ensure_headless

  run_hyprctl_batch "activar monitor de tablet" "$(monitor_rules)"
  run_hyprctl_batch "asignar escritorio de tablet" \
    "$(tablet_workspace_rules) ; keyword workspace ${PHYSICAL_WORKSPACE},monitor:${PHYSICAL_OUTPUT},default:true ; dispatch focusmonitor ${TABLET_OUTPUT} ; dispatch workspace ${TABLET_WORKSPACE} ; dispatch focusmonitor ${PHYSICAL_OUTPUT} ; dispatch workspace ${PHYSICAL_WORKSPACE}"

  notify_info "Tablet activa en ${TABLET_OUTPUT} con workspace ${TABLET_WORKSPACE}"
}

tablet_off() {
  ensure_headless

  run_hyprctl_batch "restaurar escritorio principal" \
    "dispatch focusmonitor ${PHYSICAL_OUTPUT} ; dispatch workspace ${PHYSICAL_WORKSPACE} ; $(return_tablet_workspaces_rule) ; keyword monitor ${PHYSICAL_OUTPUT},${PHYSICAL_MODE},${PHYSICAL_POSITION},${PHYSICAL_SCALE} ; keyword monitor ${TABLET_OUTPUT},disable"

  if [ "$DISABLE_LAPTOP" = "1" ]; then
    run_hyprctl_batch "mantener panel laptop apagado" "keyword monitor ${LAPTOP_OUTPUT},disable"
  fi

  notify_info "Tablet desactivada"
}

tablet_status() {
  if tablet_active; then
    printf 'on: %s %s workspaces="%s" active_workspace=%s physical=%s\n' "$TABLET_OUTPUT" "$TABLET_MODE" "$TABLET_WORKSPACES" "$TABLET_WORKSPACE" "${PHYSICAL_OUTPUT:-auto}"
  else
    printf 'off: %s\n' "$TABLET_OUTPUT"
  fi
}

bootstrap_hyprland_env
require_command hyprctl
require_command jq

case "${1:-toggle}" in
on)
  resolve_physical_output
  tablet_on
  ;;
off)
  resolve_physical_output
  tablet_off
  ;;
toggle)
  resolve_physical_output
  if tablet_active; then
    tablet_off
  else
    tablet_on
  fi
  ;;
status)
  tablet_status
  ;;
*)
  notify_error "Uso: $0 [on|off|toggle|status]"
  exit 2
  ;;
esac
