export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$'

if gls --color > /dev/null 2>&1; then colorflag="--color"; else colorflag="-G"; fi;
export CLICOLOR_FORCE=1

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
complete -C /usr/local/bin/terraform terraform
