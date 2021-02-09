#!/usr/bin/env bash

#To enable key-repeating for vim for VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium
defaults delete -g ApplePressAndHoldEnabled                                      # If necessary, reset global default