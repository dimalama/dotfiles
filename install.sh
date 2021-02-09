# Install Homebrew Packages
#sh brew.sh

# add symlinks
ln -s ~/dotfiles/.bash_profile ~/.bash_profile
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.zshrc ~/.zshrc
# ln -s ~/dotfiles/.ssh ~/.ssh


# configure VSCode
sh vscode.sh

echo '====== Installation complete ======'
