# setting zsh and plugins

* install zsh: `sudo yum install zsh`
* install auto suggestion:
`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions`
`source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh`
* install syntax highlight:
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
`echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc`
`source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`