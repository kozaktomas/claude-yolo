#!/usr/bin/env bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

pass() {
    echo -e "${GREEN}✓${NC} $1"
}

fail() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

check_cmd() {
    local name="$1"
    local cmd="$2"
    if eval "$cmd" > /dev/null 2>&1; then
        pass "$name"
    else
        fail "$name"
    fi
}

echo "=== Testing Installed Tools ==="
echo ""

echo "-- Languages & Runtimes --"
check_cmd "Node.js $(node --version)" "node --version"
check_cmd "npm $(npm --version)" "npm --version"
check_cmd "Python $(python --version 2>&1 | cut -d' ' -f2)" "python --version"
check_cmd "pip $(pip --version | cut -d' ' -f2)" "pip --version"
check_cmd "Go $(go version | cut -d' ' -f3)" "go version"
check_cmd "Rust $(rustc --version | cut -d' ' -f2)" "rustc --version"
check_cmd "Cargo $(cargo --version | cut -d' ' -f2)" "cargo --version"

echo ""
echo "-- CLI Utilities --"
check_cmd "Bash $(bash --version | head -1 | cut -d' ' -f4)" "bash --version"
check_cmd "git $(git --version | cut -d' ' -f3)" "git --version"
check_cmd "jq $(jq --version)" "jq --version"
check_cmd "yq $(yq --version | head -1)" "yq --version"
check_cmd "ripgrep $(rg --version | head -1 | cut -d' ' -f2)" "rg --version"
check_cmd "fd $(fd --version | cut -d' ' -f2)" "fd --version"
check_cmd "make $(make --version | head -1)" "make --version"
check_cmd "vim" "vim --version"

echo ""
echo "-- Binary Debugging --"
check_cmd "strace" "strace -V"
check_cmd "ltrace" "ltrace -V"
check_cmd "gdb" "gdb --version"
check_cmd "objdump" "objdump --version"
check_cmd "readelf" "readelf --version"
check_cmd "nm" "nm --version"
check_cmd "strings" "strings --version"

echo ""
echo "-- Networking Tools --"
check_cmd "lsof" "lsof -v"
check_cmd "netstat" "netstat --version"
check_cmd "ip" "ip -V"
check_cmd "ss" "ss -V"
check_cmd "dig" "dig -v"
check_cmd "ping" "ping -V"
check_cmd "traceroute" "traceroute --version"
check_cmd "tcpdump" "tcpdump --version"

echo ""
echo "-- Database Clients --"
check_cmd "psql $(psql --version | cut -d' ' -f3)" "psql --version"
check_cmd "redis-cli $(redis-cli --version | cut -d' ' -f2)" "redis-cli --version"

echo ""
echo "-- Cloud & DevOps --"
check_cmd "AWS CLI $(aws --version | cut -d' ' -f1 | cut -d'/' -f2)" "aws --version"
check_cmd "gcloud $(gcloud --version 2>&1 | head -1)" "gcloud --version"
check_cmd "Azure CLI $(az --version 2>&1 | head -1)" "az --version"
check_cmd "Docker CLI $(docker --version | cut -d' ' -f3 | tr -d ',')" "docker --version"
check_cmd "kubectl $(kubectl version --client -o yaml 2>/dev/null | grep gitVersion | cut -d':' -f2 | tr -d ' ')" "kubectl version --client"
check_cmd "Terraform $(terraform --version | head -1)" "terraform --version"

echo ""
echo "-- Browser Automation --"
check_cmd "Playwright $(npx playwright --version 2>/dev/null)" "npx playwright --version"
check_cmd "Playwright Chromium" "test -d ${PLAYWRIGHT_BROWSERS_PATH:-$HOME/.cache/ms-playwright}/chromium-*"
check_cmd "Chrome symlink for MCP" "test -L /opt/google/chrome/chrome"

echo ""
echo "-- Claude Code --"
check_cmd "Claude $(claude --version 2>/dev/null || echo 'installed')" "which claude"

echo ""
echo "=== All tests passed! ==="
