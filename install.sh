# Install Homebrew Packages
#sh brew.sh

# add symlinks
ln -s ~/Projects/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/Projects/dotfiles/.vimrc ~/.vimrc
ln -s ~/Projects/dotfiles/.vim ~/.vim
ln -s ~/Projects/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Projects/dotfiles/.zshrc ~/.zshrc
ln -s ~/Projects/dotfiles/.npmrc ~/.npmrc
ln -s ~/Projects/dotfiles/.stCommitMsg ~/.stCommitMsg
ln -s ~/Projects/dotfiles/gh/config.yml ~/.config/gh/config.yml
ln -s ~/Projects/dotfiles/gh-dash/config.yml ~/.config/gh-dash/config.yml
ln -s ~/Projects/dotfiles/.ssh ~/.ssh


# configure VSCode
sh vscode.sh

echo '====== Installation complete ======'
