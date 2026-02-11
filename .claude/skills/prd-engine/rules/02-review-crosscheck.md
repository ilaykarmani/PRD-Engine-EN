# Rule 02: Cross-Review

## Iron Rule
**Before writing to epic file — mandatory extended Cross-Review (7 checks). Only after all pass (✅) proceed to write.**

## When to Execute
After all 3 Agents finish their questions, **before** writing to file.

```
PM ✅ → Architect ✅ → Frontend ✅
                                    ↓
                         [Cross-Review — here!]
                         [7 mandatory checks]
                                    ↓
                             Diff → write
```

---

## 7 Mandatory Checks

### Check 1: PM Review — User Stories Coverage
1. Do the API Endpoints defined by Architect cover **all** User Stories?
2. Does the UI defined by Frontend enable **all** business scenarios?
3. Are there business Edge Cases that weren't addressed?
4. Are the KPIs covered — can every success metric defined be technically measured?
5. Does every role in User Roles Table receive the UI and API they need?

```
👩‍💼 PM Review:
   ✅ All User Stories covered by API and UI
   [or]
   ⚠️ Missing: [description]
      💡 Suggestion: [solution]
```

### Check 2: Architect Review — Technical Consistency
1. Does the UI require data that doesn't exist in Entities/API?
2. Is there Validation on the UI side that doesn't match Backend?
3. Do the Error Messages cover **all** API errors (every Error Code)?
4. Is every Entity required by Frontend defined in Data Model?
5. Do Auth Levels in API match User Roles defined by PM?

```
🏗️ Architect Review:
   ✅ Architecture consistent with UI
   [or]
   ⚠️ Missing: [description]
      💡 Suggestion: [solution]
```

### Check 3: Frontend Review — UI ↔ API Coverage
1. Does every field in UI receive data from a defined API endpoint?
2. Do Loading/Empty/Error states match API responses?
3. Is there any interaction requiring an endpoint that wasn't defined?
4. Do Error 3 Levels (Inline/Banner/Toast) cover all Error Codes?
5. Are Success States defined for every POST/PUT/PATCH action?

```
🎨 Frontend Review:
   ✅ All UI covered by API
   [or]
   ⚠️ Missing: [description]
      💡 Suggestion: [solution]
```

### Check 4: Analytics Events (new)
Check that every significant action is covered by tracking.
Claude generates events table:

```markdown
| # | Event Name | Trigger | Properties |
|---|-----------|---------|------------|
| 1 | page_view | Page entry | page_name, referrer, utm_source |
| 2 | form_start | Starts filling form | form_name, source |
| 3 | form_submit | Form submission | form_name, duration_ms, success |
| 4 | form_error | Form error | form_name, error_code, field |
| 5 | cta_click | CTA click | button_name, position, variant |
| 6 | login_success | Successful login | method, duration_ms |
| 7 | login_failure | Login failure | method, error_code |
| 8 | signup_complete | Signup completion | method, referral_source |
| 9 | feature_used | Feature usage | feature_name, context |
| 10 | error_displayed | Error display | error_code, error_level, page |
| 11 | session_start | Session start | landing_page, device_type |
| 12 | scroll_depth | Page scroll | page_name, depth_percent |
```

**Minimum 12 events per epic.** Claude adapts events to the specific epic.

```
📊 Analytics Events:
   ✅ X events defined (minimum 12)
   [or]
   ⚠️ Missing events for: [actions]
      💡 Suggestion: [missing events]
```

### Check 5: SEO Metadata (new)
For every public-facing page, Claude generates:

```markdown
**[Page name]:**
| Meta Tag | Value |
|----------|------|
| title | [up to 60 characters] |
| description | [up to 160 characters] |
| og:title | [title for sharing] |
| og:description | [description for sharing] |
| og:image | [image URL] |
| og:type | website |
| og:url | [canonical URL] |
| twitter:card | summary_large_image |
| canonical | [canonical URL] |
```

**For every public-accessible page:**
- `<title>` — up to 60 characters, including product name
- `<meta description>` — up to 160 characters
- OG tags (title, description, image, type, url)
- Twitter card
- Canonical URL
- Schema.org (if relevant — e.g. FAQPage, Product)

```
🔍 SEO Metadata:
   ✅ All [X] public pages covered
   [or]
   ⚠️ Missing SEO for: [pages]
      💡 Suggestion: [what to add]
```

### Check 6: i18n Consistency (new)
Verify all text is ready for internationalization:

1. **No hardcoded strings** — all text is i18n key
2. **All error messages** — with translation key (HE + EN defined)
3. **RTL/LTR** — CSS logical properties defined (margin-inline, padding-inline)
4. **Direction** — every component containing text defined as dir="auto" or dir="rtl"
5. **Dates and numbers** — Intl.DateTimeFormat / Intl.NumberFormat

```
🌐 i18n Check:
   ✅ No hardcoded strings, RTL defined
   [or]
   ⚠️ Hardcoded strings found in: [components]
      💡 Suggestion: [translation keys]
```

### Check 7: Deferred Documentation (new)
Everything deferred to Phase 2 must be explicitly documented:

```markdown
| # | Deferred Item | Reason | Effort Estimate | Dependencies | Source Agent |
|---|-----------|------|-----------|--------|-----------|
| 1 | [name] | [why deferred] | [S/M/L] | [depends on X] | PM/Arch/FE |
| 2 | [name] | [why deferred] | [S/M/L] | [depends on X] | PM/Arch/FE |
```

**Rule:** No item said "deferred" without a row in this table.

```
⏸️ Deferred Items:
   ✅ All [X] deferred items documented with reason + estimate
   [or]
   ⚠️ Missing documentation for: [items]
      💡 Suggestion: [what to document]
```

---

## Structured Summary — Summary at End of Review

At the end of Cross-Review, Claude presents a structured summary:

```
🔍 Cross-Review Summary — [Epic Name]
═══════════════════════════════════════════════

👩‍💼 PM Review:          ✅ / ⚠️ [X findings]
🏗️ Architect Review:   ✅ / ⚠️ [X findings]
🎨 Frontend Review:    ✅ / ⚠️ [X findings]
📊 Analytics Events:   ✅ [X events] / ⚠️ missing [Y]
🔍 SEO Metadata:       ✅ [X pages] / ⚠️ missing [Y]
🌐 i18n Check:         ✅ / ⚠️ [X exposed strings]
⏸️ Deferred Items:     ✅ [X items documented] / ⚠️ [Y not documented]

═══════════════════════════════════════════════
✅ Gaps found: [X]
✅ Gaps closed: [Y]
⏸️ Deferred to Phase 2: [Z]
📊 Status: [Epic ready for development ✅ / Requires fix ⚠️]
═══════════════════════════════════════════════
```

---

## Flow When There Are Contradictions

```
Review finds ⚠️
        ↓
Present findings to user (grouped by check)
        ↓
AskUserQuestionTool with proposed solutions
        ↓
Update answers
        ↓
Review again (only what changed)
        ↓
All 7 checks ✅ → proceed to Diff and write
```

## Anti-Patterns

| ❌ Don't Do | ✅ Do This Instead |
|------------|-----------|
| Skip Review because "looks fine" | Always run all 7 checks — even if seems clear |
| Ask 10 questions at once | Group by topic, one question at a time |
| Fix without asking | Present finding + options |
| Full review after small fix | Review again only what changed |
| Skip Analytics/SEO because "not business" | Every epic needs tracking and SEO |
| Don't document deferred items | Every deferral → row in Deferred Items table |
