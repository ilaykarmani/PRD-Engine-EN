#!/bin/bash

# PRD-Engine - Status Line Script
# Displays context percentage in Claude Code CLI status line
# Reads JSON from stdin and displays percentage with colored icon

input=$(cat)

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "[jq not installed]"
    exit 0
fi

# Extract information
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null || echo "Claude")
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null || echo "0")

# Ensure there is a value
if [ -z "$PCT" ] || [ "$PCT" = "null" ]; then
    PCT="0"
fi

# Round to integer
PCT_INT=$(printf "%.0f" "$PCT" 2>/dev/null || echo "0")

# Icon by percentage
if [ "$PCT_INT" -lt 30 ] 2>/dev/null; then
    ICON="🟢"
elif [ "$PCT_INT" -lt 50 ] 2>/dev/null; then
    ICON="🟡"
elif [ "$PCT_INT" -lt 70 ] 2>/dev/null; then
    ICON="🟠"
else
    ICON="🔴"
fi

# Save percentage to file (for use by other hooks)
mkdir -p .claude/memory
echo "$PCT_INT" > .claude/memory/context-status.txt

# Display in status line
echo "$ICON [$MODEL] Context: ${PCT}%"
