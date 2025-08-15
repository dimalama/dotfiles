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

# Fix terminal display issues
./fix-git-branch-display.sh
./fix-terminal-icons.sh
```

## Architecture and Key Components

### Configuration Management
- **Brewfile**: Defines all Homebrew packages (CLI tools, casks, fonts)
- **install.sh**: Main orchestration script that handles setup with user confirmation
- **Symlink Strategy**: Configuration files are symlinked from this repo to their target locations

### Key Configurations
- **Shell**: zsh with powerlevel10k theme, zplug plugin manager, and modern CLI tool aliases
- **Editor**: Vim configuration with extensive customization
- **Git**: Custom aliases for common workflows (l, lg, s, d, ca, go)
- **VS Code**: Vim mode enabled with smart relative line numbers and auto-formatting
- **Python**: Uses uv as pip alternative with default .venv virtual environment
- **Modern CLI Tools**: bat (cat), eza (ls), fd (find), ripgrep (grep), zoxide (cd), fzf, htop, tmux

### Directory Structure
```
dotfiles/
├── Brewfile                 # Homebrew package definitions
├── install.sh              # Main setup orchestrator
├── brew.sh                 # Homebrew installation script
├── vscode.sh               # VS Code configuration
├── setup-python.sh         # Python environment setup
├── .zshrc                  # Shell configuration
├── .gitconfig              # Git aliases and settings
├── .vimrc                  # Vim configuration
├── vscode/settings.json    # VS Code settings
├── gh/config.yml           # GitHub CLI configuration
├── gh-dash/config.yml      # GitHub dashboard configuration
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
- **Modern CLI alternatives**: bat, fd, ripgrep, eza, zoxide, fzf, htop, tree, jq, delta, tmux, diff-so-fancy, tldr, watch

## Symlink Targets
The install.sh script creates symlinks from this repo to:
- ~/.bash_profile, ~/.vimrc, ~/.vim, ~/.gitconfig, ~/.zshrc, ~/.npmrc, ~/.p10k.zsh, ~/.stCommitMsg
- ~/.config/gh/config.yml, ~/.config/gh-dash/config.yml
- ~/.codeium/windsurf/memories/global_rules.md
- ~/.claude/CLAUDE.md
- ~/Library/Application Support/Code/User/settings.json

## Important Notes
- Architecture-aware setup (ARM64 vs x86_64 Homebrew paths)
- Existing files are backed up before symlinking
- VS Code key repeat is enabled for vim mode
- Python setup ensures latest version with proper PATH configuration
- All scripts use `set -e` for error handling