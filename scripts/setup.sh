#!/bin/bash


DEV_DIR="${HOME}/dev"
TOOLS_DIR="${DEV_DIR}/tools"
NOTES_DIR="${DEV_DIR}/notes"


if [ -d $TOOLS_DIR ]; then
  echo "${TOOLS_DIR} already exists"
else 
  mkdir -p ${TOOLS_DIR}
  echo "Created ${TOOLS_DIR}"
fi

if [ -d $NOTES_DIR ]; then
  echo "${NOTE_DIR} already exists"
else 
  mkdir -p ${NOTES_DIR}
  echo "Created ${NOTES_DIR}"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Installing brew"
  /bin/bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
fi

echo "Installing sdkman"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
echo "Done. Don't forget to install node etc -> nvm install 'lts/*'"

touch .aliases-local
/bin/bash -c ./symlink_setup.sh


if which brew > /dev/null; then
  /bin/bash -c ./brew.sh
else
  echo "brew not found. Run brew.sh manually"
fi
