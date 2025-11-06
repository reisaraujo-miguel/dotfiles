#!/bin/env zsh

alias toolbox="SHELL=/bin/zsh toolbox"

if command -v nvim &>/dev/null; then
	alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
fi

if command -v eza &>/dev/null; then
	alias ls="eza --icons auto"
fi

if command -v lazygit &>/dev/null; then
	alias lg="lazygit"
fi

if command -v bat &>/dev/null; then
	export PAGER="bat --paging=always"
	export BAT_PAGER="less -R"

	# Optional: Create cat alias for bat with specific options
	alias cat="bat --paging=never --style=snip"
	alias less="bat --paging=always --style=auto"

	# Optional: Set batman as the pager for man pages
	# (fallback to bat if batman is not installed)
	if command -v batman &>/dev/null; then
		export MANPAGER="less -R"
		alias man="batman"
	else
		export MANPAGER="bat -l man -p'"
	fi
fi
