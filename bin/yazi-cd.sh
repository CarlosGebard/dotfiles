#!/usr/bin/env bash

tmp="$(mktemp)"

yazi --cwd-file="$tmp" "$@"

if cwd="$(cat "$tmp")" && [ -n "$cwd" ]; then
  cd "$cwd"
fi

rm -f "$tmp"

exec $SHELL
