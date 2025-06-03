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

# Get the latest Python version from Homebrew
PYTHON_VERSION=$(ls -1 $BREW_PREFIX/Cellar/python@* | grep -o '[0-9]\+\.[0-9]\+' | sort -V | tail -1)
PYTHON_FORMULA="python@$PYTHON_VERSION"
echo "Latest Python version: $PYTHON_VERSION"

# Create symlinks to ensure python/python3 commands work
echo "Creating Python command symlinks..."
ln -sf "$BREW_PREFIX/bin/python3" "$BREW_PREFIX/bin/python" 2>/dev/null || true
ln -sf "$BREW_PREFIX/bin/pip3" "$BREW_PREFIX/bin/pip" 2>/dev/null || true

# Add Homebrew Python to PATH in .zshrc if not already there
PYTHON_PATH_LINE="export PATH=\"\$BREW_PREFIX/opt/$PYTHON_FORMULA/libexec/bin:\$PATH\""

# Check if .zshrc exists and is a regular file
if [ -f "$HOME/.zshrc" ]; then
  if ! grep -q "$PYTHON_FORMULA/libexec/bin" "$HOME/.zshrc"; then
    # Create a temporary file
    TEMP_FILE=$(mktemp)
    # Filter out old Python path lines and write to temp file
    grep -v 'export PATH="\$BREW_PREFIX/opt/python/libexec/bin' "$HOME/.zshrc" > "$TEMP_FILE"
    # Copy temp file back to .zshrc
    cp "$TEMP_FILE" "$HOME/.zshrc"
    rm "$TEMP_FILE"
    # Add new Python path line
    echo "# Python configuration - ensure Homebrew's Python is used" >> "$HOME/.zshrc"
    echo "$PYTHON_PATH_LINE" >> "$HOME/.zshrc"
    echo "Updated .zshrc with correct Python path"
  fi
else
  echo "Warning: .zshrc not found or is not a regular file"
  echo "Please manually add this line to your shell configuration:"
  echo "$PYTHON_PATH_LINE"
fi

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

# Recreate the virtual environment with the latest Python if requested
if [ "$1" == "--recreate-venv" ]; then
  echo "Recreating virtual environment with latest Python..."
  rm -rf "$VENV_DIR"
  uv venv "$VENV_DIR"
  echo "Virtual environment recreated with latest Python."
fi

# Display Python information
echo "Python setup complete!"
echo "Homebrew Python path: $BREW_PREFIX/opt/$PYTHON_FORMULA"
echo "Homebrew Python version: $($BREW_PREFIX/opt/$PYTHON_FORMULA/bin/python3 --version)"
echo "Current Python version: $(python3 --version)"
echo "Pip version: $(pip3 --version)"
echo "UV version: $(uv --version)"
echo "Default venv location: $VENV_DIR"
echo ""
echo "To use your default virtual environment, run: activate"
echo "To apply changes immediately, run: source ~/.zshrc"
echo "If you want to recreate your virtual environment with the latest Python, run: ./setup-python.sh --recreate-venv"
