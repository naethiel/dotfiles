export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# chnz
export CHNZ_GITLAB_TOKEN="VcvRpEUPtfpyiGmhEwav"
export CHNZ_REPOSITORY_DEFAULT_FOLDER="/Users/nicolasmissika/dev"
export CHNZ_GITLAB_DEFAULT_GROUP="frontend"

# customization

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'
alias ll='ls -la'
