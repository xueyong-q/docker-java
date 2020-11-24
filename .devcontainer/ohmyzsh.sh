#!/usr/bin/env bash

if [ ! -e ~/ohmyzsh.lock ]; then
    
    if [ -e ~/.oh-my-zsh ]; then rm -rf ~/.oh-my-zsh; fi
    
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    cat ~/.oh-my-zsh/templates/zshrc.zsh-template >> ~/.zshrc && \
    echo "1" > ~/ohmyzsh.lock
fi