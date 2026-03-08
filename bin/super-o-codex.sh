#!/usr/bin/env bash
set -euo pipefail

DIR="/home/carlos/Documents/05-Agents/gpttalk-agent"

# 1) Open the folder in the default file manager (best-effort).
if command -v xdg-open >/dev/null 2>&1; then
  (xdg-open "$DIR" >/dev/null 2>&1 &)
elif command -v gio >/dev/null 2>&1; then
  (gio open "$DIR" >/dev/null 2>&1 &)
fi

# 2) Start Codex in kitty, with cwd set to DIR.
if ! command -v kitty >/dev/null 2>&1; then
  echo "error: kitty no esta instalado (no se encontro 'kitty' en PATH)" >&2
  exit 127
fi

exec kitty --directory "$DIR" bash -lc "exec codex"
