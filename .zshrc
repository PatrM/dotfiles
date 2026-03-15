
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export DOCKER_DEFAULT_PLATFORM=linux/amd64

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

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
ZSH_AUTOSUGGEST_DIR="$HOME/.zsh/zsh-autosuggestions"
ZSH_AUTOSUGGEST_FILE="$ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh"
if [ ! -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && [ ! -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] \
  && [ ! -f "$ZSH_AUTOSUGGEST_FILE" ]; then
  if command -v git >/dev/null 2>&1; then
    mkdir -p "$HOME/.zsh"
    GIT_TERMINAL_PROMPT=0 git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR" >/dev/null 2>&1
  fi
fi

if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f "$ZSH_AUTOSUGGEST_FILE" ]; then
  source "$ZSH_AUTOSUGGEST_FILE"
fi

# User configuration and aliases

source ~/.aliases || true
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

gac() {
  # 1. Ensure there are staged changes
  local diff
  diff=$(git diff --cached)
  if [ -z "$diff" ]; then
    echo "No staged changes found. Run 'git add' first."
    return 1
  fi

  # 2. Handle the Jira ticket ID (Argument -> Branch Name Fallback)
  local ticket_id="$1"
  
  if [ -z "$ticket_id" ]; then
    local branch
    branch=$(git branch --show-current)
    # Extract standard Jira formats (e.g., MNB-123) from the branch name
    ticket_id=$(echo "$branch" | grep -oE '[A-Z]+-[0-9]+' | head -n 1)
  fi

  # 3. Build the instruction suffix if a ticket was found
  local suffix_instruction=""
  if [ -n "$ticket_id" ]; then
    suffix_instruction=" The description MUST end with the Jira ticket ID, like this: <description> $ticket_id"
  fi

  # 4. Define the strict prompt
  # We instruct Claude to avoid double quotes so the resulting terminal command doesn't break
  local prompt="Analyze the following git diff and generate a semantic commit message.
Format: <type>(<scope>): <description>
Types: feat, fix, docs, style, refactor, perf, test, chore.$suffix_instruction

Return ONLY the commit message text. Do NOT wrap in quotes, backticks, or code blocks. Do not add conversational filler. Do NOT use double quotes inside the message.

Diff:
$diff"

  # 5. Call Claude Code CLI silently, then output the ready-to-use command
  echo "Generating commit message via Claude (Sonnet)..."
  
  local msg
  msg=$(claude --model sonnet -p "$prompt")

  local cmd="git commit -m \"$msg\""

  # Use printf to avoid any trailing newline weirdness in the clipboard
  printf "%s" "$cmd" | pbcopy

  echo ""
  echo "✅ Copied to clipboard! Just paste (Cmd+V) and hit Enter:"
  echo "$cmd"
  echo ""
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

<<<<<<< HEAD
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/patrick/google-cloud-sdk/path.zsh.inc' ]; then . '/home/patrick/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/patrick/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/patrick/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/home/patrick/.bun/_bun" ] && source "/home/patrick/.bun/_bun"
[ -s "/Users/patrick/.bun/_bun" ] && source "/Users/patrick/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/Users/patrick/.opencode/bin:$PATH
=======
# opencode
export PATH=/home/patrick/.opencode/bin:$PATH
>>>>>>> 979ba5e (local path change)
