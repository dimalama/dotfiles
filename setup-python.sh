#!/usr/bin/env bash
set -e

# Support for recreating venv
RECREATE_VENV=false
if [[ "$1" == "--recreate-venv" ]]; then
    RECREATE_VENV=true
fi

echo "Setting up Python environment with pyenv..."

# Ensure pyenv is installed
if ! command -v pyenv &> /dev/null; then
    echo "pyenv not found. Please install it first (e.g., 'brew install pyenv')."
    exit 1
fi

# Install latest stable Python version if not already installed
LATEST_PYTHON=$(pyenv install --list | grep -E "^[[:space:]]*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')

if ! pyenv versions --bare | grep -q "^$LATEST_PYTHON$"; then
    echo "Installing Python $LATEST_PYTHON..."
    pyenv install "$LATEST_PYTHON"
else
    echo "Python $LATEST_PYTHON is already installed."
fi

# Set the latest version as the global default
echo "Setting global Python version to $LATEST_PYTHON..."
pyenv global "$LATEST_PYTHON"

# Set up uv as a pip alternative
echo "Ensuring uv is installed..."
if ! command -v uv &> /dev/null; then
  brew install uv
fi

# Set up default virtual environment
DEFAULT_VENV_PATH="$HOME/.venv"
if [[ "$RECREATE_VENV" == true ]] && [[ -d "$DEFAULT_VENV_PATH" ]]; then
    echo "Removing existing virtual environment..."
    rm -rf "$DEFAULT_VENV_PATH"
fi

if [[ ! -d "$DEFAULT_VENV_PATH" ]]; then
    echo "Creating default virtual environment at $DEFAULT_VENV_PATH..."
    uv venv "$DEFAULT_VENV_PATH"
    echo "Virtual environment created. Use 'activate' alias to activate it."
else
    echo "Default virtual environment already exists at $DEFAULT_VENV_PATH"
fi

# Display Python information
echo ""
echo "Python setup complete!"
echo "Pyenv is managing your Python versions."
echo "Current global Python version: $(pyenv global)"
echo "Default virtual environment: $DEFAULT_VENV_PATH"
echo "To activate the venv, run: activate"
echo "To see all installed versions, run: pyenv versions"
echo "To install a new version, run: pyenv install <version>"
echo ""
echo "To apply changes immediately, open a new terminal or run: exec \"$SHELL\""
