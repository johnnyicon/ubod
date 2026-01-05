---
applyTo: "**/*"
---

# Pattern Matching Protocol

**Purpose:** Find and fix ALL instances of the same bug

---

🔍 **PATTERN MATCHING PROTOCOL ACTIVE** - Searching for duplicate bugs across codebase

---

## Core Principle

**When you fix a bug in ONE file, the same bug often exists in MULTIPLE files.**

**Real example:**
- Fixed layer value mismatch in controller: `["data_lake", "pillar", "asset"]` → `["L0", "L1", "L2"]`
- Same bug existed in: model method, model validation, search filter
- **Total files affected:** 4 different files with same copy-paste bug

---

## MANDATORY Pattern Check After Every Fix

### Step 1: Identify the Pattern

**After fixing any bug, extract the pattern:**

```markdown
## Pattern Identified

**What was wrong:** [Specific code pattern]
Example: Using internal names ["data_lake", "pillar", "asset"] 
         instead of DB values ["L0", "L1", "L2"]

**Where you fixed it:** [File + line]
Example: app/controllers/priority_docs_controller.rb:23

**Why it was wrong:** [Explanation]
Example: Database stores "L0", "L1", "L2" but code was filtering 
         for internal names that don't exist in DB
```

---

### Step 2: Search for All Occurrences

**MANDATORY: grep for the pattern across relevant directories**

#### For String/Value Patterns:

```bash
# Exact string match
grep -r "data_lake.*pillar.*asset" app/ test/

# Regex pattern
grep -r "layer.*\[.*data_lake\|pillar\|asset" app/

# Case-insensitive
grep -ri "obsolete_method" app/
```

#### For Method/API Patterns:

```bash
# Find all calls to a method
grep -r "\.priority_docs_with_inheritance" app/

# Find all places validating same attribute
grep -r "validates.*:layer" app/models/

# Find all references to a constant
grep -r "LAYER_VALUES" app/
```

#### For Database Patterns:

```bash
# Find all queries filtering by same column
grep -r "where.*layer:" app/

# Find all joins on same table
grep -r "joins.*:documents" app/
```

---

### Step 3: Analyze Each Occurrence

**For EACH file found, determine:**

```markdown
## Occurrence Analysis

File: [path]
Line: [number]
Code: [relevant snippet]

Questions:
1. Does it have the SAME bug? YES / NO / MAYBE
2. Why is this occurrence different (if NO)?
3. What needs to change (if YES)?
4. Risk of breaking if changed? LOW / MEDIUM / HIGH
```

**Example analysis:**

```markdown
## Occurrence 1
File: app/models/context.rb:54
Line: layer: ["data_lake", "pillar", "asset"]
Same bug: YES - using internal names instead of DB values
Change: Replace with ["L0", "L1", "L2"]
Risk: LOW - same fix as controller

## Occurrence 2
File: app/models/priority_doc.rb:35
Line: allowed_layers = %w[data_lake pillar asset]
Same bug: YES - validation expects internal names
Change: Replace with %w[L0 L1 L2]
Risk: LOW - same fix pattern

## Occurrence 3
File: test/fixtures/documents.yml
Line: layer: "data_lake"
Same bug: NO - this is test fixture, already using correct format
Change: None needed
Risk: N/A
```

---

### Step 4: Fix ALL Instances

**DO NOT fix just one and declare complete.**

**Use batch replacement for efficiency:**

```markdown
## Batch Fix Strategy

Files to fix:
1. app/controllers/priority_docs_controller.rb:23
2. app/models/context.rb:54
3. app/models/priority_doc.rb:35

All have same pattern: ["data_lake", "pillar", "asset"] → ["L0", "L1", "L2"]

Fix in single batch? YES (same exact change)
```

---

### Step 5: Verify Each Fix

**After fixing all instances, verify each one:**

```bash
# Search to confirm pattern is gone
grep -r "data_lake.*pillar.*asset" app/
# Should return: (no results)

# Search for new pattern
grep -r 'layer.*\["L0", "L1", "L2"\]' app/
# Should return: All 3 fixed files
```

---

## Pattern Categories to Watch For

### 1. Copy-Paste Bugs

**Symptom:** Same incorrect code in multiple files
**How to find:** grep for exact string/pattern
**Example:** Same validation logic copy-pasted to 3 models

---

### 2. API Migration Incomplete

**Symptom:** Some files updated to new API, others using old API
**How to find:** grep for old API method names
**Example:** Half the code uses `old_method`, half uses `new_method`

---

### 3. Configuration Drift

**Symptom:** Same config value hardcoded in multiple places with different values
**How to find:** grep for config keys or magic numbers
**Example:** Timeout set to 30s in one file, 60s in another

---

### 4. Constant/Enum Mismatch

**Symptom:** Different files use different values for same concept
**How to find:** grep for the concept name (e.g., "status", "layer")
**Example:** Controller uses ["active", "inactive"], model uses ["A", "I"]

---

### 5. Deprecated Usage

**Symptom:** Old deprecated method still used in some files
**How to find:** grep for deprecated method name
**Example:** Using `old_auth_check` instead of `new_auth_check`

---

## Pattern Fix Template

```markdown
## Pattern Fix Report

### Pattern Identified
**Description:** [What the bug pattern is]
**Original fix location:** [File + line]

### Search Results
Command: `grep -r "[pattern]" app/`
Found in: [N] files

### Occurrence Analysis
| File | Line | Has Bug? | Change Needed | Risk |
|------|------|----------|---------------|------|
| [path] | [N] | YES/NO | [change] | LOW/MED/HIGH |
| [path] | [N] | YES/NO | [change] | LOW/MED/HIGH |
| [path] | [N] | YES/NO | [change] | LOW/MED/HIGH |

### Fixes Applied
- [x] File 1 - changed [X] to [Y]
- [x] File 2 - changed [X] to [Y]
- [x] File 3 - changed [X] to [Y]

### Verification
Command: `grep -r "[old pattern]" app/`
Result: No matches (pattern eliminated)

Command: `grep -r "[new pattern]" app/`
Result: [N] files (all expected locations)

### Tests
Test command: [command]
Result: ✅ PASS
```

---

## Common Mistakes to Avoid

### 1. Fixing Only the Reported Location

❌ "Fixed the bug in the controller, done!"
✅ "Fixed controller, now searching for same bug elsewhere..."

### 2. Incomplete grep Patterns

❌ `grep "data_lake"` (might miss partial matches)
✅ `grep -r "data_lake\|pillar\|asset"` (catches all related terms)

### 3. Not Analyzing Each Occurrence

❌ "Found in 5 files, replacing all"
✅ "Found in 5 files, analyzing each to confirm they have the same bug"

### 4. Missing Test Files

❌ "Searched app/ directory only"
✅ "Searched app/ AND test/ directories"

---

## Quick Reference: Pattern Search

```bash
# After fixing any bug, run these:

# 1. Search for the exact wrong pattern
grep -r "[wrong pattern]" app/ test/

# 2. Search for related terms
grep -ri "[concept name]" app/

# 3. Search for the correct pattern (to verify fix spread)
grep -r "[correct pattern]" app/

# 4. List all files that might be affected
find app/ -name "*.rb" | xargs grep -l "[concept]"
```

---

**Remember:** One fix is not enough. Search for the pattern everywhere.

---

✅ **PATTERN MATCHING COMPLETE** - All instances of bug pattern fixed
