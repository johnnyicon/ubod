---
applyTo: "**/*"
---

# Verification Checklist (Universal)

**Purpose:** Universal verification steps for all code changes

**Last Updated:** 2025-12-31

---

## MANDATORY: Verify Before Implementing

**These checks apply to ALL code changes, regardless of app or language.**

### Step 1: Read Source Code

**MUST read the actual code you're changing:**

```
read_file(filePath: "[exact path]", startLine: 1, endLine: 50)
```

**Verify:**
- [ ] Read at minimum 50 lines of context
- [ ] Include method signatures, class definitions, comments
- [ ] Look for usage examples in comments (especially lines 1-30)
- [ ] Understand the current implementation

**❌ NEVER assume based on file names alone**
**✅ ALWAYS read the actual code**

---

### Step 2: Verify External Dependencies

#### If Using External Gems/Libraries:

**MUST read gem/library source code FIRST:**

```
run_in_terminal("bundle show gem-name")  # Ruby
run_in_terminal("npm list package-name")  # JavaScript
read_file("[gem-path]/lib/[component].rb", startLine: 1, endLine: 100)
grep_search("GemClassName", isRegexp: false)
```

**Verify:**
- [ ] API method names (exact spelling)
- [ ] Parameter signatures
- [ ] Usage examples in gem's own comments
- [ ] Return types and values

**❌ NEVER assume gem API based on similar libraries**
**✅ ALWAYS read gem source code first**

---

### Step 3: Verify Database Schema

#### If Referencing Database Columns:

**MUST read schema FIRST:**

```
read_file("db/schema.rb")  # Rails
read_file("prisma/schema.prisma")  # Prisma
```

**Verify:**
- [ ] Column names exist (exact spelling)
- [ ] Column types match usage
- [ ] Associations exist in model file
- [ ] Nullability constraints
- [ ] Indexes and foreign keys

**❌ NEVER reference columns without checking schema**
**✅ ALWAYS confirm columns exist first**

---

### Step 4: Verify Assumptions

**Before declaring discovery complete:**

1. **Read the actual code** (don't just find the file)
   - Open the file and read relevant sections
   - Verify understanding matches the code
   - Check line numbers and context

2. **Verify the problem exists** (if fixing a bug)
   - Confirm the bug is real by reading code
   - Check if issue actually exists
   - Look for existing workarounds or fixes

3. **Check for existing implementations**
   - Search for similar features already implemented
   - Verify not duplicating existing functionality
   - Learn from existing patterns and edge cases

4. **Verify all references**
   - Confirm all IDs, selectors, targets exist in code
   - Check all file paths are correct
   - Verify all method names and signatures match

---

### Step 5: Edge Case Checklist

**Before proceeding, check these common edge cases:**

- [ ] **Authorization:** Does this need permission checks? Who can access/modify?
- [ ] **Performance:** Will this be slow at scale? Need indexes/caching?
- [ ] **Data Integrity:** What happens to related records? Cascade deletes? Orphaned data?
- [ ] **External Systems:** Does this affect APIs, databases, background jobs, webhooks?
- [ ] **Security:** XSS risks? SQL injection? CSRF protection? Input validation?
- [ ] **Error Handling:** What happens on failure? Retry logic? User feedback?

---

### Step 6: Document Assumptions

**Add to your discovery response:**

```markdown
Assumptions Made:
  1. [Assumption 1] - Based on [evidence from code]
  2. [Assumption 2] - Based on [evidence from code]

Needs Verification:
  1. [Thing to verify in browser/testing]
  2. [Thing to verify before implementation]

Edge Cases Considered:
  - Authorization: [specific checks needed]
  - Performance: [specific concerns]
  - Data Integrity: [specific cascade/cleanup needs]
  - External Systems: [specific integrations affected]
```

---

## Completion Criteria

**Before declaring "Complete":**

- [ ] Tests pass
- [ ] **Actual behavior works** (browser/CLI/manual verification)
- [ ] No errors in console/logs
- [ ] User can complete workflow end-to-end
- [ ] All requirements met (not just partial)

**DON'T stop at "tests pass" - that's just ONE requirement!**

---

## Why This Matters

**Common failures prevented by verification:**

- ❌ Using wrong gem API method names
- ❌ Referencing non-existent database columns
- ❌ Breaking existing functionality
- ❌ Missing edge cases
- ❌ Security vulnerabilities

**With proper verification:**

- ✅ Correct API usage
- ✅ Valid database references
- ✅ Preserved existing functionality
- ✅ Handled edge cases
- ✅ Secure implementation
