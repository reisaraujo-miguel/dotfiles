#!/bin/bash

# Configuration
DOTFILES_DIR="./"                                                    # Replace with your dotfiles directory
BACKUP_DIR="./dotfiles_backup"                                       # Backup directory for existing configs
EXCLUDE_FILES=".git .gitignore install.sh README.md dotfiles_backup" # Files/dirs to exclude

# Function to create backup directory if it doesn't exist
create_backup_dir() {
	if [ ! -d "$BACKUP_DIR" ]; then
		mkdir -p "$BACKUP_DIR"
		echo "Created backup directory: $BACKUP_DIR"
	fi
}

# Function to create symbolic links
create_symlinks() {
	for file in "$DOTFILES_DIR"/*; do
		if [[ -f "$file" || -d "$file" ]]; then
			filename=$(basename "$file")
			if [[ " $EXCLUDE_FILES " != *" $filename "* ]]; then
				target_file="$HOME/$filename"

				if [ -e "$target_file" ]; then
					# Backup existing file
					create_backup_dir
					backup_file="$BACKUP_DIR/$filename.$(date +%Y%m%d_%H%M%S)"
					mv "$target_file" "$backup_file"
					echo "Backed up existing file: $target_file to $backup_file"
				fi

				ln -sf "$file" "$target_file"
				echo "Created symlink: $target_file -> $file"
			fi
		fi
	done
}

# Main execution
echo "Installing dotfiles..."
create_symlinks
echo "Dotfiles installation complete."

# Example Usage (optional):
# Place this script in your dotfiles repo and run it from your terminal:
# chmod +x install.sh
# ./install.sh
