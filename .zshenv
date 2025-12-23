#!/usr/bin/env zsh

# configure bitwarden ssh
BITWARDEN_NATIVE_SOCK="$HOME/.bitwarden-ssh-agent.sock"
BITWARDEN_FLATPAK_SOCK="$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"

if [[ -r "$BITWARDEN_NATIVE_SOCK" ]]; then
  export SSH_AUTH_SOCK="$BITWARDEN_NATIVE_SOCK"
elif [[ -r "$BITWARDEN_FLATPAK_SOCK" ]]; then
  export SSH_AUTH_SOCK="$BITWARDEN_FLATPAK_SOCK"
fi

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

export SYSTEM=$(uname -s)

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ("$SHLVL" -eq 1 && ! -o LOGIN) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

if [[ -d "/usr/lib/python3.13/site-packages/argcomplete/bash_completion.d" ]]; then
  # Begin added by argcomplete
  fpath=(/usr/lib/python3.13/site-packages/argcomplete/bash_completion.d "${fpath[@]}")
  # End added by argcomplete
fi

if [[ -d "/home/linuxbrew/.linuxbrew/share/zsh/site-functions" ]]; then
  # Begin added by argcomplete
  fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions "${fpath[@]}")
  # End added by argcomplete
fi

if [[ -f "$HOME/.makepkg.conf" ]]; then
  export MAKEPKG_CONF="$HOME/.makepkg.conf"
fi

declare -a editors=("nvim" "vim" "nano" "vi")

for editor in "${editors[@]}"; do
  if command -v "$editor" >/dev/null 2>&1; then
    export EDITOR="$editor"
    export VISUAL="$editor"
    break
  fi
done

export PATH=$PATH:${HOME}/.bin
export PATH=$HOME/bin:/usr/local/bin:$PATH

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"} && mkdir -p "$XDG_DATA_HOME"
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"} && mkdir -p "$XDG_CACHE_HOME"
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"} && mkdir -p "$XDG_CONFIG_HOME"
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"} && mkdir -p "$XDG_STATE_HOME"

export LESSHISTFILE=-

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$XDG_DATA_HOME/zsh-history"
export HISTSIZE=10000
export SAVEHIST=10000

if [[ -d "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
