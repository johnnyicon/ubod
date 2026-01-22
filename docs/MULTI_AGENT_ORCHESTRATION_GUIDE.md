# Multi-Agent Orchestration Guide

**A Comprehensive Guide to Agent-to-Agent Orchestration in GitHub Copilot**

**Version:** 1.0  
**Last Updated:** 2026-01-22  
**Audience:** Developers using multi-agent workflows in GitHub Copilot  
**Reading Time:** 15-20 minutes (full read) | 5 minutes (reference)

> **📌 Note:** This guide covers **multi-agent orchestration** — having one agent coordinate and delegate to other agents. This is an advanced pattern that builds on the basics covered in [GITHUB_COPILOT_ARTIFACTS_GUIDE.md](./GITHUB_COPILOT_ARTIFACTS_GUIDE.md).

---

## Quick Navigation

- [The Problem This Solves](#the-problem-this-solves)
- [Part 1: Orchestration Fundamentals](#part-1-orchestration-fundamentals)
- [Part 2: The runSubagent Tool](#part-2-the-runsubagent-tool)
- [Part 3: Designing Orchestration Workflows](#part-3-designing-orchestration-workflows)
- [Part 4: Traceability and Announcements](#part-4-traceability-and-announcements)
- [Part 5: Case Study — PRD Enrichment](#part-5-case-study--prd-enrichment)
- [Part 6: Common Patterns](#part-6-common-patterns)
- [Part 6.5: Testing Orchestration Reliability](#part-65-testing-orchestration-reliability)
- [Part 7: Debugging Orchestration](#part-7-debugging-orchestration)
- [Appendix: Orchestration Cheat Sheet](#appendix-orchestration-cheat-sheet)

---

## The Problem This Solves

**Before orchestration, complex tasks were monolithic:**

```
Scenario: Enrich a PRD with codebase-specific implementation details

Without orchestration:
- One agent tries to do everything
- Misses codebase patterns (no discovery phase)
- Makes UI decisions without design system context
- Skips verification (assumes it got everything right)
- 2000+ lines of PRD but full of gaps and assumptions

Result: 🔥 PRD that looks complete but is wrong in subtle ways
```

**After orchestration, tasks are specialized:**

```
With orchestration:
- Orchestrator (PRD Enricher) coordinates workflow
- Discovery Planner maps existing patterns → returns evidence
- UI/UX Designer makes component decisions → returns approach
- Verifier checks completeness → returns QA checklist
- Each specialist contributes domain expertise

Result: ✅ PRD with verified patterns, designed UI, and validation
```

---

## Part 1: Orchestration Fundamentals

### What is Orchestration?

**Orchestration** is when one agent (the orchestrator) coordinates multiple specialist agents to complete a complex task.

```
┌─────────────────────────────────────────────────────────────┐
│                    ORCHESTRATOR AGENT                        │
│                                                              │
│ Parses task → Invokes specialists → Merges outputs → Done   │
└─────────────────────────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ↓               ↓               ↓
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  Specialist  │ │  Specialist  │ │  Specialist  │
│   Agent A    │ │   Agent B    │ │   Agent C    │
│              │ │              │ │              │
│ (Discovery)  │ │  (UI/UX)     │ │ (Verifier)   │
└──────────────┘ └──────────────┘ └──────────────┘
```

### When to Use Orchestration

**Use orchestration when:**
- Task requires multiple domains of expertise
- Steps have dependencies (B needs output from A)
- You want to reuse specialist agents across different workflows
- Task is too complex for one agent to handle well

**Don't use orchestration when:**
- Task is simple and single-domain
- No benefit from specialist separation
- Overhead of coordination outweighs benefits

### The Key Capability: runSubagent

The `runSubagent` tool is what enables orchestration. It's **only available to agents** (not prompts, not instructions, not skills).

```javascript
// Orchestrator agent can do this:
runSubagent({
  agentName: "Tala Discovery Planner",
  prompt: "Map existing patterns for drag-and-drop functionality",
  description: "Find codebase patterns"
})
```

> **⚠️ Hard Boundary:** Only agents can call `runSubagent`. This is a system-enforced limitation, not a convention.

---

## Part 2: The runSubagent Tool

### How runSubagent Works

When an agent calls `runSubagent`:

1. **Current agent pauses** — waits for sub-agent to complete
2. **Sub-agent activates** — receives the prompt, does its work
3. **Sub-agent returns** — sends findings back to orchestrator
4. **Orchestrator resumes** — continues with sub-agent's output

```
Orchestrator                    Sub-agent
     │                              │
     │─── runSubagent ─────────────→│
     │                              │
     │    (paused)                  │← does work
     │                              │← reads files
     │                              │← searches code
     │                              │
     │←───── result ────────────────│
     │                              │
     │← continues with result       │
     ↓                              
```

### runSubagent Parameters

```javascript
runSubagent({
  agentName: "Agent Name",        // REQUIRED: Exact name from agent file
  prompt: "Task description...",   // REQUIRED: What you want the agent to do
  description: "Short label"       // OPTIONAL: Brief description for logging
})
```

**agentName must match exactly:**
- ✅ `"Tala Discovery Planner"` (exact match)
- ❌ `"tala-discovery-planner"` (kebab-case won't work)
- ❌ `"Discovery Planner"` (partial name won't work)

### What Sub-agents Return

Sub-agents return a **single message** with their findings. The orchestrator receives this as text and can:
- Parse structured sections (markdown headers, bullet lists)
- Extract specific data points
- Merge into larger output

> **Key insight:** Sub-agent output is text, not structured data. Design your sub-agent prompts to return well-organized markdown that's easy to parse.

---

## Part 3: Designing Orchestration Workflows

### Step 1: Identify the Specialists

For any complex task, identify which domains of expertise are needed:

| Task Component | Specialist Agent | What It Provides |
|----------------|------------------|------------------|
| Find existing patterns | Discovery Planner | Evidence, file paths, code references |
| Design UI approach | UI/UX Designer | Component decisions, Turbo strategy |
| Verify completeness | Verifier | QA checklist, edge cases, blockers |
| Design system work | Design System | Component patterns, conventions |

### Step 2: Define Dependencies

Not all specialists can run in parallel. Define the dependency order:

```
Discovery Planner
       ↓
       ├───────────────────┐
       ↓                   ↓
   UI/UX Designer    Design System
       ↓                   │
       └───────────────────┘
              ↓
          Verifier
              ↓
          Complete
```

**Why order matters:**
- UI/UX Designer needs Discovery results to know what patterns exist
- Verifier needs all previous work to check completeness

### Step 3: Design the Orchestrator Workflow

The orchestrator agent should have a clear workflow section:

```markdown
## WORKFLOW

### Phase 1: Parse Input
- Read the input (PRD, feature request, etc.)
- Identify gaps and what needs enrichment

### Phase 2: Invoke Discovery Planner
- Task: Map existing patterns for [feature]
- Expected output: File paths, code patterns, ADRs

### Phase 3: Invoke UI/UX Designer
- Input: Discovery findings
- Task: Design component approach
- Expected output: Component decisions, gotchas, QA steps

### Phase 4: Invoke Verifier
- Input: All previous work
- Task: Check completeness
- Expected output: Blockers, warnings, missing pieces

### Phase 5: Synthesize
- Merge all specialist outputs
- Write enriched document
- Declare completion
```

---

## Part 4: Traceability and Announcements

### The Problem: Invisible Orchestration

Without announcements, orchestration happens invisibly:

```
User: "Enrich this PRD"
...
(silence)
...
(lots of work happening)
...
Copilot: "Here's the enriched PRD"
```

**Problems:**
- User doesn't know which agents ran
- Can't verify if Discovery actually searched the codebase
- No visibility into what each specialist contributed
- Hard to debug when something goes wrong

### The Solution: Multi-Layer Traceability

**Three levels of traceability improvements:**

#### Level 1: Basic Agent Announcements

Add **ANNOUNCEMENTS** sections to each agent with clear markers (covered below).

#### Level 2: Caller Identity in Prompts

**Problem:** Sub-agents don't know who invoked them.

**Solution:** Orchestrators include caller identity in `runSubagent` prompts:

```javascript
runSubagent(
  agentName: "Discovery Planner",
  prompt: "You are being invoked by PRD Enricher.
           
           Task: Map existing patterns for drag-and-drop feature..."
)
```

Sub-agents detect and announce the caller:

```markdown
### Caller Detection

Check the prompt for "You are being invoked by [Agent Name]".

If found, announce:
```
🔍 **DISCOVERY PLANNER RESPONDING TO: PRD Enricher**

Invoked by: PRD Enricher
Task: [Restate task]
Status: ACTIVE
```
```

#### Level 3: Skill Loading Announcements

**Problem:** No visibility into which skills are loaded and when.

**Solution:** Add announcement section to skill files:

```markdown
## SKILL LOADED ANNOUNCEMENT

> **When this skill is loaded, display:**
>
> 📚 **SKILL LOADED: Discovery Methodology**
>
> **Providing knowledge for:** Evidence-first development, codebase exploration
> **Available sections:** Discovery Workflow, Verification Checklists, Patterns
> **Loaded because:** Starting new work or need to understand existing code
```

**Note:** Skills are passive files. The LLM decides when to display this. It won't auto-trigger, but provides a template for consistent announcements.

### Agent Announcements

Add **ANNOUNCEMENTS** sections to each agent with clear markers:

```markdown
## ANNOUNCEMENTS (CRITICAL)

**ALWAYS announce when you start and when you hand off:**

### On Start
```
🤖 **AGENT NAME ACTIVE**

I am the [role description]. I will:
1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Final output]

Starting work...
```

### Before Each Handoff
```
📤 **HANDOFF: [Target Agent Name]**

Reason: [Why this agent is needed]
Task: [Specific task for the agent]
Expected Output: [What the agent should return]

Invoking agent now...
```

### After Each Handoff (Orchestrator Only)
```
📥 **RECEIVED FROM: [Agent Name]**

Key Findings:
- [Bullet list of key findings]

Merging into output...
```

### On Completion
```
✅ **AGENT NAME COMPLETE**

Summary: [What was accomplished]
Deliverable: [What was produced]
```
```

### Emoji Markers Reference

| Emoji | Meaning | When to Use |
|-------|---------|-------------|
| 🤖 | Agent start | Agent begins work |
| 📤 | Handoff out | Before calling sub-agent |
| 📥 | Receive back | After sub-agent returns |
| ✅ | Complete | Agent finished its work |
| 🔍 | Discovery | Search/research actions |
| 🎨 | Design | UI/UX design actions |

### Example: What Orchestration Looks Like

With announcements, the user sees:

```
🤖 **TALA PRD ENRICHER AGENT ACTIVE**

I am the PRD enrichment orchestrator. I will:
1. Parse the base PRD and identify gaps
2. Invoke specialist agents in dependency order
3. Merge their findings into an implementation-ready PRD
4. Verify completeness before declaring ready

Starting enrichment workflow...

---

📤 **HANDOFF: Tala Discovery Planner**

Reason: Need to map existing codebase patterns for drag-and-drop
Task: Find document_selection API, existing drag patterns, Turbo Streams
Expected Output: File paths, code patterns, ADRs

Invoking agent now...

---

📥 **RECEIVED FROM: Tala Discovery Planner**

Key Findings:
- document_selection_controller.js uses getSelectedIds() API
- Existing drag pattern in document_upload_controller.js
- Multi-controller communication pattern confirmed
- Related ADR: 2026-01-12 (Semantic Token Selection States)

Merging into PRD...

---

📤 **HANDOFF: Tala UI/UX Designer**

Reason: Need UI design decisions for drag-and-drop interactions
Task: Design visual states, CSS classes, animations, gotchas
Expected Output: Component approach, QA script

Invoking agent now...

---

📥 **RECEIVED FROM: Tala UI/UX Designer**

Key Findings:
- Dragging state: opacity-50, cursor-grabbing, scale-95
- Drop zone: ring-2 ring-primary bg-primary/10
- Multi-drag badge: bg-accent text-accent-foreground
- 6 gotchas documented
- 27-step QA checklist

Merging into PRD...

---

✅ **TALA PRD ENRICHER COMPLETE**

Enrichments Applied:
- Architecture: Mapped existing patterns
- UI/UX: Complete design approach
- Verification: QA checklist included

PRD Status: READY FOR IMPLEMENTATION
```

---

## Part 5: Case Study — PRD Enrichment

### The Scenario

**Input:** A base PRD for drag-and-drop folder moving (~686 lines)
- High-level requirements
- No codebase-specific patterns
- No Tala component decisions
- No verification checklist

**Goal:** Enrich to implementation-ready (~1,693 lines)
- Verified patterns from actual codebase
- Complete UI/UX design decisions
- Full test coverage plan
- Runtime verification QA checklist

### The Orchestration Flow

```
User: "Use the Tala PRD Enricher to enrich the drag-and-drop PRD"
                    │
                    ↓
        ┌───────────────────────┐
        │  Tala PRD Enricher    │
        │     (Orchestrator)    │
        └───────────────────────┘
                    │
                    │ runSubagent
                    ↓
        ┌───────────────────────┐
        │ Tala Discovery Planner│
        │                       │
        │ Task: Map existing    │
        │ patterns for drag     │
        └───────────────────────┘
                    │
                    │ Returns: document_selection API,
                    │          drag patterns, ADRs
                    ↓
        ┌───────────────────────┐
        │  Tala UI/UX Designer  │
        │                       │
        │ Task: Design drag UI  │
        │ approach with patterns│
        └───────────────────────┘
                    │
                    │ Returns: CSS classes, animations,
                    │          gotchas, QA script
                    ↓
        ┌───────────────────────┐
        │    Tala Verifier      │
        │                       │
        │ Task: Check PRD       │
        │ completeness          │
        └───────────────────────┘
                    │
                    │ Returns: Blockers, warnings,
                    │          missing pieces
                    ↓
        ┌───────────────────────┐
        │  Synthesize & Write   │
        │  Enriched PRD         │
        └───────────────────────┘
                    │
                    ↓
              Complete!
```

### What Each Agent Contributed

**1. Discovery Planner:**
- Found `document_selection_controller.js` with `getSelectedIds()` API
- Found existing drag/drop pattern in `document_upload_controller.js`
- Identified Turbo Stream removal pattern
- Located related ADRs (2026-01-12 for semantic tokens)

**2. UI/UX Designer:**
- Specified exact CSS classes (`opacity-50`, `ring-2 ring-primary`)
- Designed multi-drag badge (teal pill per ADR)
- Documented 6 gotchas (multi-controller, memory leaks, etc.)
- Created 27-step QA checklist

**3. Verifier:**
- Identified 3 blocking issues
- Listed 5 warnings
- Checked completeness across 6 dimensions

### The Result

**Before enrichment:** ~686 lines
- Generic requirements
- No codebase context
- No design decisions
- No verification steps

**After enrichment:** ~1,693 lines
- Discovery Evidence section with file paths
- Complete implementation guide (10 steps, full code)
- UI/UX Design Decisions (CSS, animations, gotchas)
- Runtime Verification QA Checklist (60+ steps)
- Enrichment Summary documenting what was added

**Growth:** 147% increase in content, but more importantly:
- ✅ All patterns verified against actual codebase
- ✅ All UI decisions aligned with design system ADRs
- ✅ All edge cases documented
- ✅ Ready for simpler LLM (Sonnet/Haiku) to implement

---

## Part 6: Common Patterns

### Pattern 1: Discovery → Design → Verify

The most common orchestration pattern:

```
Discovery    →    Design    →    Verify
  (what)          (how)         (check)
```

**Use when:** You need to understand existing code before making decisions.

### Pattern 2: Parallel Specialists

When specialists don't depend on each other:

```
        ┌→ Specialist A ─┐
        │                ↓
Input ──┼→ Specialist B ──→ Merge
        │                ↑
        └→ Specialist C ─┘
```

**Use when:** Each specialist works on independent aspects.

> **Note:** Current runSubagent implementation is synchronous (one at a time). Parallel invocation would require system changes.

### Pattern 3: Iterative Refinement

Loop until quality threshold met:

```
Draft → Review → Refine → Review → ... → Approve
```

**Use when:** Output quality is critical and may need multiple passes.

### Pattern 4: Conditional Branching

Different specialists based on input:

```
Parse Input
    │
    ├─ If UI-focused → UI/UX Designer
    ├─ If backend-focused → Architecture Agent
    └─ If unclear → Ask for clarification
```

**Use when:** Task type determines which specialists are needed.

---

## Part 6.5: Testing Orchestration Reliability

### The Testing Harness

Before using orchestration in production workflows, validate it works:

**Test Agents:**
- **Test Orchestrator** — Minimal orchestrator that invokes Test Responder
- **Test Responder** — Returns "TEST SUCCESS" to verify round-trip works

**Location:** `.github/agents/test-orchestrator.agent.md` and `test-responder.agent.md`

### Running Reliability Tests

**Single test:**
```
@Test Orchestrator run a test
```

**Expected output:**
```
🧪 **TEST ORCHESTRATOR ACTIVE**
Purpose: Verify runSubagent orchestration mechanism
...

📤 **HANDOFF: Test Responder**
...

🤖 **TEST RESPONDER ACTIVE**
Invoked by: Test Orchestrator
...

TEST SUCCESS

✅ **TEST PASSED**
Orchestration is working correctly!
```

**10-run reliability test:**

Run `@Test Orchestrator` 10 times and track results:

| Test # | Pass/Fail | Notes |
|--------|-----------|-------|
| 1-10   | Track each | |

**Reliability interpretation:**
- **10/10 passes** = Orchestration is reliable ✅
- **7-9/10 passes** = Mostly reliable, investigate failures ⚠️
- **0-6/10 passes** = Not reliable, debug needed ❌

### When to Use the Testing Harness

**Before:**
- Deploying orchestration to production workflows
- Making changes to orchestration infrastructure
- Debugging complex orchestration failures

**To diagnose:**
- Is the problem with `runSubagent` itself or my workflow?
- Are agent names matching correctly?
- Are announcements working as expected?

**Benefits:**
- Isolates orchestration mechanism from complex domain logic
- Fast feedback (< 1 minute per test)
- Establishes baseline reliability before complex work

---

## Part 7: Debugging Orchestration

### Common Issues

**1. "Agent not found" error**

```
Error: Could not find agent "discovery-planner"
```

**Fix:** Use exact agent name from frontmatter:
```yaml
---
name: Tala Discovery Planner  # ← Use this exactly
---
```

**2. Sub-agent returns empty**

```
📥 RECEIVED FROM: Discovery Planner

Key Findings:
- (empty)
```

**Fix:** Check your prompt. Give specific context:
```javascript
// ❌ Too vague
runSubagent({
  prompt: "Find patterns"
})

// ✅ Specific
runSubagent({
  prompt: "Map existing patterns for drag-and-drop in documents. 
           Look for: document_selection controller, existing drag events, 
           Turbo Stream patterns. Return file paths and code snippets."
})
```

**3. Orchestration invisible**

**Fix:** Add ANNOUNCEMENTS section to all agents:
```markdown
## ANNOUNCEMENTS (CRITICAL)

### On Start
🤖 **AGENT NAME ACTIVE**
...
```

**4. Sub-agent doesn't follow instructions**

**Fix:** Sub-agents are stateless. Include all context in the prompt:
```javascript
// ❌ Assumes context
runSubagent({
  prompt: "Check the PRD"
})

// ✅ Provides context
runSubagent({
  prompt: `Check this PRD for completeness:
           
           File: prds/tala/mvp/20260121_folders/03_drag_and_drop.md
           
           Verify:
           1. All acceptance criteria are testable
           2. Implementation steps are copy-paste ready
           3. Edge cases are documented
           
           Return: Blockers, warnings, and completeness score`
})
```

### Traceability Checklist

If orchestration seems wrong, verify:

- [ ] Orchestrator announced start (🤖)?
- [ ] Each handoff announced (📤)?
- [ ] Each return acknowledged (📥)?
- [ ] Key findings listed after each handoff?
- [ ] Completion announced (✅)?
- [ ] All sub-agents used their own announcements?

---

## Appendix: Orchestration Cheat Sheet

### Quick Reference

| Concept | Description |
|---------|-------------|
| **Orchestrator** | Agent that coordinates other agents |
| **Sub-agent** | Specialist agent invoked by orchestrator |
| **runSubagent** | Tool to invoke sub-agents (agents only) |
| **Announcement** | Visible marker of agent activity |
| **Handoff** | Passing work from one agent to another |

### Announcement Templates

**Orchestrator Start:**
```
🤖 **[ORCHESTRATOR NAME] AGENT ACTIVE**

I am the [role]. I will:
1. [Parse input]
2. [Invoke specialists]
3. [Merge outputs]
4. [Verify and complete]

Starting workflow...
```

**Before Handoff:**
```
📤 **HANDOFF: [Sub-agent Name]**

Reason: [Why needed]
Task: [Specific task]
Expected Output: [What to return]

Invoking agent now...
```

**After Handoff:**
```
📥 **RECEIVED FROM: [Sub-agent Name]**

Key Findings:
- [Finding 1]
- [Finding 2]
- [Finding 3]

Merging into output...
```

**Completion:**
```
✅ **[AGENT NAME] COMPLETE**

[Summary of work done]
[Deliverable location or status]
```

### Best Practices

1. **Give sub-agents complete context** — They're stateless
2. **Use exact agent names** — Match frontmatter exactly
3. **Add announcements to ALL agents** — Not just orchestrators
4. **Design sub-agents to return structured output** — Easier to parse
5. **Check dependencies** — Invoke in correct order
6. **Include expected output format** — Tell sub-agent what to return
7. **Merge findings explicitly** — Show what was added from each

### Anti-patterns

❌ **Monolithic agent** — Tries to do everything without delegation
❌ **Invisible orchestration** — No announcements, can't trace what happened
❌ **Vague prompts** — "Check the thing" without context
❌ **Parallel assumption** — Assuming runSubagent runs in parallel (it doesn't)
❌ **Missing dependencies** — Calling UI/UX before Discovery
❌ **Orphaned output** — Sub-agent returns, orchestrator doesn't merge

---

## Summary

**Multi-agent orchestration enables:**
- Specialist agents with deep domain expertise
- Reusable agents across different workflows
- Visible, traceable complex task completion
- Better quality through separation of concerns

**Key tools:**
- `runSubagent` — The only way to invoke sub-agents
- Announcements — Make orchestration visible

**Best practice:** Start with a clear orchestrator workflow, design sub-agents with specific expertise, add announcements for traceability.

---

**Related Documents:**
- [GITHUB_COPILOT_ARTIFACTS_GUIDE.md](./GITHUB_COPILOT_ARTIFACTS_GUIDE.md) — Basics of skills, prompts, agents, instructions
- [Agent Schema](../../.github/schemas/agent-schema.md) — Agent file structure reference
