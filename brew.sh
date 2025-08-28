#!/usr/bin/env bash
set -e

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    # Wait for installation to complete
    echo "Waiting for Xcode Command Line Tools installation to complete..."
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo "Xcode Command Line Tools installed successfully."
else
    echo "Xcode Command Line Tools already installed."
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully."
else
    echo "Homebrew already installed."
fi

# Determine architecture-specific Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

# Add Homebrew to PATH
export PATH="$BREW_PREFIX/bin:$PATH"

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install Bundle
brew bundle

# Remove outdated versions from the cellar.
brew cleanup
brew bundle cleanup --force
