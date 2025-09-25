#!/bin/bash

# Check if we are running on macOS
if [ "$(uname)" != "Darwin" ]; then
  echo "This script is only meant to be run on macOS"
  exit 1
fi

# Check if Homebrew is installed
if ! command -v brew > /dev/null; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
fi

# Install dependencies

brew install \
git \
tmux \
fd \
fzf \
lazygit \
lua \
lua-language-server \
luajit \
luajit-openresty \
ruby \
git-delta \
bat

# casks

brew install --cask iterm2
brew install --cask font-hack-nerd-font
brew install --cask wezterm
brew install --cask todoist
brew install --cask brave-browser
