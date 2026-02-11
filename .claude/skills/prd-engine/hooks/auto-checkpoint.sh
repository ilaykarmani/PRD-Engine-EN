#!/bin/bash

# PRD-Engine - Auto Checkpoint Hook
# Trigger: Stop — at the end of every Session
# Purpose: Save checkpoint + reflection

MEMORY_DIR=".claude/memory"
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$MEMORY_DIR"

if [ -f "$CHECKPOINT_FILE" ]; then
    if command -v jq &> /dev/null; then
        TEMP_FILE=$(mktemp)
        jq --arg ts "$TIMESTAMP" '.last_saved = $ts | .session_ended = true' \
           "$CHECKPOINT_FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$CHECKPOINT_FILE"
    fi

    echo ""
    echo "💾 ════════════════════════════════════════════════════════"
    echo "   Checkpoint updated!"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "📍 File: $CHECKPOINT_FILE"
    echo "⏰ Time: $TIMESTAMP"
    echo ""
    echo "🔍 Reflection — Session End"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "   Before ending, check:"
    echo "   ❓ Questions the user didn't understand?"
    echo "   🔄 Contradictions in answers?"
    echo "   ➕ Questions that should have been asked?"
    echo "   🔁 Recurring patterns?"
    echo ""
    echo "   💡 If you found patterns → update lessons.md!"
    echo ""
    echo "════════════════════════════════════════════════════════"
else
    cat > "$CHECKPOINT_FILE" << EOF
{
  "product": null,
  "language": null,
  "last_saved": "$TIMESTAMP",
  "session_ended": true,
  "current_epic": null,
  "current_agent": null,
  "question_number": 0,
  "completed_epics": [],
  "pending": null,
  "doc_url": null,
  "notes": "Auto-generated on session end — run setup.sh first"
}
EOF
    echo ""
    echo "💾 Checkpoint created (empty — run setup.sh first)"
    echo ""
fi

exit 0
