# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set architecture-specific brew path
if [[ $(uname -m) == 'arm64' ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

export ZPLUG_HOME="$BREW_PREFIX/opt/zplug"

# zplug init
source $ZPLUG_HOME/init.zsh

#editor
export EDITOR=vim

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"

#zplug plugins (only define here, loaded later)
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "lukechilds/zsh-nvm"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# iOS Dev: Fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# Python configuration - ensure Homebrew's Python is used

# Load zplug plugins
zplug load

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

DEFAULT_USER=$(whoami)

# Azure CLI and Terraform completion (only load once)
autoload -U +X bashcompinit && bashcompinit
[[ -f "$BREW_PREFIX/etc/bash_completion.d/az" ]] && source "$BREW_PREFIX/etc/bash_completion.d/az"
complete -o nospace -C "$BREW_PREFIX/bin/terraform" terraform

# Added by Windsurf
export PATH="/Users/$DEFAULT_USER/.codeium/windsurf/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source local environment if it exists
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
# Add default Python virtual environment
alias activate='source ~/.venv/bin/activate'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if command -v pyenv-virtualenv-init 1>/dev/null 2>&1; then
    eval "$(pyenv virtualenv-init -)"
fi

# Add user bin directory to PATH
# export PATH="$HOME/.local/bin:$PATH"

# PostgreSQL
export PGDATA="$BREW_PREFIX/var/postgres"
alias pgstart='brew services start postgresql'
alias pgstop='brew services stop postgresql'
alias pgrestart='brew services restart postgresql'
alias pglocal='psql -d postgres'

