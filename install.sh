#!/bin/bash

# install.sh --help output
HELP_TEXT="\
Usage: ./install.sh [options]...
Options:
	-e \"file/dir\":		set file to be excluded from installation.
	-d \"dir\":		set dir to install to.
	-c:				copy files instead of creating symlinks.
	-h, --help:		show this help dialog."

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"               # Use the absolute path of the script directory
HOME_DIR=$HOME                                                             # Default installation directory
BACKUP_DIR="$DOTFILES_DIR/dotfiles_backup/dotfiles.$(date +%Y%m%d_%H%M%S)" # Backup directory for existing configs
EXCLUDE_FILES=".git .gitignore LICENSE README.md install.sh"               # Files/dirs to exclude

# Flag variables
EXCLUDE_FLAG=false
HOME_FLAG=false
COPY_FLAG=false
NO_BACKUP=false

# Parse command-line arguments
for arg in "$@"; do
	if $EXCLUDE_FLAG; then
		echo "Excluding $arg"
		EXCLUDE_FILES="$EXCLUDE_FILES $arg"
		EXCLUDE_FLAG=false
		continue
	elif $HOME_FLAG; then
		echo "Setting installation home as: $arg"
		HOME_DIR=$arg
		HOME_FLAG=false
		mkdir -p "$HOME_DIR"
		continue
	fi

	if [ "$arg" = "-e" ]; then
		EXCLUDE_FLAG=true
	elif [ "$arg" = "-d" ]; then
		HOME_FLAG=true
	elif [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
		echo "$HELP_TEXT"
		exit 0
	elif [ "$arg" = "-c" ]; then
		COPY_FLAG=true
	elif [ "$arg" = "--no-backup" ]; then
		NO_BACKUP=true
	else
		echo "Invalid option: $arg"
		exit 1
	fi
done

# Validate required arguments
if $HOME_FLAG; then
	echo "You need to pass a value to -d. Usage: -d \"dir\""
	exit 1
fi

HOME=$HOME_DIR

if $EXCLUDE_FLAG; then
	echo "You need to pass a value to -e. Usage: -e \"file/dir\""
	exit 1
fi

# create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ] && [ ! "$NO_BACKUP" ]; then
	mkdir -p "$BACKUP_DIR"
	echo "Created backup directory: $BACKUP_DIR"
fi

# Function to backup existing file/dir
backup_existing() {
	local target_path="$1"

	if [[ -L "$target_path" ]]; then
		return
	fi

	if [[ -f "$target_path" ]] || [[ -d "$target_path" ]]; then
		local backup_file
		backup_file="$BACKUP_DIR/$(basename "$target_path")"
		mv "$target_path" "$backup_file"
		echo "Backed up existing file: $target_path to $backup_file"
	fi
}

# Function to symlink or copy a file/dir
link_or_copy() {
	local source="$1"
	local target="$2"
	if "$COPY_FLAG"; then
		cp -r "$source" "$target"
		echo "Copied: $source -> $target"
	else
		ln -sf "$source" "$target"
		echo "Symlinked: $target -> $source"
	fi
}

# Process top-level dotfiles (non-recursive)
echo "Processing top-level dotfiles..."
for item in "$DOTFILES_DIR"/.[!.]* "$DOTFILES_DIR"/*; do
	[ ! -e "$item" ] && continue

	item_name=$(basename "$item")
	if [[ " $EXCLUDE_FILES " =~ [[:space:]]"$item_name"[[:space:]] ]]; then
		echo "Skipping excluded item: $item_name"
		continue
	fi

	if [ -f "$item" ]; then
		target_path="$HOME_DIR/$item_name"
		backup_existing "$target_path"
		link_or_copy "$item" "$target_path"
	fi
done

# Process .config directory (non-recursive)
echo "Processing .config directory..."
dir=".config"
source_dir="$DOTFILES_DIR/$dir"
target_dir="$HOME_DIR/$dir"

if [ -d "$source_dir" ]; then
	mkdir -p "$target_dir"
	echo "Created directory: $target_dir"

	for item in "$source_dir"/*; do
		[ ! -e "$item" ] && continue

		item_name=$(basename "$item")
		target_path="$target_dir/$item_name"
		backup_existing "$target_path"
		link_or_copy "$item" "$target_path"
	done
fi

# Add git Configurations
if command -v git &>/dev/null; then
	echo "Configuring git"

	if [[ ! -e "$HOME/.gitconfig" ]]; then
		read -rp "Set git credentials? [y/n]: " SET_CREDENTIALS
	fi

	if [[ "$SET_CREDENTIALS" == "y" ]]; then
		read -rp "User email: " GIT_EMAIL
		read -rp "User name: " GIT_NAME

		git config --global user.email "$GIT_EMAIL"
		git config --global user.name "$GIT_NAME"
	fi

	git config --global core.pager "command -v delta &>/dev/null && delta || less"
	git config --global init.defaultBranch "main"
fi

read -rp "Increase global maximum shader cache size to 12G? [y/n]: " INCREASE_SHADER_CACHE

if [[ "$INCREASE_SHADER_CACHE" == "y" ]]; then
	cat <<-EOF | sudo tee -a /etc/environment >/dev/null
		# Nvidia
		__GL_SHADER_DISK_CACHE_SIZE=12000000000
		# AMD
		AMD_VULKAN_ICD=RADV
		MESA_SHADER_CACHE_MAX_SIZE=12G
	EOF

	echo "Global maximum shader cache size increased, restart system to take effect."
fi

echo "Dotfiles installation complete."
