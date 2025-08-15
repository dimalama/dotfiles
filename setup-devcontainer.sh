#!/usr/bin/env bash
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TEMPLATES_DIR="$SCRIPT_DIR/.devcontainer-templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [template] [target_directory]"
    echo ""
    echo "Available templates:"
    echo "  nodejs    - Node.js development with TypeScript, pnpm, ESLint, Prettier"
    echo "  python    - Python development with uv, Black, Flake8, Jupyter"
    echo "  fullstack - Full-stack development with Node.js, Python, Terraform"
    echo ""
    echo "Examples:"
    echo "  $0 nodejs /path/to/my-project"
    echo "  $0 python ."
    echo "  $0 fullstack ~/my-fullstack-app"
    echo ""
    echo "If no arguments provided, interactive mode will start."
}

# Function to list available templates
list_templates() {
    print_color $BLUE "Available dev container templates:"
    for template in "$TEMPLATES_DIR"/*; do
        if [ -d "$template" ] && [ -f "$template/devcontainer.json" ]; then
            template_name=$(basename "$template")
            print_color $GREEN "  • $template_name"
        fi
    done
}

# Function to copy template
copy_template() {
    local template="$1"
    local target_dir="$2"
    local template_path="$TEMPLATES_DIR/$template"
    local devcontainer_dir="$target_dir/.devcontainer"

    # Validate template exists
    if [ ! -d "$template_path" ] || [ ! -f "$template_path/devcontainer.json" ]; then
        print_color $RED "Error: Template '$template' not found!"
        list_templates
        exit 1
    fi

    # Validate target directory
    if [ ! -d "$target_dir" ]; then
        print_color $RED "Error: Target directory '$target_dir' does not exist!"
        exit 1
    fi

    # Check if .devcontainer already exists
    if [ -d "$devcontainer_dir" ]; then
        print_color $YELLOW "Warning: .devcontainer already exists in $target_dir"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_color $BLUE "Operation cancelled."
            exit 0
        fi
        rm -rf "$devcontainer_dir"
    fi

    # Copy template
    print_color $BLUE "Copying $template template to $target_dir..."
    mkdir -p "$devcontainer_dir"
    cp "$template_path/devcontainer.json" "$devcontainer_dir/"

    print_color $GREEN "✓ Dev container template '$template' successfully copied to $target_dir"
    print_color $BLUE "To use:"
    print_color $BLUE "  1. Open the project in VS Code: code '$target_dir'"
    print_color $BLUE "  2. VS Code will prompt to reopen in container"
    print_color $BLUE "  3. Or use Command Palette: 'Dev Containers: Reopen in Container'"
}

# Interactive mode
interactive_mode() {
    print_color $BLUE "🚀 Dev Container Setup - Interactive Mode"
    echo ""
    
    # Select template
    list_templates
    echo ""
    read -p "Enter template name: " template
    
    # Select target directory
    echo ""
    print_color $BLUE "Target directory options:"
    print_color $GREEN "  • . (current directory)"
    print_color $GREEN "  • /path/to/your/project"
    echo ""
    read -p "Enter target directory [.]: " target_dir
    target_dir=${target_dir:-.}
    
    # Resolve target directory to absolute path
    target_dir=$(cd "$target_dir" && pwd)
    
    echo ""
    print_color $BLUE "Summary:"
    print_color $BLUE "  Template: $template"
    print_color $BLUE "  Target: $target_dir"
    echo ""
    read -p "Continue? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_color $BLUE "Operation cancelled."
        exit 0
    fi
    
    copy_template "$template" "$target_dir"
}

# Main script logic
main() {
    # Check if templates directory exists
    if [ ! -d "$TEMPLATES_DIR" ]; then
        print_color $RED "Error: Templates directory not found at $TEMPLATES_DIR"
        exit 1
    fi

    # Handle arguments
    case $# in
        0)
            interactive_mode
            ;;
        1)
            if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
                show_usage
                exit 0
            elif [[ "$1" == "--list" ]] || [[ "$1" == "-l" ]]; then
                list_templates
                exit 0
            else
                copy_template "$1" "."
            fi
            ;;
        2)
            copy_template "$1" "$2"
            ;;
        *)
            print_color $RED "Error: Too many arguments!"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"