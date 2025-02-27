alias ls="eza --icons auto"
alias toolbox="SHELL=/bin/zsh toolbox"

if command -v bat &> /dev/null; then
	export PAGER="bat --paging=always"
	export BAT_PAGER="less -R"
  
	# Optional: Create cat alias for bat with specific options
	alias cat="bat --paging=never"
  
	# Optional: Set batman as the pager for man pages 
	# (fallback to bat if batman is not instlled)
	if command -v batman &> /dev/null; then
		export MANPAGER="batman"
	else
		export MANPAGER="bat -l man -p'"
	fi
fi  
