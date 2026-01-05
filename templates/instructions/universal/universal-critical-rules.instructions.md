---
applyTo: "**/*"
---

# CRITICAL RULES - READ EVERY TIME

**Last Updated:** 2025-12-31  
**Purpose:** Essential rules that MUST be followed before any code changes  
**Length:** Intentionally kept under 50 lines for maximum visibility

---

⚠️ **CRITICAL RULES ACTIVE** - 4 non-negotiable protocols enforced

---

## 🚨 BEFORE WRITING ANY CODE

### Rule 1: INSPECT FIRST (BLOCKING - NO EXCEPTIONS)

**You MUST show evidence of inspection before proposing code:**

#### For CSS/DOM Changes:
```
"Inspecting DOM structure..."
[Show: Actual element HTML, classes, data-attributes, parent structure]
[Selector to use: ...]
```
**❌ NEVER write CSS selectors without showing actual DOM**

#### For API/Library Usage:
```
"Reading library source code..."
read_file("[library-path]/lib/component.rb", lines 1-50)
[Show: Actual API methods, slot declarations, usage examples]
[API to use: ...]
```
**❌ NEVER assume API based on similar libraries**

#### For Database Queries:
```
"Checking database schema..."
[Show: Actual table columns, types, constraints]
[Columns to use: ...]
```
**❌ NEVER reference columns without showing schema**

---

### Rule 2: CLARIFY BEFORE ASSUME

**If user request is ambiguous, ASK before implementing:**

- "doesn't work" → Ask: "What specifically? Not clickable? Wrong position? Wrong behavior?"
- "broken" → Ask: "How is it broken? Error message? Wrong output?"
- "fix X" → Ask: "What's wrong with X? When did it start?"

**Template:**
```
I want to clarify before implementing:
- You want: [restate requirement]
- Expected behavior: [describe]
- Current behavior: [describe]

Is this correct?
```

---

### Rule 3: TRY SIMPLE FIRST

**Always try solutions in this order:**

1. **CSS** (30 sec) - Can I hide/show/position with CSS?
2. **HTML/Config** (2 min) - Can I change template or config?
3. **Code** (15+ min) - Do I need to write/modify code?

**Rule: Try Level N before Level N+1**

**Show in response:**
```
Approach: [Level N - CSS/HTML/Code]
Why simplest: [Justification]
Fallback: [If this fails, will try Level N+1 because...]
```

---

## 🛑 IF STUCK (3+ Failed Attempts)

**STOP and do this:**

1. **Acknowledge:** "I'm stuck (tried X approaches without success)"
2. **Reset to inspection:** Read actual source/DOM/schema (not assumptions)
3. **Show findings:** "Found: [actual code/structure]"
4. **Ask for help:** "Does this approach make sense?"

**Don't keep guessing. Reset and inspect.**

---

## 📋 TWO-PHASE RESPONSE (MANDATORY)

### Phase 1: DISCOVERY EVIDENCE (Show First)

```
## Discovery Evidence

### Inspection Results:
[Show actual DOM/source/schema you read]

### Approach:
- Complexity: [CSS/HTML/Code]
- Why simplest: [Justification]
- Time estimate: [X minutes]

### Confidence:
- High: [What you're certain about]
- Needs verification: [What to test]

Ready to proceed?
```

### Phase 2: IMPLEMENTATION (Only After Approval)

**Wait for user to say "proceed" or "looks good"**

**THEN write code.**

---

## ✅ VALIDATION CHECKLIST

Before claiming "discovery complete":

- [ ] Showed actual inspection evidence (not assumptions)
- [ ] Clarified ambiguous requirements
- [ ] Chose simplest approach (justified if not CSS)
- [ ] User approved Phase 1

**If ANY unchecked → Return to discovery**

---

**Remember:** 2 minutes of inspection saves 40 minutes of debugging.

---

✅ **CRITICAL RULES VERIFIED** - All mandatory checks completed before implementation
