# Rule 01: Question Format

## Iron Rule
**Every question to the user must be through `AskUserQuestionTool` with numbered options + 🎯 implications.**

## Question Structure

```yaml
AskUserQuestionTool:
  question: "[The question in clear language]"
  multiSelect: false  # or true if multiple choices are allowed
  options:
    - label: "[Option 1]"
      description: "[Brief explanation + implication]"
    - label: "[Option 2]"
      description: "[Brief explanation + implication]"
    - label: "[Option 3]"
      description: "[Brief explanation + implication]"
    - label: "Other"
      description: "User explains freely"
```

## Rules
1. **Minimum 3 options, maximum 5** (including "Other")
2. **🎯 Implication required** — the user must understand what each choice leads to
3. **Clear language** — no technical jargon in PM questions, no business jargon in Architect questions
4. **One question at a time** — don't ask 3 questions at once
5. **Claude suggests default** — if there's a recommended option, mark it

## Anti-Patterns

| ❌ Don't do this | ✅ Do this instead |
|------------|-----------|
| "What do you think?" (open-ended question) | Numbered options + "Other" |
| 5 questions in a row | One question → answer → next question |
| Jargon: "N:N relation" to non-technical user | "Many-to-many relationship — for example: a student can be in many courses" |
| Skip implications | Always 🎯 — even if it seems obvious |
