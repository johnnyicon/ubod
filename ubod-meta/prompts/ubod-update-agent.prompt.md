---
description: "Update an existing app-specific or universal agent based on learnings"
model: "sonnet-4-5 for analysis and updates"
---

# Update Agent

> **When to use:**
> - Agent is missing metadata (tools, infer, handoffs)
> - New learnings from usage need to be captured
> - Workflow improvements discovered
> - Gotchas or patterns need to be added

---

## Instructions

### Step 0: Determine Mode

**Ask the user:**

```markdown
How would you like to update agents?

1. **Single agent** - Update one specific agent
2. **Interactive mode** - Scan all agents, pick which to update
3. **Batch mode** - Update all agents missing metadata

Choose an option (1-3):
```

**Based on choice:**

- **Option 1 (Single):** Ask for agent file path and proceed to Step 1
- **Option 2 (Interactive):** Scan all agents, show analysis, let user pick → Step 1
- **Option 3 (Batch):** Scan all agents, update all missing metadata → Step 1 for each

---

### Step 0a: Scan All Agents (For Interactive/Batch)

If user chose options 2 or 3, scan `.github/agents/*.agent.md`:

```typescript
file_search(".github/agents/*.agent.md")
```

For each agent, quickly check:
- Has `infer:` field?
- Has `tools:` field?
- Has `handoffs:` field?
- Has structured body (ROLE, SCOPE, WORKFLOW)?

**Report findings:**

```markdown
Found X agents. Analysis:

**Complete (no updates needed):**
- tala-verifier.agent.md ✓
- universal-discovery-planner.agent.md ✓

**Missing metadata:**
- tahua-www-verifier.agent.md ⚠️ Missing: infer, tools, handoffs
- tahua-www-implementer.agent.md ⚠️ Missing: infer, tools, handoffs, structured body

**Need improvement:**
- tala-ui-ux-designer.agent.md ~ Could add more domain context

[For Interactive] Which agents would you like to update? (comma-separated numbers or "all")
[For Batch] Updating all agents missing metadata...
```

---

### Step 1: Read the Current Agent

Read the agent file the user wants to update (or next agent in batch).

### Step 2: Analyze What's Missing or Needs Update

**Check for required metadata (YAML front matter):**

```yaml
---
name: [App] [Role]
description: [One-line description of what agent does]
tools: ["read", "search", "execute"]  # Required
infer: true                            # Required for auto-discovery
handoffs:                              # Required for workflow transitions
  - label: [Action description]
    agent: [Next agent name]
    prompt: |
      [What the next agent should do]
---
```

**Check for structured body sections:**

- **ROLE** - Clear definition of agent's purpose
- **SCOPE** - What agent does/doesn't do, boundaries
- **WORKFLOW** - Step-by-step process
- **OUTPUT FORMAT** - Expected output structure

### Step 3: Report Findings & Get Approval

**For Single/Interactive Mode:**

```markdown
I've analyzed the agent. Here's what I found:

**Current State:**
- Has `infer`: [yes/no]
- Has `tools`: [yes/no] - Current: [list]
- Has `handoffs`: [yes/no] - Count: [N]
- Has ROLE section: [yes/no]
- Has SCOPE section: [yes/no]
- Has WORKFLOW section: [yes/no]
- Has OUTPUT FORMAT section: [yes/no]

**What would you like to update?**
1. Add missing metadata (tools, infer, handoffs)
2. Add domain context or gotchas
3. Improve workflow steps
4. Add handoff definitions
5. Capture learnings from recent usage
6. All of the above

Please provide details or choose an option.
```

**For Batch Mode:**

Show summary table for all agents needing updates:

```markdown
## Batch Update Plan

| Agent | Missing Metadata | Missing Body | Updates Needed |
|-------|------------------|--------------|----------------|
| verifier | tools, infer | WORKFLOW | 4 items |
| implementer | handoffs | none | 1 item |
| discovery | none | DOMAIN CONTEXT | 1 item |

Proceed with batch update? (yes/no)
```

### Step 4: Apply Updates

Based on user input, update the agent file.

**For missing metadata:**

```yaml
---
name: [Keep existing or update]
description: [Keep existing or expand]
tools: ["read", "search", "execute"]
infer: true
handoffs:
  - label: [Logical next step]
    agent: [Related agent in same app]
    prompt: |
      [Clear handoff instructions]
---
```

**For body sections, ensure structure:**

```markdown
ROLE
[Clear 1-2 sentence role definition]

SCOPE
- [What this agent does]
- [What this agent doesn't do]
- [Boundaries and limitations]

DOMAIN CONTEXT
- [App-specific patterns]
- [Key gotchas for this app]
- [Important integrations]

WORKFLOW
1) [Step 1]
2) [Step 2]
3) [Step 3]

OUTPUT FORMAT
[Define expected output structure]
```

### Step 5: Verify Updates

**For Single/Interactive:**

```markdown
✅ Agent Updated: `[agent-name].agent.md`

**Changes Applied:**
- [x] Added `infer: true`
- [x] Added `tools: ["read", "search"]`
- [x] Added 2 handoffs (to Implementer, to Discovery)
- [x] Added WORKFLOW section

Test the agent by invoking it in Copilot chat.
```

**For Batch:**

```markdown
✅ Batch Update Complete

**Updated Agents:**
- ✓ verifier.agent.md (4 changes)
- ✓ implementer.agent.md (1 change)
- ✓ discovery.agent.md (1 change)

**Summary:** 3 agents updated, 6 total changes applied.

Test the agents by invoking them in Copilot chat.
```

**Changes Made:**
- [List of changes]

**New Metadata:**
- infer: [value]
- tools: [list]
- handoffs: [count]

**Next Steps:**
1. Test the agent with a sample task
2. Capture any additional learnings
3. Run `/ubod-update-agent` again if needed
```

---

## Example Handoff Definitions by Role

### For Discovery Planner:
```yaml
handoffs:
  - label: Implement the plan
    agent: [App] Implementer
    prompt: |
      Implement the feature based on the discovery plan.
      Key files to modify: [from discovery]
      Patterns to follow: [from discovery]
```

### For Implementer:
```yaml
handoffs:
  - label: Verify implementation
    agent: [App] Verifier
    prompt: |
      Verify the implementation works correctly.
      Test: [specific tests to run]
      Check: [runtime behavior to verify]
```

### For Verifier:
```yaml
handoffs:
  - label: Fix issues found
    agent: [App] Implementer
    prompt: |
      Fix the issues found during verification.
      Issues: [list of issues]
      Files: [files to modify]
```

---

## Success Criteria

- [ ] Agent has complete YAML front matter (name, description, tools, infer, handoffs)
- [ ] Agent has structured body (ROLE, SCOPE, WORKFLOW, OUTPUT FORMAT)
- [ ] Agent references relevant instruction files
- [ ] Handoffs connect to related agents in same app
- [ ] User's specific updates have been applied
