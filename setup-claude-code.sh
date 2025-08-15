#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $BLUE "🤖 Setting up Claude Code CLI..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_color $RED "Error: Node.js is not installed!"
    print_color $BLUE "Please run './brew.sh' first to install Node.js via Homebrew"
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    print_color $RED "Error: npm is not available!"
    print_color $BLUE "Please ensure Node.js installation is complete"
    exit 1
fi

print_color $BLUE "Installing Claude Code CLI via npm..."

# Install Claude Code CLI globally
if npm install -g @anthropic-ai/claude-code; then
    print_color $GREEN "✓ Claude Code CLI installed successfully!"
else
    print_color $YELLOW "npm install failed, trying alternative installation method..."
    
    # Try the official installer as fallback
    if curl -fsSL https://claude.ai/install.sh | bash; then
        print_color $GREEN "✓ Claude Code CLI installed successfully via official installer!"
    else
        print_color $RED "✗ Failed to install Claude Code CLI"
        print_color $BLUE "You can try manually installing with:"
        print_color $BLUE "  npm install -g @anthropic-ai/claude-code"
        print_color $BLUE "  or visit: https://docs.anthropic.com/en/docs/claude-code/setup"
        exit 1
    fi
fi

# Verify installation
if command -v claude &> /dev/null; then
    print_color $GREEN "✓ Claude Code CLI is available in PATH"
    print_color $BLUE "Version: $(claude --version 2>/dev/null || echo 'Unknown')"
else
    print_color $YELLOW "⚠ Claude Code CLI may not be in PATH"
    print_color $BLUE "You may need to restart your terminal or run:"
    print_color $BLUE "  source ~/.zshrc"
fi

print_color $BLUE ""
print_color $BLUE "🎉 Claude Code setup complete!"
print_color $BLUE ""
print_color $BLUE "To get started:"
print_color $BLUE "  1. Run 'claude auth login' to authenticate"
print_color $BLUE "  2. Navigate to your project directory"
print_color $BLUE "  3. Run 'claude' to start coding with AI assistance"
print_color $BLUE ""
print_color $BLUE "For more information: https://docs.anthropic.com/en/docs/claude-code"