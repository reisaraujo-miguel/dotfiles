# Source autosuggestions if available
autosuggestions_plugin="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f $autosuggestions_plugin ]] && source $autosuggestions_plugin

# Configure autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

# source syntax highlighting if available
syntax_highlighting_plugin="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Must be at last
[[ -f $syntax_highlighting_plugin ]] && source $syntax_highlighting_plugin
