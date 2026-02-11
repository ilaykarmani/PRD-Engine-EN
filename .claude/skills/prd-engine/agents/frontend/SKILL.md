---
name: frontend-design
description: Frontend Agent that defines Layout (+ ASCII Wireframes), States (Loading, Error 3 Levels, Success per-action), Responsive, Accessibility (WCAG AA), Interactions (per-component), i18n, Design System (colors, typography, spacing), Key Decisions, and 2030 Recommendations. Integrates Anthropic's frontend-design guidelines with structured questions for UI/UX specification.
---

# Frontend Agent

## Role
**UI/UX questions only** — Layout, States, Interactions, Accessibility, i18n, Design System.
Does not touch business (PM) or Data Model (Architect).

## Design Principles (based on Anthropic frontend-design skill)

Before starting, understand the context and choose a **bold aesthetic direction**:

**Possible directions:**
Brutally Minimal / Maximalist / Retro-Futuristic / Organic /
Luxury / Playful / Editorial / Brutalist / Art Deco / Industrial

**Typography:** Unique fonts — not Inter, Arial, Roboto.
Examples: Playfair Display, JetBrains Mono, Bricolage Grotesque, Clash Display, Satoshi.

**Colors:** Dominant color + sharp accent, not timid palettes.

**Animations:** Better one impressive animation on page load than 10 scattered small animations.

**What to avoid:** Generic fonts, purple-on-white colors, predictable layouts, "AI slop" design.

## Preparation Question: Reference Image

**Before starting the questions**, ask the user:

```yaml
AskUserQuestionTool:
  question: "Before we start — do you have a reference image, wireframe, or UI skeleton?"
  options:
    - label: "Yes, I have an image/screenshot"
      description: "Attach image and I'll analyze the structure from it"
    - label: "No, but show me the landing page guide"
      description: "I'll present a recommended landing page structure (Anatomy of Landing Page)"
    - label: "No, let's start from scratch"
      description: "We'll build the UI based on questions only"
```

### If user chose "landing page guide":
Display the recommended structure (based on landing-page-anatomy.jpg in templates/ folder):

```
📋 Anatomy of High-Converting Landing Page
═══════════════════════════════════════════

1. 🔝 Navbar — Sticky, logo + navigation + prominent CTA
2. 🎯 Hero Area — Social Proof + headline + CTA + image/video
3. 🤝 Partners Section — "Trusted by..." + logos
4. ✨ Benefits (not Features!) — 3-6 cards
5. 📖 How it Works — 3 simple steps
6. 💰 Pricing Section — packages + CTA + highlight recommended
7. 💬 Testimonials — quotes + images + rating
8. ❓ FAQ — Accordion, 4-6 questions
9. 📢 CTA Section — final prominent CTA
10. 🔻 Footer — logo + navigation + Legal + Social
```

## Required Questions (11 questions)

### Question 1: Visual Examples
```yaml
AskUserQuestionTool:
  question: "Is there an app or website whose design speaks to you?"
  options:
    - label: "Yes, I have a screenshot/link"
      description: "Attach and I'll analyze the style"
    - label: "Suggest 2-3 directions"
      description: "I'll present examples of different aesthetic directions"
    - label: "No preference, you choose direction"
      description: "I'll choose a direction that fits the product type"
```
🎯 **Implication:** Saves hours of "that's not what I meant".

### Question 2: Layout + ASCII Wireframe
```yaml
AskUserQuestionTool:
  question: "What is the general page structure?"
  options:
    - label: "Header + Main Content"
      description: "Simple — suitable for landing pages and basic dashboards"
    - label: "Header + Sidebar + Main"
      description: "Management application with side navigation"
    - label: "Full Screen"
      description: "No sidebar — suitable for work tools (editor, map)"
    - label: "Tabs / Multi-step"
      description: "Content divided into tabs or steps"
```

**After user chooses layout**, Claude generates **ASCII Wireframe**:
```
┌─────────────────────────────────────────────────────────┐
│ LOGO     Nav1  Nav2  Nav3  [🌐] [CTA]                  │  ← Navbar (sticky)
├─────────────────────────────────────────────────────────┤
│                                     ┌─────────────┐    │
│  Headline Text                      │  Product     │    │  ← Hero
│  Sub-headline                       │  Image/Video │    │
│  [Primary CTA] [Secondary CTA]     └─────────────┘    │
├─────────────────────────────────────────────────────────┤
│  [Section 2]  [Section 3]  [Section 4]                 │
├─────────────────────────────────────────────────────────┤
│             Footer                                      │
└─────────────────────────────────────────────────────────┘
```
User approves / corrects the wireframe.
**If there are multiple pages** (e.g. Landing + Login), Claude generates wireframe **for each page**.

### Question 3: Loading States
```yaml
AskUserQuestionTool:
  question: "How to display loading state?"
  options:
    - label: "Skeleton Screen"
      description: "Gray skeleton that looks like the content — smooth experience"
    - label: "Spinner"
      description: "Rotating loading icon — simple and familiar"
    - label: "Shimmer Effect"
      description: "Shimmer animation on Skeleton — modern"
    - label: "Progress Bar"
      description: "Progress bar — suitable for long operations"
```

**After answer**, Claude generates Loading table **per-component**:
```markdown
| Component | Loading Display | Behavior |
|-----------|----------------|----------|
| Page FCP | Skeleton — gray skeleton of sections | fade-in when ready |
| Button click | Small spinner + "Processing..." | disabled |
| List/Table | Skeleton 5 rows | disabled scroll |
| Form submit | Button → spinner + "Sending..." | disabled |
| Image | Blur placeholder → sharp | progressive |
```

**Empty State:**
Claude also asks: "What to display when there's no data?" — icon + message + CTA (e.g.: "No results. Try another search.")

### Question 4: Error Display — 3 Levels
```yaml
AskUserQuestionTool:
  question: "How to display errors? (recommended: 3 levels)"
  options:
    - label: "3 full levels (recommended)"
      description: "Inline (field) + Banner (form) + Toast (network) — most professional"
    - label: "2 levels"
      description: "Inline + Toast only"
    - label: "One level"
      description: "Toast only — simple but less precise"
```

**Claude details 3 levels with examples:**
```markdown
### Level 1: Inline / Field Errors
- Displayed **below the relevant field**
- Red text (#EF4444) + red border on field
- Examples:
  - "Email address is invalid"
  - "Password must contain at least 8 characters"
  - "Required field"

### Level 2: Banner / Form Errors
- Red banner **above the form** + Shake animation
- For errors not belonging to a specific field
- Examples:
  - "Email or password incorrect" (INVALID_CREDENTIALS)
  - "Account temporarily locked. Try again in 5 minutes." (ACCOUNT_LOCKED)

### Level 3: Toast / Network Errors
- Red toast in top corner, disappears after 5 seconds
- For network and server errors
- Examples:
  - "Communication problem. Check your internet connection."
  - "Service is currently unavailable. Try again in a few minutes."
```

### Question 5: Success States (per-action)
```yaml
AskUserQuestionTool:
  question: "How to display success messages?"
  options:
    - label: "Green Toast"
      description: "Corner message that disappears — suitable for small actions"
    - label: "Transition screen + redirect"
      description: "Logo + message + redirect — suitable for Login/Signup"
    - label: "Content replacement (inline)"
      description: "Content replaces with success message — suitable for forms"
    - label: "Combination (recommended)"
      description: "Each action gets appropriate success type"
```

**Claude generates Success table per-action:**
```markdown
| Action | Display |
|-------|--------|
| Successful Login | Transition screen: logo + "Preparing your space..." → redirect |
| Form submitted | Modal replaces: confetti + "Thanks! We'll get back to you within 24 hours." |
| Password changed | Green Toast + "Password changed successfully!" → redirect to Login |
| Item created | Green Toast + "Created successfully" |
| Item deleted | Toast + Undo link (5 seconds) |
```

### Question 6: Responsive
```yaml
AskUserQuestionTool:
  question: "What is the Responsive strategy?"
  options:
    - label: "Mobile First (recommended)"
      description: "Start mobile, expand — recommended for public sites"
    - label: "Desktop Only"
      description: "Management application — saves 40% development time"
    - label: "Adaptive"
      description: "Completely different layouts for mobile and desktop"
```
🎯 **Implication:** "Desktop Only" saves 40% development time. Suitable for internal applications.

**If Mobile First / Adaptive is chosen**, Claude details breakpoints:
```markdown
| Breakpoint | Changes |
|-----------|---------|
| Mobile (<768px) | [what changes — single column, hamburger, stacked] |
| Tablet (768-1024px) | [what changes — grid 2 columns, sidebar collapse] |
| Desktop (>1024px) | [full layout] |
```

### Question 7: Accessibility
```yaml
AskUserQuestionTool:
  question: "What accessibility level is required?"
  options:
    - label: "WCAG AA — Israeli standard (recommended)"
      description: "The mandatory standard in Israel: keyboard navigation, ARIA, contrast 4.5:1, focus indicators"
    - label: "WCAG A — basic"
      description: "Minimum: alt text, basic contrast, semantic HTML"
    - label: "WCAG AAA — full"
      description: "Full accessibility: contrast 7:1, captions, sign language"
```
🎯 **Implication:** **WCAG AA is the mandatory standard in Israel** (Equal Rights for People with Disabilities Regulations). This is the recommended default.

**Claude details accessibility implementation:**
```markdown
| Requirement | Implementation |
|-------|-------|
| Keyboard Navigation | Tab to every field, Enter = Submit, Esc = Close Modal |
| Screen Reader | ARIA labels, aria-live for errors, role="alert" |
| Color Contrast | Text 4.5:1, interactive elements 3:1 |
| Focus Management | Focus trap in Modal, focus on first error |
| RTL Support | dir="rtl" for Hebrew, CSS logical properties |
| Forms | label+for, autocomplete, inputmode |
```

### Question 8: Interactions and Animations
```yaml
AskUserQuestionTool:
  question: "What special interactions are required?"
  multiSelect: true
  options:
    - label: "Drag & Drop"
      description: "Drag and drop — for sorting, moving between lists"
    - label: "Infinite Scroll"
      description: "Auto-load on scroll — for long lists"
    - label: "Real-time Updates"
      description: "Real-time updates (WebSocket) — for dashboards, chat"
    - label: "None — standard"
      description: "Regular clicks, forms, navigation"
```

**Claude generates Animations table per-component:**
```markdown
| Element | Animation | Duration | Easing |
|---------|-----------|----------|--------|
| Scroll Reveal | fade-in + slide-up | 300ms | ease-out |
| Modal open | fade-in + scale(0.95→1) | 300ms | ease-out |
| Button hover | scale(1.02) + color shift | 200ms | ease |
| Error shake | shake keyframes | 400ms | ease |
| Tab switch | fade transition | 200ms | ease |
| Navbar scroll | transparent → solid bg | 300ms | ease |
| FAQ accordion | max-height transition | 300ms | ease |
| Toast | slide-in from top | 300ms | ease-out |
```

### Question 9: Form Validation
```yaml
AskUserQuestionTool:
  question: "When to perform form validation?"
  options:
    - label: "On Blur"
      description: "On leaving field — balance between experience and feedback"
    - label: "On Submit"
      description: "Only on submission — simple but frustrating"
    - label: "Real-time"
      description: "During typing — immediate feedback, more overhead"
    - label: "Hybrid (recommended)"
      description: "Real-time for format (email, phone), on blur for required, on submit final"
```

**Claude generates Validation table per-field:**
```markdown
| Field | Timing | Rule | Error Message |
|-----|--------|-----|------------|
| Email | Real-time (300ms debounce) | RFC 5322, max 255 | "Email address is invalid" |
| Email | On Blur | Required | "Please enter email address" |
| Password | On Submit only | required, 8+ chars | "Please enter password" |
| Phone | Real-time | starts 05, 10 digits | "Invalid phone number" |
```

**General rule:** Submit button disabled (disabled + opacity 50%) as long as there are errors. Auto-focus on first field with error.

### Question 10: i18n / Language and Direction
```yaml
AskUserQuestionTool:
  question: "What are the product's language requirements?"
  options:
    - label: "One language (Hebrew or English)"
      description: "Don't need i18n — saves development time"
    - label: "Hebrew + English (recommended for Israel)"
      description: "Need RTL + LTR, translation files, language toggle"
    - label: "Multi-language (3+)"
      description: "Full i18n system with locale detection"
```
🎯 **Implication:** i18n = early architectural decision. Hard to add after hardcoded strings are written.

**If multi-language is chosen**, Claude details:
```markdown
**i18n System:**
| Feature | Value |
|--------|-----|
| Library | next-intl / react-intl |
| Languages | EN (default) + HE |
| Translation Files | messages/en.json + messages/he.json |
| Direction | dir attribute per locale |
| CSS | Logical properties (margin-inline-start, padding-inline-end) |
| URL Pattern | /en/page, /he/page (locale prefix) |
| Detection | Browser Accept-Language → fallback EN |
| Fonts | [Font supporting Unicode — Hebrew + English] |
| Error Messages | Every message in both languages |
```

### Question 11: Design System / Branding
```yaml
AskUserQuestionTool:
  question: "Is there an existing Design System, or shall we define now?"
  options:
    - label: "Define now"
      description: "I'll choose colors, typography, spacing based on aesthetic direction"
    - label: "Have Brand Guidelines"
      description: "Attach/describe — and I'll adapt the Design System"
    - label: "You choose for me"
      description: "I'll choose Design System that fits the product type"
```

**Claude generates complete Design System table:**
```markdown
**Design System:**
| Feature | Value |
|--------|-----|
| **Theme** | Light / Dark / Auto |
| **Primary Color** | [name] #XXXXXX |
| **Primary Light** | #XXXXXX (backgrounds, badges) |
| **Primary Dark** | #XXXXXX (hover) |
| **Success** | #XXXXXX (green) |
| **Error** | #XXXXXX (red) |
| **Warning** | #XXXXXX (orange) |
| **Neutrals** | text: #XXX, secondary: #XXX, bg: #XXX, cards: #XXX |
| **Typography** | [Font Family] — weights: 300/400/500/700 |
| **Border Radius** | buttons: Xpx, cards: Xpx, modals: Xpx |
| **Shadows** | sm (cards), md (hover), lg (modals) |
| **Spacing** | Xpx grid system |
| **White Space** | [approach — minimalist / dense / balanced] |
```

## Output — Part C of the Epic File

```markdown
## Part C: Frontend Specification (Frontend)

**Aesthetic direction:** [chosen direction]
**Reference:** [image/link/guide]

**Layout:** [structure description]

**ASCII Wireframe:**
(wireframe for each page)

**States:**
**Loading (per-component):**
| Component | Loading Display | Behavior |
**Empty State:** [description]

**Error Display (3 Levels):**
- Level 1 (Inline): [description + examples]
- Level 2 (Banner): [description + examples]
- Level 3 (Toast): [description + examples]

**Success States:**
| Action | Display |

**Responsive:** [strategy]
| Breakpoint | Changes |

**Accessibility:** [level — WCAG AA default]
| Requirement | Implementation |

**Interactions & Animations:**
| Element | Animation | Duration | Easing |

**Validation (per-field):**
| Field | Timing | Rule | Error Message |

**i18n:**
| Feature | Value |

**Design System:**
| Feature | Value |

**2030 Recommendations (Frontend):**
- [recommendation + explanation]

**Key Decisions (Frontend):**
- [decision + rationale]
```

## Saving
⛔ **Don't save checkpoint after every answer!**
✅ Save only at completion of all Frontend questions:
```json
{ "current_agent": "frontend", "question_number": 11, "status": "complete" }
```

## Navigation at End
🎩 **We've finished the visual part!** 💾 Saving checkpoint... moving to Cross-Review...
[Continue to Review] / [Go back to fix answer] / [Interim summary]
