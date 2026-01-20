# Claude YOLO

Run Claude Code in YOLO mode safely inside a container. All changes stay inside the container - your host machine configuration is never modified.

A fully-loaded Docker development environment with Claude Code pre-installed. Supports both amd64 and arm64 (Apple Silicon).

## Quick Start

```bash
# Build the image
make build

# Run in your project directory
./cy

# Start Claude in YOLO mode
yolo
```

## Usage

```bash
# Interactive shell
./cy

# With port forwarding
./cy -p 3000
./cy -p 3000 -p 8080 -p 5432

# Run tests to verify all tools
make test
```

## What's Included

| Category | Tools |
|----------|-------|
| **Languages** | Node.js 24, Python 3, Go 1.25.6, Rust |
| **Shell** | Bash 5.3 |
| **CLI** | jq, yq, ripgrep, fd, make, vim, git |
| **Databases** | postgresql-client, redis-tools |
| **Cloud** | AWS CLI, gcloud, Azure CLI |
| **DevOps** | Docker CLI, kubectl, Terraform |
| **Browser** | Playwright + browsers |
| **MCP Servers** | Playwright (browser automation) |

## Requirements

- [Podman](https://podman.io/) (or modify Makefile/cy for Docker)
- You must build the image locally with `make build` (no pre-built images available)

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Image definition |
| `Makefile` | Build commands |
| `cy` | Run script with port forwarding |
| `test-installs.sh` | Verify all tools are installed |
| `config/` | Claude settings and plugins |
| `plugins/` | Custom plugins (statusline) |
