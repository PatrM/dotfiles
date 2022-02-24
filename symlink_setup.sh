#!/bin/bash


# create missing directories. manually for now
mkdir -p "$HOME/.config/nvim/lua"

for file in $(find . -type f -not -path '*/\.git/*' -not -name 'README.md' -not -name 'symlink_setup.sh'); do
  stripped=${file:2}
  target=$(echo "$HOME/$stripped")
  echo "$file -> $target"
  ln -sf $file $target
done
  


