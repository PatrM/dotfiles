#!/bin/bash

for file in $(find . -type f -not -path '*/\.git/*' -not -path '*/\link_ignored/*' -not -name 'README.md' -not -name 'symlink_setup.sh'); do
  stripped=${file:2}
  source=$(echo "$PWD/$stripped")
  target=$(echo "$HOME/$stripped")
  target_dir="$(dirname $target)"

  echo "$source -> $target"
  
  mkdir -p $target_dir
  ln -sf $source $target
done
