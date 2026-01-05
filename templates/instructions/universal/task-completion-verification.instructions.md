---
applyTo: "**/*"
---

# Task Completion Verification

**Purpose:** Prevent false completion reports by verifying all requirements are met

---

## Core Rule: Never Conflate "Tests Pass" with "Task Complete"

**The Problem:**
Running existing tests and seeing them pass does NOT mean your task is complete.

**Real Example:**
```
Task: "Write 5 test suites (controller, job, integration, system, model)"
Copilot wrote: 2 test suites
Copilot reported: "All tests pass (153 runs), task complete"
Reality: 60% of work missing
```

---

## Before Declaring ANY Task Complete

### Step 1: List All Original Requirements

Extract every requirement from the PRD or task description:

```
TASK: Write comprehensive test suites for document upload

REQUIREMENTS:
1. Controller tests - uploads endpoint validation
2. Job tests - BackgroundJob behavior
3. Integration tests - end-to-end flow
4. System tests - UI interaction
5. Model tests - validations, associations
```

### Step 2: Verify Each Requirement

```
VERIFICATION:
1. Controller tests - ✅ DONE (10 cases)
2. Job tests - ✅ DONE (3 cases)
3. Integration tests - ❌ MISSING
4. System tests - ❌ MISSING
5. Model tests - ❌ MISSING

COMPLETION: 40% (2 of 5 requirements)
STATUS: NOT COMPLETE
```

### Step 3: Run Final Tests

```bash
[test command]  # e.g., rails test, npm test, etc.
```

Verify:
- ✅ All tests pass (0 failures, 0 errors)
- ✅ No tests skipped
- ✅ Actual numbers match expectations

### Step 4: Report Actual Status

```
COMPLETION REPORT:

DELIVERABLES:
- ✅ Controller tests (10 cases, DONE)
- ✅ Job tests (3 cases, DONE)
- ❌ Integration tests (MISSING)
- ❌ System tests (MISSING)
- ❌ Model tests (MISSING)

TEST RESULTS:
- Runs: 153
- Assertions: 421
- Failures: 0

COMPLETION: 40% (2 of 5 test suites)

NEXT STEPS:
- Write integration tests
- Write system tests
- Write model tests
```

---

## Red Flags to Watch For

❌ "All tests pass, task complete"
❌ "I wrote tests for the main feature, that's enough"
❌ "Existing tests cover the rest"
❌ "I ran out of time/tokens, declaring it done"

Replace with:

✅ "I verified all 5 requirements are complete"
✅ "I checked each deliverable against the PRD"
✅ "I ran the full test suite and verified results"
✅ "I reported actual completion percentage"

---

## Additional Rules

### Rule 2: Never Delete Code to Avoid Debugging

When code doesn't work, debug the root cause - don't delete it.

**WRONG:** Delete the attachment code because it's not persisting
**RIGHT:** Debug why attachment isn't persisting, fix the actual issue

### Rule 3: Never Use Token Budget as Excuse

**WRONG:** "I'm out of tokens, task complete"
**RIGHT:** "I've completed 2 of 5 test suites. I'm running low on tokens. Continue with: integration tests, system tests, model tests"

---

## Completion Verification Template

Use this for ANY task before declaring it done:

```markdown
TASK: [Task Name]

ORIGINAL REQUIREMENTS:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]

VERIFICATION:
- [ ] Requirement 1 - COMPLETE / INCOMPLETE
- [ ] Requirement 2 - COMPLETE / INCOMPLETE
- [ ] Requirement 3 - COMPLETE / INCOMPLETE

TEST RESULTS:
- Runs: X
- Assertions: X
- Failures: 0
- Errors: 0

COMPLETION STATUS:
- X of 3 requirements complete (X%)
- All tests passing: YES / NO
- Ready for next phase: YES / NO

NEXT STEPS:
- [List what's still needed]
```

**DO NOT declare a task complete until ALL requirements are verified.**
