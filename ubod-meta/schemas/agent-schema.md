# Agent Schema (Canonical Definition)

**Version:** 1.0  
**Last Updated:** 2026-01-06  
**Status:** ✅ CANONICAL - This is the single source of truth for agent structure

---

## Purpose

This document defines the canonical structure for all agent files (`.agent.md`) in the ubod framework and consuming repositories. All spec files, templates, and documentation MUST reference this file instead of duplicating the schema.

---

## Required Frontmatter

```yaml
---
name: [Agent Name]                    # REQUIRED: Exact agent name (case-sensitive)
description: [One-line description]    # REQUIRED: When to use this agent
tools: ["read", "search", ...]        # REQUIRED: Tool aliases (see Tool Aliases section)
infer: true                           # OPTIONAL: Let LLM choose tools dynamically
handoffs:                             # OPTIONAL: List of agent handoffs
  - label: [Handoff label]
    agent: [Target agent name]
    prompt: "Single-line prompt"      # MUST be single-line string
---
```

### Frontmatter Rules

1. **name:** Must match agent filename (e.g., `name: Debug Stuck` for `debug-stuck.agent.md`)
2. **tools:** Use standard aliases only (see Tool Aliases section below)
3. **handoffs.prompt:** MUST be single-line string (no multiline `|` syntax)
4. **handoffs.agent:** Must match target agent's `name` field exactly (case-sensitive)

---

## Required Body Sections (In Order)

All agents MUST include these sections in this exact order:

### 1. Agent Title (H1)

```markdown
# [Agent Name] Agent

**Purpose:** [One-line purpose statement]

**When to Use:** [Clear trigger conditions]
```

### 2. ROLE (H2)

```markdown
## ROLE

[1-3 sentences defining the agent's core responsibility and expertise]
```

**Rules:**
- Must be concise (1-3 sentences)
- Defines WHO the agent is
- No lists, just prose

### 3. COMMANDS (H2)

```markdown
## COMMANDS

- **[Command Name]:** [What it does]
- **[Command Name]:** [What it does]
- [Add 3-7 key commands the agent uses]
```

**Rules:**
- Bullet list with bold command names
- 3-7 items (not exhaustive, just key commands)
- Can include tool invocations, prompts, or actions
- First section after ROLE for visibility

### 4. BOUNDARIES (H2)

```markdown
## BOUNDARIES

✅ **Always do:**
- [Action this agent should always take]
- [Another always-do action]

⚠️ **Ask first:**
- [Action requiring user confirmation]
- [Another ask-first action]

🚫 **Never do:**
- [Action this agent must avoid]
- [Another never-do action]
```

**Rules:**
- MUST use emoji icons: ✅ ⚠️ 🚫
- Three subsections (order: Always → Ask → Never)
- Each subsection: 1-5 items
- Immediately after COMMANDS for visibility

### 5. SCOPE (H2)

```markdown
## SCOPE

**What I [verb]:**
- [Specific area 1]
- [Specific area 2]
- [Specific area 3]

**What I do NOT [verb]:**
- [Out-of-scope area 1]
- [Out-of-scope area 2]
```

**Rules:**
- Two subsections: positive and negative scope
- Use consistent verb (do, maintain, verify, etc.)
- Clear boundaries between this agent and others

### 6. WORKFLOW (H2)

```markdown
## WORKFLOW

1. **[Step 1]** - [Description]
2. **[Step 2]** - [Description]
3. **[Step 3]** - [Description]
4. [Continue as needed]
5. **[Final step]** - [Description or handoff]
```

**Rules:**
- Numbered list
- Bold step names
- Brief description for each step
- Represents typical execution flow
- Include handoff points if applicable

### 7. DOMAIN CONTEXT (H2) - OPTIONAL

```markdown
## DOMAIN CONTEXT

### [Subsection 1]

[Content]

### [Subsection 2]

[Content]
```

**Rules:**
- Use for framework-specific knowledge, patterns, gotchas
- Can contain tables, lists, code examples
- Subsections as needed (H3)
- This is the "catch-all" for additional context

---

## Optional Body Sections

These sections can be added ANYWHERE after the required sections (typically in DOMAIN CONTEXT or as standalone H2):

### CRITICAL GATE (Optional Enforcement)

```markdown
## CRITICAL GATE

🚨 **STOP: [Gate condition]**

**Required before proceeding:**
- [ ] [Prerequisite 1]
- [ ] [Prerequisite 2]
- [ ] [User approval signal]

**If prerequisites not met:** [Action to take]

**If prerequisites met:** [Proceed guidance]
```

**When to use:** When this agent should NOT proceed without specific prerequisites (e.g., Implementer needs approved plan)

### MANDATORY TRIGGER (Optional Enforcement)

```markdown
## MANDATORY TRIGGER

⚠️ **This agent MUST be invoked for:**
- [Change type 1]
- [Change type 2]
- [Change type 3]

**Why mandatory:** [Explanation of what bugs occur when skipped]

**If this agent is NOT invoked:** [Risk statement]
```

**When to use:** When certain change types REQUIRE this agent (e.g., UI changes must trigger Verifier)

### EXPECTED DELIVERABLES (Optional Handoff Contract)

```markdown
## EXPECTED DELIVERABLES

**What I produce for [Downstream Agent]:**
1. **[Deliverable Category]**
   - [Specific item]
   - [Another item]

2. **[Another Category]**
   - [Specific item]

**[Downstream Agent] should NOT proceed without all items.**
```

**When to use:** When handoff clarity is needed (e.g., Discovery Planner → Implementer)

---

## Tool Aliases (Canonical List)

### Standard Tool Aliases

| Alias | Internal Names | Category | Purpose |
|-------|----------------|----------|---------|
| `read` | Read, NotebookRead | View tools | Read file contents |
| `edit` | Edit, MultiEdit, Write, NotebookEdit | Edit tools | Modify files |
| `search` | Grep, Glob | Search tools | Search files or text |
| `execute` | shell, Bash, powershell | Shell tools | Execute terminal commands |
| `agent` | custom-agent, Task | Agent tools | Invoke other custom agents |
| `web` | WebSearch, WebFetch | Web tools | Fetch URLs (NOT in coding agent) |
| `todo` | TodoWrite | Task tools | Manage task lists (VS Code only) |

### Rules

- **Always use lowercase:** `["read", "edit", "search"]`
- **Never use internal names:** ❌ `read_file`, `grep_search`, `create_file`
- **Wildcards allowed:** `["*"]` enables all available tools
- **Empty list:** `[]` disables all tools

---

## Section Ordering Rules

**MANDATORY ORDER:**

1. **Frontmatter** (YAML)
2. **Agent Title** (H1)
3. **ROLE** (H2)
4. **COMMANDS** (H2)
5. **BOUNDARIES** (H2)
6. **SCOPE** (H2)
7. **WORKFLOW** (H2)
8. **DOMAIN CONTEXT** (H2) - Optional
9. **Optional sections** (CRITICAL GATE, MANDATORY TRIGGER, EXPECTED DELIVERABLES, etc.)

**Rationale:**
- COMMANDS/BOUNDARIES appear first after ROLE for maximum visibility
- Standard sections before optional/enforcement sections
- DOMAIN CONTEXT is catch-all for additional content

---

## Validation Rules

### Frontmatter Validation

```bash
# Check tools use standard aliases (not internal names)
grep -E 'tools:.*_(file|string|search)' *.agent.md
# Expected: No matches

# Check handoffs are single-line
grep -n "prompt: |" *.agent.md
# Expected: No matches
```

### Body Section Validation

```bash
# Check all required sections exist
grep -E "^## (ROLE|COMMANDS|BOUNDARIES|SCOPE|WORKFLOW)" [agent-file].agent.md
# Expected: 5 matches (one per required section)

# Check BOUNDARIES uses emoji format
grep -E "^(✅|⚠️|🚫)" [agent-file].agent.md
# Expected: 3 matches (one per subsection)
```

---

## Schema Evolution

**When updating this schema:**

1. Update this file (canonical definition)
2. Update JSON Schema (`agent-schema.json`)
3. Update spec files to reference new version
4. Create migration if breaking
5. Update CHANGELOG
6. Run validation across all agents

**DO NOT update schemas in multiple places - only here!**

---

## References

This schema is referenced by:

- `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md`
- `ubod-meta/instructions/github-custom-agent-spec.instructions.md`
- `templates/agents/*.agent.md` (all agent templates)
- Migration files
- Ubod Maintainer agent (for validation)

**When in doubt, refer to this file.**

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-06 | Initial canonical schema (consolidates vscode/github specs) |

---

**Remember:** This is the ONLY place agent schema is defined. All other files reference this.
