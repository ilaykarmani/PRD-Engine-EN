# Rule 04: Local DOC_SOURCE Management

> Local source document — download, storage, and automatic epic detection.

---

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│  📄 DOC_SOURCE Local Optimization                          │
│                                                             │
│  Before:  WebFetch every Session → slow + internet dependent│
│  Now:     Download once → local TXT → fast + offline       │
│                                                             │
│  🎯 Epic Detection — immediate!                             │
│  Identify all potential epics and display to user           │
└─────────────────────────────────────────────────────────────┘
```

---

## Flow

### Step 1: User Provides Link

```yaml
AskUserQuestionTool:
  question: "Do you have a requirements document (Google Doc, Notion, PDF)?"
  options:
    - label: "I have a link"
      description: "🎯 Paste the link and we'll download it locally for faster access"
    - label: "I don't have one yet"
      description: "🎯 Go create a basic requirements document and come back with a link"
    - label: "Spec from scratch"
      description: "🎯 We'll ask more detailed questions — no document base"
```

### Step 2: Download to Local TXT

```
User provides link
        ↓
   [Sub-Agent: Explore/sonnet]
   ├─ WebFetch → download document
   ├─ Convert to clean TXT (remove formatting)
   └─ Save to: .claude/memory/doc-source.txt
        ↓
   Update checkpoint.json:
   {
     "doc_url": "[original URL]",
     "doc_local_path": ".claude/memory/doc-source.txt"
   }
```

### Step 3: Epic Detection (Immediate!)

```
Sub-Agent reads doc-source.txt
        ↓
   Identifies potential epics:
   - Look for: headers, sections, feature names
   - Look for: user stories, requirements, flows
   - Group related items into epic candidates
        ↓
   Display to user immediately:

   "📊 Found 5 potential epics in your document:

    1. User Authentication
       └─ Login, signup, password reset, roles

    2. Product Catalog
       └─ Categories, products, search, filters

    3. Shopping Cart
       └─ Add/remove items, quantity, pricing

    4. Checkout
       └─ Payment, shipping, confirmation

    5. Order Management
       └─ Order history, tracking, cancellation

    Which epic should we start with?"
```

---

## File Structure

```
.claude/memory/
├── doc-source.txt      ← Downloaded document (TXT)
├── checkpoint.json     ← Contains doc_local_path
└── epics/
    └── XX-name.md      ← Generated epics
```

---

## Checkpoint Fields

```json
{
  "doc_source": "google_doc",
  "doc_url": "https://docs.google.com/...",
  "doc_local_path": ".claude/memory/doc-source.txt",
  "detected_epics": [
    "user-authentication",
    "product-catalog",
    "shopping-cart",
    "checkout",
    "order-management"
  ]
}
```

---

## Benefits

| Aspect | Before | After |
|--------|--------|-------|
| Speed | WebFetch every session (~5s) | Local read (~0.1s) |
| Reliability | Depends on internet | Works offline |
| User Experience | Wait for document load | Immediate epic list |
| Context Usage | Repeated downloads | Single download |

---

## When to Re-download

Re-download the document only when:
1. User explicitly requests: "Refresh the document"
2. User provides a new link
3. Document is significantly out of date (user mentions changes)

**Do NOT re-download automatically** — the local copy is the source of truth for the session.

---

## Sub-Agent Prompt for Epic Detection

```yaml
Task Tool:
  subagent_type: "Explore"
  model: "sonnet"
  prompt: |
    Read the document at .claude/memory/doc-source.txt

    Identify potential epics by looking for:
    - Major sections/headers
    - Feature groups
    - User stories
    - Functional requirements
    - System components

    For each potential epic, provide:
    - Name (short, descriptive)
    - Brief description (1 sentence)
    - Key features (3-5 bullet points)

    Return a numbered list ready to display to the user.
    Format: "Found N potential epics in your document: [list]"
```

---

## Error Handling

| Error | Action |
|-------|--------|
| WebFetch fails | Ask user to paste document content directly |
| Empty document | Ask user to provide more content |
| No epics detected | Suggest starting with "Spec from scratch" |
| Local file missing | Re-download from doc_url |

---

## Important Notes

1. **doc-source.txt is READ-ONLY** — never modify the downloaded content
2. **Always read via sub-agent** — protects main context
3. **Keep original URL** — for reference and potential re-download
4. **detected_epics is a suggestion** — user can add/modify/skip epics
