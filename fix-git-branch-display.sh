#!/usr/bin/env bash
set -e

echo "Fixing git branch display in terminal..."

# Create a backup of the current .p10k.zsh file
if [ -f ~/.p10k.zsh ]; then
  cp ~/.p10k.zsh ~/.p10k.zsh.backup
  echo "Created backup of existing .p10k.zsh at ~/.p10k.zsh.backup"
fi

# Add text-based fallback for git branch display to .zshrc
cat << 'EOF' >> ~/.zshrc

# Fix for git branch display - added by fix-git-branch-display.sh
# This sets a simple text-based format for git branch display
POWERLEVEL9K_VCS_BRANCH_ICON='git:'
POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
# Force reload powerlevel10k
source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

EOF

echo "Added text-based git branch display to .zshrc"

# Provide instructions for manually running p10k configure
echo "
=================================================================
MANUAL CONFIGURATION INSTRUCTIONS:
=================================================================

To fully fix the git branch display, run the following command:

    p10k configure

This will launch the Powerlevel10k configuration wizard.
Choose the following options when prompted:
- Select 'Lean' style (option 1)
- Choose 'Unicode' for character set (not Nerd Font)
- Answer 'No' when asked if you see icons displaying correctly

After completing the wizard, restart your terminal.

=================================================================
"

echo "To apply changes immediately, run: source ~/.zshrc"
echo "Git branch display fix complete!"
