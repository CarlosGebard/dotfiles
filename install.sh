#!/usr/bin/env bash
set -euo pipefail

DOT="${DOTFILES_DIR:-$HOME/dotfiles}"

say() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

need_dir() {
  [[ -d "$1" ]] || die "No existe: $1"
}

backup_path() {
  local p="$1"
  [[ -e "$p" || -L "$p" ]] || return 0
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  mv -f "$p" "${p}.bak-${ts}"
  say "  ↪ backup: $p -> ${p}.bak-${ts}"
}

link_dir() {
  local src="$1" dst="$2"
  need_dir "$src"
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst")"
    if [[ "$cur" == "$src" ]]; then
      say "  ✓ ya linkeado: $dst -> $src"
      return 0
    fi
  fi

  backup_path "$dst"
  ln -s "$src" "$dst"
  say "  ✓ link: $dst -> $src"
}

link_file() {
  local src="$1" dst="$2"
  [[ -f "$src" ]] || die "No existe archivo: $src"
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst")"
    if [[ "$cur" == "$src" ]]; then
      say "  ✓ ya linkeado: $dst -> $src"
      return 0
    fi
  fi

  backup_path "$dst"
  ln -s "$src" "$dst"
  say "  ✓ link: $dst -> $src"
}

gen_pkglist() {
  mkdir -p "$DOT/pkglist"
  pacman -Qqe  > "$DOT/pkglist/pacman.txt"
  pacman -Qqem > "$DOT/pkglist/aur.txt"
  say "  ✓ pkglist actualizado: pkglist/pacman.txt y pkglist/aur.txt"
}

main() {
  need_dir "$DOT"
  say "== Install dotfiles =="
  say "DOT=$DOT"

  # 1) ~/.config apps (symlinks por carpeta)
  mkdir -p "$HOME/.config"
  for app in fastfetch hypr waybar rofi kitty; do
    if [[ -d "$DOT/.config/$app" ]]; then
      link_dir "$DOT/.config/$app" "$HOME/.config/$app"
    else
      say "  ! omitido (no existe): $DOT/.config/$app"
    fi
  done

  # 2) ~/.local/bin -> ~/dotfiles/bin (un solo symlink)
  if [[ -d "$DOT/bin" ]]; then
    mkdir -p "$HOME/.local"
    link_dir "$DOT/bin" "$HOME/.local/bin"
  else
    say "  ! omitido (no existe): $DOT/bin"
  fi

  # 3) Package lists (pacman + aur) si pacman está disponible
  if command -v pacman >/dev/null 2>&1; then
    gen_pkglist
  else
    say "  ! pacman no encontrado; no se generó pkglist"
  fi

  say ""
  say "== Listo =="
  say "SDDM: se instala aparte con sudo usando: $DOT/install-sddm.sh"
}

main "$@"
