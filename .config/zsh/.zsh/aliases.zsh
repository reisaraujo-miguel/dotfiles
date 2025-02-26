alias ls="eza --icons auto"
alias toolbox="SHELL=/bin/zsh toolbox"

if command -v bat &> /dev/null; then
	export PAGER="bat --paging=always"
	export BAT_PAGER="less -R"
  
	# Optional: Create cat alias for bat with specific options
	alias cat="bat --paging=never"
  
	# Optional: Set bat as the pager for man pages
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi  
