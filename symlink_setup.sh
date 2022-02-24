#!/bin/bash


# create missing directories. manually for now
mkdir -p "$HOME/.config/nvim/lua"

for file in $(find . -type f -not -path '*/\.git/*' -not -name 'README.md' -not -name 'symlink_setup.sh'); do
  stripped=${file:2}
  source=$(echo "$PWD/$stripped")
  target=$(echo "$HOME/$stripped")
  echo "$source -> $target"
  ln -sf $source $target
done
  


