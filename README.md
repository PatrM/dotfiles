# config-files
collection of various configs for e.g. vim/vs code etc.

# 




# First time requirements / Setup

**TODO move steps below into shell script**

* *If missing* Git <https://git-scm.com/downloads>
* If macOS [brew.sh](https://brew.sh/)
* sdkman <https://sdkman.io/install>
  * Afterwards [Java versions](https://sdkman.io/jdks#oracle), [maven/gradle](https://sdkman.io/sdks#gradle)
* NVM <https://github.com/nvm-sh/nvm#install--update-script>
  * Afterwards, execute `nvm install 'lts/*'`
* Neovim 0.6+ <https://github.com/neovim/neovim>
* Fd <https://github.com/sharkdp/fd>
* *Optional for CLI* Fzf <https://github.com/junegunn/fzf>
* Execute `symlink_setup.sh` in root of repository
* Make a copy of [local-config.lua.example](.config/nvim/lua/local-config.lua.example), strip off the `.example` and enter proper values for local configuration
* Install language servers for neovim `npm install -g @angular/language-server pyright typescript-language-server typescript dockerfile-language-server-nodejs @angular/language-service vscode-langservers-extracted`
* [Precompiled binary of sumneko lua LSP](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run)
* Misc tools provided via npm: `npm install -g rimraf`


## Java Debugging in Neovim 
* `git clone git@github.com:eclipse/eclipse.jdt.ls.git ~/dev/tools/eclipse.jdt.ls && cd ~/dev/tools/eclipse.jdt.ls && ./mvnw clean verify -DskipTests`
* `git clone git@github.com:microsoft/java-debug.git ~/dev/tools/java-debug && cd ~/dev/tools/java-debug && ./mvnw clean install`
  * might have to `@Ignore` some tests in case of failures. Due to OS/java version differences there could be issues with e.g. numeric formatter
* `git clone git@github.com:microsoft/vscode-java-test.git ~/dev/tools/vscode-java-test && cd ~/dev/tools/vscode-java-test && npm install && npm run build-plugin`
