if [ -z "$PS1" ]; then
	return
fi

if [[ $- == *i* ]]; then
	exec zsh
fi
