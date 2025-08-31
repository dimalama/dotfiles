# Manual Installation Required

This document lists tools and applications that need to be installed manually and cannot be automated through Homebrew or scripts.

## App Store Applications

### Required
- **Xcode** - Apple's IDE for iOS/macOS development
  - Install from Mac App Store
  - Required for iOS development and some command-line tools
  - Large download (~10GB+)

## Hardware-Specific Drivers

### DisplayLink (if needed)
- **Status**: Driver deprecated in Homebrew
- **When needed**: For external monitors via USB/Thunderbolt docks
- **Installation**: Download from [Synaptics DisplayLink](https://www.synaptics.com/products/displaylink-graphics/downloads/macos)
- **Note**: Only install if you have DisplayLink-compatible hardware

## VPN Applications

### NordVPN
- **Installation**: Download from [NordVPN website](https://nordvpn.com/download/macos/)
- **Configuration**: Sign in with your NordVPN account credentials
- **Note**: Requires active subscription

## Manual Configuration Required

### After Installation
1. **Alfred Powerpack License** (if purchased)
   - Enter license key in Alfred Preferences
   
2. **1Password Setup**
   - Sign in to your 1Password account
   - Enable SSH agent in Developer settings
   - Configure browser extensions

3. **Rectangle Configuration**
   - Grant accessibility permissions in System Preferences
   - Configure keyboard shortcuts

4. **Flux Configuration**
   - Set your location for automatic sunrise/sunset
   - Adjust color temperature preferences

5. **Git SSH Keys**
   - Generate SSH keys if not already present
   - Add public key to GitHub/GitLab accounts
   - Configure with `./setup-git-environment.sh`

6. **VS Code Extensions**
   - Extensions will sync if you're signed into VS Code
   - Manually install if needed:
     - Vim extension
     - GitHub Copilot (if licensed)
     - Language-specific extensions

## Browser Setup

### Extensions to Install Manually
- **1Password** - Password manager browser extension
- **uBlock Origin** - Ad blocker
- **Grammarly** - Grammar and spell checker (if using the desktop app)

### Bookmarks and Settings
- Import bookmarks from previous setup
- Configure default search engine
- Set up sync with your account

## Notes
- Check this list after running `./install.sh` to complete your setup
- Some applications may require system restarts or permission grants
- Enterprise users should check with IT before installing corporate applications