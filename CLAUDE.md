# CLAUDE.md

This is a dot files project. The purpose of this project to maintain configuration for my work, personal laptops and in case of hard reset to easy configure my laptops by running a few bash scripts. We must focus only on macos and not worry about windows configuration.

## Setup and Installation Commands

### Initial Setup
```bash
# Main installation script - installs Homebrew packages, creates symlinks, and configures VS Code
./install.sh
```

### Individual Setup Commands
```bash
# Install/update Homebrew packages
./brew.sh

# Configure VS Code settings and key repeat
./vscode.sh

# Set up Python environment with uv and virtual environment
./setup-python.sh
./setup-python.sh --recreate-venv  # Recreate venv with latest Python

# Set up dev container for projects
./setup-devcontainer.sh             # Interactive mode
./setup-devcontainer.sh nodejs .    # Quick setup

# Install Claude Code CLI
./setup-claude-code.sh

# Set up Ghostty terminal (includes system optimization)
./setup-ghostty.sh

# Set up Anki spaced repetition system
./setup-anki.sh

# Configure Git environment (personal vs work)
./setup-git-environment.sh

# Fix terminal display issues
./fix-git-branch-display.sh
./fix-terminal-icons.sh

# Fix powerlevel10k icons if not displaying correctly
p10k configure
```

## Architecture and Key Components

### Configuration Management
- **Brewfile**: Defines all Homebrew packages (CLI tools, casks, fonts)
- **install.sh**: Main orchestration script that handles setup with user confirmation
- **Symlink Strategy**: Configuration files are symlinked from this repo to their target locations

### Key Configurations
- **Shell**: zsh with powerlevel10k theme, zplug plugin manager, and modern CLI tool aliases
- **Editor**: Vim configuration with extensive customization
- **Git**: Custom aliases for common workflows, modern settings (zdiff3, autosquash, autoStash), environment-specific configurations
- **Editors**: VS Code with vim mode, Windsurf AI-powered editor with smart relative line numbers and auto-formatting
- **Browser**: Brave privacy-focused web browser
- **Python**: Uses uv as pip alternative with pyenv version management and default .venv virtual environment
- **Node.js**: Runtime with nvm version management, pnpm (preferred) and npm package managers with helpful aliases
- **Network Tools**: dig, nmap, netcat, telnet, whois, wget, and other essential network utilities
- **Modern CLI Tools**: bat (cat), eza (ls), fd (find), ripgrep (grep), zoxide (cd), fzf, htop, tmux
- **Learning Tools**: Anki spaced repetition system with curated add-ons and deck management
- **Productivity Tools**: Alfred application launcher, Rectangle window management, Flux blue light filter

### Directory Structure
```
dotfiles/
├── Brewfile                 # Homebrew package definitions
├── install.sh              # Main setup orchestrator
├── brew.sh                 # Homebrew installation script
├── vscode.sh               # VS Code configuration
├── setup-python.sh         # Python environment setup
├── setup-anki.sh           # Anki spaced repetition setup
├── setup-git-environment.sh # Git environment configuration
├── .zshrc                  # Shell configuration
├── .gitconfig              # Git aliases and settings
├── .vimrc                  # Vim configuration
├── vscode/settings.json    # VS Code settings
├── gh/config.yml           # GitHub CLI configuration
├── gh-dash/config.yml      # GitHub dashboard configuration
├── anki/                   # Anki configuration and decks
└── windsurf/global_rules.md # Windsurf coding guidelines
```

### Python Environment
- Uses uv package manager instead of pip
- Default virtual environment at ~/.venv
- Alias 'activate' for quick environment activation
- Homebrew Python with proper PATH configuration

### Development Tools
- **just**: Command runner for project automation
- **gh**: GitHub CLI with custom configuration
- **terraform**: Infrastructure as code with tflint and terraform-docs
- **checkov**: Security scanning for infrastructure
- **act**: Local GitHub Actions testing
- **Node.js**: Runtime with nvm (Node Version Manager) and pnpm/npm package managers
- **Network tools**: dig, nmap, netcat, telnet, whois, wget, mtr, iperf3, tcpdump, wireshark
- **AI Tools**: Claude Code CLI for AI-assisted coding, GitHub Copilot, Codeium
- **Dev Containers**: Pre-configured templates for Node.js, Python, and full-stack development
- **Modern CLI alternatives**: bat, fd, ripgrep, eza, zoxide, fzf, htop, tree, jq, delta, tmux, diff-so-fancy, tldr, watch

## Symlink Targets
The install.sh script creates symlinks from this repo to:
- ~/.bash_profile, ~/.vimrc, ~/.vim, ~/.gitconfig, ~/.zshrc, ~/.npmrc, ~/.p10k.zsh, ~/.stCommitMsg
- ~/.config/gh/config.yml, ~/.config/gh-dash/config.yml
- ~/.codeium/windsurf/memories/global_rules.md
- ~/.claude/CLAUDE.md
- ~/Library/Application Support/Code/User/settings.json

## Git Environment Configuration

The dotfiles provide sophisticated Git configuration management for personal vs work environments:

### Environment Selection
The script prompts you to choose between personal or work environment setups:

### Personal Environment
- **SSH Signing**: Uses 1Password SSH agent for commit signing
- **Auto-detection**: Automatically finds and configures available SSH keys
- **GitHub Integration**: Pre-configured for GitHub CLI authentication
- **Enhanced Security**: Requires signed commits and uses secure credential helpers
- **Configuration**: `~/.gitconfig.personal` (symlinked from template, excluded from version control)

### Work Environment  
- **Enterprise-Ready**: Includes corporate proxy, certificate, and GitHub Enterprise settings
- **Conservative Defaults**: Safer push/pull behavior, disabled auto-remote setup
- **No Dependencies**: No 1Password requirement, optional GPG signing
- **Customizable**: Commented configuration blocks for easy enterprise customization
- **Configuration**: `~/.gitconfig.work` (symlinked from template, excluded from version control)

### Setup Process
```bash
# Run the environment setup script
./setup-git-environment.sh

# The script will:
# 1. Prompt you to choose environment type (personal/work)
# 2. Create appropriate symbolic links to templates
# 3. Configure SSH keys automatically (personal only)
# 4. Verify 1Password installation (personal only)
```

### Manual Configuration
```bash
# Manually copy and customize templates if needed
cp .gitconfig.personal.template ~/.gitconfig.personal  # Personal laptop
cp .gitconfig.work.template ~/.gitconfig.work          # Work laptop

# Edit the files to match your specific requirements
# Templates include comprehensive options and examples
```

### Configuration Architecture
- **Main Config**: `.gitconfig` contains shared aliases and settings
- **Environment Configs**: Included conditionally via `[include]` sections
- **Template System**: Version-controlled templates with user-specific instances excluded
- **Symlink Strategy**: Templates are symlinked to home directory for easy updates

## Manual Installations
Some tools require manual installation and cannot be automated. See [manual-installs.md](manual-installs.md) for:
- App Store applications (Xcode, etc.)
- Hardware-specific drivers
- Enterprise applications
- Manual configuration steps

## Important Notes
- Architecture-aware setup (ARM64 vs x86_64 Homebrew paths)
- Existing files are backed up before symlinking
- VS Code key repeat is enabled for vim mode
- Python setup ensures latest version with proper PATH configuration
- Git environment configurations are excluded from version control for security
- All scripts use `set -e` for error handling