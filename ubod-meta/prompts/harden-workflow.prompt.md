---
name: harden-workflow
description: Analyzes recent bugs/incidents to suggest workflow hardening (gates, checks, boundaries). Use after post-mortems or when agents are bypassed.
intent: help
---

# Harden Workflow (Post-Incident Analysis)

**Purpose:** Guide you through hardening your agent workflow based on actual incidents or observed bypass patterns.

**When to use this prompt:**
- After a production bug that escaped your workflow
- When you notice agents being bypassed frequently
- During periodic workflow reviews
- When onboarding new team members (identify weak points)

---

## Step 1: Incident Inventory

Let's gather the context. Please provide:

**Recent Bugs (last 1-3 incidents):**
```
For each bug:
1. What broke? [Brief description]
2. Root cause? [Technical reason]
3. Which agent(s) could have caught it? [Agent name(s)]
4. Was that agent invoked? [Yes / No / Partially]
5. If invoked, what was missed? [Gap in agent's checks]
```

**Example:**
```
Bug: Chat rename didn't update UI in real-time
Root cause: Turbo Stream target didn't exist in DOM
Could have caught: Tala Verifier (runtime checks)
Was invoked: No - bypassed by using general AI
Missed: Portal rendering broke parent-child relationship
```

---

## Step 2: Pattern Classification

I'll analyze your incidents and classify them:

**Bypass Patterns:**
- Agent skipped entirely (used general AI instead)
- Verification agent not invoked after implementation
- Discovery phase rushed or omitted

**Gap Patterns:**
- Agent invoked but missing framework-specific checks
- Agent verified wrong thing (tests vs runtime behavior)
- Agent didn't verify edge cases

**Handoff Patterns:**
- Unclear deliverables between agents
- Missing context in handoff
- Implementer started without complete plan

---

## Step 3: Hardening Recommendations

Based on the classification, I'll suggest specific hardening:

### For Bypass Patterns → Add Gates/Triggers

**Example:**
```markdown
## Suggested Addition to [Agent Name]

🚨 CRITICAL GATE: [Why this gate is needed]

**Required before proceeding:**
- [ ] [Specific prerequisite]
- [ ] [Another prerequisite]
- [ ] [User approval signal]

**If prerequisites not met:** [Specific action to take]
```

### For Gap Patterns → Add QA Checklists

**Example:**
```markdown
## Suggested Addition to [Agent Name]

## MANDATORY QA CHECKLIST (Added YYYY-MM-DD)

**Context:** [Brief explanation of bug class this prevents]

**Before marking complete, verify:**
- [ ] [Specific check related to bug class]
- [ ] [Another specific check]
- [ ] [Runtime verification step]

**How to verify:** [Concrete steps, commands, or inspection methods]
```

### For Handoff Patterns → Define Contracts

**Example:**
```markdown
## Suggested Addition to [Agent Name]

## EXPECTED DELIVERABLES

**What I produce for [Downstream Agent]:**
1. **[Deliverable Category]**
   - [Specific item]
   - [Another item]

2. **[Another Category]**
   - [Specific item]

**[Downstream Agent] should NOT proceed without all items.**
```

---

## Step 4: Prioritization

I'll help you prioritize which hardening to apply first:

**Priority 1 (High Impact, Low Effort):**
- Additions that prevent recurring bug classes
- Gates that take <2 minutes to satisfy
- Checklists with existing tools

**Priority 2 (High Impact, Medium Effort):**
- New verification steps requiring manual inspection
- Contracts requiring process changes
- Framework-specific deep checks

**Priority 3 (Medium Impact, Low Effort):**
- Nice-to-have preventions
- Documentation improvements
- Edge case coverage

**Priority 4 (Everything Else):**
- Theoretical risks without historical precedent
- High-effort checks for rare scenarios

---

## Step 5: Implementation

For each priority level, I'll provide:

1. **Exact text to add** (copy-paste ready)
2. **Where to add it** (specific agent file, section)
3. **How to verify** (test that it catches the bug)
4. **Migration notes** (if updating deployed templates)

---

## Step 6: Verification

After applying hardening:

**Test Cases:**
- [ ] Simulate the original bug scenario—does the gate stop it?
- [ ] Try to bypass the workflow—does the trigger catch it?
- [ ] Verify false positive rate—is it usable under time pressure?

**Team Adoption:**
- [ ] Document WHY each gate/check was added (prevents box-checking)
- [ ] Train team on new workflow requirements
- [ ] Monitor for workaround attempts (signals over-engineering)

---

## Example Session

**User provides:**
```
Bug 1: Shipped UI feature that tests passed but didn't work in browser
Bug 2: Implemented without considering multi-tenancy (data leak)
Bug 3: Added modal but forgot to handle Turbo lifecycle
```

**I respond with:**
```
## Analysis

**Pattern Classification:**
- Bug 1: Gap Pattern (Verifier checked tests, not runtime)
- Bug 2: Bypass Pattern (Discovery Planner skipped)
- Bug 3: Gap Pattern (UI Designer missing framework checklist)

**Hardening Recommendations:**

### 1. Add Runtime Verification Requirement (Priority 1)
Agent: Verifier
Location: After "WORKFLOW" section
Text: [Specific runtime verification checklist]
Prevents: Bug 1 class (tests pass but broken)

### 2. Add Implementer Gate (Priority 1)
Agent: Implementer
Location: Before "WORKFLOW" section
Text: [Specific gate requiring approved plan]
Prevents: Bug 2 class (bypassed discovery)

### 3. Add UI/UX QA Checklist (Priority 2)
Agent: UI/UX Designer
Location: After "DOMAIN CONTEXT" section
Text: [Framework-specific modal/Turbo checks]
Prevents: Bug 3 class (framework lifecycle bugs)

**Implementation Order:**
1. Verifier runtime check (prevents most critical class)
2. Implementer gate (prevents bypass)
3. UI/UX checklist (prevents framework bugs)
```

---

## Ready to Start?

Provide your recent incidents and I'll guide you through hardening your workflow.

**Quick Start:**
- 1 bug? I'll do targeted hardening
- 2-3 bugs? I'll identify patterns
- 5+ bugs? I'll do comprehensive workflow audit

**What information do you have?**
