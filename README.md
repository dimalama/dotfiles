# Dotfiles Configuration

A comprehensive macOS development environment setup with modern tools, aliases, and configurations.

## 🚀 Quick Setup

```bash
git clone [your-repo-url] ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 📖 Table of Contents

- [Installation](#installation)
- [Shell Aliases](#shell-aliases)
- [Git Aliases](#git-aliases)
- [Development Tools](#development-tools)
- [Network Tools](#network-tools)
- [Configuration Details](#configuration-details)

## 🛠 Installation

### Main Installation
```bash
./install.sh          # Full setup with confirmation prompts
./brew.sh              # Install/update Homebrew packages only
./vscode.sh            # Configure VS Code settings only
./setup-python.sh      # Set up Python environment
./setup-python.sh --recreate-venv  # Recreate virtual environment
```

### Individual Scripts
```bash
./postgres.sh         # Set up PostgreSQL
./setup-claude-code.sh # Install Claude Code CLI
./fix-git-branch-display.sh    # Fix terminal display issues
./fix-terminal-icons.sh        # Fix terminal icons
```

## 🐚 Shell Aliases

### Modern CLI Tools
| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat` | Syntax highlighting, line numbers, Git integration |
| `ls` | `eza --long --header --git` | Better ls with Git status |
| `la` | `eza --long --all --header --git` | List all files with Git status |
| `tree` | `eza --tree` | Directory tree view |
| `find` | `fd` | Faster, user-friendly find |
| `cd` | `z` | Smart directory jumping with zoxide |

### Python Development
| Alias | Command | Description |
|-------|---------|-------------|
| `activate` | `source ~/.venv/bin/activate` | Activate default virtual environment |

### Network Utilities
| Alias | Command | Description |
|-------|---------|-------------|
| `myip` | `curl -s ifconfig.me && echo` | Get external IP address |
| `localip` | `ipconfig getifaddr en0` | Get local network IP |
| `ports` | `netstat -tuln` | Show open ports |
| `listening` | `lsof -iTCP -sTCP:LISTEN -n -P` | Show listening services |
| `pingg` | `ping google.com` | Quick ping to Google |
| `flushdns` | `sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder` | Clear DNS cache |

### Node.js/npm
| Alias | Command | Description |
|-------|---------|-------------|
| `ni` | `npm install` | Install dependencies |
| `nid` | `npm install --save-dev` | Install dev dependencies |
| `nig` | `npm install -g` | Install globally |
| `nls` | `npm list --depth=0` | List installed packages |
| `nod` | `npm outdated` | Check outdated packages |
| `nup` | `npm update` | Update packages |

### pnpm (Preferred Package Manager)
| Alias | Command | Description |
|-------|---------|-------------|
| `pi` | `pnpm install` | Install dependencies |
| `pa` | `pnpm add` | Add package |
| `pad` | `pnpm add --save-dev` | Add dev dependency |
| `pag` | `pnpm add --global` | Add globally |
| `pr` | `pnpm remove` | Remove package |
| `pls` | `pnpm list` | List packages |
| `pod` | `pnpm outdated` | Check outdated packages |
| `pup` | `pnpm update` | Update packages |
| `px` | `pnpm dlx` | Execute package without installing |
| `prun` | `pnpm run` | Run script |
| `pdev` | `pnpm run dev` | Run dev script |
| `pbuild` | `pnpm run build` | Run build script |
| `ptest` | `pnpm run test` | Run test script |

### PostgreSQL
| Alias | Command | Description |
|-------|---------|-------------|
| `pgstart` | `brew services start postgresql` | Start PostgreSQL |
| `pgstop` | `brew services stop postgresql` | Stop PostgreSQL |
| `pgrestart` | `brew services restart postgresql` | Restart PostgreSQL |
| `pglocal` | `psql -d postgres` | Connect to local PostgreSQL |

### Dev Containers
| Alias | Command | Description |
|-------|---------|-------------|
| `dcbuild` | `devcontainer build` | Build dev container |
| `dcup` | `devcontainer up` | Start dev container |
| `dcopen` | `devcontainer open` | Open project in dev container |
| `dcexec` | `devcontainer exec` | Execute command in dev container |
| `dcstop` | `devcontainer stop` | Stop dev container |

### Claude Code CLI
| Alias | Command | Description |
|-------|---------|-------------|
| `cc` | `claude` | Start Claude Code assistant |
| `cchelp` | `claude --help` | Show Claude Code help |
| `ccauth` | `claude auth login` | Authenticate with Claude |
| `ccstatus` | `claude auth status` | Check authentication status |

## 🔀 Git Aliases

### Basic Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `s` | `status` | Working tree status |
| `ss` | `status --short --branch` | Compact status with branch |
| `d` | `diff --patch-with-stat` | Show changes with stats |
| `l` | `log --pretty=oneline -n 20 --graph --abbrev-commit` | Compact log |
| `lg` | `log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit` | Beautiful log |

### Branch Management
| Alias | Command | Description |
|-------|---------|-------------|
| `cb` | `branch --show-current` | Show current branch |
| `nb` | `checkout -b` | Create and switch to new branch |
| `go` | `checkout -b "$1" 2> /dev/null \|\| git checkout "$1"; git pull origin "$1"` | Smart branch switching |
| `branches-by-date` | `branch --sort=-committerdate` | List branches by date |

### Commit Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `ca` | `add -A && commit -av` | Commit all changes |
| `cm` | `commit -m` | Quick commit with message |
| `amend` | `commit --amend --reuse-message=HEAD` | Amend last commit |
| `amend-quick` | `commit --amend --no-edit` | Amend without editing message |
| `undo` | `reset --soft HEAD~1` | Undo last commit (keep staged) |
| `unstage` | `reset HEAD~1` | Undo last commit and unstage |

### Information & History
| Alias | Command | Description |
|-------|---------|-------------|
| `last` | `show --name-only` | Files changed in last commit |
| `file-history` | `log --follow --patch --` | Show commits that touch a file |
| `tree` | `log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all` | Git tree with all branches |
| `contributors` | `shortlog --summary --numbered` | List contributors |

### Stash Management
| Alias | Command | Description |
|-------|---------|-------------|
| `st` | `stash push -m "$1"` | Create named stash |
| `stl` | `stash list` | List stashes |
| `sta` | `stash apply stash@{"$1"}` | Apply stash by index |
| `str` | `stash drop stash@{"$1"}` | Remove stash by index |

### Advanced Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `squash` | `reset --soft HEAD~${1} && commit --edit` | Squash last n commits |
| `dm` | `branch --merged \| grep -v '\\*' \| xargs -n 1 git branch -d` | Delete merged branches |

## 🛠 Development Tools

### Installed Tools
- **Languages**: Node.js (with nvm), Python (with pyenv), Java (OpenJDK)
- **Package Managers**: pnpm (preferred), npm, uv (Python), Homebrew
- **Version Managers**: nvm (Node.js), pyenv (Python)
- **Infrastructure**: Terraform, Checkov, Docker
- **CI/CD**: GitHub CLI (gh), act (local GitHub Actions)
- **AI Assistants**: Claude Code CLI, GitHub Copilot
- **Editors**: VS Code, Windsurf (AI-powered)

### Modern CLI Alternatives
- **bat** → Better `cat` with syntax highlighting
- **eza** → Better `ls` with Git integration  
- **fd** → Better `find`
- **ripgrep** → Better `grep`
- **zoxide** → Better `cd` with frequency tracking
- **fzf** → Fuzzy finder
- **delta** → Better Git diff
- **htop** → Better `top`

### Network Tools
- **dig, nslookup** → DNS utilities
- **nmap** → Network scanning
- **netcat, telnet** → Network connections
- **wget, curl** → File downloading
- **mtr** → Network diagnostics
- **tcpdump, wireshark** → Packet analysis

## ⚙️ Configuration Details

### Shell (zsh)
- **Theme**: Powerlevel10k with custom configuration
- **Plugin Manager**: zplug
- **Plugins**: zsh-nvm, zsh-syntax-highlighting, zsh-autosuggestions
- **Modern tools**: Automatic zoxide integration, enhanced completions

### Git Configuration
- **Modern settings**: zdiff3 conflict style, autosquash, autostash
- **Enhanced diffs**: histogram algorithm, color moved blocks
- **Smart features**: auto-setup remote, rerere conflict memory
- **Commit template**: Conventional commits with examples

### Python Environment
- **Version Manager**: pyenv with pyenv-virtualenv
- **Package Manager**: uv (modern pip replacement)
- **Default Environment**: ~/.venv with easy activation
- **Tools**: Latest Python with proper PATH configuration

### Node.js Environment
- **Version Manager**: nvm with completion
- **Package Manager**: pnpm (fast, disk-efficient)
- **Runtime**: Latest stable Node.js
- **Aliases**: Comprehensive shortcuts for common operations

### VS Code
- **Vim Mode**: Enabled with smart relative line numbers
- **Key Repeat**: Configured for vim navigation
- **Auto-formatting**: Enabled with consistent settings

## 🔒 Security Features

### Git Security
- **Signed commits**: Configurable GPG signing
- **Sensitive files**: Comprehensive .gitignore patterns
- **SSH keys**: Excluded from version control

### Environment Security
- **Secrets management**: .env files in gitignore
- **SSH configuration**: Private keys excluded
- **Network security**: Tools for security analysis

## 🐳 Dev Containers

### Available Templates
- **nodejs** - Node.js development with TypeScript, pnpm, ESLint, Prettier
- **python** - Python development with uv, Black, Flake8, Jupyter  
- **fullstack** - Full-stack development with Node.js, Python, Terraform

### Setup Dev Container
```bash
# Interactive setup (recommended)
./setup-devcontainer.sh

# Quick setup for current directory
./setup-devcontainer.sh nodejs .

# Setup for specific project
./setup-devcontainer.sh python /path/to/project
```

### Dev Container Features
- **Consistent environments** across team members
- **Pre-configured tools** and extensions
- **Automatic port forwarding** for development servers
- **Git and SSH config mounting** from host
- **VS Code integration** with proper settings
- **Modern package managers** (pnpm, uv) pre-installed
- **AI assistance** with Claude Code CLI and Codeium extensions

## 📚 Usage Examples

### Quick Development Setup
```bash
# Clone a project
git clone <repo-url>
cd project

# Install dependencies (using pnpm)
pi

# Start development
pdev
```

### Dev Container Workflow
```bash
# Set up dev container for project
./setup-devcontainer.sh nodejs my-project

# Open in VS Code (will prompt for container)
code my-project

# Or use dev container CLI
dcopen my-project
```

### Network Diagnostics
```bash
# Check your IP
myip

# See what's listening
listening

# Scan a host
nmap hostname

# Test connectivity
pingg
```

### Python Development
```bash
# Activate environment
activate

# Install package with uv
uv add package-name

# Create new environment
uv venv new-project
```

### AI-Assisted Development
```bash
# Start Claude Code assistant
cc

# Authenticate with Claude (first time)
ccauth

# Check authentication status
ccstatus

# Get help with Claude Code
cchelp
```

## 🔄 Maintenance

### Update Tools
```bash
brew update && brew upgrade  # Update Homebrew packages
pup                          # Update pnpm packages
pyenv update                 # Update pyenv
```

### Backup & Sync
All configurations are version controlled. Simply commit changes:
```bash
git add .
git commit -m "feat: update configuration"
git push
```

## 🔗 References

- [Terminal Customization Guide](https://gist.github.com/ghorsey/613a38a6931ba64425ad80f9035194db)
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)

---

⭐ **Pro Tip**: Use `tldr <command>` for quick command references, and `fzf` for fuzzy finding files and command history!