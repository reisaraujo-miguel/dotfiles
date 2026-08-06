#!/usr/bin/env bash
set -ouex pipefail

# Terra repos
if ! dnf repo list | grep terra; then
  sudo dnf5 install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi

if ! dnf repo list | grep "rpmfusion-free "; then
  sudo dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm
fi

if ! dnf repo list | grep "rpmfusion-nonfree "; then
  sudo dnf5 install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
fi

# Swap ffmpeg-free with ffmpeg to get the full version
sudo dnf5 swap ffmpeg-free ffmpeg --allowerasing

# Install multimedia group without weak dependencies and exclude PackageKit-gstreamer-plugin
sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Install tainted firmware for proprietary drivers
sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

# Install mesa-va-drivers-freeworld for hardware video acceleration
sudo dnf5 install mesa-va-drivers-freeworld

# Install intel-media-driver for Intel GPU video acceleration
sudo dnf install intel-media-driver

sudo dnf5 -y copr enable atim/starship
sudo dnf5 -y copr enable dusansimic/themes
sudo dnf5 -y copr enable che/nerd-fonts

sudo dnf5 -y upgrade --refresh

PACKAGES=(
  ghostty

  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  bat
  bat-extras
  eza
  starship
  btop
  wl-clipboard

  steam
  morewaita-icon-theme
  adw-gtk3-theme
  nerd-fonts

  neovim
  lazygit
  git-delta
  git-crypt

  gcc
  g++
  npm
  bun
  golang
  cargo

  perf
  binutils-gprofng

  openssh-askpass
  bpftune
  ananicy-cpp
  podman-compose

  perl-FindBin
  perl-File-Compare
  perl-File-Copy
  perl-IPC-Cmd
)

sudo dnf5 -y install "${PACKAGES[@]}"

gsettings set org.gnome.desktop.interface icon-theme "MoreWaita"
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'

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
sudo systemctl enable --now ananicy-cpp.service
sudo systemctl enable --now docker.socket
sudo systemctl enable --now podman.socket
