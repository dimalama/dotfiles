#!/usr/bin/env bash

# Dotfiles Doctor - Health Check System
# Verifies that your dotfiles environment is correctly configured

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Determine architecture-specific Homebrew path
if [[ $(uname -m) == 'arm64' ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS_COUNT++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN_COUNT++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL_COUNT++))
}

check_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

###############################################################################
# System Information                                                          #
###############################################################################

print_header "System Information"

MACOS_VERSION=$(sw_vers -productVersion)
ARCH=$(uname -m)
check_info "macOS Version: $MACOS_VERSION ($ARCH)"
check_info "Homebrew Prefix: $BREW_PREFIX"

###############################################################################
# Homebrew                                                                    #
###############################################################################

print_header "Homebrew"

if command -v brew &> /dev/null; then
    BREW_VERSION=$(brew --version | head -n 1)
    check_pass "Homebrew installed ($BREW_VERSION)"

    # Check if Homebrew is in PATH
    if [[ ":$PATH:" == *":$BREW_PREFIX/bin:"* ]]; then
        check_pass "Homebrew in PATH"
    else
        check_fail "Homebrew not in PATH (add $BREW_PREFIX/bin to PATH)"
    fi

    # Check for outdated packages
    OUTDATED_COUNT=$(brew outdated --quiet | wc -l | tr -d ' ')
    if [ "$OUTDATED_COUNT" -eq 0 ]; then
        check_pass "All Homebrew packages up to date"
    else
        check_warn "$OUTDATED_COUNT packages outdated (run 'brew upgrade' to update)"
    fi

    # Check for Homebrew issues
    if brew doctor &> /dev/null; then
        check_pass "Homebrew health check passed"
    else
        check_warn "Homebrew has warnings (run 'brew doctor' for details)"
    fi
else
    check_fail "Homebrew not installed (run /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\")"
fi

###############################################################################
# Core Tools                                                                  #
###############################################################################

print_header "Core Command Line Tools"

REQUIRED_TOOLS=(git vim zsh gh curl wget jq)
for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        VERSION=$("$tool" --version 2>&1 | head -n 1)
        check_pass "$tool installed ($VERSION)"
    else
        check_fail "$tool not installed (run 'brew install $tool')"
    fi
done

###############################################################################
# Modern CLI Alternatives                                                     #
###############################################################################

print_header "Modern CLI Tools"

MODERN_TOOLS=(bat fd ripgrep eza zoxide fzf htop delta)
for tool in "${MODERN_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        check_pass "$tool installed"
    else
        check_warn "$tool not installed (run 'brew install $tool')"
    fi
done

###############################################################################
# Shell Configuration                                                         #
###############################################################################

print_header "Shell Configuration"

# Check current shell
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "zsh" ]; then
    check_pass "Current shell is zsh"
else
    check_warn "Current shell is $CURRENT_SHELL (consider switching to zsh)"
fi

# Check zplug
if [ -d "$BREW_PREFIX/opt/zplug" ]; then
    check_pass "zplug installed"
else
    check_fail "zplug not installed (run 'brew install zplug')"
fi

# Check powerlevel10k
if [ -d "$BREW_PREFIX/opt/powerlevel10k" ]; then
    check_pass "powerlevel10k theme installed"
else
    check_warn "powerlevel10k not installed (run 'brew install powerlevel10k')"
fi

# Check .zshrc
if [ -f "$HOME/.zshrc" ]; then
    if [ -L "$HOME/.zshrc" ] && [ "$(readlink "$HOME/.zshrc")" = "$SCRIPT_DIR/.zshrc" ]; then
        check_pass ".zshrc symlinked correctly"
    elif [ -L "$HOME/.zshrc" ]; then
        check_warn ".zshrc is a symlink but points to: $(readlink "$HOME/.zshrc")"
    else
        check_warn ".zshrc exists but is not a symlink (backup and run ./install.sh)"
    fi
else
    check_fail ".zshrc not found (run ./install.sh)"
fi

# Check .p10k.zsh
if [ -f "$HOME/.p10k.zsh" ]; then
    check_pass ".p10k.zsh configuration exists"
else
    check_warn ".p10k.zsh not found (run 'p10k configure')"
fi

###############################################################################
# Symlinks                                                                    #
###############################################################################

print_header "Configuration Symlinks"

SYMLINKS=(
    ".bash_profile"
    ".vimrc"
    ".gitconfig"
    ".zshrc"
    ".npmrc"
    ".p10k.zsh"
    ".stCommitMsg"
)

for file in "${SYMLINKS[@]}"; do
    if [ -L "$HOME/$file" ]; then
        TARGET=$(readlink "$HOME/$file")
        if [ "$TARGET" = "$SCRIPT_DIR/$file" ]; then
            check_pass "$file → $SCRIPT_DIR/$file"
        else
            check_warn "$file symlinked to: $TARGET (expected $SCRIPT_DIR/$file)"
        fi
    elif [ -f "$HOME/$file" ]; then
        check_warn "$file exists but is not a symlink"
    else
        check_fail "$file not found"
    fi
done

# Check config directories
if [ -L "$HOME/.config/gh/config.yml" ]; then
    check_pass "GitHub CLI config symlinked"
else
    check_warn "GitHub CLI config not symlinked"
fi

if [ -L "$HOME/.config/gh-dash/config.yml" ]; then
    check_pass "gh-dash config symlinked"
else
    check_warn "gh-dash config not symlinked"
fi

if [ -L "$HOME/.codeium/windsurf/memories/global_rules.md" ]; then
    check_pass "Windsurf global rules symlinked"
else
    check_warn "Windsurf global rules not symlinked"
fi

if [ -L "$HOME/.claude/CLAUDE.md" ]; then
    check_pass "Claude Code config symlinked"
else
    check_warn "Claude Code config not symlinked"
fi

###############################################################################
# Git Configuration                                                           #
###############################################################################

print_header "Git Configuration"

if command -v git &> /dev/null; then
    # Check user config
    GIT_USER_NAME=$(git config --global user.name 2>/dev/null)
    GIT_USER_EMAIL=$(git config --global user.email 2>/dev/null)

    if [ -n "$GIT_USER_NAME" ]; then
        check_pass "Git user.name: $GIT_USER_NAME"
    else
        check_fail "Git user.name not set (run 'git config --global user.name \"Your Name\"')"
    fi

    if [ -n "$GIT_USER_EMAIL" ]; then
        check_pass "Git user.email: $GIT_USER_EMAIL"
    else
        check_fail "Git user.email not set (run 'git config --global user.email \"your@email.com\"')"
    fi

    # Check environment-specific configs
    if [ -f "$HOME/.gitconfig.personal" ] || [ -f "$HOME/.gitconfig.work" ]; then
        if [ -f "$HOME/.gitconfig.personal" ]; then
            check_pass "Personal git config exists"
        fi
        if [ -f "$HOME/.gitconfig.work" ]; then
            check_pass "Work git config exists"
        fi
    else
        check_warn "No environment-specific git config (run ./setup-git-environment.sh)"
    fi

    # Check for SSH keys
    if [ -d "$HOME/.ssh" ]; then
        SSH_KEY_COUNT=$(find "$HOME/.ssh" -name "id_*" -not -name "*.pub" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$SSH_KEY_COUNT" -gt 0 ]; then
            check_pass "SSH keys found ($SSH_KEY_COUNT key(s))"
        else
            check_warn "No SSH keys found (generate with 'ssh-keygen -t ed25519')"
        fi
    else
        check_warn ".ssh directory not found"
    fi

    # Check git LFS
    if git lfs version &> /dev/null; then
        check_pass "Git LFS installed"
    else
        check_warn "Git LFS not installed (run 'brew install git-lfs && git lfs install')"
    fi
fi

###############################################################################
# Development Environments                                                    #
###############################################################################

print_header "Development Environments"

# Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    check_pass "Python installed ($PYTHON_VERSION)"
else
    check_fail "Python not installed"
fi

if command -v pyenv &> /dev/null; then
    check_pass "pyenv installed"
else
    check_warn "pyenv not installed (run 'brew install pyenv')"
fi

if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version)
    check_pass "uv (pip alternative) installed ($UV_VERSION)"
else
    check_warn "uv not installed (run 'brew install uv')"
fi

if [ -d "$HOME/.venv" ]; then
    check_pass "Default Python virtual environment exists (~/.venv)"
else
    check_warn "Default venv not found (run './setup-python.sh')"
fi

# Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    check_pass "Node.js installed ($NODE_VERSION)"
else
    check_warn "Node.js not installed (run 'brew install node')"
fi

if command -v nvm &> /dev/null || [ -s "$HOME/.nvm/nvm.sh" ]; then
    check_pass "nvm (Node Version Manager) available"
else
    check_warn "nvm not available (run 'brew install nvm')"
fi

if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm --version)
    check_pass "pnpm installed ($PNPM_VERSION)"
else
    check_warn "pnpm not installed (run 'brew install pnpm')"
fi

# Other dev tools
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    check_pass "Docker installed ($DOCKER_VERSION)"
else
    check_warn "Docker not installed (install Docker Desktop)"
fi

if command -v terraform &> /dev/null; then
    TERRAFORM_VERSION=$(terraform --version | head -n 1)
    check_pass "Terraform installed ($TERRAFORM_VERSION)"
else
    check_warn "Terraform not installed (run 'brew install terraform')"
fi

###############################################################################
# Applications                                                                #
###############################################################################

print_header "Applications"

APPS=(
    "Visual Studio Code"
    "Ghostty"
    "iTerm"
    "Brave Browser"
    "1Password"
    "Rectangle"
    "Alfred"
    "Obsidian"
    "Slack"
)

for app in "${APPS[@]}"; do
    if [ -d "/Applications/$app.app" ]; then
        check_pass "$app installed"
    else
        check_warn "$app not found in /Applications"
    fi
done

###############################################################################
# Claude Code                                                                 #
###############################################################################

print_header "Claude Code"

if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>&1 | head -n 1)
    check_pass "Claude Code CLI installed ($CLAUDE_VERSION)"

    # Check authentication
    if claude auth status &> /dev/null; then
        check_pass "Claude Code authenticated"
    else
        check_warn "Claude Code not authenticated (run 'claude auth login')"
    fi
else
    check_warn "Claude Code CLI not installed (run './setup-claude-code.sh')"
fi

###############################################################################
# 1Password                                                                   #
###############################################################################

print_header "1Password"

if command -v op &> /dev/null; then
    OP_VERSION=$(op --version)
    check_pass "1Password CLI installed ($OP_VERSION)"

    # Check if signed in
    if op account list &> /dev/null; then
        check_pass "1Password CLI authenticated"
    else
        check_warn "1Password CLI not authenticated (run 'op signin')"
    fi
else
    check_warn "1Password CLI not installed (run 'brew install --cask 1password-cli')"
fi

if [ -d "/Applications/1Password.app" ]; then
    check_pass "1Password app installed"

    # Check SSH agent
    if [ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]; then
        check_pass "1Password SSH agent available"
    else
        check_warn "1Password SSH agent not configured (enable in 1Password settings)"
    fi
else
    check_warn "1Password app not found"
fi

###############################################################################
# Terminal                                                                    #
###############################################################################

print_header "Terminal Configuration"

if [ -d "$HOME/.config/ghostty" ]; then
    check_pass "Ghostty config directory exists"

    if [ -f "$HOME/.config/ghostty/config" ]; then
        check_pass "Ghostty config file exists"
    else
        check_warn "Ghostty config file not found"
    fi
else
    check_warn "Ghostty not configured (run './setup-ghostty.sh')"
fi

# Check terminal font
if fc-list 2>/dev/null | grep -q "MesloLGS NF" || system_profiler SPFontsDataType 2>/dev/null | grep -q "MesloLGS NF"; then
    check_pass "Nerd Font installed (MesloLGS NF)"
else
    check_warn "Nerd Font not found (run 'brew install --cask font-meslo-lg-nerd-font')"
fi

###############################################################################
# Services                                                                    #
###############################################################################

print_header "Background Services"

# Check for common services
if launchctl list | grep -q "syncthing"; then
    check_pass "Syncthing service running"
else
    check_info "Syncthing not running (install with './setup-macos-services.sh syncthing')"
fi

###############################################################################
# Summary                                                                     #
###############################################################################

print_header "Summary"

TOTAL=$((PASS_COUNT + WARN_COUNT + FAIL_COUNT))
echo ""
echo -e "${GREEN}Passed:${NC}  $PASS_COUNT / $TOTAL"
echo -e "${YELLOW}Warnings:${NC} $WARN_COUNT / $TOTAL"
echo -e "${RED}Failed:${NC}  $FAIL_COUNT / $TOTAL"
echo ""

if [ $FAIL_COUNT -eq 0 ] && [ $WARN_COUNT -eq 0 ]; then
    echo -e "${GREEN}🎉 Your dotfiles environment is in perfect health!${NC}"
    exit 0
elif [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Your environment is functional but has some optional improvements available.${NC}"
    exit 0
else
    echo -e "${RED}❌ Your environment has some issues that need attention.${NC}"
    exit 1
fi
