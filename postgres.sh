#!/usr/bin/env bash
set -e

# Determine architecture-specific Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

# Add Homebrew to PATH
export PATH="$BREW_PREFIX/bin:$PATH"

echo "Starting PostgreSQL service..."
brew services start postgresql

echo "PostgreSQL service started."
