#!/bin/zsh

if [[ -f "$HOME/.avante/deepseek_api_key" ]]; then
	export DEEPSEEK_API_KEY=$(cat "$HOME/.avante/deepseek_api_key")
fi

if [[ -f "$HOME/.avante/google_search_api_key" ]]; then
	export GOOGLE_SEARCH_API_KEY=$(cat "$HOME/.avante/google_search_api_key")
fi

if [[ -f "$HOME/.avante/google_search_engine_id" ]]; then
	export GOOGLE_SEARCH_ENGINE_ID=$(cat "$HOME/.avante/google_search_engine_id")
fi
