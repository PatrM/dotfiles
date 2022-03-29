# config-files
collection of various configs for e.g. vim/vs code etc.

# 




# First time requirements / Setup

**TODO move steps below into shell script**

* *If missing* Git <https://git-scm.com/downloads>
* Node <https://nodejs.org/en/download/package-manager/>
* Neovim 0.6+ <https://github.com/neovim/neovim>
* Fd <https://github.com/sharkdp/fd>
* *Optional for CLI* Fzf <https://github.com/junegunn/fzf>
* Java
* Execute `symlink_setup.sh` in root of repository
* Make a copy of [local-config.lua.example](.config/nvim/lua/local-config.lua.example), strip off the `.example` and enter proper values for local configuration
* Install language servers for neovim `npm install -g @angular/language-server pyright typescript-language-server typescript dockerfile-language-server-nodejs`
* Misc tools provided via npm: `npm install -g rimraf`
