# Ubod Architecture: Agents + Instructions

**Purpose:** Explain how agents and instructions work together in the Ubod framework.

---

## The Mental Model

```
┌─────────────────────────────────────────────────────────────────┐
│                        INSTRUCTIONS                              │
│                    (The "Kernel" / Constitution)                 │
│                                                                  │
│  • Always-on rules, auto-injected via applyTo scope             │
│  • Repo conventions, architecture patterns, guardrails          │
│  • Single source of truth for durable rules                     │
│  • Like .editorconfig or rubocop.yml for AI behavior            │
│                                                                  │
│  Examples:                                                       │
│  - discovery-methodology.instructions.md (always verify first)  │
│  - tala-critical-gotchas.instructions.md (Rails + Hotwire)      │
│  - verification-checklist.instructions.md (universal)           │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ Auto-loaded based on
                              │ applyTo scope matching
                              │ current context
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          AGENTS                                  │
│                   (Roles + Workflows + Tool Gates)               │
│                                                                  │
│  • Temporary job roles with specific permissions                │
│  • Define workflow sequence (plan → implement → verify)         │
│  • Control tool access (read-only vs edit-capable)              │
│  • Specify output format (plan template, QA script)             │
│  • Thin descriptions because instructions provide depth         │
│                                                                  │
│  Examples:                                                       │
│  - Discovery Planner (read/search only, outputs plan)           │
│  - Implementer (edit/execute, small diffs, runs tests)          │
│  - Verifier (execute, runtime QA, validates behavior)           │
│  - UI/UX Designer (read/search, architecture decisions)         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Distinction

### Instructions = Static Policy/Config

**What they are:**
- Long-lived rules that apply regardless of which agent is active
- Scoped by `applyTo` patterns (file paths, extensions)
- Automatically injected when relevant context is in scope

**Put it in instructions if it is:**
- ✅ Long-lived
- ✅ Applies to many tasks
- ✅ Architecture/pattern related
- ✅ A constraint enforced regardless of agent

**Examples:**
```yaml
# Loads when working in apps/tala/**
applyTo: "apps/tala/**/*"
# Contains: Rails patterns, Hotwire gotchas, testing conventions
```

### Agents = Runtime Mode

**What they are:**
- Temporary job assignments with specific permissions
- Define workflow (sequence of steps)
- Control tool access (what the agent can do)
- Specify output format (what the agent produces)

**Put it in an agent if it is:**
- ✅ About phase ("don't edit" vs "edit")
- ✅ About tool permissions
- ✅ About output format (plan template, QA script)
- ✅ About escalation/stopping conditions

**Examples:**
```yaml
# Discovery Planner
tools: ["read", "search"]  # Cannot edit
output: Implementation plan with checkpoints
handoffs:
  - label: Implement this plan
    agent: Implementer
```

---

## How They Work Together

### Instructions Load Based on Scope

Instructions don't load because an agent "touches" files. They load because:

1. You're operating in certain paths (e.g., `apps/tala/**`)
2. Copilot's context includes files matching `applyTo` patterns
3. The matching instructions are auto-injected

**Example flow:**
```
User asks: "Fix the document drawer in Tala"

Context includes: apps/tala/app/components/documents/drawer_component.rb

Instructions auto-loaded:
- tala-critical-gotchas.instructions.md (applyTo: apps/tala/**/*.rb)
- tala-viewcomponents.instructions.md (applyTo: apps/tala/app/components/**)
- verification-checklist.instructions.md (applyTo: **/*)

These provide the rules; the agent provides the workflow.
```

### Agents Stay Thin

Because instructions provide the depth (conventions, patterns, gotchas), agents can focus on:

- **Workflow:** What sequence of steps to follow
- **Permissions:** What tools are allowed
- **Output:** What format to produce
- **Handoffs:** When to pass to another agent

**Agent body focuses on:**
```markdown
ROLE
[1-2 sentences defining purpose]

SCOPE
- What this agent does
- What this agent doesn't do

WORKFLOW
1) First step
2) Second step
3) Third step

OUTPUT FORMAT
[Expected output structure]
```

---

## Standard Agent Types

### 1. Discovery Planner

**Purpose:** Investigate and plan before any code changes

**Permissions:** Read + Search only (no edits)

**Output:** Implementation plan with checkpoints

**When to use:** Starting a new feature, investigating a bug

### 2. Implementer

**Purpose:** Write code following a verified plan

**Permissions:** Read + Search + Edit + Execute

**Output:** Code changes + test runs

**When to use:** After discovery/planning is complete

### 3. Verifier

**Purpose:** Validate that implementation actually works

**Permissions:** Read + Search + Execute

**Output:** QA script results, test evidence

**When to use:** After implementation, before declaring complete

### 4. UI/UX Designer (Optional)

**Purpose:** Design UI architecture before implementation

**Permissions:** Read + Search only (no edits)

**Output:** Architecture approach, gotchas list, implementation checklist

**When to use:** Complex UI frameworks (Rails+Hotwire, Next.js+RSC, Vue+Nuxt)

---

## Best Practices

### ✅ Do

- Centralize durable rules in instructions
- Keep agents thin (workflow + permissions + output)
- Use `applyTo` scoping to prevent instruction overload
- Share instructions across all agents for consistency

### ❌ Don't

- Repeat the same rule in 4 places
- Put architecture rules only in one agent (others will ignore them)
- Create conflicting rules between agents and instructions
- Make agent descriptions verbose when instructions cover it

### Exception: Mission-Critical Rules

Some rules are so important they should appear in both:

```markdown
# In agent:
"Discovery Planner does NOT edit files"

# In instructions:
"Planners are read-only. Never edit during discovery phase."
```

This redundancy is intentional for hard safety boundaries.

---

## File Organization

```
.github/
├── agents/                    # Agent definitions (thin, workflow-focused)
│   ├── tala-discovery-planner.agent.md
│   ├── tala-implementer.agent.md
│   ├── tala-verifier.agent.md
│   └── tala-ui-ux-designer.agent.md  # Optional
│
├── instructions/              # Always-on rules (kernel)
│   ├── discovery-methodology.instructions.md
│   ├── verification-checklist.instructions.md
│   ├── stuck-detection.instructions.md
│   └── tala/                  # App-specific
│       ├── tala-critical-gotchas.instructions.md
│       └── tala-patterns.instructions.md
│
└── prompts/                   # One-time workflows
    └── ubod/
        ├── ubod-update-agent.prompt.md
        └── ubod-bootstrap-app-context.prompt.md
```

---

## Summary

| Aspect | Instructions | Agents |
|--------|--------------|--------|
| **Longevity** | Permanent rules | Task-specific roles |
| **Scope** | Via `applyTo` patterns | Active during invocation |
| **Content** | Conventions, patterns, guardrails | Workflow, permissions, output |
| **Verbosity** | Can be detailed | Should be thin |
| **Loading** | Auto-injected by context | Explicitly invoked |

**The key insight:** Instructions are the constitution; agents are job assignments. Keep rules in instructions, keep workflows in agents.
