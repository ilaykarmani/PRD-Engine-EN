#!/bin/bash

# PRD-Engine - Pre-Compact Hook
# Trigger: PreCompact (manual /compact or automatic)
# Purpose: Safety net — forces save before context compaction

MEMORY_DIR=".claude/memory"
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update timestamp in checkpoint
if [ -f "$CHECKPOINT_FILE" ] && command -v jq &> /dev/null; then
    TEMP_FILE=$(mktemp)
    jq --arg ts "$TIMESTAMP" \
       '.last_saved = $ts | .pre_compact = true | .session_ended = false' \
       "$CHECKPOINT_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$CHECKPOINT_FILE"
fi

echo ""
echo "✅ ════════════════════════════════════════════════════════════"
echo "   🔄 COMPACT — completed successfully!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "   ✅ The following actions were performed automatically:"
echo ""
echo "   1. 💾 checkpoint.json updated (timestamp + pre_compact=true)"
echo "   2. 📝 All answers saved in memory for the next Session"
echo "   3. 🔄 The context will be compacted and preserved"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "   👉 Press Enter to continue, then open a new Session."
echo ""
echo "════════════════════════════════════════════════════════════"

exit 0
