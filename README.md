# PRD-Engine

**Turn product ideas into development-ready specs in minutes, not days.**

PRD-Engine is a Claude Code framework that generates complete technical specifications through structured AI conversations. Three specialized agents (PM, Architect, Frontend) ask the right questions and produce documentation that developers can code from directly.

![PRD-Engine Architecture](PRD-Engine-Architecture.svg)

---

## The Problem

Writing PRDs is slow, inconsistent, and creates gaps that developers discover mid-sprint.

## The Solution

PRD-Engine asks 28 structured questions across three perspectives, validates for contradictions, and outputs a single markdown file ready for any AI coding tool.

```
Your idea → 28 questions → Cross-validation → Dev-ready spec
```

---

## How It Works

| Agent | Focus | Questions |
|-------|-------|-----------|
| **PM** | Business: users, stories, KPIs | 9 |
| **Architect** | Technical: data, APIs, validations | 8 |
| **Frontend** | UI/UX: layouts, states, accessibility | 11 |

Each epic goes through all three agents, then a 7-point cross-review catches gaps before output.

---

## Output

One markdown file per feature containing:

- **Part A** — User stories, acceptance criteria, roles, KPIs
- **Part B** — Data models, API specs, error codes, validations
- **Part C** — Wireframes, responsive rules, design system
- **Part D** — Analytics events, SEO metadata, cross-review summary

Hand this file to Cursor, Copilot, or any AI coding tool. No follow-up questions needed.

---

## Quick Start

```bash
git clone https://github.com/ilaykarmani/PRD-Engine.git
cd PRD-Engine
./setup.sh
```

Open in VSCode, run `claude`, and type: **"Let's spec a new feature"**

---

## Key Features

- **Persistent memory** — Resume where you left off, even after restarts
- **Source document support** — Feed it Google Docs, Notion, or plain text
- **Cross-epic intelligence** — Knows existing entities, avoids duplication
- **Sweet Spot tagging** — Separates MVP requirements from future recommendations
- **Automatic saves** — Never lose progress

---

## Requirements

- [Claude Code](https://claude.ai/code) (Pro/Max)
- Git

---

## File Structure

```
.claude/
├── CLAUDE.md              # 18 rules that govern behavior
├── memory/
│   ├── checkpoint.json    # Current position
│   ├── prd-index.json     # All epics summary
│   └── epics/*.md         # Output files
└── skills/prd-engine/
    └── agents/            # PM, Architect, Frontend configs
```

---

## License

MIT

---

Built by [Ilay Karmani](https://github.com/ilaykarmani) with [Claude Code](https://claude.ai/code)
