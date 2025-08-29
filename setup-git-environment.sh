#!/bin/bash

# Git Environment Setup Script
# Configures Git for personal vs work environments

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


# Choose environment
choose_environment() {
    echo >&2
    print_status "Please choose your environment:" >&2
    echo "1) Personal (uses 1Password SSH signing)" >&2
    echo "2) Work (no 1Password, standard GPG or no signing)" >&2
    echo >&2
    
    while true; do
        read -p "Enter choice (personal/work or 1/2): " choice
        case $choice in
            1|personal|p) 
                echo "personal"
                return 0
                ;;
            2|work|w) 
                echo "work"
                return 0
                ;;
            *) 
                print_error "Invalid choice. Please enter 'personal', 'work', '1', or '2'." >&2
                ;;
        esac
    done
}

# Setup personal environment
setup_personal() {
    print_status "Setting up personal Git environment with 1Password SSH signing..."
    
    # Create symbolic link from dotfiles to home directory
    if [[ ! -L ~/.gitconfig.personal ]]; then
        if [[ -f "$SCRIPT_DIR/.gitconfig.personal.template" ]]; then
            # Remove existing file if it exists
            [[ -f ~/.gitconfig.personal ]] && rm ~/.gitconfig.personal
            ln -s "$SCRIPT_DIR/.gitconfig.personal.template" ~/.gitconfig.personal
            print_success "Created symbolic link ~/.gitconfig.personal -> $SCRIPT_DIR/.gitconfig.personal.template"
        else
            print_error "Personal template not found"
            return 1
        fi
    else
        print_status "Symbolic link ~/.gitconfig.personal already exists"
    fi
    
    # SSH key auto-detection and configuration
    echo
    print_status "SSH Key Configuration"
    
    # Try to auto-detect SSH keys
    ssh_keys=($(find ~/.ssh -name "*.pub" -type f 2>/dev/null))
    
    if [[ ${#ssh_keys[@]} -eq 0 ]]; then
        print_warning "No SSH public keys found in ~/.ssh/"
        print_status "You may need to generate an SSH key first:"
        echo "  ssh-keygen -t ed25519 -C \"your.email@example.com\""
        return 0
    elif [[ ${#ssh_keys[@]} -eq 1 ]]; then
        print_status "Auto-detected SSH key: ${ssh_keys[0]}"
        read -p "Use this key for Git signing? (Y/n): " use_key
        case $use_key in
            n|N|no|No)
                # Fall through to manual selection
                ;;
            *)
                ssh_key_path="${ssh_keys[0]}"
                sed -i '' "s|signingkey = ~/.ssh/YOUR_SSH_KEY.pub|signingkey = $ssh_key_path|" ~/.gitconfig.personal
                print_success "SSH key configured: $ssh_key_path"
                return 0
                ;;
        esac
    else
        print_status "Multiple SSH keys found:"
        for i in "${!ssh_keys[@]}"; do
            echo "  $((i+1))) ${ssh_keys[i]}"
        done
        
        while true; do
            read -p "Select SSH key (1-${#ssh_keys[@]}): " key_choice
            if [[ "$key_choice" =~ ^[0-9]+$ ]] && \
               [[ "$key_choice" -ge 1 ]] && \
               [[ "$key_choice" -le ${#ssh_keys[@]} ]]; then
                ssh_key_path="${ssh_keys[$((key_choice-1))]}"
                sed -i '' "s|signingkey = ~/.ssh/YOUR_SSH_KEY.pub|signingkey = $ssh_key_path|" ~/.gitconfig.personal
                print_success "SSH key configured: $ssh_key_path"
                return 0
            else
                print_error "Invalid selection. Please choose 1-${#ssh_keys[@]}."
            fi
        done
    fi
    
    # Manual SSH key input as fallback
    echo
    print_status "Available SSH public keys in ~/.ssh/:"
    ls -1 ~/.ssh/*.pub 2>/dev/null || echo "No .pub files found"
    echo
    
    while true; do
        read -p "Enter path to your SSH public key (e.g., ~/.ssh/id_ed25519.pub): " ssh_key_path
        
        # Expand tilde
        ssh_key_path="${ssh_key_path/#\~/$HOME}"
        
        if [[ -f "$ssh_key_path" ]]; then
            # Update the gitconfig.personal file with the SSH key
            sed -i '' "s|signingkey = ~/.ssh/YOUR_SSH_KEY.pub|signingkey = $ssh_key_path|" ~/.gitconfig.personal
            print_success "SSH key configured: $ssh_key_path"
            break
        else
            print_error "SSH key not found at: $ssh_key_path"
            echo "Please check the path and try again."
        fi
    done
    
    # Verify 1Password SSH agent
    if [[ ! -f "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ]]; then
        print_warning "1Password SSH agent not found"
        print_status "Make sure 1Password is installed and SSH agent is enabled"
    fi
    
    print_success "Personal Git environment configured"
}

# Setup work environment
setup_work() {
    print_status "Setting up work Git environment (no 1Password signing)..."
    
    # Create symbolic link from dotfiles to home directory
    if [[ ! -L ~/.gitconfig.work ]]; then
        if [[ -f "$SCRIPT_DIR/.gitconfig.work.template" ]]; then
            # Remove existing file if it exists
            [[ -f ~/.gitconfig.work ]] && rm ~/.gitconfig.work
            ln -s "$SCRIPT_DIR/.gitconfig.work.template" ~/.gitconfig.work
            print_success "Created symbolic link ~/.gitconfig.work -> $SCRIPT_DIR/.gitconfig.work.template"
            print_warning "Please edit $SCRIPT_DIR/.gitconfig.work.template with your work email and settings"
        else
            print_error "Work template not found at: $SCRIPT_DIR/.gitconfig.work.template"
            return 1
        fi
    else
        print_status "Symbolic link ~/.gitconfig.work already exists"
    fi
    
    print_success "Work Git environment configured"
}

# Main setup function
main() {
    echo "Git Environment Setup"
    echo "===================="
    
    # Choose environment
    ENV=$(choose_environment)
    
    print_status "Environment selected: $ENV"
    
    # Setup based on environment
    case $ENV in
        "personal")
            setup_personal
            ;;
        "work")
            setup_work
            ;;
        *)
            print_error "Unknown environment: $ENV"
            exit 1
            ;;
    esac
    
    echo
    print_success "Git environment setup complete!"
    print_status "You can verify your configuration with: git config --list --show-origin"
}

# Run main function
main "$@"
