#!/usr/bin/env bash
set -e

echo "Fixing git branch display in terminal..."

# Create a backup of the current .p10k.zsh file (only if not already backed up)
if [ -f ~/.p10k.zsh ] && [ ! -f ~/.p10k.zsh.backup ]; then
  cp ~/.p10k.zsh ~/.p10k.zsh.backup
  echo "Created backup of existing .p10k.zsh at ~/.p10k.zsh.backup"
elif [ -f ~/.p10k.zsh.backup ]; then
  echo "Backup of .p10k.zsh already exists at ~/.p10k.zsh.backup"
fi

# Check if fix has already been applied
if grep -q "POWERLEVEL9K_VCS_BRANCH_ICON='git:'" ~/.zshrc; then
  echo "Git branch display settings already exist in .zshrc, skipping..."
else
  # Add text-based fallback for git branch display to .zshrc
  cat << 'EOF' >> ~/.zshrc

# Fix for git branch display - added by fix-git-branch-display.sh
# This sets a simple text-based format for git branch display
POWERLEVEL9K_VCS_BRANCH_ICON='git:'
POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
# Force reload powerlevel10k using architecture-aware path
source $(brew --prefix)/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

EOF
  echo "Added text-based git branch display to .zshrc"
fi

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
