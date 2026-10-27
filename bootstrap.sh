#!/usr/bin/env bash
# Rebuild this machine on top of a fresh Omarchy install.
set -euo pipefail
cd "$(dirname "$0")"

# Full upgrade with the install, as Arch requires (no partial upgrades).
sudo pacman -Syu --needed --noconfirm git ansible

if [[ ! -f vars/local.yml ]]; then
  read -rp "Dotfiles repo URL (blank to skip): " dotfiles_repo
  read -rp "NAS server address (blank to skip): " nas_server
  nas_export=""
  [[ -n $nas_server ]] && read -rp "NAS export path: " nas_export
  cat > vars/local.yml <<VARS
dotfiles_repo: "$dotfiles_repo"
nas_server: "$nas_server"
nas_export: "$nas_export"
VARS
fi

ansible-playbook site.yml --ask-become-pass "$@"
