---
name: ubod-update-instruction
description: "Update an existing ubod instruction with sanitization and quality checks"
---

# Update ubod Instruction

You are updating an existing instruction file in the ubod framework.

**Your role:** Modify the instruction while maintaining sanitization, following the template structure, and ensuring the change integrates well with other instructions.

**Before starting:** Read these specification files for official instruction format:
- `github-custom-instructions-spec.instructions.md` - Cross-product compatible instruction specification (GitHub Copilot)
- `vscode-custom-instructions-spec.instructions.md` - VS Code-specific instruction features

These files auto-load when editing `.instructions.md` files and contain authoritative documentation on instruction file structure, `applyTo` patterns, frontmatter properties, and best practices.

---

## Pre-Flight Checks

Before making changes, verify:

1. **Which instruction are you updating?**
   - Path: `templates/instructions/[category]/[name].instructions.md`
   - Current content understood?

2. **What is the scope of the change?**
   - [ ] Minor fix (typo, clarification) → Use Sonnet 4.5, single pass
   - [ ] Moderate update (new section, refined examples) → Use Sonnet 4.5, single pass + self-review
   - [ ] Major revision (restructure, new methodology) → Use Opus 4.5, multi-pass

3. **Does this change affect other instructions?**
   - List any cross-references that need updating
   - Check for dependencies

---

## Step 1: Understand Current State

Read the instruction file and answer:

1. What is the instruction's purpose?
2. What patterns does it establish?
3. How does it reference other instructions?
4. Does it have deferral hooks for app-specific content?

---

## Step 2: Plan the Change

Describe your change:

```markdown
## Change Plan

**Instruction:** [filename]

**Change Type:** Minor / Moderate / Major

**What's Changing:**
- [Specific change 1]
- [Specific change 2]

**Why:**
- [Reasoning for change]

**Impact on Other Instructions:**
- [List any affected files]

**Deferral Hooks Needed:**
- [ ] This change is universal (no app-specific content)
- [ ] This change needs app-specific deferral (describe hook)
```

---

## Step 3: Apply the Change

Make the modification following these rules:

### Template Structure (Must Maintain)

```markdown
---
applyTo: "[glob pattern]"
---

# [Title]

**Purpose:** [One-line description]

---

## [Emoji] PROTOCOL ACTIVE (if applicable)

---

## Core Principle

[Main concept]

---

## [Main Content Sections]

---

## [Checklist/Template Section] (if applicable)

---

**Remember:** [Key takeaway]

---

[Emoji] **PROTOCOL COMPLETE** (if applicable)
```

### Sanitization Rules

**NEVER include:**
- Project names (Tala, Bathala, etc.)
- Framework-specific terms without generification (Stimulus → "JS framework controller")
- Hardcoded paths to specific apps
- Internal team references

**ALWAYS include:**
- Generic placeholders: `[FRAMEWORK: ...]`, `[APP-SPECIFIC: ...]`
- Deferral statements: "See app-specific instructions for..."
- Universal patterns that apply to any stack

---

## Step 4: Verification Checklist

Before finalizing, verify:

### Sanitization Check
```bash
grep -ri "tala\|bathala\|stimulus\|viewcomponent\|shadcn\|hotwire\|turbo" [file]
# Should return empty or only generic placeholder comments
```

### Structure Check
- [ ] Has frontmatter with `applyTo`
- [ ] Has Purpose statement
- [ ] Has Core Principle section
- [ ] Follows consistent heading structure
- [ ] Ends with summary/reminder

### Cross-Reference Check
- [ ] All referenced instructions exist
- [ ] References use correct paths
- [ ] Deferral hooks point to valid extension points

### Content Quality Check
- [ ] Clear, actionable guidance
- [ ] Examples are generic but useful
- [ ] No framework-specific assumptions
- [ ] Matches tone of other ubod instructions

---

## Step 5: Document the Change

Add to your commit message:

```
[type](scope): [brief description]

- [Specific change 1]
- [Specific change 2]

Sanitization verified: [yes/no]
Cross-references updated: [list or N/A]
```

---

## Self-Review Questions

If doing single-pass, ask yourself:

1. Would this instruction make sense in a React + Node.js project?
2. Would this instruction make sense in a Python + Django project?
3. Would this instruction make sense in a Go + gRPC project?
4. Are there any assumptions about the tech stack baked in?
5. Does the instruction defer properly to app-specific content?

If any answer is "no" or "maybe", revise before committing.

---

## When to Escalate to Multi-Pass

Request a review from a different model if:

- [ ] Change affects fundamental methodology
- [ ] Change restructures instruction categories
- [ ] Change introduces new deferral patterns
- [ ] You're unsure about sanitization decisions
- [ ] Change might conflict with other instructions
