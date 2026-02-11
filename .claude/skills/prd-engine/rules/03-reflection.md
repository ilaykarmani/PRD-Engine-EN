# Rule 03: Reflection — Cumulative Learning

## Iron Rule
**At the end of every Session (Stop trigger), Claude must summarize what was learned and update lessons.md if there are new patterns.**

## When Activated
- **Automatic:** The `auto-checkpoint.sh` hook displays a Reflection reminder
- **Manual:** The user can request "learning summary" at any moment

## 4 Points to Check

### 1. Questions Not Understood
```
❓ Were there questions where the user requested additional explanation?
   → If yes: rephrase in lessons.md
```

### 2. Contradictions in Answers
```
🔄 Were there contradictions between different answers?
   → If yes: document the pattern and how it was resolved
```

### 3. Missing Questions
```
➕ Was there a question that should have been asked but wasn't?
   → If yes: add to the question list of the relevant Agent
```

### 4. Recurring Patterns
```
🔁 Is there a pattern that repeats itself between epics?
   → If yes: create a new rule or update an existing one
```

## lessons.md Update Format

```markdown
## Date: [DD/MM/YYYY]

### Session: [name of the epic we worked on]

### ❌ Problem:
[brief description]

### 🔍 Pattern:
[what caused the problem]

### ✅ Solution:
[how to prevent next time]
```

## Anti-Patterns

| ❌ Don't Do | ✅ Do Instead |
|------------|-----------|
| "Everything worked great" without checking | Go through all 4 points |
| lessons too long | One sentence per pattern |
| Change rules without approval | Suggest change, wait for approval |
