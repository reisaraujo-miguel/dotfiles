#!/usr/bin/env bash
set -ouex pipefail

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

INSTALL=(
  app.zen_browser.zen
  org.gnome.World.PikaBackup
  com.bitwarden.desktop
  dev.vencord.Vesktop
  org.telegram.desktop
  com.mattjakeman.ExtensionManager
  org.gtk.Gtk3theme.adw-gtk3
  org.gtk.Gtk3theme.adw-gtk3-dark
)

flatpak install flathub "${INSTALL[@]}"
