# PRD-Engine — CLAUDE.md

> This is the "brain" of PRD-Engine. All rules here are **iron rules** — no skipping, no shortcuts.
> Product: [PRODUCT_NAME] | Language: [LANGUAGE] | Source: [DOC_URL]

---

## Key Files

```
┌──────────────────────────────────────────────────────────┐
│  📂 Files you must know:                                 │
│                                                          │
│  🧠 .claude/CLAUDE.md          ← You are here! Iron rules│
│  ⚙️ skills/prd-engine/SKILL.md ← Main Orchestrator       │
│  💾 memory/checkpoint.json     ← Where we stopped (~200 tok)│
│  📊 memory/prd-index.json      ← Epic map (~500 tok)     │
│  📝 memory/lessons.md          ← Lessons learned         │
│  🔍 memory/session-init.json   ← Sub-agent verification  │
│  📄 memory/epics/*.md          ← Dev-ready specifications│
│                                                          │
│  📐 rules/01-questions-format.md  ← Question format      │
│  📐 rules/02-review-crosscheck.md ← 7 Cross-Review checks│
│  📐 rules/03-reflection.md        ← Reflection protocol  │
└──────────────────────────────────────────────────────────┘
```

---

## Session Init Protocol

At the start of **every** Session (including after compact), follow exactly 4 steps:

```
Session starts
     │
     ▼
 [Step 1] Read checkpoint.json (~200 tok)
     │
     ▼
 [Step 2] Send sub-agent (Explore/sonnet)
     │    Reads: SKILL.md + rules/ + lessons + epics/ + DOC
     │    Writes: session-init.json
     ▼
 [Step 3] Display status to user
     │
     ▼
 [Step 4] Key-point saving active from this moment!
```

### Step 1: Read checkpoint
```
Read .claude/memory/checkpoint.json
```
Small file (~200 tokens). Read directly in main context.

### Step 2: Send sub-agent
```
Task Tool (subagent_type: "Explore", model: "sonnet"):
  ├─ Read: SKILL.md + rules/ + lessons.md + prd-index.json
  ├─ Read: all epics/ files
  ├─ If doc_url exists → WebFetch to catch external changes
  └─ Return: 60-line summary + write session-init.json
```

**session-init.json structure written by sub-agent:**
```json
{
  "timestamp": "2026-02-10T14:30:00",
  "files_read": [
    "SKILL.md", "rules/01-questions-format.md",
    "rules/02-review-crosscheck.md", "rules/03-reflection.md",
    "lessons.md", "prd-index.json", "epics/01-user-auth.md"
  ],
  "feature_summary": "Auth system with JWT, 2 roles. Epic 1 complete (PM+Arch+FE). Epic 2 in progress — Architect Q5.",
  "doc_source_status": "Re-read, no changes from previous session",
  "warnings": ["lessons.md: User prefers Hebrew in questions"]
}
```

### Step 3: Display status
```
Display to user:
  📦 Product: [name]
  📄 Current Epic: [name] (question X of Y)
  📊 Completed Epics: [N]

  [Continue where we left off] / [Start new epic]
```

### Step 4: Key-point saving (not after every answer!)
```
┌──────────────────────────────────────────────────────────┐
│  ⛔ Don't save checkpoint after every answer — disrupts  │
│     flow!                                                │
│                                                          │
│  ✅ Save only at key points:                             │
│  • End of Agent phase (PM → Architect → Frontend)        │
│  • End of Epic (after Cross-Review and approval)         │
│  • /compact or Session end                               │
│  • 50% Context → 🛑 Stop + save + suggest compact        │
│                                                          │
│  📝 Individual answers stored in memory until Agent ends!│
└──────────────────────────────────────────────────────────┘
```

---

## Step 0: Getting Source Document (DOC_SOURCE)

**Before starting a new epic** — ask the user about the source document:

```yaml
AskUserQuestionTool:
  question: "Do you have a requirements document (Google Doc, Notion, PDF) to work from?"
  multiSelect: false
  options:
    - label: "I have a link"
      description: "🎯 Paste the link and we'll start working from it. Sub-agent will read it."
    - label: "I don't have one yet"
      description: "🎯 Go create a basic requirements document and come back with a link."
    - label: "Spec from scratch"
      description: "🎯 We'll ask more detailed questions — no base document."
```

**DOC_SOURCE flow:**
```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  📄 DOC_SOURCE = READ-ONLY!                              │
│                                                          │
│  • This is the "source of truth" for requirements        │
│  • Do not modify — it's what the user brought            │
│  • Do not read in main context — may destroy context!    │
│                                                          │
└──────────────────────────────────────────────────────────┘

     DOC_SOURCE (Google Doc / Notion / PDF)
              │
              ▼
     ┌─────────────────┐
     │  Sub-agent      │  ◄── Read via sub-agent only!
     │  (Explore/sonnet)│      Never in main context
     └────────┬────────┘
              │
              ▼
     Requirements summary (~60 lines)
              │
              ▼
     Claude asks detailed questions
              │
              ▼
     epics/XX.md ◄── Write after Diff approval
```

---

## Iron Rules (18 rules — 0 to 17)

### Rule 0: Sub-agents (3 sub-rules)

**Rule 0a: Sonnet only**
Every Task Tool use must have `model: "sonnet"`. Not Haiku, not Opus.

**Rule 0b: DOC_SOURCE = Local TXT + Sub-agent**
```
┌──────────────────────────────────────────────────────────┐
│  🚀 DOC_SOURCE Local Optimization                        │
│                                                          │
│  1. User provides link                                   │
│  2. Sub-agent downloads → converts to clean TXT          │
│  3. Saves to .claude/memory/doc-source.txt               │
│  4. Immediate Epic Detection — display epics to user     │
│                                                          │
│  ⚡ Benefits:                                            │
│  • Fast: local read (~0.1s) instead of WebFetch (~5s)    │
│  • Reliable: works offline                               │
│  • UX: immediate epic identification!                    │
│                                                          │
│  ⛔ Still required: read only via sub-agent!             │
│     Never directly in main context.                      │
└──────────────────────────────────────────────────────────┘
```

📐 Full protocol: see `rules/04-local-doc-source.md`

**Rule 0c: 4 scenarios that require sub-agent**

| # | Scenario | Type | What it does |
|---|----------|------|--------------|
| 1 | Session start / after compact | `Explore` | Reads all files + returns 60-line summary |
| 2 | Reading source document (DOC_SOURCE) | `Explore` | Reads large document + returns requirements summary |
| 3 | Checking links between epics | `Explore` | Checks existing epics + identifies overlaps |
| 4 | Cross-Review analysis | `general-purpose` | Analyzes contradictions between 3 Agents |

**When sub-agent is NOT needed:**
- checkpoint.json — small (~200 tokens), read directly
- prd-index.json — small (~500 tokens), read directly
- Single question to user — no sub-agent needed

**Rule 0d: User notification (transparency)**
```
┌──────────────────────────────────────────────────────────┐
│  Must notify user when using sub-agent:                  │
│                                                          │
│  🔄 Before: "Sending sub-agent to read [what]..."        │
│  ✅ After: "Sub-agent returned: [short summary of result]"│
│                                                          │
│  Why important?                                          │
│  • User understands why there's a delay                  │
│  • Transparency — clear what runs in main vs sub-agent   │
│  • Main Context stays clean and focused                  │
│                                                          │
│  Examples:                                               │
│  🔄 "Sending sub-agent to scan all system files..."      │
│  ✅ "Sub-agent returned: found 2 epics, 3 lessons"       │
│                                                          │
│  🔄 "Sending sub-agent to read requirements document..." │
│  ✅ "Sub-agent returned: 45-line summary, 3 user stories"│
└──────────────────────────────────────────────────────────┘
```

---

### Rule 1: Structured Questions
Every question to user must be via `AskUserQuestionTool` with:
- Numbered options (minimum 3, maximum 5 including "Other")
- 🎯 Implication for each option — user must understand what each choice leads to
- One question at a time — don't ask 3 questions at once
- Claude suggests default — if there's a recommended option, mark it

📐 YAML format + Anti-Patterns: see `rules/01-questions-format.md`

---

### Rule 2: Modularity + 500 Line Limit

**Agent Separation:**
- Each Agent asks only their questions:
  - **PM** = business (what, why) — 9 questions
  - **Architect** = technical (data, API, validations) — 8 questions
  - **Frontend** = UI/UX (layout, states, accessibility) — 11+1 questions

**Important:** PM/Architect/Frontend are **"hats"** — not separate agents.
Claude is one brain switching hats. All context remains. No "passing information" between agents.

**500 line limit per file — Split protocol:**
```
┌──────────────────────────────────────────────────────────┐
│  ⚠️ Epic file exceeds 500 lines? → Split protocol:       │
│                                                          │
│  1. 🔔 Alert: "File reached [X] lines (max 500)"         │
│  2. 📊 Analysis: Suggest where to split (Part A+B / C+D) │
│  3. 💡 Proposal: "Can split to 2 files: XX-name-spec.md  │
│      + XX-name-frontend.md"                              │
│  4. ✅ Approval: Wait for user approval before splitting │
│                                                          │
│  ❌ Forbidden: cut in middle of section                  │
│  ✅ Always: split at Part boundary (A|B|C|D)             │
└──────────────────────────────────────────────────────────┘
```

---

### Rule 3: Key-point Saving (not after every answer!)
```
┌──────────────────────────────────────────────────────────┐
│  ⛔ Do not save checkpoint after every answer!           │
│     It disrupts flow and is unnecessary.                 │
│                                                          │
│  ✅ Save only at:                                        │
│     • End of Agent phase (PM/Architect/Frontend)         │
│     • End of Epic (after Cross-Review)                   │
│     • /compact                                           │
│     • Session end (automatic hook)                       │
│     • 50% Context (with alert)                           │
└──────────────────────────────────────────────────────────┘
```

**Saving Matrix — when to save what:**

| Event | checkpoint | epic file | prd-index |
|-------|------------|-----------|-----------|
| Single answer | ❌ | ❌ (in memory) | ❌ |
| **Agent phase end** | ✅ | ✅ | ❌ |
| **Epic end** | ✅ | ✅ | ✅ |
| **/compact** | ✅ | ✅ | ❌ |
| **Session end** | ✅ | ✅ | ❌ |
| **50% Context** | ✅ + alert | ✅ | ❌ |

**At 50% Context:**
```
🛑 Stop! → 💾 Save everything → 🔄 Suggest /compact or new Session
```

**checkpoint.json structure (~200 tokens):**
```json
{
  "timestamp": "2026-02-10T14:30:00",
  "epic": "user-authentication",
  "agent": "architect",
  "question_number": 5,
  "completed": ["Q1: Entities", "Q2: Relations", "Q3: APIs", "Q4: Validations"],
  "pending": "Q5: Error Codes",
  "doc_source": "https://docs.google.com/...",
  "notes": "User wants JWT, not sessions"
}
```

---

### Rule 4: Zero Open Ends
Every detail must be defined. If missing → ask. No assumptions, no skipping.

| ❌ Not enough | ✅ Enough |
|---------------|-----------|
| "Error message will display" | "Display: 'An error occurred while saving. Please try again.'" |
| "Button will submit" | "Click: 1) spinner, 2) POST /api/x, 3) green toast / red message" |
| "There will be validation" | "Name — required, min 2 chars. Email — format. Phone — 10 digits." |
| "User can delete" | "popup 'Are you sure?' → red button → toast 'Deleted successfully'" |

---

### Rule 5: Plan Mode Required

Plan Mode is required before any significant task:
- New epic specification
- Architecture change
- Adding features that affect existing epics
- Epic file split (Rule 2)
- Fixing contradictions found in Cross-Review

**Plan Mode Template:**
```
📋 Plan Mode — [Task Name]
═══════════════════════════════════════

🎯 Task: [what we're doing]

📝 Steps:
  1. [First step] — [estimated time]
  2. [Second step] — [estimated time]
  3. [Third step] — [estimated time]

📂 Files affected:
  - [File 1] — [what changes]
  - [File 2] — [what changes]

⚠️ Risks:
  - [Risk 1 + mitigation]

✅ Approval: User approves before execution
```

---

### Rule 6: Cross-Review Required (7 checks)
Don't write to epic file without all 3 agents approving.
See: `rules/02-review-crosscheck.md`

**7 Required Checks:**

| # | Check | What we verify |
|---|-------|----------------|
| 1 | PM Coverage | Every User Story covered in API and UI? |
| 2 | Tech Consistency | Entities match APIs? Auth Levels = User Roles? |
| 3 | Frontend Mapping | Every endpoint appears in UI? Every state handled? |
| 4 | Analytics Events | Minimum 12 events — page_view, form_submit, click, error |
| 5 | SEO Metadata | Every public page — title, description, og:tags |
| 6 | i18n Consistency | No hardcoded strings, RTL/LTR defined |
| 7 | Deferred Documentation | Everything deferred documented with reason + estimate |

**Flow:**
```
PM ✅ → Architect ✅ → Frontend ✅
                                    ↓
                         [Cross-Review — 7 checks]
                                    ↓
                    ⚠️ Contradictions? → AskUserQuestionTool → fix → review again
                    ✅ All good? → Diff → approval → write to file
```

📐 Structured Summary template + each check detailed: see `rules/02-review-crosscheck.md`

---

### Rule 7: Sweet Spot (Architect)
For every technical question, separate: **🟢 MVP Required** (won't work without), **🔵 Future Recommendation** (will save refactor), **❓ User Decides** (2 valid approaches).

---

### Rule 8: Epics = Dev-Ready Output
Every file in `epics/` is a standalone specification document with 4 parts:
- **Part A** — Business Requirements (PM): User Stories, Acceptance Criteria, Roles, KPIs
- **Part B** — Technical Architecture (Architect): Entities, Relations, APIs, Validations, Error Codes
- **Part C** — Frontend Specification: Wireframes, States, Responsive, A11y, Design System
- **Part D** — Cross-Review: Analytics, SEO, i18n, Deferred Items

📐 Full structure with all sub-sections: see `templates/epic-template.md`

**Benefit:** File → Cursor / Claude Code / Copilot / Windsurf / Bolt → development directly, no questions.

---

### Rule 9: Diff Before Write
```
┌──────────────────────────────────────────────────────────┐
│  ⛔ Do not write to epic file without explicit approval! │
│     Not even "small fixes" or "single field update"      │
└──────────────────────────────────────────────────────────┘
```

Before any write to epic file:
1. Show detailed diff to user
2. Wait for explicit approval
3. Only then write to file

---

### Rule 10: Holistic Flexibility
Questions in SKILL.md are a **starting point, not a closed list!**

```
📋 SKILL.md = required minimum + direction
🧠 The Agent = goes deeper as needed

Example:
  PM asks (from SKILL.md): "Who is the user?"
  User answers: "Store manager"

  PM continues (from intelligence):
  ┌─
  │ "Can a store manager manage more than one store?"
  │ "Is there a difference between internal and external manager?"
  │ "Does store manager see all employees?"
  └─

✅ Ask required from SKILL.md
✅ Add questions as needed
✅ Go deeper when there's ambiguity
❌ Don't ignore required questions
❌ Don't ask irrelevant questions
```

---

### Rule 11: Improvement Loop (lessons.md)
After every mistake or correction, Claude identifies pattern and updates `lessons.md`.

**The Loop:**
```
Mistake → Identify pattern → Write rule → Check → Improve
   ▲                                              │
   └──────────────────────────────────────────────┘
```

📐 lessons.md update format: see `rules/03-reflection.md`

---

### Rule 12: DOC_SOURCE Reading — Local TXT First
```
┌──────────────────────────────────────────────────────────┐
│  🚀 NEW: Local TXT Optimization                          │
│                                                          │
│  Session Start → check doc_local_path in checkpoint      │
│                                                          │
│  If local file exists:                                   │
│  ✅ Read from .claude/memory/doc-source.txt (fast!)      │
│                                                          │
│  If no local file but doc_url exists:                    │
│  📥 Download → convert to TXT → save locally             │
│                                                          │
│  If user requests refresh:                               │
│  🔄 "Refresh the document" → re-download from doc_url    │
└──────────────────────────────────────────────────────────┘
```

See: Step 0 (above) + Rule 0b + `rules/04-local-doc-source.md`

---

### Rule 13: PRD Context Loading (prd-index.json)
At the start of every new epic, Claude reads `prd-index.json` (~500 tokens) to:
- Know which epics already exist
- Identify shared entities
- Ask smart context-based questions
- Automatically identify links between epics

**prd-index.json structure:**
```json
{
  "epics_completed": 2,
  "epics": {
    "user-auth": {
      "entities": ["User", "Role", "Session"],
      "apis": ["/api/auth/login", "/api/users"],
      "relations": ["User->Role (N:N)"]
    }
  },
  "global_entities": ["User", "Role", "Product"],
  "cross_epic_relations": ["Product->User (created_by)"]
}
```

**Usage:**
```
Architect asks smart question:
"I see we have Product and User entities.
 Is an order linked to a user and specific products?"

⚠️ Automatic link detection:
"This epic will affect: user-auth, product-catalog"
```

---

### Rule 14: Hat Switching

```
     ┌──────────┐         ┌──────────┐         ┌──────────┐
     │  🎩 PM   │ ──────► │ 🎩 Arch  │ ──────► │ 🎩 FE    │
     │ 9 questions│        │ 8 questions│        │ 11+1     │
     └──────────┘         └──────────┘         └──────────┘
        Part A               Part B               Part C
```

When Claude switches between agents: read agent's SKILL.md → announce "🎩 Switching to [Agent]!" → ask only their questions → save checkpoint.

---

### Rule 15: Analytics Tracking
**Minimum 12 events per epic.** Claude adapts events to the specific epic.
Includes: page_view, form_start/submit/error, cta_click, login/signup, feature_used, error_displayed, session_start, scroll_depth.

📐 Full events table: see `rules/02-review-crosscheck.md` check 4

---

### Rule 16: Design System Required
Every epic must define full Design System: Colors (Primary/Success/Error/Neutrals), Typography (family+weights+sizes), Spacing (grid+padding+margins), Border Radius, Shadows, Theme (Light/Dark/Auto).

---

### Rule 17: Reflection (End of Every Session)
At end of every session, check: questions not understood, contradictions, missing questions, recurring patterns, user preferences.
If findings → update `lessons.md`

📐 Full protocol + Anti-Patterns: see `rules/03-reflection.md`

---

## Workflow Order
📐 See `skills/prd-engine/SKILL.md` — section "Workflow — Work Order for Each Epic" (steps 0-6).

---

## Important Notes — Detail Level
> ⚠️ Every Part = dev-ready epic, not skeleton. Every table complete, every Entity with types+constraints, every endpoint with request/response, every error message in Hebrew+English.

---

## Hooks = Automation
3 Automatic Hooks: **SessionStart** (startup.sh — prints "Ready!"), **PreCompact** (pre-compact.sh — saves checkpoint), **Stop** (auto-checkpoint.sh — saves + reflection + lessons).

---

## Navigation (via AskUserQuestionTool)
At every step, offer user 4 options: **Continue** (next question/agent), **Back** (fix previous answer), **Summary** (interim summary), **Skip** (not recommended).
All navigation via AskUserQuestionTool with 🎯 implication for each option.

---

## Complete File Structure

```
.claude/
├── CLAUDE.md                    ← 🧠 The "brain" — 18 iron rules
├── settings.json                ← 3 Hooks (SessionStart, PreCompact, Stop)
├── settings.local.json          ← WebFetch permissions
│
├── scripts/
│   └── statusline.sh            ← Context percentage in colors in CLI
│
├── memory/                      ← 💾 Persistent memory
│   ├── checkpoint.json          ← ~200 tokens — where we stopped
│   ├── prd-index.json           ← ~500 tokens — PRD map
│   ├── lessons.md               ← Lessons learned
│   ├── session-init.json        ← Sub-agent verification
│   └── epics/                   ← 📄 Dev-ready specifications
│       ├── 01-user-auth.md
│       └── 02-product-catalog.md
│
└── skills/prd-engine/           ← ⚙️ Skill Engine
    ├── SKILL.md                 ← Main Orchestrator
    ├── config/
    │   └── workflow.json        ← Workflow settings (v2.1.0)
    ├── agents/
    │   ├── product-manager/
    │   │   └── SKILL.md         ← 9 business questions
    │   ├── architect/
    │   │   └── SKILL.md         ← 8 technical questions
    │   └── frontend/
    │       └── SKILL.md         ← 11+1 UI/UX questions
    ├── rules/
    │   ├── INDEX.md
    │   ├── 01-questions-format.md
    │   ├── 02-review-crosscheck.md
    │   └── 03-reflection.md
    ├── templates/
    │   ├── epic-template.md     ← Epic template (Parts A-D)
    │   ├── checkpoint.json
    │   ├── prd-index.json
    │   ├── landing-page-guide.md  ← Landing Page guide (10 sections)
    │   └── landing-page-anatomy.jpg
    └── hooks/
        ├── startup.sh           ← SessionStart
        ├── pre-compact.sh       ← PreCompact
        └── auto-checkpoint.sh   ← Stop (Reflection)
```

---

PRD-Engine v2.1.0 | 18 Iron Rules | Multi-Agent Architecture | WebFetch permissions: see settings.local.json
