#!/usr/bin/env bash
set -ouex pipefail

# Terra repos
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

sudo dnf5 -y copr enable dusansimic/themes
sudo dnf5 -y copr enbale che/nerd-fonts

sudo dnf5 -y upgrade --refresh

PACKAGES=(
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  gcc
  g++
  git-crypt
  bat
  bat-extras
  eza
  starship
  morewaita-icon-theme
  neovim
  lazygit
  git-delta
  git-crypt
  npm
  bun
  golang
  perf
  binutils-gprofng
  openssh-askpass
  btop
  wl-clipboard
  nerd-fonts
  steam
  bpftune
  podman-compose
)

sudo dnf5 -y install "${PACKAGES[@]}"

REMOVE=(
  firefox
  firefox-langpacks
)

# Remove excluded packages if they are installed
if [[ "${#REMOVE[@]}" -gt 0 ]]; then
  readarray -t INSTALLED_EXCLUDED < <(rpm -qa --queryformat='%{NAME}\n' "${REMOVE[@]}" 2>/dev/null || true)
  if [[ "${#INSTALLED_EXCLUDED[@]}" -gt 0 ]]; then
    sudo dnf -y remove "${INSTALLED_EXCLUDED[@]}"
  else
    echo "No excluded packages found to remove."
  fi
fi

# Docker
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
dnf -y install --enablerepo=docker-ce-stable \
  containerd.io \
  docker-buildx-plugin \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin \
  docker-model-plugin

# VPN Forticlient

sudo dnf config-manager --add-repo https://repo.fortinet.com/repo/forticlient/7.4/centos/8/os/x86_64/fortinet.repo

sudo dnf5 install forticlient

# Enable systemd thingies
sudo systemctl enable --now bpftune
sudo systemctl enable --now docker.socket
sudo systemctl enable --now podman.socket
