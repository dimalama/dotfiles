#!/usr/bin/env bash
set -e

echo "Setting up Python environment..."

# Determine architecture-specific Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

# Install/update Python
echo "Installing/updating Python..."
brew update
brew upgrade python
brew cleanup python

# Create symlinks to ensure python/python3 commands work
echo "Creating Python command symlinks..."
ln -sf "$BREW_PREFIX/bin/python3" "$BREW_PREFIX/bin/python" 2>/dev/null || true
ln -sf "$BREW_PREFIX/bin/pip3" "$BREW_PREFIX/bin/pip" 2>/dev/null || true

# Set up uv as a pip alternative
echo "Setting up uv as pip alternative..."
if ! command -v uv &> /dev/null; then
  brew install uv
fi

# Create a default virtual environment if it doesn't exist
VENV_DIR="$HOME/.venv"
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating default virtual environment at $VENV_DIR..."
  uv venv "$VENV_DIR"
  echo "# Add default Python virtual environment" >> "$HOME/.zshrc"
  echo "alias activate='source $VENV_DIR/bin/activate'" >> "$HOME/.zshrc"
  echo "Virtual environment created. Use 'activate' command to activate it."
else
  echo "Default virtual environment already exists at $VENV_DIR"
fi

# Display Python information
echo "Python setup complete!"
echo "Python version: $(python3 --version)"
echo "Pip version: $(pip3 --version)"
echo "UV version: $(uv --version)"
echo "Default venv location: $VENV_DIR"
echo ""
echo "To use your default virtual environment, run: activate"
