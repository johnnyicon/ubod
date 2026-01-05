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

ROLE
[1-2 sentences defining this agent's purpose and expertise]

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
