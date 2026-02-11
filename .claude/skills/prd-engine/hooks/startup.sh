#!/bin/bash

# PRD-Engine - Startup Hook
# Trigger: SessionStart (startup, compact, resume, clear)
# Purpose: Display status + initialization instructions

MEMORY_DIR=".claude/memory"
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.json"
PRD_INDEX_FILE="$MEMORY_DIR/prd-index.json"
LESSONS_FILE="$MEMORY_DIR/lessons.md"
EPICS_DIR="$MEMORY_DIR/epics"

echo ""
echo "🚀 ════════════════════════════════════════════════════════════"
echo "   PRD-Engine — Session Initialization"
echo "════════════════════════════════════════════════════════════"
echo ""

# ─── 1. Checkpoint ───
if [ -f "$CHECKPOINT_FILE" ] && command -v jq &> /dev/null; then
    PRODUCT=$(jq -r '.product // "null"' "$CHECKPOINT_FILE")
    EPIC=$(jq -r '.current_epic // "null"' "$CHECKPOINT_FILE")
    AGENT=$(jq -r '.current_agent // "null"' "$CHECKPOINT_FILE")
    QUESTION=$(jq -r '.question_number // 0' "$CHECKPOINT_FILE")
    DOC_URL=$(jq -r '.doc_url // ""' "$CHECKPOINT_FILE")
    LAST_SAVED=$(jq -r '.last_saved // ""' "$CHECKPOINT_FILE")

    echo "📍 CHECKPOINT found! ($LAST_SAVED)"
    echo "   ┌────────────────────────────────────────"
    echo "   │ Product:  $PRODUCT"
    echo "   │ Epic:     $EPIC"
    echo "   │ Agent:    $AGENT"
    echo "   │ Question: $QUESTION"
    if [ -n "$DOC_URL" ] && [ "$DOC_URL" != "" ] && [ "$DOC_URL" != "null" ]; then
        echo "   │ DOC:      $DOC_URL"
    fi

    # Check for local doc-source.txt
    DOC_LOCAL=$(jq -r '.doc_local_path // ""' "$CHECKPOINT_FILE")
    if [ -n "$DOC_LOCAL" ] && [ "$DOC_LOCAL" != "" ] && [ "$DOC_LOCAL" != "null" ]; then
        if [ -f "$DOC_LOCAL" ]; then
            DOC_SIZE=$(wc -l < "$DOC_LOCAL" | tr -d ' ')
            echo "   │ LOCAL:    $DOC_LOCAL ($DOC_SIZE lines)"
        else
            echo "   │ LOCAL:    ⚠️  $DOC_LOCAL (file not found!)"
        fi
    fi
    echo "   └────────────────────────────────────────"
    echo ""
else
    echo "ℹ️  No checkpoint — run setup.sh first"
    echo ""
fi

# ─── 2. Epic Files ───
if [ -d "$EPICS_DIR" ]; then
    EPIC_COUNT=$(ls "$EPICS_DIR"/*.md 2>/dev/null | wc -l)
    if [ "$EPIC_COUNT" -gt 0 ]; then
        LATEST_EPIC=$(ls -t "$EPICS_DIR"/*.md 2>/dev/null | head -1)
        BASENAME=$(basename "$LATEST_EPIC")
        echo "📄 $EPIC_COUNT epic files | latest: $BASENAME"
    fi
fi

# ─── 3. PRD Index ───
if [ -f "$PRD_INDEX_FILE" ] && command -v jq &> /dev/null; then
    COMPLETED=$(jq -r '.features_completed // 0' "$PRD_INDEX_FILE")
    ENTITIES=$(jq -r '.global_entities | length' "$PRD_INDEX_FILE" 2>/dev/null || echo "0")
    echo "📊 PRD: $COMPLETED epics completed | $ENTITIES global entities"
fi

# ─── 4. Lessons ───
if [ -f "$LESSONS_FILE" ]; then
    LESSON_COUNT=$(grep -c "^## Date:" "$LESSONS_FILE" 2>/dev/null || echo "0")
    echo "📚 Lessons: $LESSON_COUNT"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "⚡ MANDATORY PROTOCOL:"
echo ""
echo "   1. 📖 Read .claude/memory/checkpoint.json (small file)"
echo ""
echo "   2. 🚀 Send sub-agent (Task Tool, model: sonnet):"
echo "      ┌─ Read: SKILL.md + rules/ + lessons.md + prd-index.json"
echo "      │  + ALL epic files"
echo "      ├─ If doc_url exists → WebFetch to catch external changes"
echo "      └─ Return 60-line summary + write session-init.json"
echo ""
echo "   3. 📋 Display status + offer:"
echo "      [Continue where we left off] [Start new epic]"
echo ""
echo "   ⛔ DO NOT read project files directly in main context!"
echo "   ⛔ ALL sub-agents MUST use model: \"sonnet\""
echo ""
echo "═══════════════════════════════════════════════════════════════"

exit 0
