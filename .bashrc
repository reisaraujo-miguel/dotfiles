# .bashrc

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"} && mkdir -p "$XDG_DATA_HOME"
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"} && mkdir -p "$XDG_CACHE_HOME"
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"} && mkdir -p "$XDG_CONFIG_HOME"
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"} && mkdir -p "$XDG_STATE_HOME"

export LESSHISTFILE=-

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ $HOME/.local/bin:$HOME/bin: ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$HOME/.ghcup/bin:$PATH"
fi

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

if command -v starship &>/dev/null; then
	eval "$(starship init bash)"
fi
