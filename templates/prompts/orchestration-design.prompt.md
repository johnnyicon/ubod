---
name: orchestration-design
description: Interactive workflow for designing multi-agent orchestrations
tags: [orchestration, multi-agent, workflow, design, setup]
estimatedTime: 20 minutes
---

# Orchestration Design Prompt

**Purpose:** Guide you through designing a multi-agent orchestration workflow

**When to Use:** When you have a complex task that might benefit from multiple specialist agents

**Prerequisites:** Read [Orchestration Design Skill](../../skills/orchestration-design/SKILL.md) for methodology

---

## Phase 1: Task Discovery (5 min)

Let's understand what you're trying to build.

### Question 1: What's the task?

**Describe the task you want to orchestrate:**

(Example: "Enrich a PRD with codebase-specific implementation details", "Generate comprehensive test suite for a feature", "Design and implement a new UI component")

**Your answer:**
[User provides task description]

---

### Question 2: Why orchestrate?

**Check all that apply:**
- [ ] Task requires 2+ domains of expertise (discovery, design, testing, etc.)
- [ ] Steps have dependencies (B needs output from A)
- [ ] Task would take single agent > 30 minutes
- [ ] Want to reuse specialists across different workflows
- [ ] Task too complex for one agent to handle well

**If you checked 2+ boxes:** Orchestration is likely beneficial. Proceed to Phase 2.

**If you checked 0-1 boxes:** Consider using a single optimized agent instead. Still want to orchestrate? Proceed anyway.

---

## Phase 2: Domain Decomposition (5 min)

Let's identify which specialist agents you need.

### Question 3: What domains of expertise are needed?

**Common domains:**
- **Discovery:** Find existing patterns in codebase
- **Architecture:** Design system structure, APIs, data flow
- **UI/UX:** Design visual components, interactions, flows
- **Testing:** Plan test strategy, coverage, edge cases
- **Verification:** Check completeness, validate assumptions
- **Documentation:** Write guides, ADRs, API docs

**For your task, which domains are needed? (List 2-5):**

1. ________________
2. ________________
3. ________________
4. ________________ (optional)
5. ________________ (optional)

---

### Question 4: What are the dependencies?

**For each domain, answer:**
- Does it depend on output from another domain?
- Or can it run independently?

**Example dependency mapping:**
```
Discovery (no dependencies) → runs first
   ↓
UI/UX (needs Discovery output) → runs second
   ↓
Verification (needs all previous) → runs last
```

**Your dependency map:**
```
{{DOMAIN_1}} ({{dependencies or "no dependencies"}})
   ↓
{{DOMAIN_2}} (needs {{which_domain}} output)
   ↓
{{DOMAIN_3}} (needs {{which_domain}} output)
```

---

## Phase 3: Agent Scaffolding (10 min)

Now let's create the agent files.

### Orchestrator Agent

**File:** `.github/agents/{{task-name}}-orchestrator.agent.md`

**Template:**
```chatagent
---
name: {{TASK_NAME}} Orchestrator
description: Coordinates {{specialist_count}} specialists for {{task_description}}
tools: ["read", "search", "agent"]
infer: true
handoffs:
  - label: Review orchestration with different model
    agent: {{TASK_NAME}} Orchestrator
    prompt: "Review the orchestration I just designed. Check for dependency errors, missing specialists, and announcement completeness."
---

# {{TASK_NAME}} Orchestrator Agent

**Purpose:** Coordinates {{specialist_count}} specialist agents to {{task_description}}

**When to Use:** Invoke this agent when you need to {{when_to_use}}

---

## ROLE

You are the **{{TASK_NAME}} Orchestrator**, responsible for coordinating {{specialist_count}} specialist agents to complete {{task_description}}.

Your job is to:
1. Parse the input and identify gaps
2. Invoke specialists in dependency order
3. Merge their findings into a cohesive result
4. Verify completeness before declaring done

---

## COMMANDS

- **Coordinate Workflow:** Invoke specialists in the correct dependency order
- **Merge Outputs:** Synthesize specialist findings into final deliverable
- **Verify Completeness:** Ensure all requirements met before completion

## BOUNDARIES

✅ **Always do:**
- Announce each handoff (📤 HANDOFF) and receipt (📥 RECEIVED FROM)
- Include "You are being invoked by {{TASK_NAME}} Orchestrator" in all specialist prompts
- Verify completeness checklist before declaring done
- Read and parse specialist outputs (don't assume)

⚠️ **Ask first:**
- When task requirements are ambiguous
- When unclear which specialists are needed
- When specialist output seems incomplete

🚫 **Never do:**
- Skip specialists to save time (all are needed)
- Invoke specialists in wrong order (ignoring dependencies)
- Declare complete without verification
- Assume specialist output without reading it

---

## SCOPE

**What I orchestrate:**
- {{DOMAIN_1}}: {{what this specialist does}}
- {{DOMAIN_2}}: {{what this specialist does}}
- {{DOMAIN_3}}: {{what this specialist does}}

**What I do NOT handle:**
- Actual implementation (that's for implementer agents)
- Detailed domain work (that's for specialists)
- Edge case handling (that's for verification specialist)

---

## WORKFLOW

### Phase 1: Parse Input
- Read the task requirements
- Identify what needs specialist expertise
- Prepare for orchestration

### Phase 2: Invoke {{SPECIALIST_1}}
- Task: {{specific_task}}
- Expected output: {{expected_findings}}

### Phase 3: Invoke {{SPECIALIST_2}}
- Input: {{SPECIALIST_1}} findings
- Task: {{specific_task}}
- Expected output: {{expected_findings}}

### Phase 4: Invoke {{SPECIALIST_3}}
- Input: All previous findings
- Task: {{specific_task}}
- Expected output: {{expected_findings}}

### Phase 5: Synthesize
- Merge all specialist outputs
- Write final deliverable
- Verify completeness
- Declare completion

---

## ANNOUNCEMENTS (CRITICAL)

**ALWAYS announce orchestration progress:**

### On Start
\```
🤖 **{{TASK_NAME}} ORCHESTRATOR ACTIVE**

I am the orchestration coordinator. I will:
1. Parse input and identify gaps
2. Invoke {{specialist_count}} specialists in order
3. Merge their findings
4. Verify completeness

Starting workflow...
\```

### Before Each Handoff
\```
📤 **HANDOFF: {{Specialist Name}}**

Reason: {{why this specialist is needed}}
Task: {{specific task for the specialist}}
Expected Output: {{what specialist should return}}

Invoking specialist now...
\```

### After Each Handoff
\```
📥 **RECEIVED FROM: {{Specialist Name}}**

Key Findings:
- {{bullet 1}}
- {{bullet 2}}
- {{bullet 3}}

Merging into output...
\```

### On Completion
\```
✅ **{{TASK_NAME}} ORCHESTRATOR COMPLETE**

Summary: {{what was accomplished}}
Deliverable: {{what was produced}}
Status: READY FOR NEXT PHASE
\```

---

## DOMAIN CONTEXT

### Orchestration Workflow

**Specialist execution order (dependency-based):**
1. **{{SPECIALIST_1}}** → {{why it runs first}}
2. **{{SPECIALIST_2}}** → {{why it runs after #1}}
3. **{{SPECIALIST_3}}** → {{why it runs last}}

**Merging strategy:**
- {{SPECIALIST_1}} provides: {{what_it_returns}}
- {{SPECIALIST_2}} provides: {{what_it_returns}}
- {{SPECIALIST_3}} provides: {{what_it_returns}}
- Final output combines all three into: {{final_deliverable}}

**Completeness checklist (verify before declaring done):**
- [ ] All specialists invoked successfully
- [ ] No specialists returned empty/error
- [ ] Outputs merged coherently
- [ ] No obvious gaps or contradictions
- [ ] Deliverable matches requirements
```

---

### Specialist Agents (Create one file per specialist)

**For each specialist domain, create:**

**File:** `.github/agents/{{specialist-name}}.agent.md`

**Template:**
```chatagent
---
name: {{SPECIALIST_NAME}}
description: {{what this specialist does}}
tools: ["read", "search", {{other_tools_if_needed}}]
infer: true
---

# {{SPECIALIST_NAME}} Agent

**Purpose:** {{specialist_purpose}}

**When to Use:** Invoke when you need {{when_to_use}}

---

## ROLE

You are the **{{SPECIALIST_NAME}}**, specialized in {{domain}}.

Your expertise: {{list_expertise_areas}}

---

## COMMANDS

- **{{Primary Command}}:** {{what this command does}}
- **Return Findings:** Structured markdown output for orchestrator

## BOUNDARIES

✅ **Always do:**
- Detect and announce caller identity (check prompt for "You are being invoked by")
- Return well-structured markdown (headers, bullets, code blocks)
- Focus on your specialty domain only
- Be comprehensive (don't skip edge cases)

⚠️ **Ask first:**
- When requirements are ambiguous
- When you need additional context

🚫 **Never do:**
- Make decisions outside your domain
- Return unstructured text (hard for orchestrator to parse)
- Assume context you weren't explicitly given

---

## SCOPE

**What I handle:**
- {{responsibility_1}}
- {{responsibility_2}}
- {{responsibility_3}}

**What I do NOT handle:**
- {{out_of_scope_1}} (that's for {{OTHER_SPECIALIST}})
- {{out_of_scope_2}} (that's for {{OTHER_SPECIALIST}})

---

## WORKFLOW

### Phase 1: Detect Caller (if orchestrated)

Check prompt for "You are being invoked by {{ORCHESTRATOR_NAME}}"

If found, announce:
\```
{{EMOJI}} **{{SPECIALIST_NAME}} RESPONDING TO: {{ORCHESTRATOR_NAME}}**

Invoked by: {{ORCHESTRATOR_NAME}}
Task: {{restate task from prompt}}
Status: ACTIVE
\```

### Phase 2: Execute Specialty Work

- {{step_1_of_specialty}}
- {{step_2_of_specialty}}
- {{step_3_of_specialty}}

### Phase 3: Return Structured Findings

\```
## {{SPECIALIST_NAME}} Findings

### {{Section_1}}
- {{findings}}

### {{Section_2}}
- {{findings}}

### {{Section_3}}
- {{findings}}

## Summary

{{brief_summary_of_findings}}
\```

### On Completion
\```
✅ **{{SPECIALIST_NAME}} COMPLETE**

Summary: {{what was found}}
Returned: {{list sections returned}}
\```

---

## DOMAIN CONTEXT

### {{Domain}} Expertise

{{Describe what this specialist knows and how it approaches problems}}

**Typical deliverables:**
- {{deliverable_1}}
- {{deliverable_2}}
- {{deliverable_3}}

**Common patterns:**
- {{pattern_1}}
- {{pattern_2}}
```

---

## Phase 4: Testing Setup (Optional but Recommended)

Want to validate orchestration works before production use?

### Create Test Harness

**File:** `.github/agents/test-orchestrator.agent.md`

```chatagent
---
name: Test Orchestrator
description: Validates runSubagent orchestration mechanism
tools: ["agent"]
---

# Test Orchestrator

Minimal orchestrator for testing runSubagent reliability.

## WORKFLOW

1. Announce test start
2. Invoke Test Responder
3. Verify response = "TEST SUCCESS"
4. Report PASS/FAIL
```

**File:** `.github/agents/test-responder.agent.md`

```chatagent
---
name: Test Responder
description: Returns TEST SUCCESS to validate orchestration
tools: []
---

# Test Responder

Minimal responder for testing.

## WORKFLOW

1. Detect caller
2. Return "TEST SUCCESS"
3. Complete
```

**Reliability test:** Run `@Test Orchestrator` 10 times. Target: 10/10 passes.

---

## Phase 5: Documentation (Optional but Recommended)

Document your orchestration design:

**File:** `.github/docs/{{task-name}}-orchestration.md`

```markdown
# {{TASK_NAME}} Orchestration Design

**Created:** {{DATE}}
**Orchestrator:** {{TASK_NAME}} Orchestrator
**Specialists:** {{SPECIALIST_1}}, {{SPECIALIST_2}}, {{SPECIALIST_3}}

## Purpose

{{Why this orchestration exists}}

## Workflow

\```
{{SPECIALIST_1}} (no dependencies)
   ↓
{{SPECIALIST_2}} (needs {{SPECIALIST_1}} output)
   ↓
{{SPECIALIST_3}} (needs all previous)
\```

## Specialists

### {{SPECIALIST_1}}
- **Domain:** {{domain}}
- **Provides:** {{what_it_returns}}
- **Tools:** {{tools_it_uses}}

### {{SPECIALIST_2}}
- **Domain:** {{domain}}
- **Provides:** {{what_it_returns}}
- **Tools:** {{tools_it_uses}}

### {{SPECIALIST_3}}
- **Domain:** {{domain}}
- **Provides:** {{what_it_returns}}
- **Tools:** {{tools_it_uses}}

## Testing

**Test harness:** Test Orchestrator + Test Responder
**Reliability:** {{X}}/10 tests passed
**Last tested:** {{DATE}}

## Usage

\```
@{{TASK_NAME}} Orchestrator {{your_input}}
\```

**Expected output:** {{description_of_output}}
**Estimated time:** {{X}} minutes
```

---

## Completion Checklist

Before using your orchestration in production:

**Files created:**
- [ ] `.github/agents/{{task-name}}-orchestrator.agent.md`
- [ ] `.github/agents/{{specialist-1}}.agent.md`
- [ ] `.github/agents/{{specialist-2}}.agent.md`
- [ ] `.github/agents/{{specialist-3}}.agent.md`
- [ ] `.github/agents/test-orchestrator.agent.md` (optional)
- [ ] `.github/agents/test-responder.agent.md` (optional)
- [ ] `.github/docs/{{task-name}}-orchestration.md` (optional)

**Design validated:**
- [ ] Dependency map verified (no circular dependencies)
- [ ] All agents have ANNOUNCEMENTS sections
- [ ] Orchestrator includes caller identity in prompts
- [ ] Specialists detect and announce caller
- [ ] Test harness created and validated (10/10 passes)

**Documentation:**
- [ ] Orchestration design documented
- [ ] Specialist responsibilities clear
- [ ] Usage examples provided

**Ready for production:** All checkboxes ✅

---

## Next Steps

1. **Test the orchestration:** `@{{TASK_NAME}} Orchestrator {{test_input}}`
2. **Verify announcements:** Check that 🤖📤📥✅ markers appear
3. **Check specialist outputs:** Ensure structured, parseable markdown
4. **Refine if needed:** Adjust specialist prompts for clarity
5. **Document learnings:** Add to orchestration guide if patterns emerge

**Need help?** Consult:
- [Orchestration Design Skill](../../skills/orchestration-design/SKILL.md) - Full methodology
- [Multi-Agent Orchestration Guide](../../docs/MULTI_AGENT_ORCHESTRATION_GUIDE.md) - Comprehensive reference

---

**Remember:** Orchestration adds overhead. Use when coordination saves more effort than it costs.
