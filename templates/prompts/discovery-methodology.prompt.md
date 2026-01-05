---
description: "Run a focused discovery phase before implementing or debugging"
---

# Discovery Methodology (Search-First Workflow)

You are leading a **short, focused discovery phase** before writing or changing any code.

**Your role:** Gather concrete context from this repo, summarize it, and only then propose an implementation or debugging plan.

---

## Step 0: Confirm the Task

Ask the user to clarify:
1. What are you trying to achieve? (feature / bug / refactor)
2. Which area of the codebase is likely involved? (models, services, UI, jobs, etc.)
3. Any known files, routes, or classes already related?

Keep the summary short but specific.

---

## Step 1: Search for Related Code (2–5 minutes)

Use the tools available (semantic search, ripgrep, file tree) to discover:

1. **Existing models/classes**
   - List likely files (e.g., `app/models/*`, `app/services/*`, relevant directories)
   - Identify exact class/module names that matter for this task

2. **Actual implementation details**
   - Open the most relevant files
   - Note associations, validations, public methods, callbacks, and any non-obvious behavior

3. **Database/schema state**
   - Check schema file or migrations for relevant tables/columns/indexes
   - Note what exists **and what does NOT exist** but might be assumed

4. **Existing patterns & tests**
   - Find similar features, components, or flows
   - Look at existing tests (models, services, controllers, system tests) for patterns

Keep this phase **read-only**: no changes yet.

---

## Step 2: Produce a Discovery Summary

Summarize findings in a compact structure like this:

```markdown
## Discovery Summary

### Relevant Models / Classes
- **[Name]:** [file path]
  - Fields: [...]
  - Associations: [...]
  - Validations / callbacks: [...]

### Existing Patterns
- [Feature or flow name]
  - Location: [path/to/file]
  - Pattern: [short description]

### Schema Snapshot
- Tables/columns directly involved
- Notable constraints (null, defaults, indexes)

### Open Questions
- [Question 1]
- [Question 2]
```

Do **not** propose solutions yet — just reflect current reality.

---

## Step 3: Plan Based on Verified Context

Using the Discovery Summary, propose a **small, verifiable plan**:

1. What already exists and can be reused
2. What needs to be added or changed (files, classes, migrations, tests)
3. Dependencies or integration points to be careful about
4. A minimal sequence of steps (Phase 1, Phase 2, …) to implement or debug

Represent this as a short checklist or phased plan the user can approve.

---

## Step 4: Ask for Confirmation Before Implementing

Before writing code:
- Present the Discovery Summary and proposed plan
- Ask the user to confirm or correct any assumptions
- Only after confirmation, move on to implementation, tests, or deeper debugging

Your output from this prompt should be **only**:
1. A filled-in **Discovery Summary**, and
2. A **proposed implementation/debugging plan** based on that summary.
