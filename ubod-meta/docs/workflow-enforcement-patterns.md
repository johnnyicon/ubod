# Workflow Enforcement Patterns

**Purpose:** Guidance on when and how to add gates, boundaries, and mandatory verifications to multi-agent workflows

**Last Updated:** 2026-01-06  
**Version:** 1.0

---

## When to Harden Your Workflow

**You should add enforcement patterns when:**

1. **Post-Incident:** Bugs traced to bypassing intended workflow (e.g., going straight to general AI instead of specialized agents)
2. **High Complexity Domain:** Multiple interacting systems (backend + frontend + real-time + async)
3. **Framework Magic:** Technology with implicit behavior (Hotwire, React hooks, ORM N+1 queries)
4. **Cross-Team Development:** Multiple developers with varying framework expertise
5. **Historical Pattern:** Same class of bugs recurring despite fixes

**You can skip enforcement if:**
- Simple CRUD with established patterns
- Solo developer who understands the full stack
- Prototyping phase (speed > correctness)
- Low-risk changes (docs, comments, config)

---

## Pattern 1: Critical Gates (Prevent Premature Implementation)

### What It Is
A gate STOPS an agent from proceeding until prerequisites are met.

### When to Use
- Implementer should not code without approved plan
- Deployment agent should not deploy without passing tests
- Database migration agent should not apply migrations without backup

### Example Implementation

**In Implementer Agent:**
```markdown
## CRITICAL GATE

🚨 **STOP: Do you have an approved plan from Discovery Planner?**

**Required before coding:**
- [ ] Discovery Planner has produced a plan
- [ ] Plan includes call flows, edge cases, and patterns to follow
- [ ] User has explicitly approved the plan ("proceed", "looks good", "implement it")

**If NO approved plan:**
1. Request plan from Discovery Planner
2. Wait for user approval
3. THEN implement

**If YES approved plan:**
Proceed with small diffs, frequent test runs, and incremental verification.
```

### Benefits
- Prevents "shoot from the hip" coding
- Ensures discovery phase is not skipped
- Creates audit trail of decisions

---

## Pattern 2: Mandatory Triggers (Prevent Skipped Verification)

### What It Is
A trigger makes an agent invocation REQUIRED for certain change types.

### When to Use
- UI changes should always trigger Verifier (runtime checks)
- Schema changes should always trigger Database Reviewer
- API changes should always trigger Integration Tester

### Example Implementation

**In Verifier Agent:**
```markdown
## MANDATORY TRIGGER

⚠️ **This agent MUST be invoked for:**
- Any UI/View/Controller changes
- Any Stimulus/React/Vue component changes
- Any real-time update (WebSocket, Turbo Stream, SSE)
- Any modal/dialog/portal implementation

**Why mandatory:**
"Tests pass" does NOT mean "feature works" for UI interactions.
Runtime verification catches:
- Event handlers not attached
- Controllers not connected
- Portals breaking parent-child relationships
- Race conditions in async updates

**If this agent is NOT invoked:**
Risk of shipping bugs that tests don't catch.
```

### Benefits
- Makes verification explicit requirement
- Prevents "tests pass, ship it" syndrome
- Documents WHY verification is mandatory

---

## Pattern 3: Handoff Contracts (Clear Deliverables)

### What It Is
Explicit definition of what one agent produces for the next agent.

### When to Use
- Complex multi-agent workflows
- When downstream agents struggle with unclear context
- When handoffs frequently require rework

### Example Implementation

**In Discovery Planner Agent:**
```markdown
## EXPECTED DELIVERABLES

**What I produce for Implementer:**
1. **Call Flow Diagram** (text-based)
   - Entry point → Service → Model → Job → Response
   - Data transformations at each layer

2. **Edge Cases List**
   - Authorization checks needed
   - Error scenarios and handling
   - Race conditions or concurrency issues

3. **Pattern References**
   - Similar implementations in codebase (file:line)
   - Existing patterns to follow
   - Anti-patterns to avoid

4. **Test Strategy**
   - Unit tests needed (models, services)
   - Integration tests needed (controller actions)
   - System tests needed (browser automation)

**Implementer should NOT start without all 4 deliverables.**
```

### Benefits
- Removes ambiguity about readiness
- Prevents back-and-forth clarification loops
- Creates consistent workflow quality

---

## Pattern 4: QA Checklists (Prevent Classes of Bugs)

### What It Is
Framework-specific mandatory checks before declaring work complete.

### When to Use
- Framework has common gotchas (Hotwire portals, React deps, SQL N+1)
- Team has recurring bug patterns
- Post-incident hardening

### Example Structure (Framework-Agnostic)

```markdown
## MANDATORY QA CHECKLIST

**Before declaring UI work complete, verify:**

### Scope & Lifecycle
- [ ] {{FRAMEWORK_LIFECYCLE_CHECK}}
  Example: "Stimulus controller is in active DOM, not inside <template>"
  Example: "React useEffect has correct dependency array"
  Example: "Vue component lifecycle hooks are called in expected order"

### Event Handling
- [ ] {{EVENT_HANDLER_CHECK}}
  Example: "Event listeners attached (check browser DevTools)"
  Example: "Turbo form submission intercepted correctly"
  Example: "Click handlers fire on first click (not just second)"

### Async Behavior
- [ ] {{ASYNC_BEHAVIOR_CHECK}}
  Example: "Race conditions handled (debounce, cancellation)"
  Example: "Loading states shown during async operations"
  Example: "Error states handled gracefully"

### Cross-Boundary Interactions
- [ ] {{BOUNDARY_CHECK}}
  Example: "Portal content can still access parent controller"
  Example: "Modal close button calls correct handler"
  Example: "Nested components communicate correctly"

**Each framework fills in specific checks based on its gotchas.**
```

### Benefits
- Prevents entire classes of bugs
- Documents framework-specific knowledge
- Makes implicit checks explicit

---

## Pattern 5: Runtime Verification Requirements

### What It Is
Explicit requirement to verify actual behavior, not just test assertions.

### When to Use
- ANY UI interaction change
- External API integrations
- Background job workflows
- Real-time update features

### Example Implementation

**In Verifier Agent:**
```markdown
## RUNTIME VERIFICATION CHECKLIST

**For UI Changes:**
1. **Browser Manual Test**
   - Open feature in browser
   - Perform actual user interaction
   - Verify visual feedback
   - Check browser console (no errors)

2. **Framework-Specific Checks**
   - {{CONTROLLER_CONNECTION_CHECK}}
   - {{TARGET_ACCESSIBILITY_CHECK}}
   - {{EVENT_HANDLER_ATTACHED_CHECK}}

3. **Full User Workflow**
   - Start from entry point (not deep-linked)
   - Complete entire workflow
   - Verify all state transitions

**For Background Jobs:**
1. **Job Execution**
   - Trigger job via actual event (not just unit test)
   - Monitor job queue
   - Verify job completes successfully

2. **Side Effects**
   - Check database state
   - Verify external API calls
   - Confirm notifications sent

**Do NOT mark complete until runtime verification passes.**
```

### Benefits
- Catches bugs that tests miss
- Validates integration points
- Ensures user-facing quality

---

## Post-Incident Hardening Workflow

**When a bug makes it to production:**

1. **Root Cause Analysis**
   - Which agent should have caught this?
   - Was the agent bypassed?
   - Was the check missing from the agent?

2. **Identify Pattern**
   - Is this a one-off or recurring issue?
   - Are there similar potential bugs?
   - What class of bugs does this represent?

3. **Add Enforcement**
   - **If bypassed:** Add gate or mandatory trigger
   - **If check missing:** Add QA checklist item
   - **If handoff unclear:** Define deliverable contract

4. **Update Agents**
   - Add enforcement to relevant agents
   - Document WHY enforcement was added
   - Test that enforcement catches the bug class

5. **Verify Effectiveness**
   - Does new gate/check catch the original bug?
   - Does it prevent similar bugs?
   - Does it create false positives?

---

## Anti-Patterns (What NOT to Do)

❌ **Adding gates everywhere "just in case"**
- Makes workflow bureaucratic
- Slows down simple changes
- Creates workaround pressure

✅ **Add gates based on actual incidents or clear risk**

---

❌ **Copying framework-specific checklists to universal templates**
- Creates confusion for other tech stacks
- Doesn't generalize well
- Maintenance burden

✅ **Use placeholder structure, let apps fill in specifics**

---

❌ **Making verification optional with "should" language**
- Gets skipped under time pressure
- No real enforcement

✅ **Use "MUST" language for critical checks, "SHOULD" only for nice-to-haves**

---

❌ **Creating checklists without explaining WHY**
- Feels like box-checking
- Easy to rationalize skipping

✅ **Document the bug class each check prevents**

---

## Summary: When to Use Each Pattern

| Pattern | Use When | Example Trigger |
|---------|----------|-----------------|
| **Critical Gate** | Premature action causes bugs | "Implementer coded without plan" |
| **Mandatory Trigger** | Agent frequently skipped | "Shipped UI bug that Verifier would catch" |
| **Handoff Contract** | Unclear what's ready | "Implementer asks Planner for missing info" |
| **QA Checklist** | Recurring bug class | "3rd portal bug this month" |
| **Runtime Verification** | Tests pass but feature broken | "System tests green but user can't click button" |

---

## Next Steps

After reading this guide:

1. **Audit Recent Incidents:** Review last 5 bugs—which patterns would have caught them?
2. **Identify High-Risk Areas:** Where is framework magic most complex?
3. **Prioritize Hardening:** Start with highest-impact, lowest-effort additions
4. **Test Enforcement:** Verify gates/checks actually prevent bugs
5. **Iterate:** Remove false positives, add missing checks

**Remember:** Enforcement should be proportional to risk. Don't over-engineer for simple domains.
