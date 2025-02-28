# Check if bash is running in interactive mode and not as a login shell
if [[ $- == *i* ]] && [[ -z "$BASH_EXECUTION_STRING" ]] && [[ "$0" == *bash ]]; then
    # Check if zsh is installed
    if command -v zsh >/dev/null 2>&1; then
        exec zsh
    fi
fi

