# Source autosuggestions if available
if [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then 
	source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/zsh-autosuggestions.zsh" ]; then
	source "/home/linuxbrew/.linuxbrew/bin/zsh-autosuggestions.zsh"
fi

# Configure autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

# source syntax highlighting if available
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"]; then
	source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/zsh-syntax-highlighting.zsh" ]; then
	source "/home/linuxbrew/.linuxbrew/bin/zsh-syntax-highlighting.zsh"
fi
