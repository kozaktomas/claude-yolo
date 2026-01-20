# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker image for running Claude Code in YOLO mode safely. All changes stay inside the container - your host machine configuration is never modified.

A fully-loaded development environment based on `node:24-bookworm` with multi-architecture support (amd64/arm64).

## Build & Run

```bash
# Build with podman
make build

# Run interactive shell (mounts current dir to /app)
./cy

# Run with port forwarding
./cy -p 3000 -p 8080

# Test all installed tools
make test

# Clean up image
make clean
```

## Inside Container

```bash
# Start Claude in YOLO mode
yolo

# Run Claude with a prompt N times
reyolo 23 "Fix 10 errors"
```

## Installed Tools

**Languages & Runtimes**
- Bash 5.3 (compiled from source)
- Node.js 24 (LTS) + npm
- Python 3 + pip + venv
- Go 1.25.6
- Rust (stable via rustup)

**CLI Utilities**
- jq, yq (JSON/YAML processing)
- ripgrep (rg), fd (fast search)
- make, vim, git

**Networking Tools**
- lsof (list open files/ports)
- net-tools (netstat, ifconfig, route)
- iproute2 (ip, ss)
- dnsutils (dig, nslookup, host)
- iputils-ping (ping)
- traceroute, tcpdump

**Binary Debugging**
- strace (trace system calls)
- gdb (GNU debugger)
- binutils (objdump, readelf, nm, strings)

**Database Clients**
- postgresql-client
- redis-tools

**Cloud & DevOps**
- AWS CLI v2
- Google Cloud CLI (gcloud)
- Azure CLI (az)
- Docker CLI
- kubectl (Kubernetes)
- Terraform

**Browser Automation**
- Playwright + Chromium browser
- Playwright MCP server (@playwright/mcp)

**Claude Code**
- Installed via official installer
- GitHub plugin enabled
- Playwright plugin enabled
- Playwright MCP server (browser automation tools available to Claude)
- Custom statusline
