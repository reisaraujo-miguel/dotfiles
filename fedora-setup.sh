#!/usr/bin/env bash
set -ouex pipefail

# Terra repos
if ! dnf repo list | grep terra; then
  sudo dnf5 install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

sudo dnf5 -y copr enable atim/starship
sudo dnf5 -y copr enable dusansimic/themes
sudo dnf5 -y copr enable che/nerd-fonts

sudo dnf5 -y upgrade --refresh

PACKAGES=(
  ghostty
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
  ptyxis
  firefox
  firefox-langpacks
)

# Remove excluded packages if they are installed
if [[ "${#REMOVE[@]}" -gt 0 ]]; then
  readarray -t INSTALLED_EXCLUDED < <(rpm -qa --queryformat='%{NAME}\n' "${REMOVE[@]}" 2>/dev/null || true)
  if [[ "${#INSTALLED_EXCLUDED[@]}" -gt 0 ]]; then
    sudo dnf5 -y remove "${INSTALLED_EXCLUDED[@]}"
  else
    echo "No excluded packages found to remove."
  fi
fi

# Docker
if ! dnf repo list | grep "docker-ce"; then
  sudo dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
fi

sudo dnf5 -y install \
  containerd.io \
  docker-buildx-plugin \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin \
  docker-model-plugin

sudo usermod -a -G docker "$USER"

# VPN Forticlient

if ! dnf repo list | grep "fortinet"; then
  sudo dnf5 config-manager addrepo --from-repofile=https://repo.fortinet.com/repo/forticlient/7.4/centos/8/os/x86_64/fortinet.repo
fi

sudo dnf5 -y install forticlient

# Enable systemd thingies
sudo systemctl enable --now bpftune
sudo systemctl enable --now docker.socket
sudo systemctl enable --now podman.socket
