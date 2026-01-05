---
applyTo: "**/*"
---

# Error Log Analysis Protocol

**Purpose:** Systematic approach to reading and analyzing error messages

---

📋 **ERROR ANALYSIS PROTOCOL ACTIVE** - Systematic 4XX/5XX error debugging

---

## Core Principle

**Don't guess what errors mean - READ them systematically.**

**Common failure mode:**
- See "422 Unprocessable Entity" → guess at solutions
- Try random fixes → still fails
- Miss the actual validation message that explains the problem

---

## When You See a 4XX/5XX Error

### Step 1: Capture Full Error Message

**Don't stop at HTTP status code. Get the FULL error:**

#### For API/Controller Errors:

```bash
# Read last 100 lines of log
tail -n 100 log/development.log

# Or search for recent errors
grep -A 10 "Error\|Exception" log/development.log | tail -n 50
```

#### For Browser Errors:

Use browser automation to capture:

```javascript
// Get console errors
const errors = await page.evaluate(() => {
  return window.console.errors || [];
});

// Get network errors
const failedRequests = await page.evaluate(() => {
  return performance.getEntries()
    .filter(e => e.responseStatus >= 400);
});
```

---

### Step 2: Extract Key Information

**Parse the error systematically:**

```markdown
## Error Analysis

**HTTP Status:** [e.g., 422 Unprocessable Entity]

**Error Class:** [e.g., ValidationError, RecordInvalid]

**Error Message:** [exact message]
Example: "Validation failed: Document must be from content layers (L0-L2)"

**Expected Value:** [what code expects]
Example: allowed_layers = ["data_lake", "pillar", "asset"]

**Actual Value:** [what was provided]
Example: document.layer = "L2"

**Mismatch:** [why they don't match]
Example: "L2" not in ["data_lake", "pillar", "asset"]

**Failed At:** [file and line number]
Example: app/models/priority_doc.rb:35
```

---

### Step 3: Read Source Code at Error Line

**MANDATORY: Read the actual code that raised the error**

```ruby
# If error says: "app/models/priority_doc.rb:35"

read_file("app/models/priority_doc.rb", startLine=25, endLine=45)
# Read 10 lines before and after for context
```

**Look for:**
- Validation logic
- Conditional checks
- Expected values (constants, arrays, enums)
- Comments explaining the business rule

---

### Step 4: Trace Backwards

**Find where the problematic value comes from:**

```markdown
## Value Trace

Error at: priority_doc.rb:35
└─ Validates: document.layer must be in ["data_lake", "pillar", "asset"]
   └─ document.layer comes from: documents table
      └─ documents.layer value: "L2" (from database)
         └─ MISMATCH FOUND: DB has "L2", code expects "data_lake"
```

**Use grep to find all references:**

```bash
# Find all places that reference this column/attribute
grep -r "layer.*data_lake\|pillar\|asset" app/
```

---

### Step 5: Check Stack Trace

**Don't ignore the stack trace - it shows the call chain:**

```
1. app/controllers/priority_docs_controller.rb:23 - create action
2. app/models/context.rb:54 - priority_docs_with_inheritance method
3. app/models/priority_doc.rb:35 - validation
   └─ ERROR HERE: layer validation failed
```

**This tells you:**
- Where the request started (controller)
- What business logic ran (model method)
- Where it failed (validation)

**Action:** Check ALL 3 files for the same bug pattern

---

## Error Categories

### 4XX Errors (Client Errors)

#### 400 Bad Request
**Meaning:** Request syntax invalid or malformed
**Check:**
- Request payload format (JSON valid?)
- Required parameters present?
- Content-Type header correct?

#### 401 Unauthorized
**Meaning:** Authentication required or failed
**Check:**
- Auth token present?
- Token expired?
- Token format correct?

#### 403 Forbidden
**Meaning:** Authenticated but not authorized
**Check:**
- User has permission for this resource?
- Resource belongs to correct organization?
- Role-based access control rules?

#### 404 Not Found
**Meaning:** Resource doesn't exist
**Check:**
- ID valid?
- Resource deleted?
- Route exists? (check routes file)

#### 422 Unprocessable Entity
**Meaning:** Validation failed
**Check:**
- What validation failed? (read error message!)
- What value was submitted?
- What value was expected?

---

### 5XX Errors (Server Errors)

#### 500 Internal Server Error
**Meaning:** Unexpected exception in code
**Check:**
- Full stack trace in logs
- What line threw the exception?
- What was the exact error message?

#### 502 Bad Gateway
**Meaning:** Upstream server error
**Check:**
- Database connection?
- External API responding?
- Proxy configuration?

#### 503 Service Unavailable
**Meaning:** Server overloaded or down
**Check:**
- Is server running?
- Memory/CPU usage?
- Connection limits?

---

## Error Analysis Template

Use this template for systematic analysis:

```markdown
## Error Analysis Report

### 1. Error Captured
- **Status:** [HTTP status code]
- **Class:** [Error class name]
- **Message:** [Exact error message]
- **File:** [File and line number]

### 2. Context
- **Request:** [What was user trying to do?]
- **Endpoint:** [Route/URL]
- **Payload:** [What data was submitted?]

### 3. Root Cause Analysis
- **Expected:** [What the code expects]
- **Actual:** [What was provided]
- **Why mismatch:** [Explanation]

### 4. Stack Trace Analysis
1. [First frame] - [Meaning]
2. [Second frame] - [Meaning]
3. [Third frame] - [ERROR HERE]

### 5. Fix Plan
- **File(s) to change:** [List]
- **What to change:** [Description]
- **Test to verify:** [Test command]
```

---

## Common Mistakes to Avoid

### 1. Guessing from Status Code Alone

❌ "422 means validation error, let me fix the form"
✅ "422 means validation - let me READ which validation and WHY"

### 2. Ignoring the Error Message

❌ "Some error happened, let me try a different approach"
✅ "Error says 'column not found: status' - let me check the schema"

### 3. Not Reading Stack Trace

❌ "Error in my controller"
✅ "Error at controller:23 → model:54 → validation:35, let me check all 3"

### 4. Fixing Symptoms Not Causes

❌ "Wrap in try/catch to suppress the error"
✅ "Find why the error happens and fix the root cause"

---

## Quick Reference: Error Debugging Steps

1. **Capture** full error (status, message, stack trace)
2. **Read** exact error message carefully
3. **Locate** file and line number from stack trace
4. **Read** source code at that location
5. **Trace** where the problematic value comes from
6. **Fix** the root cause, not the symptom
7. **Verify** fix with specific test

---

**Remember:** The error message tells you exactly what's wrong. Read it!

---

✅ **ERROR ANALYSIS COMPLETE** - Root cause identified from logs
