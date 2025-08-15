# Dev Container Templates

This directory contains pre-configured development container templates for consistent development environments across projects.

## Available Templates

### 1. Node.js Development (`nodejs/`)
- **Base Image**: Microsoft's TypeScript/Node.js container
- **Node Version**: 20.x LTS
- **Package Manager**: pnpm (configured)
- **Features**: Git, GitHub CLI, Docker-outside-of-Docker, zsh
- **Extensions**: ESLint, Prettier, TypeScript, Tailwind CSS, Vim, Copilot
- **Ports**: 3000, 3001, 5173, 8080, 8000

### 2. Python Development (`python/`)
- **Base Image**: Microsoft's Python 3.12 container
- **Python Version**: 3.12
- **Package Manager**: uv (configured)
- **Features**: Git, GitHub CLI, Docker-outside-of-Docker, zsh
- **Extensions**: Python, Black, Flake8, Jupyter, Vim, Copilot
- **Ports**: 8000, 5000, 8080, 3000

### 3. Full-Stack Development (`fullstack/`)
- **Base Image**: Microsoft's Universal container (Node.js + Python + more)
- **Languages**: Node.js, Python, Go, Java, .NET, PHP, Ruby
- **Features**: Git, GitHub CLI, Docker, Terraform, zsh
- **Extensions**: All language extensions, Vim, Copilot, Docker, Terraform
- **Ports**: 3000, 3001, 5000, 5173, 8000, 8080, 9000

## Usage

### Option 1: Copy Template to Project
```bash
# Copy desired template to your project
cp -r ~/.dotfiles/.devcontainer-templates/nodejs/.devcontainer /path/to/your/project/

# Open project in VS Code
code /path/to/your/project/
# VS Code will prompt to reopen in container
```

### Option 2: Use devcontainer CLI
```bash
# Navigate to your project
cd /path/to/your/project/

# Initialize with template
devcontainer init --template ~/.dotfiles/.devcontainer-templates/nodejs/devcontainer.json

# Open in container
devcontainer open .
```

### Option 3: VS Code Command Palette
1. Open project in VS Code
2. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
3. Type "Dev Containers: Add Dev Container Configuration Files"
4. Choose "From a predefined container configuration definition"
5. Browse to select one of these templates

## Features Included

### Common Features (All Templates)
- **zsh shell** with proper configuration
- **Git** with latest version
- **GitHub CLI** for repository management
- **Docker-outside-of-Docker** for container operations
- **SSH and Git config mounting** from host machine
- **VS Code Vim extension** for vim users
- **GitHub Copilot** for AI assistance

### Development Tools
- **Automatic port forwarding** for development servers
- **Pre-configured VS Code settings** for optimal development
- **Language-specific extensions** and formatters
- **Security**: Safe directory configuration for Git

## Customization

### Adding Custom Features
Edit the `features` section in `devcontainer.json`:
```json
"features": {
	"ghcr.io/devcontainers/features/your-feature:1": {
		"option": "value"
	}
}
```

### Adding VS Code Extensions
Add to the `extensions` array:
```json
"extensions": [
	"publisher.extension-name"
]
```

### Custom Port Forwarding
Modify the `forwardPorts` and `portsAttributes`:
```json
"forwardPorts": [3000, 8080],
"portsAttributes": {
	"3000": {
		"label": "My App",
		"onAutoForward": "notify"
	}
}
```

## Environment Variables

You can add environment variables to any template:
```json
"containerEnv": {
	"NODE_ENV": "development",
	"DEBUG": "true"
}
```

## Volume Mounts

The templates include SSH and Git config mounts. Add custom mounts:
```json
"mounts": [
	"source=${localEnv:HOME}/.aws,target=/home/node/.aws,type=bind,consistency=cached"
]
```

## Best Practices

1. **Keep templates generic** - avoid project-specific configurations
2. **Use post-create commands** for setup that should run once
3. **Use post-start commands** for setup that should run every time
4. **Mount sensitive files** rather than copying them
5. **Pin feature versions** for reproducibility

## Troubleshooting

### Container Won't Start
- Check Docker is running
- Ensure template JSON is valid
- Check base image availability

### Extensions Not Installing
- Verify extension IDs are correct
- Check VS Code marketplace availability
- Some extensions may require specific base images

### Port Forwarding Issues
- Ensure ports aren't already in use on host
- Check firewall settings
- Verify application is binding to 0.0.0.0, not localhost

## Integration with Dotfiles

These templates are designed to work with the dotfiles configuration:
- Git config is automatically mounted from host
- SSH keys are available in container
- zsh is configured but simplified for container use
- Development tools match those in the main dotfiles setup