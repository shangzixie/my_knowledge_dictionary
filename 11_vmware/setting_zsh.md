# setting zsh and plugins

* install zsh: `sudo yum install zsh`
* install oh my zsh: [link](https://ohmyz.sh/#install)
* install auto suggestion: [link](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
* install syntax highlight: [link](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

## [install docker](https://docs.docker.com/engine/install/centos/)

## backend

* install go:
  * `wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz`
  * `sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz`
  * add into ~/.zshrc: `export PATH=$PATH:/usr/local/go/bin`
  * `source ~/.zshrc`

## frontend

* install nvm:
  * `wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
  * `echo 'export NVM_DIR=~/.nvm' >> ~/.zshrc`
  * `echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.zshrc`
  * `source ~/.zshrc`
* install node `nvm install Fermium`
