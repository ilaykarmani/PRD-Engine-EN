#!/bin/bash

# PRD-Engine - Setup Wizard
# Interactive setup wizard that configures the project

echo ""
echo "🚀 ════════════════════════════════════════════════"
echo "   PRD-Engine - Setup Wizard"
echo "════════════════════════════════════════════════"
echo ""

# ─── 1. Product Name ───
read -p "📦 What is your product name? " PRODUCT_NAME
if [ -z "$PRODUCT_NAME" ]; then
    echo "❌ Product name is required"
    exit 1
fi

# ─── 2. Working Language ───
echo ""
echo "🌐 Which language for the specification?"
echo "   1. English (default)"
echo "   2. Hebrew"
read -p "Choose [1/2]: " LANG_CHOICE
case $LANG_CHOICE in
    2) LANGUAGE="he" ;;
    *) LANGUAGE="en" ;;
esac

# ─── 3. Document Source ───
echo ""
echo "📄 Where is your requirements document from?"
echo "   1. Google Docs"
echo "   2. Notion"
echo "   3. Confluence"
echo "   4. None — I'll write free text"
read -p "Choose [1/2/3/4]: " DOC_CHOICE

case $DOC_CHOICE in
    1) DOC_SOURCE="google_docs"; DOMAIN="docs.google.com" ;;
    2) DOC_SOURCE="notion"; DOMAIN="notion.so" ;;
    3) DOC_SOURCE="confluence"; DOMAIN="confluence.atlassian.com" ;;
    *) DOC_SOURCE="manual"; DOMAIN="" ;;
esac

if [ "$DOC_SOURCE" != "manual" ]; then
    read -p "🔗 Paste the document link: " DOC_URL
else
    DOC_URL=""
fi

# ─── 4. Create settings.local.json ───
if [ -n "$DOMAIN" ]; then
    cat > .claude/settings.local.json << EOF
{
  "permissions": {
    "allow": [
      "WebFetch(domain:$DOMAIN)"
    ]
  }
}
EOF
    echo "✅ settings.local.json created with permission for $DOMAIN"
else
    cat > .claude/settings.local.json << EOF
{
  "permissions": {
    "allow": []
  }
}
EOF
    echo "✅ settings.local.json created (no external permissions)"
fi

# ─── 5. Create checkpoint.json ───
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > .claude/memory/checkpoint.json << EOF
{
  "product": "$PRODUCT_NAME",
  "language": "$LANGUAGE",
  "doc_source": "$DOC_SOURCE",
  "doc_url": "$DOC_URL",
  "last_saved": "$TIMESTAMP",
  "session_ended": false,
  "current_epic": null,
  "current_agent": null,
  "question_number": 0,
  "completed_epics": [],
  "pending": null,
  "notes": "Initial setup"
}
EOF
echo "✅ checkpoint.json created"

# ─── 6. Create prd-index.json ───
cat > .claude/memory/prd-index.json << EOF
{
  "product": "$PRODUCT_NAME",
  "language": "$LANGUAGE",
  "created": "$TIMESTAMP",
  "epics": [],
  "global_entities": [],
  "features_completed": 0,
  "export_instruction": "Every epic with dev_ready:true is ready for development. Copy the file to your development tool."
}
EOF
echo "✅ prd-index.json created"

# ─── 7. Update CLAUDE.md ───
sed -i "s/\[PRODUCT_NAME\]/$PRODUCT_NAME/g" .claude/CLAUDE.md 2>/dev/null
sed -i "s/\[LANGUAGE\]/$LANGUAGE/g" .claude/CLAUDE.md 2>/dev/null
sed -i "s|\[DOC_URL\]|$DOC_URL|g" .claude/CLAUDE.md 2>/dev/null
echo "✅ CLAUDE.md updated"

echo ""
echo "════════════════════════════════════════════════"
echo "   ✅ Setup complete!"
echo "════════════════════════════════════════════════"
echo ""
echo "   📦 Product: $PRODUCT_NAME"
echo "   🌐 Language: $LANGUAGE"
echo "   📄 Source: $DOC_SOURCE"
if [ -n "$DOC_URL" ]; then
    echo "   🔗 Link: $DOC_URL"
fi
echo ""
echo "   🚀 Next step:"
echo "   Open VSCode and launch Claude Code"
echo "   Type: \"Let's start specifying $PRODUCT_NAME\""
echo ""
echo "════════════════════════════════════════════════"
