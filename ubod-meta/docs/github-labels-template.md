# GitHub Labels Template

**Purpose:** Standard label structure for organizing issues in monorepos

**Last Updated:** 2026-01-10

---

## Label Structure

This template provides a consistent labeling system for GitHub Issues across different repository types. Customize the **values** (app names, feature areas) for your specific repo, but keep the **structure** consistent.

---

### App Labels (Monorepos)

**Format:** `app:{{app-name}}`

**Purpose:** Filter issues by application in a monorepo

**Example Values:**
- `app:tala` - Main Rails application
- `app:api` - API service
- `app:mobile` - Mobile app
- `app:admin` - Admin dashboard

**Color:** `#0366d6` (blue)

---

### Feature Area Labels

**Format:** `area:{{feature-area}}`

**Purpose:** Group issues by feature domain

**Example Values:**
- `area:documents` - Document management
- `area:upload` - File uploads
- `area:chat` - Chat/messaging
- `area:auth` - Authentication
- `area:rag` - RAG/AI features
- `area:ui-ux` - UI/UX improvements
- `area:testing` - Test infrastructure

**Color:** `#fbca04` (yellow)

---

### Priority Labels

**Format:** `priority:{{level}}`

**Purpose:** Indicate urgency/importance

**Standard Values:**
- `priority:P0` - Critical (blocks release, immediate fix required)
- `priority:P1` - High (needed for release, address soon)
- `priority:P2` - Medium (nice-to-have, can wait)
- `priority:P3` - Low (enhancement, backlog)

**Colors:**
- P0: `#b60205` (red)
- P1: `#d93f0b` (orange)
- P2: `#fbca04` (yellow)
- P3: `#0e8a16` (green)

---

### Type Labels

**Format:** `type:{{type}}`

**Purpose:** Categorize issue by nature of work

**Standard Values:**
- `type:enhancement` - New feature or improvement
- `type:bug` - Bug fix
- `type:tech-debt` - Technical debt refactoring
- `type:docs` - Documentation
- `type:chore` - Maintenance tasks

**Color:** `#1d76db` (blue)

---

### Status Labels

**Format:** `status:{{status}}`

**Purpose:** Track issue lifecycle state

**Standard Values:**
- `status:deferred` - Deferred from completed PRD
- `status:backlog` - In backlog, not yet prioritized
- `status:blocked` - Blocked by dependency
- `status:in-progress` - Currently being worked on
- `status:review` - In review/QA

**Color:** `#c5def5` (light blue)

---

## Usage Guidelines

### Minimum Required Labels

Every issue should have **at minimum**:
- 1 `app:*` label (monorepos only)
- 1 `area:*` label
- 1 `priority:*` label
- 1 `type:*` label

### Optional Labels
- `status:*` - Use when tracking state beyond GitHub's built-in states
- Custom labels as needed for your workflow

---

## Creating Issues from PRDs

When extracting deferred items from PRDs to GitHub Issues:

### Issue Title Format
```
[Feature Name] - [App Name]
```

### Issue Body Template
```markdown
## Context
- **App:** {{app-name}}
- **PRD:** prds/{{app}}/{{prd-folder}}/
- **Original Priority:** {{P2|P3}}
- **Deferred from:** {{PRD Name}}
- **Deferred Date:** YYYY-MM-DD

## Description
{{Copy from PRD}}

## Acceptance Criteria
{{Copy from PRD}}

## Technical Context
- **Relevant files:** {{List key files}}
- **Dependencies:** {{Technical dependencies}}

## Links
- **PRD:** {{Link to GitHub}}
- **Related Issues:** {{Dependencies}}
```

### Label Assignment
```
Labels:
  - app:{{app-name}}
  - area:{{feature-area}}
  - priority:{{P2|P3}}
  - type:enhancement
  - status:deferred
```

---

## Milestones (Optional)

**Purpose:** Group related issues into releases or feature sets

**When to use:**
- Grouping deferred items from same PRD
- Planning releases (v1.0, v1.1, etc.)
- Tracking feature sets (e.g., "Upload UX Enhancements")

**Example:**
- Milestone: "Tala Upload UX Enhancements"
- Contains: 4 deferred upload issues
- Shows: Progress (0/4 → 2/4 → 4/4)

---

## Implementation Checklist

### For Ubod Framework Maintainers
- [ ] Keep this template updated as patterns evolve
- [ ] Document rationale for any structure changes
- [ ] Maintain color consistency across standards

### For Consumer Repos
- [ ] Create `.github/LABELS.md` with repo-specific values
- [ ] Set up labels in GitHub (manual or via API/MCP)
- [ ] Document custom labels specific to your domain
- [ ] Train team on labeling conventions

---

## Examples by Repo Type

### Monorepo (Rails + Next.js + Services)
```
Apps: app:rails-api, app:nextjs-web, app:mobile
Areas: area:auth, area:payments, area:analytics
```

### Single App (Just Tala)
```
Apps: app:tala (still useful for filtering if adding more apps later)
Areas: area:documents, area:chat, area:rag
```

### Library/Framework (Ubod itself)
```
Apps: Skip app labels (not applicable)
Areas: area:templates, area:prompts, area:docs
```

---

## Label Management via GitHub API/MCP

If using GitHub MCP or API to create labels:

```javascript
// Example structure
{
  name: "app:tala",
  description: "Tala Rails application",
  color: "0366d6"
}
```

---

**Remember:** The **structure** is universal (ubod standard), but **values** are repo-specific. Adapt the examples to your domain while preserving the pattern.
