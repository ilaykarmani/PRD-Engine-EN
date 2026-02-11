---
name: prd-engine
description: >
  Multi-Agent system for creating technical specifications. 3 agents (PM, Architect, Frontend)
  ask structured questions and generate a complete, dev-ready specification document. Activate when user
  requests to specify a product, feature, or epic.
---

# PRD-Engine — Main Orchestrator

## Triggers
Activate this skill when the user says:
- "Let's specify..."
- "Technical specification for..."
- "PRD for..."
- "Start a new epic"
- Any request related to product specification

## Initialization Protocol (SessionStart)
1. **Read checkpoint.json** (directly — small file, ~200 tokens)
2. **Send sub-agent** (subagent_type: "Explore", model: "sonnet"):
   - **Notify user:** 🔄 "Sending sub-agent to scan all system files..."
   - Read: SKILL.md + all rules/ + lessons.md + prd-index.json + all epics/ files
   - If there's doc_url in checkpoint → read the document (WebFetch) to catch changes
   - Return 60-line summary + write session-init.json
   - **When returning:** ✅ "Sub-agent returned: found X epics, Y lessons, Z entities"
3. **Display status to user** + offer: [Continue where we left off] / [Start new epic]
4. **Key-point saving** — only at end of Agent/Epic/compact/Session (not after every answer!)

## Workflow — Work Order for Each Epic

```
0. 📄 Get source document link (AskUserQuestionTool)
   └─ Have a link? / Don't have? / Spec from scratch?
   └─ DOC_SOURCE = READ-ONLY!

   🚀 NEW: Local TXT Optimization
   ┌─────────────────────────────────────────────────────────┐
   │ If user chose "I have a link":                          │
   │                                                         │
   │ 1. WebFetch → download the document                    │
   │ 2. Convert to clean TXT → save to .claude/memory/doc-source.txt│
   │ 3. Update checkpoint: doc_local_path                    │
   │                                                         │
   │ 🎯 Epic Detection — immediate!                          │
   │ Sub-agent reads the TXT and identifies potential epics: │
   │                                                         │
   │ "I identified 5 epics in your document:                 │
   │  1. User Authentication                                 │
   │  2. Product Catalog                                     │
   │  3. Shopping Cart                                       │
   │  4. Checkout                                            │
   │  5. Order Management                                    │
   │                                                         │
   │  Where should we start?"                                │
   └─────────────────────────────────────────────────────────┘

1. Define Epic
   └─ What's the epic name? What's the scope?

2. 🎩 PM (Product Manager) — Part A
   └─ 9 business questions
   └─ Output: User Stories (2-4), Acceptance Criteria (8-12),
          User Roles Table, Edge Cases/Funnel, KPIs Tables,
          2030 Recommendations (PM), Key Decisions

3. 🎩 Architect — Part B
   └─ 8 technical questions
   └─ Output: Entities (detailed — fields, indexes, rules, edge cases),
          Relations (with FK behavior), API Endpoints (with Auth + Rate Limit),
          Validations (HE + EN), Error Codes (cataloged — 7 categories),
          Logging & Monitoring, Dependencies (3 categories),
          2030 Recommendations (Architect), Key Decisions
   └─ Sweet Spot: 🟢 MVP Required + 🔵 Future Recommendations + ❓ User Decides

4. 🎩 Frontend — Part C
   └─ Prep question: Have a reference image?
   └─ 11 UI/UX questions
   └─ Output: ASCII Wireframes, Layout, Loading/Empty States,
          Error Display 3 Levels (Inline/Banner/Toast),
          Success States, Responsive Breakpoints,
          Accessibility (WCAG AA), Animations per-component,
          Validation (per-field), i18n System,
          Design System (colors, typography, spacing),
          2030 Recommendations (Frontend), Key Decisions

5. 🔍 Cross-Review — Part D
   └─ 7 required checks:
      1. PM → User Stories coverage
      2. Architect → technical consistency
      3. Frontend → UI ↔ API coverage
      4. Analytics Events (minimum 12)
      5. SEO Metadata (for every public page)
      6. i18n Consistency
      7. Deferred Documentation
   └─ Structured Summary: gaps / closed / deferred / status
   └─ If contradictions exist → AskUserQuestionTool → fix → review again

6. Write to Epic file
   └─ Show diff to user → approval → write to epics/XX-name.md
   └─ Update checkpoint.json + prd-index.json
   └─ Display: "✅ Epic ready for development!"
```

## Important Notes — Detail Level

> **Every Part must be at the detail level of a dev-ready epic — not a skeleton.**
> Every table must be complete with real values, not placeholders.
> Every Entity must have detailed fields, every endpoint must have request/response,
> every error message must be in Hebrew and English.

## Iron Rules (summary — full details in CLAUDE.md)

0. **Sub-agents** — Sonnet only + DOC_SOURCE always via sub-agent
1. **Structured questions** — AskUserQuestionTool + 🎯 implications + YAML format
2. **Modularity** — 500 lines maximum + agent separation
3. **Key-point saving** — checkpoint only at end of Agent/Epic/compact (not every answer!)
4. **Zero open ends** — every detail defined + examples ❌/✅
5. **Plan Mode** — required before significant task
6. **Cross-Review required** — 7 checks before writing to file
7. **Sweet Spot** — 🟢 MVP / 🔵 future / ❓ user decides
8. **Epics = dev-ready output** — pass to any AI tool
9. **Diff before write**
10. **Holistic flexibility** — SKILL questions = starting point, Agent goes deeper
11. **Improvement loop** — lessons.md with detailed template
12. **DOC_SOURCE reading** — every Session via sub-agent
13. **PRD Context loading** — prd-index.json for smart questions
14. **Hat switching** — 🎩 switching to [Agent Name]
15. **Analytics Tracking** — 12+ events per epic
16. **Design System** — colors + typography + spacing required
17. **Reflection** — at end of every session

## Hat Switching
When Claude switches between agents, it:
1. Reads the SKILL.md of the next agent
2. Notifies user: "🎩 Switching to [Agent Name]"
3. Asks only that agent's questions
4. Doesn't repeat questions already asked

## Navigation
At every step the user can:
- **[Continue]** — to next question
- **[Back]** — fix previous answer
- **[Summary]** — interim summary of what's been collected
- **[Skip]** — skip to next agent (not recommended)
