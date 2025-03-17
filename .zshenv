#!/usr/bin/env zsh

export SHELL=/bin/zsh

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
