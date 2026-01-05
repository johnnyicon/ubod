---
applyTo: "**/*"
---

# Two-Phase Response Pattern (Universal)

**Purpose:** Always show discovery evidence before implementing

**Last Updated:** 2025-12-31

---

## The Two-Phase Pattern

**ALWAYS respond in two phases:**

### Phase 1: Discovery Evidence

**Show what you found BEFORE implementing:**

```markdown
✅ Discovery Evidence:

[If fixing a bug] Error Analysis:
  - Error message: [exact error from logs]
  - Failed at: [file:line]
  - Stack trace shows: [key insights]

Source Code Read:
  - File: [path]
  - Lines: [range]
  - Key findings:
    * [finding 1 with line number reference]
    * [finding 2 with line number reference]
    * [finding 3 with line number reference]

Similar Implementations Found:
  1. [file:line] - [how it works]
  2. [file:line] - [how it works]

Pattern Confirmed:
  - Pattern name: [specific pattern]
  - Based on: [files where you saw this pattern]
  - API usage: [exact method calls / signatures]
  - Naming convention: [specific convention]

Assumptions Made:
  1. [Assumption 1] - Based on [evidence from code]
  2. [Assumption 2] - Based on [evidence from code]

Edge Cases Considered:
  - Authorization: [specific checks needed]
  - Performance: [specific concerns]
  - Data Integrity: [specific cascade/cleanup needs]

Ready to implement: Yes

---

**Shall I proceed with implementation?**
```

### Phase 2: Implementation (After User Approval)

**Only after user says "yes" or "proceed":**

```markdown
✅ Implementing based on discovery evidence...

[Your implementation here]
```

---

## Why Two Phases?

**Benefits:**

1. **Catches wrong assumptions early**
   - User can correct misunderstandings before code is written
   - Saves time by avoiding wrong implementations

2. **Builds trust**
   - User sees you did proper research
   - Evidence-based approach, not guessing

3. **Creates audit trail**
   - Documents decision-making process
   - Helps with future debugging and maintenance

4. **Prevents wasted work**
   - User can redirect if approach is wrong
   - Avoids implementing solutions to wrong problems

---

## Validation Rules

**Phase 1 MUST include:**

- ✅ Tool call results (error logs, file reads, searches)
- ✅ Specific line numbers from files you read
- ✅ Pattern evidence from multiple files
- ✅ Explicit assumptions and edge cases
- ✅ Question: "Shall I proceed with implementation?"

**Phase 1 CANNOT:**

- ❌ Skip discovery and go straight to code
- ❌ Show code without evidence
- ❌ Assume APIs without reading source
- ❌ Reference columns without checking schema

---

## Example: Good Two-Phase Response

**User asks:** "Add a close button to the document drawer"

**Phase 1 (Discovery):**

```markdown
✅ Discovery Evidence:

Source Code Read:
  - File: app/components/documents/drawer_component.rb
  - Lines: 1-50
  - Key findings:
    * Uses Library::SheetComponent (line 15)
    * Has header slot defined (line 23)
    * Controller: documents--drawer (line 10)

Library Source Read:
  - File: [library-path]/app/components/library/sheet_component.rb
  - Lines: 1-40
  - Key findings:
    * Provides with_header slot (line 18)
    * Provides with_close_button method (line 25)
    * Example usage in comments (lines 5-15)

Similar Implementations Found:
  1. app/components/messages/panel_component.rb:45 - Uses with_close_button
  2. app/components/settings/modal_component.rb:32 - Similar pattern

Pattern Confirmed:
  - Pattern: Sheet with close button
  - API: sheet.with_close_button { "Close" }
  - Location: Inside sheet.with_header block

Assumptions:
  1. Close button should be in header - Based on similar components
  2. Should use Library's built-in close button - Based on library API

Ready to implement: Yes

---

**Shall I proceed with adding the close button using this pattern?**
```

**Phase 2 (After user approval):**

```markdown
✅ Implementing close button in drawer header...

[Implementation code here]
```

---

## Example: Bad Single-Phase Response

**User asks:** "Add a close button to the document drawer"

**❌ BAD (No discovery, straight to code):**

```markdown
Here's the code to add a close button:

[Code here]
```

**Why this is bad:**
- No evidence of reading source code
- No verification of library API
- No pattern confirmation
- User can't verify approach before implementation
- Might use wrong API or pattern

---

## When to Skip Phase 1

**Only skip discovery phase if:**

1. **User explicitly says "skip discovery"**
   - Still warn about risks
   - Document assumptions

2. **Trivial changes** (e.g., fixing typos, updating comments)
   - But still verify the file exists and read it first

3. **User provides complete specification**
   - User has already done discovery
   - You're just implementing their exact spec

**Otherwise, ALWAYS use two-phase pattern.**

---

## Emergency Override

If user says:
- **"Skip discovery"** → Skip Phase 1 but warn about risks
- **"Just do it"** → Proceed to Phase 2 but document assumptions
- **"I've already verified this"** → Trust user but confirm understanding

**Otherwise, ALWAYS show discovery evidence first.**

---

**Remember:** Discovery evidence → User approval → Implementation

This pattern prevents wasted work and builds trust.
