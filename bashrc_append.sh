# Check if bash is running in interactive mode and not as a login shell
if [ -t 0 ] && [ "$PS1" ]; then
    if command -v zsh >/dev/null 2>&1; then
        exec zsh
    fi
fi
