# Function to add to PATH if not already present
add_to_path() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# Add local bin to path
add_to_path "$HOME/.local/bin"

# Configure npm
if npm -v &> /dev/null; then
	NPM_CONFIG_PREFIX="$HOME/.npm-global"
	mkdir -p "$NPM_CONFIG_PREFIX/lib" "$NPM_CONFIG_PREFIX/bin"

	npm config set prefix "$NPM_CONFIG_PREFIX"

	add_to_path "$NPM_CONFIG_PREFIX/bin"
fi

# Add my scripts to path
if [ -d "$HOME/scripts" ]; then
    add_to_path "$HOME/scripts"
fi

# Add bun
if [ -d "$HOME/.bun" ]; then
    BUN_INSTALL="$HOME/.bun"
    add_to_path "$BUN_INSTALL/bin"

	# bun completions
	[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Add deno
if [ -d "$HOME/.deno" ]; then
    add_to_path "$HOME/.deno/bin"
    . "$HOME/.deno/env"
fi

# Add android tools
if [ -d "$HOME/Android/Sdk" ]; then
    ANDROID_HOME="$HOME/Android/Sdk"
    add_to_path "$ANDROID_HOME/emulator"
    add_to_path "$ANDROID_HOME/platform-tools"
fi

# Add kitty
if [ -d "$HOME/.local/kitty.app" ]; then
    add_to_path "$HOME/.local/kitty.app/bin"
fi

# Add cargo
if [ -d "$HOME/.cargo" ]; then
    add_to_path "$HOME/.cargo/bin"
    . "$HOME/.cargo/env"
fi

# Add flutter
if [ -d "$HOME/.flutter" ]; then
    add_to_path "$HOME/.flutter/bin"
fi

# Add golang
if [ ! -z "$GOPATH" ]; then
    add_to_path "$GOPATH/bin"
fi

export PATH

