alias yolo='claude --dangerously-skip-permissions'

reyolo() {
    local count="$1"
    local prompt="$2"
    for ((i=1; i<=count; i++)); do
        echo "=== Run $i/$count ==="
        claude --dangerously-skip-permissions -p "$prompt"
    done
}
