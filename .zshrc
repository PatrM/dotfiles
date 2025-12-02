
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

mkdir -p $HOME/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin

# Starship optional installation + sourcing
if ! command -v starship >/dev/null 2>&1; then
    STARSHIP_HOME="${HOME}/.local/bin"
    mkdir -p "$STARSHIP_HOME"
    if [ ! -x "${STARSHIP_HOME}/starship" ]; then
      echo "starship missing; installing to ${STARSHIP_HOME}..."
      curl -fsSL https://starship.rs/install.sh | sh -s -- -y --bin-dir "${STARSHIP_HOME}"
    fi
    export PATH="${STARSHIP_HOME}:${PATH}"
  fi

  eval "$(starship init zsh)"

# Keep a usable history and completions even without oh-my-zsh
bindkey -e
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt inc_append_history share_history hist_ignore_all_dups hist_find_no_dups extended_glob

autoload -Uz compinit
ZCOMPDUMP=${ZDOTDIR:-$HOME}/.zcompdump
if [[ -n ${ZCOMPDUMP}(#qN.mh-24) ]]; then
  compinit -C
else
  compinit
fi

# Prefix-search on arrow keys like the old history-substring-search plugin
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Autosuggestions from history (Homebrew or manual install)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# User configuration and aliases

source ~/.aliases
source ~/.aliases-local || true

# custom functions
git_qp() {
  git pull && git add . && git commit -m "$1" && git push
}

git_ezsquash() {
    # no clue how good of an idea that is honestly
    CURRENT="$(git branch --show-current)"
    echo "> Current branch: $CURRENT"
    COPY="$CURRENT-copy"
    WORKING_BRANCH='master'

    echo "> Renaming branch to $COPY."
    git branch -m "$COPY"
    git checkout "$WORKING_BRANCH"
    git pull
    git checkout -b "$CURRENT"

    echo "> Squashing $COPY -> $CURRENT"
    git merge --squash "$COPY"

    echo '> Done. committing.'
    git commit
}

gch() {
    git checkout "$(git branch --all  | fzf | tr -d '[:space:]')"
}

gstash() {
    git stash -m "$1"
}

cdd() {
    cd "$(find ~/dev -type d -print | fzf | tr -d '[:space:]')"
}

work() {
    timer 30m -n Work && terminal-notifier -message 'Pomodoro' -title 'Work Timer is up! Take a Break 😊' -appIcon '~/Pictures/pumpkin.png' -sound Crystal
}

rest() {
    timer 10m -n Rest && terminal-notifier -message 'Pomodoro' -title 'Break is over! Get back to work 😬' -appIcon '~/Pictures/pumpkin.png' -sound Crystal
}


# autoload -U promptinit; promptinit


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)


# Auto-activate Python virtualenv when entering a directory with .venv
autoload -U add-zsh-hook

function auto_venv() {
  if [ -n "$VIRTUAL_ENV" ] && [ ! -d "$PWD/.venv" ]; then
    deactivate >/dev/null 2>&1
  fi

  if [ -d "$PWD/.venv" ] && [ -z "$VIRTUAL_ENV" ]; then
    source "$PWD/.venv/bin/activate"
  fi
}

add-zsh-hook chpwd auto_venv
# Also run once on shell start (in case you start inside a venv directory)
auto_venv

# Added by Antigravity
export PATH="/Users/patrick/.antigravity/antigravity/bin:$PATH"
