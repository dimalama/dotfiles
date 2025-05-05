#!/usr/bin/env bash
set -e

# Get the directory of the install.sh script (assuming vscode.sh is called from it)
# If vscode.sh could be run standalone, it needs its own directory detection.
# Assuming it's called by install.sh which already determined SCRIPT_DIR
if [ -z "$SCRIPT_DIR" ]; then
  echo "Error: SCRIPT_DIR not set. Run this script via install.sh"
  exit 1
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

echo "VS Code configuration complete."