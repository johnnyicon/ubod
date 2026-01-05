---
applyTo: "**/*"
---

# Runtime Verification for UI Issues

**Purpose:** Verify actual behavior in browser, not just code/tests

---

🌐 **RUNTIME VERIFICATION PROTOCOL ACTIVE** - Testing actual behavior in browser/CLI

---

## Core Principle

**Static verification (code/tests) is NOT enough for UI issues.**

**Real Example:**
- Changed CSS classes
- System tests passed (verified CSS classes applied)
- Declared fix complete
- **But actual behavior unchanged** - feature still broken

**Root Cause:** Tests verified implementation details (CSS classes), not actual behavior (event handlers attached)

---

## Runtime Verification Checklist

**For ANY UI interaction issue, verify:**

### 1. Actual Behavior in Browser

```markdown
Before declaring fix complete:

1. Test in real browser (Playwright or manual)
2. Verify the actual user interaction works
3. Check browser console for errors
4. Inspect DOM structure
```

### 2. JavaScript Framework Controller Connection

```javascript
// For JavaScript framework controller issues, verify controller is connected:
// [FRAMEWORK: Adapt selectors for your JS framework - Stimulus, React, Vue, etc.]

const controller = document.querySelector('[data-controller="your-controller"]');
const target = document.querySelector('[data-controller-target="target"]');

// These should ALL be true:
console.log('Controller exists:', !!controller);
console.log('Target exists:', !!target);
console.log('Target inside controller:', controller?.contains(target));
```

### 3. Event Handlers Attached

```javascript
// Verify event handlers are actually attached:
// [FRAMEWORK: Adapt for your event binding pattern]

const element = document.querySelector('[data-action="click->controller#method"]');
console.log('Has click listener:', getEventListeners(element).click?.length > 0);
```

### 4. Framework Architecture Understanding

```markdown
For framework interaction issues, verify:

- Modal/dialog components may use portals (move content to document.body)
- Portals break parent-child DOM relationships
- JavaScript framework controllers must contain their targets
- Frontend routers may intercept form submissions
- CSS frameworks may not generate classes from all source files
```

---

## Red Flags: Insufficient Verification

❌ "Tests pass, so it's fixed"
❌ "I verified the CSS classes are applied"
❌ "The HTML structure looks correct"
❌ "System tests verify the behavior"

Replace with:

✅ "I've verified actual behavior in browser"
✅ "I've checked controller connection at runtime"
✅ "I've verified event handlers are attached"
✅ "I've tested the full user workflow"

---

## Runtime Verification Report Template

```markdown
## Runtime Verification Results

**Fix Applied:** [What was changed]

**Static Verification (Code/Tests):**
- [ ] Code changes applied
- [ ] Tests pass
- [ ] No syntax errors

**Runtime Verification (Browser):**
- [ ] Tested in browser (Playwright/manual)
- [ ] Actual behavior works as expected
- [ ] No console errors
- [ ] Event handlers attached (for JS framework)
- [ ] Controller connected (for JS framework)
- [ ] Full user workflow tested

**Status:**
- Static verification: COMPLETE / INCOMPLETE
- Runtime verification: COMPLETE / INCOMPLETE
- **Overall:** COMPLETE / INCOMPLETE

**Only mark COMPLETE when BOTH static and runtime verification pass.**
```

---

## When Runtime Verification is Required

**Always required for:**
- UI interaction issues (click, drag/drop, form submission)
- JavaScript framework controller issues
- Modal/dialog issues
- Event handler issues
- Framework interaction bugs

**Not required for:**
- Pure backend logic (services, jobs)
- Database migrations
- Model validations (unless UI-related)
- API endpoints (unless UI calls them)

---

## Verify Assumptions Before Proposing Solutions

**Before proposing a fix, verify your core assumption:**

**For JS framework issues:** Is the controller in active DOM?
```javascript
document.querySelector('[data-controller~="..."]')
```

**For portal/modal issues:** Are you using querySelector across portal boundaries?

**For template/component issues:** Is the controller inside a `<template>` element?
(Controllers don't connect until template content is cloned to DOM)

**If you can't verify:** Request browser debugging or escalate.

**Pattern recognition without verification = wrong diagnosis.**

---

## Browser Debugging Techniques

### 1. Console Inspection

```javascript
// Check for errors
console.error
console.warn

// Check for component state
// [FRAMEWORK: Add framework-specific debugging commands]
```

### 2. DOM Inspection

```javascript
// Find all controllers/components on page
document.querySelectorAll('[data-controller]')

// Check element properties
getComputedStyle(element)
element.getBoundingClientRect()
```

### 3. Event Debugging

```javascript
// Check event listeners (Chrome DevTools)
getEventListeners(element)

// Monitor events
monitorEvents(element, 'click')
```

### 4. Network Tab

- Check for failed requests (4XX/5XX)
- Verify request payload
- Check response data

---

## Common Runtime Issues

### 1. Controller Not Connected

**Symptom:** Click handlers don't fire
**Check:** Is controller element in active DOM?
**Common cause:** Element inside `<template>` or rendered outside controller scope

### 2. Target Not Found

**Symptom:** Controller connected but can't find target
**Check:** Is target inside controller's DOM subtree?
**Common cause:** Portals move content to document.body

### 3. Event Not Bound

**Symptom:** Element exists but doesn't respond
**Check:** Is action attribute correct? Is method defined?
**Common cause:** Typo in action string, method not public

### 4. Timing Issue

**Symptom:** Works sometimes, fails other times
**Check:** Is content loaded before controller connects?
**Common cause:** Dynamic content loaded after page ready

---

**Remember:** Tests pass ≠ Feature works. Always verify actual behavior in browser for UI issues.

---

✅ **RUNTIME VERIFICATION COMPLETE** - Actual behavior verified in browser/CLI
