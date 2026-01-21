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
# Attach to container (starts it if not running)
./cy

# Run tests to verify all tools
make test
```

## Docker Compose

The `cy` script uses Docker Compose to manage the container:

```yaml
services:
  claude:
    image: claude-yolo:latest
    stdin_open: true
    tty: true
    volumes:
      - .:/app
    ports:
      - "3000:3000"
      - "8080:8080"
    command: ["-c", "sleep infinity"]
```

A `docker-compose.yml` is included in the repo. Just run `./cy` to start and attach to the container.

## What's Included

| Category | Tools |
|----------|-------|
| **Languages** | Node.js 24, Python 3, PHP, Go 1.25.6, Rust |
| **Shell** | Bash 5.3 |
| **CLI** | jq, yq, ripgrep, fd, make, vim, git |
| **Networking** | lsof, net-tools, iproute2, dnsutils, ping, traceroute, tcpdump |
| **Debugging** | strace, gdb, binutils |
| **Databases** | postgresql-client, redis-tools, sqlite3 |
| **Cloud** | AWS CLI, gcloud, Azure CLI |
| **DevOps** | Docker CLI, kubectl, Terraform |
| **Browser** | Playwright + Chromium |
| **MCP Servers** | Playwright (browser automation) |

## Requirements

- [Podman](https://podman.io/) or [Docker](https://www.docker.com/)
- You must build the image locally with `make build` (no pre-built images available)

The Makefile auto-detects the container engine (prefers podman, falls back to docker). To override:

```bash
make ENGINE=docker build
make ENGINE=podman build
```

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Image definition |
| `Makefile` | Build commands |
| `cy` | Run script with port forwarding |
| `test-installs.sh` | Verify all tools are installed |
| `config/` | Claude settings and plugins |
| `plugins/` | Custom plugins (statusline) |
