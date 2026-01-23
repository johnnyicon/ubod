# Orchestration Design Skill

**Purpose:** Step-by-step methodology for designing multi-agent orchestrations

**When to Use:** When you need to coordinate multiple specialist agents to complete a complex task

**Prerequisites:** Read [MULTI_AGENT_ORCHESTRATION_GUIDE.md](../../docs/MULTI_AGENT_ORCHESTRATION_GUIDE.md) for conceptual foundation

---

## SKILL LOADED ANNOUNCEMENT

> **When this skill is loaded, display:**
>
> 📐 **SKILL LOADED: Orchestration Design**
>
> **Providing knowledge for:** Multi-agent workflow design, task decomposition, dependency mapping
> **Available sections:** Quick Start (5 min), Full Methodology (20 min), Testing Patterns
> **Loaded because:** Designing orchestration for complex multi-step task

---

## Quick Start (5 minutes)

### When to Orchestrate vs Single Agent

**Use orchestration when (YES to 2+ questions):**
- [ ] Task requires 2+ domains of expertise (discovery, design, verification)
- [ ] Steps have dependencies (B needs output from A)
- [ ] Task > 30 minutes for single agent
- [ ] Want to reuse specialists across workflows

**DON'T orchestrate when:**
- [ ] Single-file change or simple CRUD
- [ ] Well-documented task with no discovery needed
- [ ] Tight latency budget (< 10 seconds end-to-end)
- [ ] Specialists would do < 30 seconds of work each

---

## Full Methodology (20 minutes)

### Step 1: Task Analysis (5 min)

**Decompose the task into domains:**

| Question | Domain | Example Specialist |
|----------|--------|-------------------|
| What exists in the codebase? | Discovery | Discovery Planner |
| How should it look/work? | Design | UI/UX Designer, Architect |
| Is it complete/correct? | Verification | Verifier, QA Agent |
| What tests are needed? | Testing | Test Strategy Designer |

**Output:** List of 2-5 specialist domains

### Step 2: Dependency Mapping (5 min)

**Define execution order:**

```
Step 1: Discovery (no dependencies)
   ↓
Step 2: Design (needs Discovery output)
   ↓
Step 3: Implementation (needs Design output)
   ↓
Step 4: Verification (needs all previous)
```

**Rules:**
- Specialists with no dependencies can run first
- Specialists needing output from others run after
- Current `runSubagent` is synchronous (one at a time)
- Avoid depth > 1 (orchestrator → specialist → specialist)

**Output:** Dependency graph showing order

### Step 3: Routing Strategy (5 min) — OPTIONAL

**For hybrid orchestrators (route OR handle directly):**

If building an orchestrator that needs to dynamically select specialists based on user request:

**Option A: Fixed Routing (Simple)**
- Orchestrator always calls same specialists in same order
- Example: PRD Enricher always calls (1) Discovery → (2) UI Designer → (3) Verifier
- **Use when:** Workflow is always the same

**Option B: Dynamic Routing (Advanced)**
- Orchestrator matches request keywords to specialist domains
- Routes complex requests to specialists, handles simple requests directly
- Example: Tala Orchestrator routes "design UI" → UI Designer, handles "what's in model?" directly
- **Use when:** Orchestrator is user-facing entry point with varying request types

**If using dynamic routing, create agent registry:**

1. **Generate registry** using `/agent-registry-update` prompt
   - Scans all agent files
   - Extracts domains and keywords from frontmatter
   - Generates `agents-registry.yaml` with routing patterns

2. **Implement semantic matching** in orchestrator:
   ```typescript
   // Load registry
   const registry = YAML.parse(await read_file(".github/agents/agents-registry.yaml"));
   
   // Extract keywords from user request
   const keywords = extractKeywords(userRequest);
   
   // Match against agent keywords
   const bestMatch = findBestMatch(keywords, registry.agents);
   
   // Route based on confidence
   if (bestMatch.confidence >= 0.9) {
     return await runSubagent({ agentName: bestMatch.agentId, ... }); // HIGH: auto-route
   } else if (bestMatch.confidence >= 0.6) {
     return await ask(`Route to ${bestMatch.agent.name}?`); // MEDIUM: confirm
   } else {
     return handleDirectly(); // LOW: handle without specialist
   }
   ```

3. **Confidence thresholds** (empirically validated):
   - High (90%+): Auto-route without confirmation
   - Medium (60-89%): Ask confirmation before routing
   - Low (<60%): Show options or handle directly

**Reference:** See `ubod-meta/docs/case-studies/tala-orchestrator.md` for full implementation (92% routing accuracy)

**Skip routing if:** Fixed workflow, <5 agents, or not user-facing

### Step 4: Agent Scaffolding (10 min)

For each specialist, define:

#### Orchestrator Agent

```markdown
---
name: {{TASK_NAME}} Orchestrator
description: Coordinates {{specialist_count}} specialists for {{task_description}}
tools: ["read", "search", "agent"]
---

## ROLE

You are the **{{TASK_NAME}} Orchestrator**. You coordinate {{specialist_count}} specialist agents to complete {{task_description}}.

## COMMANDS

- **Coordinate Workflow:** Invoke specialists in dependency order
- **Merge Outputs:** Synthesize specialist findings into cohesive result
- **Verify Completeness:** Ensure all requirements met before declaring complete

## BOUNDARIES

✅ Always do:
- Announce each handoff (📤) and receipt (📥)
- Include caller identity in specialist prompts
- Verify completeness before declaring done

⚠️ Ask first:
- When task requirements are ambiguous
- When unclear which specialists are needed

🚫 Never do:
- Skip specialists to save time
- Assume specialist output without reading it
- Invoke specialists in wrong order (ignoring dependencies)

## WORKFLOW

### Phase 1: Parse Input
- Read task requirements
- Identify gaps and what needs specialist expertise

### Phase 2: Invoke {{SPECIALIST_1}}
- Task: {{specific_task}}
- Expected output: {{expected_findings}}

### Phase 3: Invoke {{SPECIALIST_2}}
- Input: {{SPECIALIST_1}} output
- Task: {{specific_task}}
- Expected output: {{expected_findings}}

### Phase 4: Synthesize
- Merge all specialist outputs
- Produce final deliverable
- Declare completion

## ANNOUNCEMENTS (CRITICAL)

### On Start
```
🤖 **{{TASK_NAME}} ORCHESTRATOR ACTIVE**

I am the orchestration coordinator. I will:
1. Parse task and identify gaps
2. Invoke {{specialist_count}} specialists in order
3. Merge their findings
4. Verify completeness

Starting workflow...
```

### Before Each Handoff
```
📤 **HANDOFF: {{Specialist Name}}**

Reason: {{why this specialist is needed}}
Task: {{specific task}}
Expected Output: {{what specialist should return}}

Invoking specialist now...
```

### After Each Handoff
```
📥 **RECEIVED FROM: {{Specialist Name}}**

Key Findings:
- {{bullet list of findings}}

Merging into output...
```

### On Completion
```
✅ **{{TASK_NAME}} ORCHESTRATOR COMPLETE**

Summary: {{what was accomplished}}
Deliverable: {{what was produced}}
```
```

#### Specialist Agent Template

```markdown
---
name: {{SPECIALIST_NAME}}
description: {{what this specialist does}}
tools: ["read", "search", "edit"]
---

## ROLE

You are the **{{SPECIALIST_NAME}}**. You {{role_description}}.

## COMMANDS

- **{{Primary Command}}:** {{what this specialist does}}
- **Return Findings:** Structured markdown output for orchestrator

## BOUNDARIES

✅ Always do:
- Detect and announce caller identity (if invoked by orchestrator)
- Return well-structured markdown (headers, bullets, code blocks)
- Focus on your specialty (don't drift into other domains)

🚫 Never do:
- Make decisions outside your domain
- Return unstructured text (hard to parse)
- Assume context you weren't given

## WORKFLOW

### Phase 1: Detect Caller
Check prompt for "You are being invoked by {{ORCHESTRATOR_NAME}}"
If found, announce:
```
{{EMOJI}} **{{SPECIALIST_NAME}} RESPONDING TO: {{ORCHESTRATOR_NAME}}**

Invoked by: {{ORCHESTRATOR_NAME}}
Task: {{restate task}}
Status: ACTIVE
```

### Phase 2: Execute Specialty
- {{step 1 of specialty work}}
- {{step 2 of specialty work}}
- {{step 3 of specialty work}}

### Phase 3: Return Findings
```
## {{SPECIALIST_NAME}} Findings

### {{Section 1}}
- {{bullet points}}

### {{Section 2}}
- {{bullet points}}

### {{Section 3}}
- {{bullet points}}
```

### On Completion
```
✅ **{{SPECIALIST_NAME}} COMPLETE**

Summary: {{what was found}}
Returned: {{structured sections}}
```
```

---

## Testing Patterns

### Test Harness (Validate Orchestration Works)

**Before production use, create test agents:**

#### Test Orchestrator

```markdown
---
name: Test Orchestrator
description: Validates runSubagent orchestration mechanism
tools: ["agent"]
---

## ROLE

You validate that orchestration works via minimal test harness.

## WORKFLOW

1. Announce test start
2. Invoke Test Responder via runSubagent
3. Verify response contains "TEST SUCCESS"
4. Report PASS/FAIL
```

#### Test Responder

```markdown
---
name: Test Responder
description: Returns TEST SUCCESS to validate orchestration
tools: []
---

## ROLE

You are a minimal responder for testing orchestration.

## WORKFLOW

1. Detect caller identity
2. Respond with exactly "TEST SUCCESS"
3. Declare complete
```

**Reliability target:** 10/10 tests pass before production use

---

## Announcement Best Practices

### Emoji Markers

| Emoji | Meaning | When to Use |
|-------|---------|-------------|
| 🤖 | Agent start | Agent begins work |
| 📤 | Handoff out | Before calling sub-agent |
| 📥 | Receive back | After sub-agent returns |
| ✅ | Complete | Agent finished |
| 🔍 | Discovery | Search/research |
| 🎨 | Design | UI/UX design |
| 🧪 | Testing | Test harness |

### Caller Identity Pattern

**Orchestrators always include in prompts:**
```
You are being invoked by {{ORCHESTRATOR_NAME}}.

Task: {{specific_task}}
Expected output: {{what_to_return}}
```

**Specialists always check and announce:**
```markdown
Check prompt for "You are being invoked by"
If found, announce:
```
{{EMOJI}} **{{SPECIALIST_NAME}} RESPONDING TO: {{ORCHESTRATOR_NAME}}**
```
```

---

## Common Patterns

### Pattern 1: Discovery → Design → Verify

```
Discovery    →    Design    →    Verify
  (what)          (how)         (check)
```

**Use when:** Need to understand existing code before making decisions

### Pattern 2: Conditional Branching

```
Parse Input
    │
    ├─ If UI-focused → UI/UX Designer
    ├─ If backend → Architect
    └─ If unclear → Ask for clarification
```

**Use when:** Task type determines which specialists needed

### Pattern 3: Iterative Refinement

```
Draft → Review → Refine → Review → Approve
```

**Use when:** Output quality critical, may need multiple passes

---

## Performance Considerations

**Orchestration has overhead:**
- Agent activation: ~1-2 seconds per specialist
- Token usage: 3× more than single agent (orchestrator + 2 specialists)
- Debugging complexity: Increases with depth

**Optimize when:**
- Latency budget tight (< 15 seconds end-to-end)
- Token costs high (use efficient specialist prompts)
- Orchestration takes > 2× single agent but quality similar

**Mitigation:**
- Combine specialists when dependencies allow
- Front-load expensive operations (discovery first)
- Use selective handoffs (only invoke when needed)

---

## Depth Limits

| Depth | Pattern | Status |
|-------|---------|--------|
| 0 | No orchestration | ✅ Standard |
| 1 | Orchestrator → Specialists | ✅ Recommended |
| 2 | Orchestrator → Sub-orchestrator → Specialists | ⚠️ Complex |
| 3+ | Multiple nested levels | 🚫 Avoid |

**Rule:** Start with depth 1. Only add depth 2 when sub-workflow reuse is proven.

---

## Debugging Checklist

**When orchestration fails:**

1. **Agent name mismatch?**
   - Check frontmatter `name:` matches `runSubagent({ agentName: "..." })`
   - Use exact spelling, capitalization, spaces

2. **Sub-agent returns empty?**
   - Check prompt specificity (too vague = empty response)
   - Give context, expected output format, examples

3. **Orchestration invisible?**
   - Add ANNOUNCEMENTS sections to all agents
   - Use emoji markers (🤖📤📥✅)

4. **Wrong execution order?**
   - Verify dependency graph (specialists invoked in correct order)
   - Check if specialist B needs specialist A's output

5. **Test with test harness**
   - Create Test Orchestrator + Test Responder
   - Run 10 times, verify 10/10 pass
   - Isolates orchestration mechanism from complex logic

---

## Reference Materials

**For deep concepts, see:**
- [MULTI_AGENT_ORCHESTRATION_GUIDE.md](../../docs/MULTI_AGENT_ORCHESTRATION_GUIDE.md) - Comprehensive guide
- Part 1: Orchestration Fundamentals
- Part 2: The runSubagent Tool
- Part 3: Designing Orchestration Workflows
- Part 4: Traceability and Announcements
- Part 5: Case Study (PRD Enrichment example)
- Part 6: Common Patterns
- Part 7: Debugging Orchestration

**Schema compliance:**
- Agent structure: ROLE → COMMANDS → BOUNDARIES → SCOPE → WORKFLOW → DOMAIN CONTEXT
- Tool aliases: `read`, `search`, `edit`, `create_file`, `execute`, `agent`

---

## Summary Checklist

Before declaring orchestration design complete:

**Task Analysis:**
- [ ] Identified 2-5 specialist domains
- [ ] Verified orchestration benefits outweigh overhead
- [ ] Confirmed task isn't simple CRUD or single-file change

**Dependency Mapping:**
- [ ] Defined execution order (graph showing dependencies)
- [ ] Verified no circular dependencies
- [ ] Confirmed depth ≤ 1 (no sub-orchestrators unless reusable)

**Agent Scaffolding:**
- [ ] Created orchestrator agent with WORKFLOW section
- [ ] Created specialist agents with focused ROLE
- [ ] Added ANNOUNCEMENTS to all agents (🤖📤📥✅)
- [ ] Included caller identity in orchestrator prompts
- [ ] Added caller detection in specialist agents

**Testing:**
- [ ] Created test harness (Test Orchestrator + Test Responder)
- [ ] Ran 10 reliability tests
- [ ] Achieved 10/10 pass rate (or debugged failures)

**Documentation:**
- [ ] Documented why orchestration chosen (vs single agent)
- [ ] Documented specialist responsibilities
- [ ] Documented dependency order and rationale

**Ready for production:** All checkboxes ✅

---

**Remember:** Orchestration is powerful but has overhead. Use when coordination saves more effort than it costs.
