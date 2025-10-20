#!/bin/env zsh

# Function to add to PATH if not already present
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Add local bin to path
add_to_path "$HOME/.local/bin"

# Configure npm
if command -v npm &>/dev/null; then
    NPM_CONFIG_PREFIX="$HOME/.npm-global"
    mkdir -p "$NPM_CONFIG_PREFIX/lib" "$NPM_CONFIG_PREFIX/bin"

    add_to_path "$NPM_CONFIG_PREFIX/bin"
fi

# Add brew to path
if [ -d /home/linuxbrew/.linuxbrew/bin/ ]; then
    add_to_path /home/linuxbrew/.linuxbrew/bin
    add_to_path /home/linuxbrew/.linuxbrew/sbin
fi

# Add my scripts to path
if [ -d "$HOME/scripts" ]; then
    add_to_path "$HOME/scripts"
fi

# Add bun
if command -v bun &>/dev/null; then
    mkdir -p "$HOME/.bun/bin"
    export BUN_INSTALL="$HOME/.bun"
    add_to_path "$BUN_INSTALL/bin"

    # bun completions
    [[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
fi

# Add deno
if command -v deno &>/dev/null; then
    mkdir -p "$HOME/.deno/bin"
    add_to_path "$HOME/.deno/bin"

    [[ -s "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

fi

# Add android tools
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"

    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/platform-tools"
fi

# Add kitty
if [ -d "$HOME/.local/kitty.app" ]; then
    add_to_path "$HOME/.local/kitty.app/bin"
fi

# Add cargo
if command -v cargo &>/dev/null; then
    mkdir -p "$HOME/.cargo/bin"
    add_to_path "$HOME/.cargo/bin"

    [[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
fi

# Add flutter
if command -v flutter &>/dev/null; then
    mkdir -p "$HOME/.flutter/bin"
    add_to_path "$HOME/.flutter/bin"
fi

# Add golang
if command -v go &>/dev/null; then
    add_to_path "$GOPATH/bin"
fi

export PATH
