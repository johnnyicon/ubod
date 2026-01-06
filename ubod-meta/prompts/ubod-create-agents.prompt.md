---
description: "Generate agents for a new app or framework (Rails, Next.js, etc.)"
model: "claude-opus-4-5 for initial setup, sonnet-4-5 for individual agent generation"
---

# Create Agents for New App

You are creating app-specific agents for a new application in your monorepo.

**Your role:** Generate agents (and supporting instruction files) that understand your app's tech stack and patterns, extending ubod's universal agents with app-specific knowledge.

---

## Overview

The ubod framework provides **universal methodology** (HOW to work).
Your app provides **specific context** (WHAT you're working with).

This prompt helps you create the app-specific files that complete the picture.

---

## Pre-Flight: Gather App Context

Before generating files, gather this information:

### 1. Tech Stack Inventory

```markdown
## App Tech Stack

**Backend:**
- Language: [Ruby/Python/Go/Node.js/etc.]
- Framework: [Rails/Django/Express/Gin/etc.]
- Database: [PostgreSQL/MySQL/MongoDB/etc.]
- Background Jobs: [Sidekiq/Celery/Bull/etc.]
- Real-time: [ActionCable/Socket.io/WebSockets/etc.]

**Frontend:**
- Framework: [React/Vue/Hotwire/HTMX/etc.]
- JS Framework: [Stimulus/Alpine/vanilla/etc.]
- CSS: [Tailwind/CSS Modules/styled-components/etc.]
- Build: [Vite/Webpack/esbuild/etc.]

**Testing:**
- Unit: [RSpec/pytest/Jest/etc.]
- Integration: [Capybara/Playwright/Cypress/etc.]
- Coverage: [SimpleCov/coverage.py/nyc/etc.]

**Infrastructure:**
- Deployment: [Heroku/AWS/Vercel/etc.]
- CI/CD: [GitHub Actions/CircleCI/etc.]
```

### 2. Architecture Patterns

```markdown
## App Architecture

**Code Organization:**
- [MVC/Clean Architecture/Domain-Driven/etc.]

**Key Abstractions:**
- [Services/Repositories/Use Cases/etc.]

**Multi-tenancy:**
- [None/Org-scoped/Schema-per-tenant/etc.]

**Authentication:**
- [Devise/Auth0/Custom/etc.]
```

### 3. Existing Conventions

```markdown
## Existing Conventions

**File Naming:**
- [snake_case/kebab-case/camelCase]

**Test Location:**
- [test/spec/tests/__tests__]

**Component Location:**
- [app/components/src/components/etc.]
```

---

## Files to Generate

Based on ubod's universal instructions, generate these app-specific files:

### 1. App Complexity Signals

**Path:** `[app]/.copilot/instructions/[app]-complexity-signals.instructions.md`

**Extends:** `universal/task-complexity-signals.instructions.md`

**Content to include:**
- Framework-specific complexity indicators
- Your stack's "framework magic" examples
- Real examples from your codebase

**Template:**

```markdown
---
applyTo: "[app]/**/*"
---

# [App Name] Complexity Signals

**Purpose:** App-specific complexity indicators for [App Name]

**Extends:** `universal/task-complexity-signals.instructions.md`

---

## Framework-Specific Complexity

### [Framework Name] Conventions

**Surface Level:**
- [Simple pattern in your stack]

**Deep Level:**
- [Complex pattern in your stack]
- [Framework magic to watch for]

---

## Stack-Specific Integration Points

**Multi-Layer Integrations in this app:**
- [Your real example: Controller + Model + Job + etc.]

**Real-time Features:**
- [Your real-time stack: ActionCable/Socket.io/etc.]
- [Complexity indicators specific to your setup]

---

## Examples from This Codebase

### Example 1: [Feature Name]

**Why it was complex:**
- [Specific reason from your experience]

### Example 2: [Feature Name]

**Why it was complex:**
- [Specific reason from your experience]
```

---

### 2. App Architecture Reference

**Path:** `[app]/.copilot/instructions/[app]-architecture.instructions.md`

**Extends:** General codebase understanding

**Content to include:**
- Key directories and their purposes
- Important abstractions and patterns
- How data flows through your app

**Template:**

```markdown
---
applyTo: "[app]/**/*"
---

# [App Name] Architecture

**Purpose:** Architecture reference for [App Name]

---

## Directory Structure

```
[app]/
├── app/
│   ├── models/          # [Description]
│   ├── controllers/     # [Description]
│   ├── services/        # [Description]
│   └── [other dirs]/    # [Description]
├── test/                # [Description]
└── [other dirs]/        # [Description]
```

---

## Key Abstractions

### [Abstraction 1: e.g., Services]

**Location:** `app/services/`
**Purpose:** [What they do]
**Pattern:** [How to create new ones]

### [Abstraction 2: e.g., Components]

**Location:** `app/components/`
**Purpose:** [What they do]
**Pattern:** [How to create new ones]

---

## Data Flow

```
[Request] → [Controller] → [Service] → [Model] → [Database]
                                    ↓
                              [Background Job]
```

---

## Critical Paths

### [Critical Path 1: e.g., User Authentication]

**Files involved:**
- `[path/to/file.rb]`
- `[path/to/file.rb]`

**Flow:** [Description]

### [Critical Path 2: e.g., Payment Processing]

**Files involved:**
- `[path/to/file.rb]`

**Flow:** [Description]
```

---

### 3. App Testing Patterns

**Path:** `[app]/.copilot/instructions/[app]-testing.instructions.md`

**Extends:** `universal/verification-checklist.instructions.md`

**Content to include:**
- Your test framework specifics
- Your test organization
- Common test patterns in your codebase

**Template:**

```markdown
---
applyTo: "[app]/test/**/*"
---

# [App Name] Testing Patterns

**Purpose:** Testing conventions for [App Name]

---

## Test Framework

**Framework:** [RSpec/Minitest/pytest/Jest/etc.]
**Run all:** `[command]`
**Run specific:** `[command] [path]`

---

## Test Organization

```
test/
├── models/          # Model unit tests
├── controllers/     # Controller tests
├── integration/     # Integration tests
├── system/          # Browser tests
└── fixtures/        # Test data
```

---

## Common Patterns

### Multi-Tenancy Testing

```[language]
# How to scope tests to organization
[code example from your codebase]
```

### Authentication in Tests

```[language]
# How to authenticate in tests
[code example from your codebase]
```

### Stubbing External Services

```[language]
# How to stub external APIs
[code example from your codebase]
```

---

## Test Data

**Fixtures/Factories location:** `[path]`
**How to create test data:** [description]
```

---

### 4. App Critical Gotchas

**Path:** `[app]/.copilot/instructions/[app]-gotchas.instructions.md`

**Extends:** General awareness

**Content to include:**
- Known pitfalls in your stack
- Integration quirks
- Things that "just don't work as expected"

**Template:**

```markdown
---
applyTo: "[app]/**/*"
---

# [App Name] Critical Gotchas

**Purpose:** Known pitfalls and quirks specific to [App Name]

---

## [Category 1: e.g., Frontend Framework]

### Gotcha: [Name]

**What happens:**
[Description of the problem]

**Why:**
[Root cause]

**Solution:**
[How to avoid/fix]

---

## [Category 2: e.g., Database]

### Gotcha: [Name]

**What happens:**
[Description]

**Why:**
[Root cause]

**Solution:**
[How to avoid/fix]

---

## [Category 3: e.g., Testing]

### Gotcha: [Name]

**What happens:**
[Description]

**Why:**
[Root cause]

**Solution:**
[How to avoid/fix]
```

---

## Generation Workflow

### Step 1: Gather Context (Human + AI)

1. Human provides tech stack inventory
2. AI reads key files to understand architecture:
   - `README.md`
   - `Gemfile` / `package.json` / `requirements.txt`
   - `config/routes.rb` / route definitions
   - `db/schema.rb` / schema files
   - Sample model, controller, service

### Step 2: Generate Files (AI)

For each file:
1. Use template above
2. Fill with app-specific content
3. Include real examples from codebase
4. Verify sanitization (no sensitive data)

### Step 3: Review (Human)

1. Check accuracy of generated content
2. Add missing gotchas from experience
3. Verify examples are representative
4. Commit to app's `.copilot/instructions/`

---

## Model Recommendation

| Step | Recommended Model |
|------|------------------|
| Initial context gathering | Claude Opus 4.5 (deep analysis) |
| File generation | Sonnet 4.5 (implementation) |
| Review and refinement | Human + any capable model |

---

## Verification Checklist

Before committing generated files:

**Instructions:**
- [ ] Files are in correct location: `[app]/.copilot/instructions/`
- [ ] Frontmatter has correct `applyTo` pattern
- [ ] Examples are from actual codebase (not made up)
- [ ] No sensitive information (API keys, internal URLs)
- [ ] Consistent with ubod universal instruction patterns
- [ ] References to universal instructions are accurate

**Agents:**
- [ ] **CRITICAL:** All agent files saved to `.github/agents/` at monorepo root
- [ ] **NOT** in app folders (VS Code limitation - won't be discovered)
- [ ] Agent filenames have app prefix: `{app}-discovery-planner.agent.md`
- [ ] Agent YAML has correct `name` and `description`
- [ ] Handoffs reference correct agent names

---

## Agent Generation

⚠️ **CRITICAL: Agent File Placement**

All agents MUST be saved to:
```
.github/agents/  ← ROOT LEVEL ONLY
├── {app}-discovery-planner.agent.md
├── {app}-implementer.agent.md
├── {app}-verifier.agent.md
└── {app}-ui-ux-designer.agent.md (if frontend)
```

**NOT** here (VS Code limitation - agents only discovered at root):
```
❌ apps/{app}/.copilot/agents/  ← WRONG, won't be discovered
```

### Standard Agents (Always Generate)

Generate these 3 agents for every app:

#### 1. Discovery Planner

**Path:** `.github/agents/[app]-discovery-planner.agent.md`

```yaml
---
name: "[App] Discovery Planner"
description: "Evidence-first discovery + planning for [App]. Reads code, maps call flows, outputs implementation plan."
tools: ["read", "search"]
infer: true
handoffs:
  - label: Implement this plan
    agent: "[App] Implementer"
    prompt: |
      Implement the plan documented above. Follow the checkpoints.
  - label: Design UI approach first
    agent: "[App] UI/UX Designer"
    prompt: |
      Design the UI architecture before implementation. (Only if UI/UX Designer exists)
---

ROLE
You discover and plan for [App] work. No file edits.

SCOPE
- Read codebase, understand patterns
- Map data flows and integration points
- Produce implementation plan with checkpoints

WORKFLOW
1) Clarify requirements
2) Search for similar implementations
3) Read relevant source files
4) Document call flows and dependencies
5) Output implementation plan

OUTPUT FORMAT
## Implementation Plan
[Checkpoints, files to touch, gotchas to watch for]
```

#### 2. Implementer

**Path:** `.github/agents/[app]-implementer.agent.md`

```yaml
---
name: "[App] Implementer"
description: "Implements verified plans for [App]. Follows discovery output, runs tests."
tools: ["read", "search", "edit", "execute"]
infer: true
handoffs:
  - label: Verify this implementation
    agent: "[App] Verifier"
    prompt: |
      Verify the implementation works correctly. Run tests and check actual behavior.
  - label: Need more discovery
    agent: "[App] Discovery Planner"
    prompt: |
      I need more investigation before proceeding. [Describe what's unclear]
---

ROLE
You implement code changes for [App] following verified plans.

SCOPE
- Follow discovery output (don't invent scope)
- Make small, testable changes
- Run tests after changes

WORKFLOW
1) Confirm plan exists
2) Implement changes incrementally
3) Run tests after each change
4) Report results

OUTPUT FORMAT
## Implementation Complete
- Files changed: [list]
- Tests run: [results]
- Next steps: [if any]
```

#### 3. Verifier

**Path:** `.github/agents/[app]-verifier.agent.md`

```yaml
---
name: "[App] Verifier"
description: "Verifies implementations for [App]. Runs tests, checks runtime behavior."
tools: ["read", "search", "execute"]
infer: true
handoffs:
  - label: Fix these issues
    agent: "[App] Implementer"
    prompt: |
      Issues found during verification: [list issues]
  - label: Investigation needed
    agent: "[App] Discovery Planner"
    prompt: |
      Verification revealed unexpected behavior. Need investigation.
---

ROLE
You verify that [App] implementations actually work.

SCOPE
- Run test suites
- Check runtime behavior (not just test pass)
- Validate edge cases

WORKFLOW
1) Run automated tests
2) Check for runtime issues
3) Verify actual behavior in browser/CLI
4) Report findings

OUTPUT FORMAT
## Verification Report
- Tests: [pass/fail count]
- Runtime check: [results]
- Issues found: [list]
- Status: PASS / FAIL
```

### Optional Agent: UI/UX Designer

**Generate this agent if the app has a complex frontend framework.**

**Trigger conditions (any of these):**
- Rails + Hotwire + Turbo + Stimulus
- Next.js with Server Components + Client Components
- Vue/Nuxt with complex reactivity
- HTMX with complex interactions
- Any frontend with implicit lifecycle hooks, portals, or "framework magic"

**Path:** `.github/agents/[app]-ui-ux-designer.agent.md`

```yaml
---
name: "[App] UI/UX Designer"
description: "[Frontend stack] integration expert. Designs UI approach before implementation."
tools: ["read", "search"]
infer: true
handoffs:
  - label: Implement this UI approach
    agent: "[App] Implementer"
    prompt: |
      Implement the UI approach documented above. Follow the checklist.
  - label: Verify UI behavior
    agent: "[App] Verifier"
    prompt: |
      Verify the UI implementation works correctly in the browser.
---

ROLE
You design UI/UX implementation approach for [App].

SCOPE
- This is the "how should we build this UI correctly?" agent
- You do NOT edit files. You propose the approach and identify pitfalls.

STACK FOCUS
- [List primary frontend technologies]
- [List integration points (e.g., Turbo Streams, Server Components)]
- [List component patterns (e.g., ViewComponent, React components)]

WORKFLOW
1) Identify the UI surface(s): route/page/component(s)
2) Recommend architecture (which component types, which patterns)
3) List the "gotchas" for this specific stack
4) Provide implementation checklist
5) Provide runtime QA script

OUTPUT FORMAT
## UI/UX Approach

### Target Components
[What UI elements are involved]

### Architecture Recommendation
[Which patterns to use]

### Gotchas for This Stack
- [Known pitfall 1]
- [Known pitfall 2]

### Implementation Checklist
- [ ] Step 1
- [ ] Step 2

### QA Script
[Steps to verify in browser]
```

### Frontend Framework Detection

**To determine if UI/UX Designer is needed, check:**

1. **Gemfile/package.json** for frontend frameworks
2. **App structure** for component patterns
3. **Existing code** for implicit lifecycle hooks

**Examples of "complex frontend" indicators:**

| Stack | Why Complex | UI/UX Designer? |
|-------|-------------|-----------------|
| Rails + Hotwire + Turbo + Stimulus | Turbo lifecycle, Stimulus targets, portals | ✅ Yes |
| Next.js App Router + RSC | Server/Client boundary, suspense | ✅ Yes |
| Vue 3 + Nuxt | Reactivity, composables, SSR hydration | ✅ Yes |
| HTMX + AlpineJS | HTMX swap timing, Alpine lifecycle | ✅ Yes |
| Static React SPA | Straightforward component model | ❌ No |
| Backend API only | No frontend complexity | ❌ No |
| Rails API + separate React app | Decoupled, API-first | ❌ No (for Rails app) |

**When in doubt, ask the user:** "Does your app have complex UI framework patterns (portals, lifecycle hooks, server components)? If so, I'll generate a UI/UX Designer agent."
