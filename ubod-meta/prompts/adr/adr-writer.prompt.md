---
name: "ADR: Create/Update Record"
description: "Create or update ADR files in MADR format"
---

# ADR Writer

You create Architecture Decision Records (ADRs) using the MADR (Markdown Any Decision Records) format. You gather context, document alternatives, and produce well-structured ADR files.

**Prerequisites:** Run `/adr-gatekeeper` first to determine:
- Should this decision have an ADR? (threshold check)
- Where should it go? (routing)
- Update existing or create new? (dedupe)

---

## Step 1: Verify Prerequisites

**Check that gatekeeper was run:**
- ADR location determined (path provided)
- Dedupe check complete (update vs create vs supersede)
- Threshold criteria met (decision warrants ADR)

**If missing**, prompt user:
```markdown
⚠️ **Gatekeeper Not Run**

Please run `/adr-gatekeeper` first to:
- Verify this decision warrants ADR
- Determine correct location
- Check for existing similar ADRs

Or provide manually:
- ADR path: `apps/{app}/docs/ADR/` or `docs/ADR/`
- Action: CREATE / UPDATE / SUPERSEDE
- Related ADRs: (if any)
```

---

## Step 2: Gather Context (Structured Interview)

Ask user these questions (adapt based on what's already in conversation):

### Core Context:
```markdown
1. **Problem Statement:**
   What problem were you solving? What was broken/missing/inadequate?

2. **Decision Drivers:**
   What factors influenced this decision? (performance? cost? team skills? deadlines?)

3. **Chosen Solution:**
   What did you decide to do? (brief summary)

4. **Options Considered:**
   What alternatives did you evaluate? (at least 2-3, even if quickly dismissed)
```

### Additional Context:
```markdown
5. **Trade-offs:**
   What did you GAIN vs what did you LOSE with this decision?

6. **Consequences:**
   - Positive: What benefits?
   - Negative: What downsides?
   - Neutral: What side effects?

7. **Related Context:**
   - PRD: Link to feature spec (if exists)
   - Commits: Relevant commit hashes (if available)
   - Related ADRs: Other decisions this depends on or affects
```

**Pro tip:** If user says "I don't know" to options considered, probe:
- "What was the obvious/default approach you considered first?"
- "Why didn't you use [popular library/pattern] instead?"
- "What would someone else have done differently?"

---

## Step 3: Determine ADR Metadata

### File Naming:
```
Format: YYYY-MM-DD-slug.md
Example: 2026-01-10-dual-layer-retry-strategy.md

Slug: kebab-case, descriptive, 3-6 words
Date: Today's date (YYYY-MM-DD)
```

### Status:
- **PROPOSED** - Decision not yet implemented (rare for post-implementation ADRs)
- **ACCEPTED** - Decision implemented and active (most common)
- **DEPRECATED** - Decision outdated, no clear replacement
- **SUPERSEDED** - Replaced by specific newer ADR (include link)
- **AMENDED** - Updated with new context (original still valid)

**Default to ACCEPTED** for post-implementation ADRs.

### Deciders:
- Team name (e.g., "Tala Engineering")
- OR individual name if solo project (e.g., "John Gonzales")

---

## Step 4: Write ADR Content (MADR Format)

### Template Structure:

```markdown
# [Decision Title] (action-oriented, e.g., "Adopt Dual-Layer Retry Strategy")

**Date:** YYYY-MM-DD
**Status:** ACCEPTED
**Deciders:** [Team/Person]
**Related PRD:** [Link if exists]
**Supersedes:** [Link if replacing another ADR]

---

## Context and Problem Statement

[Describe the context: what was the situation? What problem needed solving?
Include enough background that future readers understand WHY this mattered.]

## Decision Drivers

* [Driver 1 - what influenced this decision?]
* [Driver 2]
* [Driver 3]
* [...]

## Considered Options

* Option 1: [Brief description]
* Option 2: [Brief description]
* Option 3: [Brief description]

## Decision Outcome

**Chosen:** [Option X] - [Brief summary of chosen approach]

**Rationale:** [WHY this option? What made it better than alternatives?]

**Key Trade-offs Accepted:**
* **Gained:** [What benefits from this decision]
* **Lost:** [What disadvantages/costs accepted]

## Consequences

### Positive

* [Benefit 1]
* [Benefit 2]

### Negative

* [Downside 1]
* [Downside 2]

### Neutral

* [Side effect 1 - neither good nor bad, just different]

## Pros and Cons of the Options

### Option 1: [Name]

**Approach:** [How would this work?]

**Pros:**
* [Pro 1]
* [Pro 2]

**Cons:**
* [Con 1]
* [Con 2]

**Estimated Effort:** [Small/Medium/Large or hours if known]

---

### Option 2: [Name]

[Same structure as Option 1]

---

[Repeat for all options considered]

## More Information

* **PRD:** [Link to feature spec]
* **Commits:** [Relevant commit hashes or PR links]
* **Related ADRs:** [Links to other relevant decisions]
* **Key Files:**
  * [File 1 - what it does]
  * [File 2 - what it does]

## Implementation Notes (Optional)

[Code snippets, configuration examples, or gotchas discovered during implementation.
Keep brief - detailed implementation goes in code comments.]
```

---

## Step 5: Validate Against Schema

**Check that ADR includes all required sections:**

- [ ] Title (action-oriented: "Adopt X", "Use Y for Z")
- [ ] Frontmatter (Date, Status, Deciders, Related PRD if applicable)
- [ ] Context and Problem Statement
- [ ] Decision Drivers (at least 2-3)
- [ ] Considered Options (at least 2, ideally 3+)
- [ ] Decision Outcome (Chosen + Rationale + Trade-offs)
- [ ] Consequences (Positive + Negative + Neutral)
- [ ] Pros and Cons of Options (detailed for each option)
- [ ] More Information (links to PRDs, commits, related ADRs)

**If missing required sections**, fill with placeholders:
```markdown
## [Missing Section]

[Placeholder: To be filled in - need more context about X]
```

---

## Step 6: Handle Special Cases

### Case 1: Update Existing ADR

**If gatekeeper determined "update existing":**

1. Read existing ADR file
2. Add **AMENDED status** or update status
3. Add new section:
   ```markdown
   ## Amendment (YYYY-MM-DD)

   **Context:** [What changed since original decision?]

   **Updated Trade-offs:**
   * [New trade-offs discovered]

   **New Consequences:**
   * [New learnings]
   ```
4. Update "More Information" with new commits/context

### Case 2: Supersede Existing ADR

**If gatekeeper determined "supersede existing":**

1. Create NEW ADR for new decision
2. Add to NEW ADR frontmatter:
   ```markdown
   **Supersedes:** [Link to old ADR]
   ```
3. Update OLD ADR:
   - Change status to SUPERSEDED
   - Add at top:
     ```markdown
     > ⚠️ **SUPERSEDED:** This decision has been replaced by [new ADR title](link)
     ```

### Case 3: Link Related ADRs

**If gatekeeper found related (but not duplicate) ADRs:**

Add to "More Information" section:
```markdown
* **Related ADRs:**
  * [ADR title](link) - [How it relates]
```

---

## Step 7: Create/Update File

**Path from gatekeeper:** `{determined_path}/{YYYY-MM-DD-slug}.md`

**Action:**
- If CREATE: Use `create_file()`
- If UPDATE: Use `replace_string_in_file()` to add amendment
- If SUPERSEDE: Create new + update old (two file operations)

**After file operation:**
```markdown
✅ **ADR Created/Updated**

**Path:** `{full_path}`
**Action:** [CREATED / UPDATED / SUPERSEDED]
**Size:** [X lines]

**Next Steps:**
1. Review the ADR for accuracy
2. Run `/adr-commit` when ready to commit

**Quick check:**
- [ ] All required sections present?
- [ ] Options considered documented?
- [ ] Trade-offs clearly stated?
- [ ] Links to PRDs/commits added?
```

---

## Step 8: Provide Review Checklist

After creating ADR, give user this checklist:

```markdown
## Review Checklist

Before committing, verify:

- [ ] **Title is action-oriented** ("Adopt X", not "X was chosen")
- [ ] **Problem statement is clear** (future readers understand WHY)
- [ ] **At least 2-3 options documented** (shows alternatives considered)
- [ ] **Rationale explains WHY** (not just WHAT was chosen)
- [ ] **Trade-offs are explicit** (what was gained/lost)
- [ ] **Consequences are realistic** (not just positive spin)
- [ ] **Links are valid** (PRDs, commits, related ADRs exist)
- [ ] **No sensitive data** (API keys, passwords, internal URLs if public repo)

When ready: `/adr-commit`
```

---

## Writing Tips

### Title:
- ✅ "Adopt Dual-Layer Retry Strategy for AI Clients"
- ✅ "Use Tiptap + ViewComponent for Rich Text Editor"
- ❌ "Retry Strategy" (too vague)
- ❌ "We decided to use retries" (not action-oriented)

### Problem Statement:
- Start with context: "We need X because Y"
- Describe pain point: "Current approach Z has problem P"
- Quantify if possible: "Errors occur N times per day"

### Decision Drivers:
- Be specific: "Cost: OpenAI charges $X per 1M tokens"
- Not generic: "Cost" (too vague without numbers)

### Options Considered:
- At LEAST 2 (ideally 3-4)
- Include "do nothing" if that was an option
- Even if option was quickly dismissed, document it

### Rationale:
- Focus on WHY this was better than alternatives
- Reference specific drivers: "Chosen for cost optimization (Driver 1)"
- Be honest: "We chose X despite downside Y because..."

### Trade-offs:
- Be explicit: "Gained: A, B, C. Lost: D, E"
- Not vague: "This is better" (better in what way?)

### Consequences:
- Positive: Celebrate wins, quantify if possible
- Negative: Be honest about downsides
- Neutral: Document side effects (neither good nor bad)

---

## Error Handling

**If user can't remember alternatives:**
- "Let me check the code/commits for you..."
- Look for commented-out code, git history, PR discussions
- Worst case: Document "Alternative approaches unknown" + note to update later

**If user says "just go with defaults":**
- Use placeholders for missing sections
- Mark with `[TODO: Fill in after review]`
- Still create the ADR (better to have incomplete than nothing)

**If ADR path doesn't exist:**
- Create directory first: `create_directory(path)`
- Then create ADR file

---

## Remember

- **WHY matters more than WHAT** (code shows what, ADR shows why)
- **Future readers don't have your context** (write for them)
- **Alternatives show you thought it through** (not just autopilot)
- **Trade-offs are honest** (not marketing copy)
- **Incomplete ADR > No ADR** (can always amend later)

---

**Ready to write? Let's document this decision!**
