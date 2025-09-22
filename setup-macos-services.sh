#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to set up a single service
setup_service() {
    local service_name="$1"
    echo "--- Setting up $service_name for macOS ---"

    # Install service if not already installed
    if ! brew list "$service_name" &> /dev/null; then
        echo "$service_name is not installed. Installing with Homebrew..."
        brew install "$service_name"
    fi

    # Define paths
    local plist_file="homebrew.mxcl.${service_name}.plist"
    local plist_src="$DOTFILES_DIR/macos/launchd/$plist_file"
    local plist_dest="$HOME/Library/LaunchAgents/$plist_file"

    # Check if the plist file exists in dotfiles
    if [ ! -f "$plist_src" ]; then
        echo "Error: $plist_src not found in dotfiles. Skipping setup for $service_name."
        return
    fi

    # Create LaunchAgents directory if it doesn't exist
    mkdir -p "$HOME/Library/LaunchAgents"

    # Symlink the plist file
    if [ ! -L "$plist_dest" ]; then
        echo "Symlinking $service_name launch agent..."
        ln -sf "$plist_src" "$plist_dest"
    else
        echo "$service_name launch agent already symlinked."
    fi

    # Start the service using brew services
    echo "Starting $service_name service..."
    brew services start "$service_name"

    echo "$service_name setup complete."
}

# Main script logic
if [[ "$(uname)" != "Darwin" ]]; then
    echo "Skipping macOS services setup (not on macOS)."
    exit 0
fi

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <service1> <service2> ..."
    exit 1
fi

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install it first."
    exit 1
fi

for service in "$@"; do
    setup_service "$service"
done

echo "All macOS services have been configured."
