#!/bin/bash

# PRD-Engine - Pre-Compact Hook
# טריגר: PreCompact (ידני /compact או אוטומטי)
# מטרה: רשת ביטחון — מכריח שמירה לפני דחיסת קונטקסט

MEMORY_DIR=".claude/memory"
CHECKPOINT_FILE="$MEMORY_DIR/checkpoint.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# עדכן timestamp ב-checkpoint
if [ -f "$CHECKPOINT_FILE" ] && command -v jq &> /dev/null; then
    TEMP_FILE=$(mktemp)
    jq --arg ts "$TIMESTAMP" \
       '.last_saved = $ts | .pre_compact = true | .session_ended = false' \
       "$CHECKPOINT_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$CHECKPOINT_FILE"
fi

echo ""
echo "✅ ════════════════════════════════════════════════════════════"
echo "   🔄 COMPACT — בוצע בהצלחה!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "   ✅ הפעולות הבאות בוצעו אוטומטית:"
echo ""
echo "   1. 💾 checkpoint.json עודכן (timestamp + pre_compact=true)"
echo "   2. 📝 כל התשובות נשמרות בזיכרון של ה-Session הבא"
echo "   3. 🔄 הקונטקסט יידחס ויישמר"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "   👉 לחץ Enter להמשיך, ואז פתח Session חדש."
echo ""
echo "════════════════════════════════════════════════════════════"

exit 0
