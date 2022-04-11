source ~/.aliases

autoload -U compinit; compinit
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

setopt PROMPT_SUBST
NEWLINE=$'\n'
PROMPT='%1~%F{bg[white]}${vcs_info_msg_0_}%f %F{cyan}❯%f '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
