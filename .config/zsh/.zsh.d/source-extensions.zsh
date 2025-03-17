# Source autosuggestions if available
SYSTEM_PACKAGE="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
BREW_PACKAGE="/home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -f $SYSTEM_PACKAGE ]; then 
	source $SYSTEM_PACKAGE
elif [ -f $BREW_PACKAGE ]; then
	source $BREW_PACKAGE
fi

# Configure autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

# source syntax highlighting if available
SYSTEM_PACKAGE="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 
BREW_PACKAGE="/home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 

if [ -f $SYSTEM_PACKAGE ]; then
	source $SYSTEM_PACKAGE
elif [ -f $BREW_PACKAGE ]; then
	source $BREW_PACKAGE
fi
