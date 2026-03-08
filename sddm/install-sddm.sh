#!/bin/bash
set -e

DOT="$HOME/dotfiles/sddm"

echo "▶ Instalando tema SDDM..."
sudo cp -r $DOT/themes/* /usr/share/sddm/themes/

echo "▶ Instalando sddm.conf..."
sudo cp $DOT/config/sddm.conf /etc/sddm.conf

echo "✔ SDDM restaurado"
