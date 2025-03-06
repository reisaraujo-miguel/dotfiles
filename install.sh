#!/bin/bash

HELP_TEXT="\
Usage: ./install.sh [options]...
Options:
	-e \"file/dir\":		set file to be excluded from installation.
	-d \"dir\":		set dir to install to.
	-h, --help:		show this help dialog."

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Use absolute path of script directory
HOME_DIR=$HOME
BACKUP_DIR="$DOTFILES_DIR/dotfiles_backup"         # Backup directory for existing configs
EXCLUDE_FILES=".git .gitignore .devcontainer.json" # Files/dirs to exclude

EXCLUDE_FLAG=false
HOME_FLAG=false

for arg in "$@"; do
	if $EXCLUDE_FLAG; then
		echo "Excluding $arg"
		EXCLUDE_FILES="$EXCLUDE_FILES $arg"
		EXCLUDE_FLAG=false
		continue
	elif $HOME_FLAG; then
		if [ -d "$HOME_DIR" ]; then
			echo "Setting installation home as: $arg"
			HOME_DIR=$arg
			HOME_FLAG=false
			continue
		else
			echo "Error: no $arg directory found."
			exit 1
		fi
	fi

	if [ "$arg" = "-e" ]; then
		EXCLUDE_FLAG=true
	elif [ "$arg" = "-d" ]; then
		HOME_FLAG=true
	elif [ "$arg" = "-h" ] || [ "$arg" = "--help" ]; then
		echo "$HELP_TEXT"
		exit 0
	else
		echo "Invalid option: $arg"
		exit 1
	fi
done

if $HOME_FLAG; then
	echo "You need to pass a value to -d. Usage: -d \"dir\""
	exit 1
fi

if $EXCLUDE_FLAG; then
	echo "You need to pass a value to -e. Usage: -e \"file/dir\""
	exit 1
fi

# Function to create backup directory if it doesn't exist
create_backup_dir() {
	if [ ! -d "$BACKUP_DIR" ]; then
		mkdir -p "$BACKUP_DIR"
		echo "Created backup directory: $BACKUP_DIR"
	fi
}

# Function to recursively process files and directories
process_dotfiles() {
	local source_dir="$1"
	local target_dir="$2"

	# Process both regular and hidden files/directories (excluding . and ..)
	for item in "$source_dir"/* "$source_dir"/.[!.]*; do
		# Skip if the item doesn't exist (common when no hidden files are present)
		[ ! -e "$item" ] && continue

		# Get the basename of the item
		local item_name
		item_name=$(basename "$item")

		# Skip excluded files/directories
		if [[ " $EXCLUDE_FILES " =~ [[:space:]]"$item_name"[[:space:]] ]]; then
			echo "Skipping excluded item: $item_name"
			continue
		fi

		# Create the target path
		local target_path="$target_dir/$item_name"

		if [ -d "$item" ]; then
			# Handle directories: create them if they don't exist
			if [ ! -d "$target_path" ]; then
				mkdir -p "$target_path"
				echo "Created directory: $target_path"
			fi

			# Recursively process the contents of this directory
			process_dotfiles "$item" "$target_path"
		else
			# Handle files: create symlinks
			if [ -e "$target_path" ] || [ -L "$target_path" ]; then
				# Backup existing file
				create_backup_dir
				local backup_file
				backup_file="$BACKUP_DIR/$(realpath --relative-to="$HOME_DIR" "$target_path").$(date +%Y%m%d_%H%M%S)"
				# Create parent directory for backup if needed
				mkdir -p "$(dirname "$backup_file")"
				mv "$target_path" "$backup_file"
				echo "Backed up existing file: $target_path to $backup_file"
			fi

			# Create symlink
			ln -sf "$item" "$target_path"
			echo "Created symlink: $target_path -> $item"
		fi
	done
}

# Function to process hidden files/dirs in the root of DOTFILES_DIR
process_hidden_root_files() {
	for item in "$DOTFILES_DIR"/.[!.]*; do
		[ ! -e "$item" ] && continue

		local item_name
		item_name=$(basename "$item")

		# Skip excluded files/directories
		if [[ " $EXCLUDE_FILES " =~ [[:space:]]"$item_name"[[:space:]] ]]; then
			echo "Skipping excluded item: $item_name"
			continue
		fi

		local target_path="$HOME_DIR/$item_name"

		if [ -d "$item" ]; then
			# Handle directories: create them if they don't exist
			if [ ! -d "$target_path" ]; then
				mkdir -p "$target_path"
				echo "Created directory: $target_path"
			fi

			# Recursively process the contents of this directory
			process_dotfiles "$item" "$target_path"
		else
			# Handle files: create symlinks
			if [ -e "$target_path" ] || [ -L "$target_path" ]; then
				# Backup existing file
				create_backup_dir
				local backup_file
				backup_file="$BACKUP_DIR/$item_name.$(date +%Y%m%d_%H%M%S)"
				mv "$target_path" "$backup_file"
				echo "Backed up existing file: $target_path to $backup_file"
			fi

			# Create symlink
			ln -sf "$item" "$target_path"
			echo "Created symlink: $target_path -> $item"
		fi
	done
}

# Main execution
echo "Installing dotfiles..."
process_hidden_root_files

# Add git Configurations
if command -v git &>/dev/null; then
	echo "Configuring git"
	git config --global core.pager "delta"
	git config --global init.defaultBranch "main"
fi

# check if there is a .bashrc file on the $HOME_DIR and add a line
# to replace the bash shell for a zsh shell
if [ -f "$HOME_DIR"/.bashrc ]; then
	echo "Configuring .bashrc"
	cat "$DOTFILES_DIR"/bashrc_append.sh >>"$HOME_DIR"/.bashrc
fi

echo "Dotfiles installation complete."
