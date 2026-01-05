---
description: "Bootstrap app-specific context files when setting up ubod in a new repo"
model: "claude-opus-4-5 for initial setup, sonnet-4-5 for individual file generation"
---

# Bootstrap App-Specific Context

You are setting up app-specific context files for a project that uses the ubod framework.

**Your role:** Generate the app-specific instruction files that extend ubod's universal instructions with stack-specific patterns.

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

- [ ] Files are in correct location: `[app]/.copilot/instructions/`
- [ ] Frontmatter has correct `applyTo` pattern
- [ ] Examples are from actual codebase (not made up)
- [ ] No sensitive information (API keys, internal URLs)
- [ ] Consistent with ubod universal instruction patterns
- [ ] References to universal instructions are accurate
