#!/usr/bin/env bash

IMAGE_NAME="claude-yolo"

show_help() {
    echo "Usage: $0 [-p PORT]..."
    echo ""
    echo "Run claude-yolo container with current directory mounted to /app"
    echo ""
    echo "Options:"
    echo "  -p PORT   Forward port (can be specified multiple times)"
    echo "  -h        Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run without port forwarding"
    echo "  $0 -p 3000            # Forward port 3000"
    echo "  $0 -p 3000 -p 8080    # Forward ports 3000 and 8080"
}

PORTS=()

while getopts "p:h" opt; do
    case $opt in
        p)
            PORTS+=("-p" "${OPTARG}:${OPTARG}")
            ;;
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

podman run -it --rm \
    -e HOME=/home/claude \
    -v "$(pwd)":/app \
    -w /app \
    "${PORTS[@]}" \
    "$IMAGE_NAME"
