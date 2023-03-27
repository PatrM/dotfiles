# Dotfiles

**TODO move steps below into shell script or ansible. **

## First time requirements / Setup

* If macOS [brew.sh](https://brew.sh/)
* sdkman <https://sdkman.io/install>
  * Afterwards [Java versions](https://sdkman.io/jdks#oracle), [maven/gradle](https://sdkman.io/sdks#gradle)
* NVM <https://github.com/nvm-sh/nvm#install--update-script>
  * Afterwards, execute `nvm install 'lts/*'`
* Execute `symlink_setup.sh` in root of repository
* Misc tools provided via npm: `npm install -g rimraf`
* Fzf <https://github.com/junegunn/fzf>
* Fd <https://github.com/sharkdp/fd>

### Manual Neovim steps

* Neovim <https://github.com/neovim/neovim>
    *  Clone repository --> `make install`
* Make a copy of [local-config.lua.example](.config/nvim/lua/local-config.lua.example), strip off the `.example` and enter proper values for local configuration

### Java Debugging
* `git clone git@github.com:eclipse/eclipse.jdt.ls.git ~/dev/tools/eclipse.jdt.ls && cd ~/dev/tools/eclipse.jdt.ls && ./mvnw clean verify -DskipTests`
* `git clone git@github.com:microsoft/java-debug.git ~/dev/tools/java-debug && cd ~/dev/tools/java-debug && ./mvnw clean install`
  * might have to `@Ignore` some tests in case of failures. Due to OS/java version differences there could be issues with e.g. numeric formatter
* `git clone git@github.com:microsoft/vscode-java-test.git ~/dev/tools/vscode-java-test && cd ~/dev/tools/vscode-java-test && npm install && npm run build-plugin`
