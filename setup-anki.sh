#!/usr/bin/env bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Anki is installed
check_anki_installed() {
    if [ -d "/Applications/Anki.app" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get Anki data directory
get_anki_data_dir() {
    echo "$HOME/Library/Application Support/Anki2"
}

# Function to backup existing Anki configuration
backup_anki_config() {
    local anki_data_dir=$(get_anki_data_dir)
    
    if [ -d "$anki_data_dir" ]; then
        local backup_dir="${anki_data_dir}.backup.$(date +%Y%m%d%H%M%S)"
        print_status "Backing up existing Anki configuration to $backup_dir"
        cp -r "$anki_data_dir" "$backup_dir"
    fi
}

# Function to setup Anki configuration
setup_anki_config() {
    local anki_data_dir=$(get_anki_data_dir)
    
    # Create Anki data directory if it doesn't exist
    mkdir -p "$anki_data_dir"
    
    # Copy configuration if it exists
    if [ -f "$SCRIPT_DIR/anki/config.json" ]; then
        print_status "Setting up Anki preferences..."
        # Note: Anki stores preferences in a SQLite database, not a simple JSON file
        # This is a placeholder for future configuration automation
        print_warning "Manual configuration required: Import preferences through Anki UI"
    fi
}

# Function to setup add-ons directory
setup_addons() {
    local anki_data_dir=$(get_anki_data_dir)
    local addons_dir="$anki_data_dir/addons21"
    
    mkdir -p "$addons_dir"
    
    if [ -f "$SCRIPT_DIR/anki/addons.txt" ]; then
        print_status "Add-on installation guide created at $addons_dir/README.txt"
        cp "$SCRIPT_DIR/anki/addons.txt" "$addons_dir/README.txt"
    fi
}

# Function to setup decks directory
setup_decks() {
    local anki_data_dir=$(get_anki_data_dir)
    local decks_source="$SCRIPT_DIR/anki/decks"
    local decks_target="$anki_data_dir/decks"
    
    if [ -d "$decks_source" ]; then
        print_status "Setting up decks directory..."
        mkdir -p "$decks_target"
        
        # Copy any .apkg files
        if ls "$decks_source"/*.apkg 1> /dev/null 2>&1; then
            cp "$decks_source"/*.apkg "$decks_target/"
            print_status "Copied deck files to $decks_target"
        fi
        
        # Copy README
        if [ -f "$decks_source/README.md" ]; then
            cp "$decks_source/README.md" "$decks_target/"
        fi
    fi
}

# Function to display post-installation instructions
show_instructions() {
    echo ""
    print_status "Anki setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. Launch Anki from Applications"
    echo "2. Install recommended add-ons from Tools > Add-ons > Get Add-ons"
    echo "   (See add-on codes in ~/Library/Application Support/Anki2/addons21/README.txt)"
    echo "3. Import any deck files from ~/Library/Application Support/Anki2/decks/"
    echo "4. Configure preferences: Tools > Preferences"
    echo "5. Set up AnkiWeb sync if desired: Tools > Sync"
    echo ""
    print_warning "Note: Some configuration may require manual setup through Anki's interface"
}

# Main execution
main() {
    print_status "Starting Anki setup..."
    
    # Check if Anki is installed
    if ! check_anki_installed; then
        print_error "Anki is not installed. Please run 'brew install --cask anki' first."
        exit 1
    fi
    
    print_status "Anki installation found"
    
    # Backup existing configuration
    backup_anki_config
    
    # Setup configuration
    setup_anki_config
    
    # Setup add-ons
    setup_addons
    
    # Setup decks
    setup_decks
    
    # Show instructions
    show_instructions
}

# Run main function
main "$@"
