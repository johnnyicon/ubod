---
applyTo: "**/*"
---

# Assumption Verification Protocol

**Purpose:** Identify and verify all assumptions before implementing

---

🔍 **ASSUMPTION VERIFICATION PROTOCOL ACTIVE** - Verifying beliefs before coding

---

## Core Principle

**Your assumptions are often wrong. Verify them BEFORE implementing.**

**Common failure mode:**
- Assume column exists → write code referencing it → error: column doesn't exist
- Assume API method exists → call it → error: undefined method
- Assume validation allows value → submit it → error: validation failed

**Better approach:**
- List assumptions explicitly
- Verify each one by reading source/schema/docs
- Update assumptions based on evidence
- THEN implement

---

## MANDATORY: List Assumptions First

**Before writing ANY code, list your assumptions:**

```markdown
## Assumptions for [Task Name]

### Assumption 1: [Specific belief]
- What I believe: [clear statement]
- Why I believe it: [reasoning]
- Evidence: [where I got this idea - docs, similar code, etc.]
- Verified: NO (need to check)

### Assumption 2: [Specific belief]
- What I believe: [clear statement]
- Why I believe it: [reasoning]
- Evidence: [where I got this idea]
- Verified: NO (need to check)

### Assumption 3: [Specific belief]
- What I believe: [clear statement]
- Why I believe it: [reasoning]
- Evidence: [where I got this idea]
- Verified: NO (need to check)

---

**Total assumptions: 3**
**Verified: 0 of 3**

**DO NOT proceed until verified: 3 of 3**
```

---

## Types of Assumptions to Watch For

### 1. Database Assumptions

**Common mistakes:**

```markdown
## Database Assumption

ASSUMPTION: "users table has a status column"
├─ Why I believe it: Saw references to user.status in code
├─ Evidence: app/models/user.rb has scope :by_status
└─ Verified: NO

VERIFICATION NEEDED:
- Read db/schema.rb (or equivalent schema file)
- Check for "status" in users table definition
- Confirm data type and constraints
```

**How to verify:**

```bash
# Read schema file
read_file("db/schema.rb", startLine=1, endLine=500)

# Or check in console/REPL
# [FRAMEWORK: Add command to list model columns]
```

---

### 2. API/Method Assumptions

**Common mistakes:**

```markdown
## API Assumption

ASSUMPTION: "Dialog component has with_close_button method"
├─ Why I believe it: Similar components like Modal have it
├─ Evidence: Guessing based on naming patterns
└─ Verified: NO

VERIFICATION NEEDED:
- Read library/gem source code
- Check component class definition
- Look for method definitions in source
- Check documentation/comments
```

**How to verify:**

```bash
# Find library location
# [FRAMEWORK: Add command to find library path]

# Read component source
read_file("[library-path]/components/dialog.rb", startLine=1, endLine=100)

# Or grep for method
grep -r "with_close_button" [library-path]
```

---

### 3. Framework Convention Assumptions

**Common mistakes:**

```markdown
## Framework Assumption

ASSUMPTION: "Routes resource name can differ from controller file name"
├─ Why I believe it: Seems flexible
├─ Evidence: Haven't checked routing conventions
└─ Verified: NO

VERIFICATION NEEDED:
- Read routes configuration file
- Check framework routing documentation
- Test with actual route definition
```

**How to verify:**

```bash
# Read routes file
read_file("config/routes.rb", startLine=1, endLine=100)

# Or check framework docs
# [FRAMEWORK: Add link to routing docs]
```

---

### 4. State Assumptions

**Common mistakes:**

```markdown
## State Assumption

ASSUMPTION: "User session is always present in authenticated routes"
├─ Why I believe it: Middleware should ensure this
├─ Evidence: Haven't checked authentication flow
└─ Verified: NO

VERIFICATION NEEDED:
- Read authentication middleware/concern
- Check all routes that assume session
- Verify edge cases (expired session, token refresh)
```

---

### 5. Data Format Assumptions

**Common mistakes:**

```markdown
## Data Format Assumption

ASSUMPTION: "API returns dates in ISO 8601 format"
├─ Why I believe it: Common practice
├─ Evidence: No explicit documentation checked
└─ Verified: NO

VERIFICATION NEEDED:
- Check API response serializer
- Read API documentation
- Test with actual API call
```

---

## Verification Workflow

### Step 1: List All Assumptions

Before implementing, list EVERY assumption:

```markdown
## All Assumptions for [Task]

1. Database: [column exists, type is X]
2. API: [method exists, returns Y]
3. Framework: [convention works this way]
4. State: [value available in context]
5. Data: [format is Z]
```

### Step 2: Prioritize by Risk

**High Risk (verify first):**
- Database columns/tables (schema mismatch = runtime errors)
- External API methods (undefined method = crash)
- Authorization logic (security implications)

**Medium Risk (verify next):**
- Framework conventions (may work but be brittle)
- Data formats (may cause subtle bugs)
- State assumptions (edge cases may fail)

**Low Risk (verify if time permits):**
- Code style conventions
- Performance assumptions
- UI/UX expectations

### Step 3: Verify Each Assumption

For each assumption, document:

```markdown
## Verified Assumption

ASSUMPTION: "users table has status column"

VERIFICATION:
- Tool used: read_file("db/schema.rb")
- Lines checked: 45-60
- Result: CONFIRMED - status column exists, type: string, nullable: false

STATUS: ✅ VERIFIED
```

Or if assumption was WRONG:

```markdown
## Corrected Assumption

ASSUMPTION: "users table has status column"

VERIFICATION:
- Tool used: read_file("db/schema.rb")
- Lines checked: 45-60
- Result: WRONG - no status column, but has "state" column instead

CORRECTION: Use "state" column instead of "status"
STATUS: ⚠️ CORRECTED
```

### Step 4: Update Implementation Plan

After verification, update your plan based on VERIFIED facts:

```markdown
## Updated Plan (Post-Verification)

Original assumptions: 5
Verified correct: 3
Corrected: 2

Changes to plan:
1. Use "state" column instead of "status" (corrected assumption #1)
2. Call `user.active?` instead of `user.status == "active"` (corrected assumption #2)
```

---

## Common Mistakes to Avoid

### 1. Assuming Based on Names

❌ "Column is probably called `created_at`"
✅ Check schema: `read_file("db/schema.rb")`

### 2. Assuming Based on Similar Code

❌ "This component probably works like that other one"
✅ Read the actual component: `read_file("[component-path]")`

### 3. Assuming Framework Magic

❌ "The framework probably handles this automatically"
✅ Read framework source or docs: Verify the magic exists

### 4. Assuming Past Knowledge

❌ "I remember this works like X"
✅ Verify current state: Code may have changed

### 5. Assuming Error Messages

❌ "Error says X so the problem must be Y"
✅ Read the actual code that raised the error

---

## Quick Verification Checklist

Before implementing, verify:

- [ ] **Database:** All referenced columns exist with expected types
- [ ] **APIs:** All called methods exist with expected signatures
- [ ] **Framework:** Conventions used match actual framework behavior
- [ ] **State:** All assumed available values are actually present
- [ ] **Data:** All assumed formats match actual data

**Only proceed when ALL high-risk assumptions are verified.**

---

**Remember:** 5 minutes of verification prevents 40 minutes of debugging wrong assumptions.

---

✅ **ASSUMPTION VERIFICATION COMPLETE** - All beliefs verified against source
