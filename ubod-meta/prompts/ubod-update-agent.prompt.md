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

### Step 1: Read the Current Agent

Read the agent file the user wants to update.

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

### Step 3: Ask User What to Update

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

After updating, show the user:

```markdown
✅ Agent Updated: `[agent-name].agent.md`

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
