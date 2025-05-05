#!/bin/zsh

if [[ -f "$HOME/.avante/deepseek_api_key" ]]; then
	export DEEPSEEK_API_KEY=$(cat "$HOME/.avante/deepseek_api_key")
fi
