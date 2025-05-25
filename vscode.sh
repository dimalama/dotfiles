#!/usr/bin/env bash
set -e

# Get the directory of the script if SCRIPT_DIR is not already set
if [ -z "$SCRIPT_DIR" ]; then
  SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
  echo "Setting SCRIPT_DIR to: $SCRIPT_DIR"
fi

echo "Configuring VS Code settings..."

#To enable key-repeating for vim for VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium

# Symlink settings file
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER_DIR" # Ensure directory exists
ln -sf "$SCRIPT_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"

echo "VS Code configuration complete.source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme
p10k configure"