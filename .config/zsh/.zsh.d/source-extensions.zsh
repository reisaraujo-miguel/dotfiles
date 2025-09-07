#!/bin/env zsh

SYSTEM_PATH="/usr/share/zsh/plugins/"
SYSTEM_PATH_ALT="/usr/share/"
BREW_PATH="/home/linuxbrew/.linuxbrew/share/"

# Source autosuggestions if available
SYSTEM_PACKAGE="$SYSTEM_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh"
SYSTEM_PACKAGE_ALT="$SYSTEM_PATH_ALT/zsh-autosuggestions/zsh-autosuggestions.zsh"
BREW_PACKAGE="$BREW_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -f $SYSTEM_PACKAGE ]; then 
	source $SYSTEM_PACKAGE
elif [ -f $SYSTEM_PACKAGE_ALT ]; then
	source $SYSTEM_PACKAGE_ALT
elif [ -f $BREW_PACKAGE ]; then
	source $BREW_PACKAGE
fi

# Configure autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history)

# source syntax highlighting if available
SYSTEM_PACKAGE="$SYSTEM_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
SYSTEM_PACKAGE_ALT="$SYSTEM_PATH_ALT/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
BREW_PACKAGE="$BREW_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 

if [ -f $SYSTEM_PACKAGE ]; then
	source $SYSTEM_PACKAGE
elif [ -f $SYSTEM_PACKAGE_ALT ]; then
	source $SYSTEM_PACKAGE_ALT
elif [ -f $BREW_PACKAGE ]; then
	source $BREW_PACKAGE
fi
