#!/bin/bash
set -e

echo "🔧 Setting up Ghostty terminal..."

# Create necessary directories if they don't exist
mkdir -p "$HOME/.config/ghostty"

# Backup existing files if they exist
if [ -f "$HOME/.config/ghostty/config" ] && [ ! -L "$HOME/.config/ghostty/config" ]; then
    echo "Backing up existing Ghostty config..."
    mv "$HOME/.config/ghostty/config" "$HOME/.config/ghostty/config.backup.$(date +%Y%m%d%H%M%S)"
fi

if [ -d "$HOME/.config/ghostty/themes" ] && [ ! -L "$HOME/.config/ghostty/themes" ]; then
    echo "Backing up existing Ghostty themes directory..."
    mv "$HOME/.config/ghostty/themes" "$HOME/.config/ghostty/themes.backup.$(date +%Y%m%d%H%M%S)"
fi

# Create symlinks to dotfiles
echo "Creating symlinks for Ghostty configuration..."
ln -sfn "$PWD/ghostty/config" "$HOME/.config/ghostty/config"
ln -sfn "$PWD/ghostty/themes" "$HOME/.config/ghostty/themes"

# Set Ghostty as default terminal handler
echo "Setting Ghostty as default terminal..."
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.unix-executable";LSHandlerRoleShell="com.mitchellh.ghostty";}'

# Enable quick terminal toggle (optional)
echo "Setting up quick terminal access..."
# This requires additional system configuration

# macOS-specific optimizations
echo "Applying macOS optimizations..."
# Enable key repeat for better vim experience
defaults write -g ApplePressAndHoldEnabled -bool false
# Set faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "✅ Ghostty setup complete!"
echo ""
echo "📋 Manual setup notes:"
echo "  • Set Ghostty as default terminal in System Preferences"
echo "  • Restart applications to apply key repeat settings"
echo "  • Use cmd+shift+, to reload config while Ghostty is running"
echo "  • Check themes with: ghostty +show-themes"