#!/usr/bin/env bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

echo "Fixing terminal icons configuration..."

# Ensure p10k.zsh is properly linked
if [ -f "$SCRIPT_DIR/.p10k.zsh" ]; then
  echo "Linking .p10k.zsh configuration file..."
  ln -sf "$SCRIPT_DIR/.p10k.zsh" ~/.p10k.zsh
else
  echo "Error: .p10k.zsh not found in $SCRIPT_DIR"
  exit 1
fi

# Ensure Nerd Font is properly configured
echo "
=================================================================
TERMINAL FONT CONFIGURATION INSTRUCTIONS:
=================================================================

To properly display icons in your terminal, follow these steps:

1. Open your terminal preferences (⌘+,)
2. Go to the 'Profiles' tab
3. Select your active profile
4. Click on the 'Text' tab
5. Change the font to one of these Nerd Fonts (already installed):
   - MesloLGS NF
   - FiraCode Nerd Font
   - Hack Nerd Font

6. After changing the font, restart your terminal

=================================================================
"

# Reload zsh configuration
echo "Reloading zsh configuration..."
echo "source ~/.zshrc" > /tmp/reload_zsh.sh
echo "Restart your terminal or run 'source ~/.zshrc' to apply changes"

echo "Terminal icons fix complete!"
