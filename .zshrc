export ZPLUG_HOME=/usr/local/opt/zplug

# zplug init
source $ZPLUG_HOME/init.zsh

#editor
export EDITOR=vim

export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

#zplug
zplug "dracula/zsh", as:theme
zplug "lukechilds/zsh-nvm"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# iOS Dev: Fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

#load
zplug load


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

DEFAULT_USER=$(whoami)
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"

source $(brew --prefix)/etc/bash_completion.d/az
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# Added by Windsurf
export PATH="/Users/$DEFAULT_USER/.codeium/windsurf/bin:$PATH"

# Source powerlevel10k
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
