# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository creates a Debian-based Docker development container with Fish shell and various development tools. The container is published as `ghcr.io/bearfield/debian-fish:bookworm` and is designed for multi-platform development (arm64/amd64).

## Architecture

- **Base Image**: Debian bookworm-slim
- **Shell**: Fish shell with bobthefish theme and custom configuration
- **Target Platforms**: linux/arm64 and linux/amd64
- **Build System**: Makefile-based with Docker Buildx for multi-platform builds

## Common Commands

### Build and Test
```bash
# Test both architectures
make test

# Test specific architecture
make test.arm64
make test.amd64

# Build only (without cleanup)
make test.build.arm64
make test.build.amd64

# Clean up images
make test.rmi.arm64
make test.rmi.amd64
```

### Docker Operations
The Makefile uses these environment variables:
- `DOCKERHUB_REPONAME=ghcr.io/bearfield`
- `CONTAINER_NAME=debian-fish`
- `CONTAINER_TAG=test.bookworm`

## Key Components

### Dockerfile Structure
The Dockerfile (`docker/Dockerfile`) sets up:
1. User creation with configurable USER_NAME, USER_ID, GROUP_ID
2. Essential development packages (git, curl, make, peco, fish, etc.)
3. Development tools (jq, tree, zip/unzip for file operations)
4. Cloud tools (Google Cloud SDK, AWS CLI, 1Password CLI)
5. Docker CE installation
6. Node.js and Claude Code CLI
7. Python 3.13 via uv with comprehensive development environment
8. Fish shell plugins via Fisher

### Python Development Environment
- **Python Version**: 3.13 (latest stable version installed via uv)
- **Package Manager**: uv (ultrafast Python package installer)
- **Development Tools**:
  - ruff: Fast Python linter and formatter
  - mypy: Static type checker
  - black: Code formatter
  - pytest: Testing framework
  - ipython: Enhanced interactive Python shell
  - poetry: Dependency management and packaging
  - pipx: Install Python applications in isolated environments
  - httpie: API testing tool
  - yq: YAML processor
- **Environment Variables**:
  - `PYTHONUNBUFFERED=1`: Real-time output in Docker logs
  - `PYTHONDONTWRITEBYTECODE=1`: No .pyc files
  - `UV_SYSTEM_PYTHON=1`: Allow system Python usage

### Fish Configuration
- Located at `docker/config.fish`
- Uses bobthefish theme with solarized color scheme
- Includes timezone and date format customization
- Sets up cloud SDK configuration
- Python aliases for convenient command shortcuts:
  - `py` → `python3`
  - `pip` → `uv pip`
  - `pytest`, `ruff`, `black`, `mypy`, `ipython` → respective uv tool commands

## DevContainer Configuration

### VS Code Extensions
The devcontainer includes the following extensions:
- Shell and development tools (Fish, ShellCheck, GitLens, etc.)
- Cloud and container tools (Docker, GitHub Actions)
- AI assistants (GitHub Copilot, Claude Code)
- Diagram support (Mermaid preview)
- Security scanning (Trivy)

### Mounted Volumes
The devcontainer mounts several local directories using the host user's environment:
- `~/.gitconfig_linux` → `/home/${USER}/.gitconfig`
- `~/.config/gcloud` → `/home/${USER}/.config/gcloud`
- `~/.ssh` → `/home/${USER}/.ssh`
- `~/.claude` → `/home/${USER}/.claude` (for Claude Code settings)

**Note**: The devcontainer uses `${localEnv:USER}` to automatically map to the host user's username.

## Development Workflow

When modifying the container:
1. Edit `docker/Dockerfile` for package changes
2. Update `docker/config.fish` for shell configuration
3. Use `make test` to verify both architectures build correctly
4. The build process automatically tests and cleans up images

### Working with DevContainers
- The `.devcontainer/devcontainer.json` defines the development environment
- Local Claude settings are automatically available in the container via volume mount
- Mermaid diagrams can be previewed directly in VS Code

## CI/CD with GitHub Actions

### Parallel Build Architecture
The GitHub Actions workflow (`.github/workflows/debian-fish-bookworm.yaml`) uses a matrix build strategy to parallelize the multi-platform image creation:

1. **Build Job**: Uses matrix strategy to build arm64 and amd64 images in parallel
   - Each platform builds independently with its own tag (`bookworm-arm64`, `bookworm-amd64`)
   - Significantly reduces total build time

2. **Push-Manifest Job**: Creates the final multi-platform manifest
   - Combines both platform-specific images
   - Pushes the unified `bookworm` tag

This parallel approach cuts the build time approximately in half compared to sequential builds.