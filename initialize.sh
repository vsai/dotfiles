#!/bin/bash

# Shell config (zsh)
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/zprofile ~/.zprofile
ln -sf ~/dotfiles/zshenv ~/.zshenv

# Shared config
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/bash_aliases ~/.bash_aliases
ln -sf ~/dotfiles/gitconfig ~/.gitconfig

# Claude Code config
ln -sf ~/dotfiles/claude ~/.claude

# Legacy bash (kept for reference, not symlinked)
# ln -sf ~/dotfiles/profile ~/.profile
# ln -sf ~/dotfiles/bash_profile ~/.bash_profile
