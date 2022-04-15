echo "Download..."
cd ~/Downloads
rm -vrf nvim-macos.tar.gz
curl -# -L -O https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar zxpvf nvim-macos.tar.gz

echo "Deleting current version"
rm -rf ~/dev/tools/nvim-osx64


echo "Moving new Neovim"
mv nvim-osx64/ ~/dev/tools/nvim-osx64

echo "Removing downloaded archive"
rm -vrf ~/Downloads/nvim-macos.tar.gz
echo "Done!"
