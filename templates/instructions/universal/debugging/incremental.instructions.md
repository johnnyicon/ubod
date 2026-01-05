---
applyTo: "**/*"
---

# Incremental Fix Verification

**Purpose:** Test each fix separately to isolate issues

---

✅ **INCREMENTAL VERIFICATION PROTOCOL ACTIVE** - Testing each fix separately

---

## Core Principle

**DO NOT batch multiple fixes and run tests once at the end.**

**Why this fails:**
- Apply fixes 1, 2, 3 all at once
- Run tests → FAIL
- Which fix broke it? Unknown
- Have to undo everything and start over

**Better approach:**
- Apply fix 1 → test → PASS
- Apply fix 2 → test → PASS
- Apply fix 3 → test → FAIL ← Now you know fix 3 is the problem

---

## The Incremental Verification Protocol

### Step 1: Plan Fixes in Order

**Before making ANY changes, list all fixes:**

```markdown
## Fix Plan

### Fix 1: [Description]
- File: [path]
- Change: [what to change]
- Reason: [why this fixes the bug]
- Risk: LOW / MEDIUM / HIGH
- Test: [how to verify this fix]

### Fix 2: [Description]
- File: [path]
- Change: [what to change]
- Reason: [why this fixes the bug]
- Risk: LOW / MEDIUM / HIGH
- Test: [how to verify this fix]

### Fix 3: [Description]
- File: [path]
- Change: [what to change]
- Reason: [why this fixes the bug]
- Risk: LOW / MEDIUM / HIGH
- Test: [how to verify this fix]

---

**Order rationale:** [Why fixing in this order]
Example: Fix 1 is foundational, fix 2 depends on it, fix 3 is UI layer
```

---

### Step 2: Apply Fix Incrementally

**ONE fix at a time:**

```markdown
## Fix #1: [Description]

### Changes
File: app/controllers/priority_docs_controller.rb
Lines: 23-25
Change: layer: ["L0", "L1", "L2"] (was ["data_lake", "pillar", "asset"])

### Verification
Test command: [framework-specific test command]
Result: ✅ PASS (10 runs, 0 failures)

Additional verification: 
- Checked logs: No errors
- Tested in browser: Submission succeeds
- Verified: Documents filtered correctly

Status: ✅ Fix #1 CONFIRMED WORKING

---

**Ready to proceed to Fix #2**
```

---

### Step 3: Test After Each Fix

**MANDATORY: Run tests after EVERY fix**

#### For Unit Tests:

```bash
# Run specific test file
# [FRAMEWORK: Add command for running specific test file]

# Or specific test method
# [FRAMEWORK: Add command for running specific test]
```

#### For Integration Tests:

```bash
# Run controller/integration tests
# [FRAMEWORK: Add command for integration tests]
```

#### For System/E2E Tests:

```bash
# Run browser-based tests
# [FRAMEWORK: Add command for system tests]
```

#### For Runtime Verification:

```javascript
// Use browser automation to verify actual behavior
const result = await page.evaluate(async () => {
  const response = await fetch('/api/endpoint', {
    method: 'POST',
    body: formData
  });
  return { status: response.status, ok: response.ok };
});
```

---

### Step 4: Document Results

**After each fix, update your progress:**

```markdown
## Progress Tracker

### ✅ Fix #1 - Controller layer filter
- Status: COMPLETE
- Tests: PASSING
- Verified: Yes (browser + logs)

### 🔄 Fix #2 - Model method layer filter
- Status: IN PROGRESS
- Tests: [pending]
- Verified: [pending]

### ⏳ Fix #3 - Validation layer values
- Status: NOT STARTED
- Tests: [pending]
- Verified: [pending]

---

**Current state:** 1 of 3 fixes complete
```

---

## When to Batch Fixes

**ONLY batch fixes if ALL of these are true:**

1. **Same file** - All changes in one file
2. **Unrelated logic** - Changes don't interact or depend on each other
3. **Low risk** - Simple changes (typos, formatting, comments)
4. **Can explain independence** - You can articulate why they won't interfere

**Example of safe batching:**

```markdown
## Batch Fix: Update variable names (same file, unrelated)

File: app/models/document.rb
Changes:
1. Line 10: old_name → new_name
2. Line 45: temp_var → descriptive_var
3. Line 80: x → document_count

Why safe to batch:
- All in same file
- Just variable renames (no logic changes)
- Don't interact with each other
- Low risk of breaking anything

Test after batch: [test command]
```

---

## When a Fix Fails

### If Test Fails After Fix

```markdown
## Fix #2 FAILED

### What happened
- Applied change: [description]
- Test command: [command]
- Result: FAIL (1 failure)

### Error message
[Paste exact error]

### Analysis
- The fix introduced a regression because [reason]
- Original assumption was wrong: [what was wrong]

### Rollback
- Reverted fix #2
- Tests now: PASSING again

### Next step
- Re-analyze the problem
- Try different approach: [new approach]
```

---

### If You Can't Isolate the Problem

```markdown
## Cannot Isolate

### Attempted
1. Fix #1 → PASS
2. Fix #2 → PASS
3. Fix #3 → PASS
4. All together → FAIL (!?)

### Analysis
- Individual fixes work, but together they conflict
- Likely interaction between fix #2 and fix #3

### Investigation plan
1. Apply fix #1 + #2 → test
2. If PASS, add fix #3 → test
3. If FAIL, the conflict is #2 + #3

### Finding
- Fix #2 changes [X], fix #3 assumes [Y]
- Resolution: [how to make them compatible]
```

---

## Rollback Strategy

### Before Making ANY Fix

```bash
# Check current state
git status

# Stash any uncommitted changes
git stash

# Or commit current state
git add -A && git commit -m "WIP: before fix attempt"
```

### After Each Successful Fix

```bash
# Commit the working fix
git add [file] && git commit -m "fix: [description]"
```

### If Fix Fails

```bash
# Rollback to last good state
git checkout -- [file]

# Or reset to last commit
git reset --hard HEAD
```

---

## Progress Template

Use this template for tracking incremental fixes:

```markdown
## Incremental Fix Progress

**Bug:** [Description of the bug]
**Total fixes needed:** [N]

| # | Description | File | Status | Tests | Verified |
|---|-------------|------|--------|-------|----------|
| 1 | [Desc] | [path] | ✅ | PASS | Yes |
| 2 | [Desc] | [path] | 🔄 | - | - |
| 3 | [Desc] | [path] | ⏳ | - | - |

**Current status:** [X] of [N] complete
**Next step:** [What to do next]
**Blockers:** [Any issues preventing progress]
```

---

## Common Mistakes to Avoid

### 1. Applying All Fixes at Once

❌ "Let me fix all 5 issues and then run tests"
✅ "Fix 1 → test → Fix 2 → test → ..."

### 2. Skipping Tests Between Fixes

❌ "This is a simple change, no need to test"
✅ "Simple changes can still break things - always test"

### 3. Not Committing Working Fixes

❌ "I'll commit everything at the end"
✅ "Commit each working fix so you can rollback"

### 4. Continuing After a Failure

❌ "This failed but let me try the next fix anyway"
✅ "Stop, analyze why it failed, fix that first"

---

**Remember:** One fix at a time. Test after each. Commit working fixes.

---

✅ **INCREMENTAL VERIFICATION COMPLETE** - All fixes tested individually
