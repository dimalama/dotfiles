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
