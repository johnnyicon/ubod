---
description: "Create a new universal instruction for the ubod framework"
model: "claude-opus-4-5 for methodology, sonnet-4-5 for implementation"
---

# Create New ubod Instruction

You are creating a new instruction file for the ubod framework.

**Your role:** Design and create a universal instruction that provides clear methodology guidance without app-specific assumptions.

---

## Pre-Flight Checks

Before creating, answer:

1. **What problem does this instruction solve?**
   - What methodology gap are you filling?
   - What anti-patterns are you preventing?

2. **Is this truly universal?**
   - Would this apply to Rails, React, Python, Go, etc.?
   - Is it about HOW to work (methodology) vs WHAT to build (implementation)?

3. **Does an existing instruction already cover this?**
   - Check `templates/instructions/universal/` for overlap
   - Consider extending an existing instruction instead

4. **What category does this belong to?**
   - `universal/` - Core methodology (discovery, verification, debugging)
   - `universal/debugging/` - Debugging-specific protocols
   - New category? Justify it.

---

## Step 1: Define the Instruction

```markdown
## Instruction Definition

**Name:** [name].instructions.md

**Category:** [universal / universal/debugging / new category]

**Purpose:** [One clear sentence]

**Problem it Solves:**
- [Problem 1]
- [Problem 2]

**Anti-Patterns it Prevents:**
- [Anti-pattern 1]
- [Anti-pattern 2]

**Related Instructions:**
- [instruction-name.instructions.md] - [relationship]
- [instruction-name.instructions.md] - [relationship]

**App-Specific Deferral Needed?**
- [ ] No - fully universal
- [ ] Yes - needs app-specific hook for: [describe]
```

---

## Step 2: Design the Structure

Use this template:

```markdown
---
applyTo: "**/*"
---

# [Title]

**Purpose:** [One-line description]

---

## [Emoji] [PROTOCOL NAME] ACTIVE (optional - for protocols)

---

## Core Principle

**[Main insight in bold]**

[Explanation of why this matters]

**Common failure mode:**
- [What goes wrong without this instruction]

**Better approach:**
- [What this instruction teaches]

---

## [Main Section 1]

[Content with examples]

### Subsection (if needed)

[More detail]

---

## [Main Section 2]

[Content]

---

## [Checklist / Template / Quick Reference]

Use this for practical application:

```markdown
## [Template Name]

- [ ] [Item 1]
- [ ] [Item 2]
- [ ] [Item 3]
```

---

## App-Specific Extensions

**If your [domain] has specific patterns, create:**

`[app]/.copilot/instructions/[app]-[topic].instructions.md`

**This file should define:**
- [What app-specific content goes there]
- [How it extends this universal instruction]

---

## Common Mistakes to Avoid

### 1. [Mistake Name]

❌ [What not to do]
✅ [What to do instead]

### 2. [Mistake Name]

❌ [What not to do]
✅ [What to do instead]

---

**Remember:** [Key takeaway in one sentence]

---

[Emoji] **[PROTOCOL NAME] COMPLETE** (optional - for protocols)
```

---

## Step 3: Write the Content

Follow these content guidelines:

### Be Specific but Generic

**Good:** "Before calling any API method, read the library source to verify the method exists"
**Bad:** "Before calling Stimulus controller actions, verify the action exists"

### Use Placeholder Patterns

```markdown
# For framework-specific examples:
[FRAMEWORK: Add command for your test runner]

# For app-specific content:
See: `[app]/.copilot/instructions/[app]-[topic].instructions.md`

# For language-specific commands:
# Ruby: bundle exec rspec
# Python: pytest
# Node: npm test
```

### Include Real Patterns, Genericized

```markdown
## Example: Verifying API Existence

```bash
# Find library location
# [FRAMEWORK: Add command to find library/package path]

# Read source
read_file("[library-path]/components/[component].rb", startLine=1, endLine=100)
```
```

---

## Step 4: Create Deferral Hooks (if needed)

If the instruction needs app-specific extensions:

### 1. Add Deferral Section to Instruction

```markdown
## App-Specific Extensions

**Universal patterns are defined above. For stack-specific patterns:**

See your app's `.copilot/instructions/[app]-[topic].instructions.md`

**That file should define:**
- [Specific item 1]
- [Specific item 2]
- [Specific item 3]
```

### 2. Create Generator Prompt

Create a corresponding prompt at:
`templates/prompts/generate-[topic].prompt.md`

This prompt helps users create the app-specific file.

---

## Step 5: Verification Checklist

### Sanitization Check
```bash
grep -ri "tala\|bathala\|stimulus\|viewcomponent\|shadcn\|hotwire\|turbo" [file]
# Should return empty or only in placeholder comments like "[FRAMEWORK: Stimulus, React, Vue, etc.]"
```

### Universality Check
Ask: Would this instruction make sense for a developer using:
- [ ] Ruby on Rails
- [ ] React + Node.js
- [ ] Python + Django
- [ ] Go + standard library
- [ ] A stack I've never heard of

### Structure Check
- [ ] Has frontmatter with `applyTo`
- [ ] Has Purpose statement
- [ ] Has Core Principle section
- [ ] Has actionable content (not just philosophy)
- [ ] Has checklist or template for practical use
- [ ] Has "Common Mistakes" section
- [ ] Has "Remember" summary
- [ ] References related instructions correctly

### Content Check
- [ ] Examples are generic but useful
- [ ] Placeholders are clear: `[FRAMEWORK: ...]`
- [ ] Deferral hooks are documented (if needed)
- [ ] Tone matches other ubod instructions

---

## Step 6: Request Review

For new instructions, especially methodology-defining ones:

1. **Self-review** with universality questions above
2. **Cross-model review** if introducing new patterns
3. **Test mentally** against different tech stacks

---

## Commit Template

```
feat(ubod): add [instruction-name].instructions.md

New universal instruction for [purpose].

Covers:
- [Key topic 1]
- [Key topic 2]

Deferral hooks: [yes/no]
Generator prompt: [created/not-needed]
Sanitization verified: yes
```
