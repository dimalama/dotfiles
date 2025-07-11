#!/usr/bin/env bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Determine architecture-specific Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

# Function to ask for confirmation
ask_confirmation() {
    read -p "$1 (yes/no): " choice
    case "$choice" in
        y|Y|yes|Yes|YES ) return 0;;
        n|N|no|No|NO ) return 1;;
        * ) echo "Please answer yes or no."; ask_confirmation "$1";;
    esac
}

# Function to create a symlink if it doesn't exist
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if target exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi

    echo "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
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
    # Core dotfiles
    create_symlink "$SCRIPT_DIR/.bash_profile" "$HOME/.bash_profile"
    create_symlink "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
    create_symlink "$SCRIPT_DIR/.vim" "$HOME/.vim"
    create_symlink "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    create_symlink "$SCRIPT_DIR/.npmrc" "$HOME/.npmrc"
    create_symlink "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$SCRIPT_DIR/.stCommitMsg" "$HOME/.stCommitMsg"

    # Config directories
    mkdir -p "$HOME/.config/gh"
    create_symlink "$SCRIPT_DIR/gh/config.yml" "$HOME/.config/gh/config.yml"

    mkdir -p "$HOME/.config/gh-dash"
    create_symlink "$SCRIPT_DIR/gh-dash/config.yml" "$HOME/.config/gh-dash/config.yml"

    mkdir -p "$HOME/.codeium/windsurf/memories"
    create_symlink "$SCRIPT_DIR/windsurf/global_rules.md" "$HOME/.codeium/windsurf/memories/global_rules.md"

    mkdir -p "$HOME/.claude"
    create_symlink "$SCRIPT_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    # Note: .ssh directory is commented out for security reasons
    # create_symlink "$SCRIPT_DIR/.ssh" "$HOME/.ssh"
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
