---
name: [App Name] [Role]
description: [One-line description of what this agent does and when to use it]
tools: ["read", "search", "execute"]
infer: true
handoffs:
  - label: [Next logical step]
    agent: [Related agent name]
    prompt: |
      [Clear instructions for the next agent]
---

<!--
📖 SCHEMA REFERENCE: projects/ubod/ubod-meta/schemas/agent-schema.md
This template includes optional enforcement sections (CRITICAL GATE, MANDATORY TRIGGER).
Remove sections you don't need for your app-specific agent.
-->

ROLE
[1-2 sentences defining this agent's purpose and expertise]

COMMANDS
Key commands this agent uses:
- `/ubod-update-agent` - Update agent metadata
- `/ubod-bootstrap-app-context` - Generate new agents
- [Add app-specific commands, test runners, etc.]

BOUNDARIES
✅ **Always do:**
- [Action this agent should always take]
- [Another always-do action]

⚠️ **Ask first:**
- [Action requiring user confirmation]
- [Another ask-first action]

🚫 **Never do:**
- [Action this agent must avoid]
- [Another never-do action]

CRITICAL GATE (Optional - Add if bypass causes bugs)
<!-- Add this section if this agent frequently acts without prerequisites.
     Common for Implementer agents that should require approved plans.
     See ubod-meta/docs/workflow-enforcement-patterns.md for examples. -->

🚨 **STOP: Prerequisites required before proceeding**

**Required:**
- [ ] [Specific prerequisite from upstream agent]
- [ ] [User approval signal]
- [ ] [Required context or documentation]

**If missing:** [Action to take - request from other agent, ask user, etc.]

MANDATORY TRIGGER (Optional - Add if this agent is skipped)
<!-- Add this section if changes should always invoke this agent.
     Common for Verifier agents that validate UI or critical paths.
     See ubod-meta/docs/workflow-enforcement-patterns.md for examples. -->

**This agent MUST be invoked for:**
- [Change type 1 that requires this agent]
- [Change type 2 that requires this agent]

**Why mandatory:** [Brief explanation of what bugs occur when skipped]

SCOPE
- [What this agent DOES]
- [What this agent DOES NOT do]
- [When to hand off to another agent]

DOMAIN CONTEXT
- [App-specific patterns this agent should know]
- [Key gotchas for this app/framework]
- [Important integrations or dependencies]

WORKFLOW
1) [First step]
2) [Second step]
3) [Third step]
4) [Continue as needed]
5) [Final step or handoff]

INSTRUCTION FILES
Use these instruction files for detailed methodology:
- `[app]/.copilot/instructions/[app]-architecture.instructions.md`
- `[app]/.copilot/instructions/[app]-critical-gotchas.instructions.md`
- `[app]/.copilot/instructions/[app]-testing.instructions.md`

OUTPUT FORMAT
[Define the expected output structure, e.g.:]
1) What I discovered/implemented/verified
2) Key findings or changes
3) Issues or edge cases
4) Recommendations or next steps
