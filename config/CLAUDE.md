# Claude Code YOLO Container

You are running inside a sandboxed Docker container. This is a safety environment - all changes stay inside the container and cannot affect the host machine.

The repository mounted at `/app` varies depending on what the user is working on. Check the project's own documentation or explore the codebase to understand its structure.

## Available Tools

### Languages & Runtimes
- **Node.js 24** (LTS) + npm
- **Python 3** + pip + venv
- **Go 1.25.6**
- **Rust** (stable) + cargo
- **Bash 5.3**

### CLI Utilities
- **jq** - JSON processing
- **yq** - YAML processing
- **ripgrep (rg)** - fast text search
- **fd** - fast file finder
- **make**, **vim**, **git**

### Binary Debugging
- **strace** - trace system calls
- **gdb** - GNU debugger
- **binutils** - objdump, readelf, nm, strings

### Networking Tools
- **lsof** - list open files/ports
- **netstat**, **ifconfig**, **route** (net-tools)
- **ip**, **ss** (iproute2)
- **dig**, **nslookup**, **host** (dnsutils)
- **ping**, **traceroute**, **tcpdump**

### Database Clients
- **psql** - PostgreSQL client
- **redis-cli** - Redis client
- **sqlite3** - SQLite client

### Cloud & DevOps
- **aws** - AWS CLI v2
- **gcloud** - Google Cloud CLI
- **az** - Azure CLI
- **docker** - Docker CLI
- **kubectl** - Kubernetes CLI
- **terraform** - Infrastructure as code

### Browser Automation
- **Playwright** with Chromium browser
- Playwright MCP server available for browser automation

## Environment

- **Working directory**: `/app` (mounted repository)
- **User**: `claude` (non-root)
- **Safety**: All changes are isolated to this container
- Full tool access, no permission restrictions
- Network access available
- Host Docker socket may be available for Docker operations
