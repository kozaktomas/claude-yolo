#!/usr/bin/env bash

IMAGE_NAME="claude-yolo"
CONTAINER_NAME="claude"

# Detect container engine
if command -v podman &> /dev/null; then
    ENGINE=podman
elif command -v docker &> /dev/null; then
    ENGINE=docker
else
    echo "Error: podman or docker required"
    exit 1
fi

show_help() {
    echo "Usage: $0 [-h]"
    echo ""
    echo "Attach to the claude-yolo container."
    echo ""
    echo "If docker-compose.yml doesn't exist, creates one and prompts for ports."
    echo "Starts the container via $ENGINE compose if not already running."
    echo ""
    echo "Options:"
    echo "  -h        Show this help"
}

while getopts "h" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# Create docker-compose.yml if it doesn't exist
if [ ! -f "docker-compose.yml" ]; then
    echo "Creating docker-compose.yml..."
    read -p "Enter ports to expose (comma-separated, e.g., 3000,8080) [3000,8080]: " PORTS_INPUT
    PORTS_INPUT=${PORTS_INPUT:-3000,8080}

    # Build ports section
    PORTS_YAML=""
    IFS=',' read -ra PORT_ARRAY <<< "$PORTS_INPUT"
    for port in "${PORT_ARRAY[@]}"; do
        port=$(echo "$port" | xargs)  # trim whitespace
        if [ -n "$port" ]; then
            PORTS_YAML="$PORTS_YAML      - \"$port:$port\"\n"
        fi
    done

    cat > docker-compose.yml << EOF
services:
  claude:
    image: claude-yolo:latest
    stdin_open: true
    tty: true
    volumes:
      - .:/app
    ports:
$(echo -e "$PORTS_YAML" | sed 's/\\n$//')
    command: ["-c", "sleep infinity"]
EOF
    echo "Created docker-compose.yml"
fi

# Check if container is already running (via compose or otherwise)
RUNNING=$($ENGINE ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -E "^${CONTAINER_NAME}$|[-_]${CONTAINER_NAME}[-_]|[-_]${CONTAINER_NAME}$" | head -1)

if [ -z "$RUNNING" ]; then
    # Container not running, start it via compose
    echo "Starting container via $ENGINE compose..."
    $ENGINE compose up -d claude
    sleep 5
    RUNNING=$($ENGINE ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -E "^${CONTAINER_NAME}$|[-_]${CONTAINER_NAME}[-_]|[-_]${CONTAINER_NAME}$" | head -1)
fi

if [ -z "$RUNNING" ]; then
    echo "Error: Failed to start container"
    exit 1
fi

echo "Attaching to container: $RUNNING"
exec $ENGINE exec -it "$RUNNING" bash
