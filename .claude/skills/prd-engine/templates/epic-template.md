<!--
📋 DEVELOPMENT-READY SPECIFICATION
=================================
This file is a complete technical specification ready for development.
You can copy this file and feed it to any AI development tool:
  → Cursor / Claude Code / GitHub Copilot / Windsurf / Bolt
The file includes all required information: business requirements, architecture, UI, and Cross-Review.

Status: ⏳ In Progress
Last Updated: [timestamp]
Epic: [XX] — [epic name]
Product: [product name]
-->

# Epic [XX]: [Epic Name]

---

## Part A: Business Requirements (PM)

**Primary User:** [user type]
**Problem:** [what problem does the epic solve]
**Solution:** [one sentence describing the solution]
**Priority:** [P1/P2/P3] — [rationale]

### User Stories
```
US-1: As [user type 1], I want [Y] so that [Z]
US-2: As [user type 2], I want [Y] so that [Z]
US-3: As [admin], I want [Y] so that [Z]
```

### Acceptance Criteria (8-12)

**Performance:**
- [ ] [criterion — LCP, response time, etc.]
- [ ] [criterion]

**Security:**
- [ ] [criterion — CSRF, rate limiting, etc.]
- [ ] [criterion]

**UX:**
- [ ] [criterion — responsive, accessible, etc.]
- [ ] [criterion]

**Business:**
- [ ] [criterion — conversion, edge cases, etc.]
- [ ] [criterion]

### User Roles Table

| # | Role | Login Method | Post-Login Routing | Scope |
|---|--------|-------------|------------------|-------|
| 1 | [role] | [method] | [target page] | [permissions] |
| 2 | [role] | [method] | [target page] | [permissions] |

### Edge Cases / Funnel

| Stage | Name | Trigger | Action |
|------|------|--------|--------|
| 1 | [stage] | [what causes] | [what happens] |
| 2 | [stage] | [what causes] | [what happens] |

**Edge Cases:**
| # | Case | Expected Behavior | User Message |
|---|------|-------------|-------------|
| 1 | [edge case] | [what happens] | [message] |
| 2 | [edge case] | [what happens] | [message] |

### KPIs

**[Domain 1 — e.g. Landing Page]:**
| KPI | Metric | Target | Measurement Tool |
|-----|------|------|----------|
| [name] | [what we measure] | [numeric target] | [GA/Mixpanel/etc.] |

**[Domain 2 — e.g. Login/Signup]:**
| KPI | Metric | Target | Measurement Tool |
|-----|------|------|----------|
| [name] | [what we measure] | [numeric target] | [GA/Mixpanel/etc.] |

### 2030 Recommendations (PM)
1. [recommendation] — [business explanation + why it's worth it]
2. [recommendation] — [explanation]
3. [recommendation] — [explanation]

### Key Decisions (PM)
- [decision + rationale]
- [decision + rationale]

---

## Part B: Technical Architecture (Architect)

### Entities

#### 1. [Entity Name]
- **Purpose:** [what the entity represents in the system]
- **Fields:**

| Field | Type | Nullable | Unique | Default | Business Rule |
|-------|------|----------|--------|---------|---------------|
| id | UUID | false | true | auto | Primary key |
| [field] | [type] | [bool] | [bool] | [default] | [rule] |

- **Indexes:** [list of indexes]
- **Business Rules:** [business rules]
- **Edge Cases:** [entity-specific edge cases]

#### 2. [Entity Name]
- **Purpose:** [description]
- **Fields:**

| Field | Type | Nullable | Unique | Default | Business Rule |
|-------|------|----------|--------|---------|---------------|
| id | UUID | false | true | auto | Primary key |
| [field] | [type] | [bool] | [bool] | [default] | [rule] |

- **Indexes:** [list of indexes]
- **Business Rules:** [business rules]
- **Edge Cases:** [edge cases]

### Relations

| From | To | Type | FK Column | ON DELETE | ON UPDATE |
|------|-----|------|-----------|----------|----------|
| [entity] | [entity] | [1:1/1:N/N:N] | [column] | [CASCADE/RESTRICT/SET NULL] | [CASCADE] |

### API Endpoints

| # | Method | Endpoint | Auth | Rate Limit | Description | MVP? |
|---|--------|----------|------|------------|--------|------|
| 1 | [method] | [path] | [Public/Bearer/Admin] | [X/min] | [desc] | 🟢/🔵 |

**Auth Levels:**
- **Public** — no authentication required
- **Bearer** — JWT token required
- **Admin** — JWT + role check

**For each critical endpoint:**
```
[Method] [Path]
  Request Body: { [fields] }
  Response 200: { [fields] }
  Error Responses: [error codes]
```

### Validations

| Field | Rule | Error Message (HE) | Error Message (EN) |
|------|------|-------------------|-------------------|
| [field] | [rule] | [message HE] | [message EN] |

**Frontend UX notes:** Real-time validation (debounce 300ms), inline errors, red border, submit disabled with errors, focus on first error.

### Error Codes

**Auth Errors:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Account Errors:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Not Found:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Validation:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Conflict:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Rate Limit:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Server:**
| Code | HTTP | When | Message |
|------|------|------|-------|
| [code] | [status] | [when] | [message] |

**Error Response Format:**
```json
{
  "error": {
    "code": "[ERROR_CODE]",
    "message": "[error message]",
    "details": null,
    "field": null,
    "timestamp": "2026-01-01T00:00:00Z",
    "requestId": "req_abc123"
  }
}
```

### Logging & Monitoring

**INFO Events** (successes):
- [event 1], [event 2], ...

**WARN Events** (suspicions):
- [event 1], [event 2], ...

**ERROR Events** (failures):
- [event 1], [event 2], ...

**PII Rules:**
- **Never log:** passwords, tokens, OTP codes, credit cards
- **Mask:** email (i***@example.com), phone (05X-XXX-XX12)

**Retention:**
| Level | Retention |
|-------|-----------|
| INFO | 30 days |
| WARN | 90 days |
| ERROR | 365 days |

**Alerts:**
| Condition | Channel | Priority |
|-----------|---------|----------|
| [condition] | [Slack/PagerDuty] | [High/Critical] |

### Dependencies

**Forward Dependencies** (this epic depends on):
- [ ] [entity/epic that must be ready first]

**Side Effects** (this epic affects):
- [ ] [existing epics that will be affected]

**Pending Dependencies** (waiting for):
- [ ] [epics not yet specified but related]

### Deferred to Phase 2
- [what was deferred and why]

### 2030 Recommendations (Architect)
1. [recommendation] — [technical explanation + why it's worth it]
2. [recommendation] — [explanation]
3. [recommendation] — [explanation]

### Key Decisions (Architect)
- [decision + rationale]
- [decision + rationale]

---

## Part C: Frontend Specification (Frontend)

### Reference & Direction
**Aesthetic Direction:** [chosen direction]
**Reference:** [image/link/guide]

### ASCII Wireframes

```
┌─────────────────────────────────────────┐
│              [Page Name]                 │
├─────────────────────────────────────────┤
│                                         │
│  [Wireframe content — page structure    │
│   in ASCII text with all sections]      │
│                                         │
└─────────────────────────────────────────┘
```

### Layout
**Structure:** [layout description — Split Screen / Single Column / etc.]
**Grid:** [grid system — 12 columns / CSS Grid / etc.]

### Loading & Empty States

| Component | Loading Display | Duration | Behavior |
|-----------|----------------|----------|----------|
| [component] | [Skeleton/Spinner/Shimmer] | [ms] | [behavior] |

**Empty State:** [description — icon + text + CTA]

### Error Display — 3 Levels

**Level 1 — Inline (field):**
```
Validation errors below the specific field
→ Red border (#EF4444)
→ Red message below field
→ Icon ⚠️
→ Example: "Email address is invalid"
```

**Level 2 — Banner (form):**
```
Form-level error above the form
→ Light red background + red border
→ Shake animation (0.5s)
→ Example: "Email or password incorrect"
```

**Level 3 — Toast (network/server):**
```
Network/server error at screen corner
→ Toast in top corner (or bottom)
→ Auto-dismiss after 5 seconds
→ X button to close
→ Example: "Connection error — please try again"
```

### Success States

| Action | Display | Message | Duration | Routing |
|--------|--------|--------|------|-------|
| [action] | [Toast/Redirect/Inline] | [message] | [ms] | [to where] |

### Responsive Breakpoints

| Breakpoint | Width | Changes |
|-----------|-------|---------|
| Mobile | < 768px | [specific changes] |
| Tablet | 768-1024px | [specific changes] |
| Desktop | > 1024px | [default layout] |

### Accessibility (WCAG AA)

| Category | Requirement | Implementation |
|----------|--------|--------|
| Keyboard | [tab order, shortcuts] | [details] |
| Screen Reader | [aria-labels, roles] | [details] |
| Contrast | [minimum ratios] | [details] |
| Focus | [visible indicators] | [details] |
| RTL | [logical properties] | [details] |
| Forms | [labels, errors, hints] | [details] |

### Animations

| Element | Animation | Duration | Easing | CSS |
|---------|-----------|----------|--------|-----|
| [element] | [type] | [ms] | [easing] | [property] |

### Validation (Frontend)

| Field | Timing | Rule | Error Message |
|------|--------|------|------------|
| [field] | [onBlur/onChange/onSubmit] | [rule] | [message] |

### i18n System

| Parameter | Value |
|--------|------|
| Library | [next-intl / react-intl] |
| Translation File Structure | [/locales/he.json, /locales/en.json] |
| URL Pattern | [locale prefix: /he/... /en/...] |
| CSS Logical Properties | [margin-inline-start, padding-inline] |
| Language Detection | [browser / cookie / URL] |
| Default Locale | [he] |
| Supported Locales | [he, en] |

### Design System

| Parameter | Value |
|--------|------|
| **Theme** | [Light / Dark / Both] |
| **Primary Color** | [hex] |
| **Primary Light** | [hex] |
| **Primary Dark** | [hex] |
| **Secondary Color** | [hex] |
| **Success** | [hex] |
| **Error** | [hex] |
| **Warning** | [hex] |
| **Neutral 50-900** | [hex range] |
| **Font Family (HE)** | [font name] |
| **Font Family (EN)** | [font name] |
| **Font Sizes** | [xs/sm/base/lg/xl/2xl/3xl] |
| **Font Weights** | [Regular 400 / Medium 500 / SemiBold 600 / Bold 700] |
| **Border Radius** | sm: [X]px / md: [X]px / lg: [X]px / full |
| **Shadows** | sm: [value] / md: [value] / lg: [value] |
| **Spacing Base** | [X]px (multiples: 4, 8, 12, 16, 24, 32, 48, 64) |
| **White Space** | [Generous / Compact / Balanced] |

### 2030 Recommendations (Frontend)
1. [recommendation] — [explanation + why it's worth it]
2. [recommendation] — [explanation]
3. [recommendation] — [explanation]

### Key Decisions (Frontend)
- [decision + rationale]
- [decision + rationale]

---

## Part D: Cross-Review

### PM Review
- [ ] All User Stories covered by API and UI
- [ ] All KPIs are technically measurable
- [ ] Every User Role receives what they need
- [findings if any]

### Architect Review
- [ ] Architecture is consistent with UI
- [ ] Validations match between Backend and Frontend
- [ ] Error Codes cover all UI states
- [ ] Auth Levels match User Roles
- [findings if any]

### Frontend Review
- [ ] All UI is covered by the API
- [ ] Error 3 Levels cover all Error Codes
- [ ] Success States defined for every action
- [findings if any]

### Analytics Events

| # | Event Name | Trigger | Properties |
|---|-----------|---------|------------|
| 1 | [event] | [trigger] | [props] |
| 2 | [event] | [trigger] | [props] |
| ... | ... | ... | ... |
| 12+ | [event] | [trigger] | [props] |

### SEO Metadata

**[Page name 1]:**
| Meta Tag | Value |
|----------|------|
| title | [up to 60 chars] |
| description | [up to 160 chars] |
| og:title | [title] |
| og:description | [description] |
| og:image | [URL] |
| og:type | website |
| canonical | [URL] |

### i18n Consistency Check
- [ ] No hardcoded strings
- [ ] All error messages with translation key
- [ ] RTL/LTR defined — CSS logical properties
- [ ] Dates and numbers — Intl APIs

### Deferred Items (Phase 2)

| # | Deferred Item | Reason | Effort Estimate | Dependencies | Source Agent |
|---|-----------|------|-----------|--------|-----------|
| 1 | [name] | [reason] | [S/M/L] | [dependencies] | [PM/Arch/FE] |

### Review Summary
```
✅ Gaps found: [X]
✅ Gaps closed: [Y]
⏸️ Deferred to Phase 2: [Z]
📊 Status: [Epic ready for development ✅ / Fix required ⚠️]
```

---

## Key Decisions (All Agents)

| # | Decision | Rationale | Agent |
|---|--------|--------|-------|
| 1 | [decision] | [why] | [PM/Arch/FE] |
| 2 | [decision] | [why] | [PM/Arch/FE] |
