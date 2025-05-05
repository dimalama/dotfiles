#!/usr/bin/env bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Function to ask for confirmation
ask_confirmation() {
    read -p "$1 (yes/no): " choice
    case "$choice" in 
        y|Y|yes|Yes|YES ) return 0;;
        n|N|no|No|NO ) return 1;;
        * ) echo "Please answer yes or no."; ask_confirmation "$1";;
    esac
}

# Homebrew setup
if ask_confirmation "Do you want to run Homebrew setup?"; then
    echo "Running Homebrew setup..."
    "$SCRIPT_DIR/brew.sh"
else
    echo "Skipping Homebrew setup."
fi

# Symlinks setup
if ask_confirmation "Do you want to create symlinks?"; then
    echo "Creating symlinks..."
    # add symlinks
    ln -sf "$SCRIPT_DIR/.bash_profile" ~/.bash_profile
    ln -sf "$SCRIPT_DIR/.vimrc" ~/.vimrc
    ln -sf "$SCRIPT_DIR/.vim" ~/.vim
    ln -sf "$SCRIPT_DIR/.gitconfig" ~/.gitconfig
    ln -sf "$SCRIPT_DIR/.zshrc" ~/.zshrc
    ln -sf "$SCRIPT_DIR/.npmrc" ~/.npmrc
    ln -sf "$SCRIPT_DIR/.stCommitMsg" ~/.stCommitMsg

    # Ensure target directories exist before creating links inside them
    mkdir -p ~/.config/gh
    ln -sf "$SCRIPT_DIR/gh/config.yml" ~/.config/gh/config.yml
    mkdir -p ~/.config/gh-dash
    ln -sf "$SCRIPT_DIR/gh-dash/config.yml" ~/.config/gh-dash/config.yml
    mkdir -p ~/.codeium/windsurf/memories
    ln -sf "$SCRIPT_DIR/windsurf/global_rules.md" ~/.codeium/windsurf/memories/global_rules.md     
    # ln -s ~/dotfiles/.ssh ~/.ssh
else
    echo "Skipping symlinks creation."
fi

# VS Code setup
if ask_confirmation "Do you want to run VS Code setup?"; then
    echo "Running VS Code setup..."
    # configure VSCode
    "$SCRIPT_DIR/vscode.sh"
else
    echo "Skipping VS Code setup."
fi

echo '====== Installation complete ======'
