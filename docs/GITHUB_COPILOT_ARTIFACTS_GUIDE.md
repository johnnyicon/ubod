# GitHub Copilot Artifacts Guide

**A Comprehensive Guide to Skills, Prompts, Agents, and Instructions in GitHub Copilot**

**Last Updated:** 2026-01-21

> **📌 Note:** This guide is specifically for **GitHub Copilot's artifact system**. Other AI coding tools (Claude Code, Cursor, etc.) may organize things differently. The principles (DRY, separation of concerns, progressive disclosure) apply universally, but the specific features (auto-loading via `applyTo`, orchestration via `runSubagent`) are GitHub Copilot-specific.

---

## The Problem This Solves

**Before artifacts, your AI assistance was chaotic:**

```
Scenario: You're building a design system with 10 components.

Without artifacts:
- Copy-paste naming rules into every chat
- Repeat file structure conventions over and over
- AI forgets context between sessions
- Knowledge scattered across 100 chat threads
- Change a convention? Update everywhere manually

Result: 🔥 Inconsistent code, wasted time, tribal knowledge
```

**After artifacts, it's organized:**

```
With artifacts:
- Naming rules live in ONE skill file
- Instructions auto-enforce for component files
- Agents know how to delegate to specialists
- Prompts guide through complex workflows
- Change a convention? Update ONE file

Result: ✅ Consistent code, faster development, documented patterns
```

---

## Why This Guide Exists

If you've ever asked yourself:
- "When should I create a skill vs. an agent?"
- "What's the difference between an instruction and a prompt?"
- "Can agents call other agents? Can prompts?"
- "Why do we have four different artifact types?"

...then this guide is for you.

The short answer: **Most of these boundaries are conventions for human organization, not hard technical constraints.** GitHub Copilot can read any file. But understanding WHY we organize things this way unlocks powerful capabilities like orchestration and automatic enforcement.

---

## Part 1: The Big Picture

### The 30-Second Mental Model

Before diving into details, here's how everything fits together:

```
┌─────────────────────────────────────────────────────────────┐
│ SKILL = Single Source of Truth (Knowledge)                  │
│                                                             │
│ Contains ALL reusable knowledge:                            │
│ - Conventions, patterns, templates                          │
│ - Facts that multiple artifacts need                        │
└─────────────────────────────────────────────────────────────┘
              ↑                    ↑                    ↑
              │ loads              │ loads              │ loads
              │                    │                    │
┌─────────────┴──────┐  ┌─────────┴────────┐  ┌───────┴───────┐
│ INSTRUCTION        │  │ AGENT            │  │ PROMPT        │
│                    │  │                  │  │               │
│ "For these paths,  │  │ "Here's how to   │  │ "Follow these │
│ enforce rules      │  │ do X using       │  │ steps to      │
│ from skill"        │  │ skill knowledge" │  │ complete Y"   │
│                    │  │                  │  │               │
│ (thin reference)   │  │ (workflow only)  │  │ (user-facing) │
└────────────────────┘  └──────────────────┘  └───────────────┘
        │                      │                      │
        ▼                      ▼                      ▼
   AUTO-LOADS            CAN DELEGATE           USER INVOKES
   (by file path)        (via runSubagent)      (directly)
```

**The key insight:** Skills are the knowledge layer. Everything else references skills to stay DRY.

### Quick Reference: What Each Artifact Is

| Artifact | Think of it as... | Key Question |
|----------|------------------|--------------|
| **Skill** | Reference book on your shelf | "What knowledge do I need?" |
| **Instruction** | Auto-pilot rules for this folder | "What rules apply when editing files here?" |
| **Agent** | Expert you can hire | "Who can do this job for me?" |
| **Prompt** | Template/form to fill out | "What steps should I follow for this task?" |

### The Clear Mental Model (Memorize This)

```
SKILL       = Reference book (knowledge anyone can use)
INSTRUCTION = Auto-pilot rules (loads automatically for certain files)
AGENT       = Expert worker (does jobs, can delegate to other experts)
PROMPT      = Step-by-step guide (you follow it directly)
```

### Even Simpler Analogies

If those don't click, try these:

```
SKILL       = Wikipedia article (facts anyone can look up)
INSTRUCTION = Autocorrect (automatically fixes for certain files)
AGENT       = Contractor (you hire them, they can subcontract)
PROMPT      = Recipe (you follow the steps yourself)
```

### Start Simple (For Beginners)

**Don't create all four types at once!** Start with:
1. **Skills** - Document your knowledge
2. **Prompts** - Guide common tasks

Add later when needed:
3. **Agents** - When you need orchestration
4. **Instructions** - When you need automatic enforcement

You can always convert a prompt to an agent or extract knowledge to a skill later.

---

## Part 2: The Critical Distinction (Hard vs. Soft Boundaries)

**This is the most important concept in the entire guide.**

When I first started working with these artifacts, I was confused about what made them different. Could a prompt act like an agent? Could an instruction have a workflow? The answer surprised me.

### The Aha Moment

**Most boundaries between artifacts are conventions for human organization, not hard technical constraints.**

GitHub Copilot can read any file you tell it to. A prompt can load an agent file and "behave like" that agent. GitHub Copilot doesn't prevent this. So why have separate artifacts?

Because of **two hard technical constraints** and **many soft conventions**.

> **🎯 Key Principle: Can vs. Should**
> 
> GitHub Copilot **CAN** read any file and do almost anything.
> These artifacts define what it **SHOULD** do in different situations.
> 
> Think of it like traffic laws:
> - You **CAN** drive through a red light (technically possible)
> - You **SHOULD** stop (the convention that keeps things safe and organized)
> 
> Similarly:
> - A prompt **CAN** load an agent file and copy its behavior
> - You **SHOULD** just use the agent directly (cleaner, more maintainable)

### What This Means in Practice

**Example of a hard boundary:**
```javascript
// This will work:
runSubagent({
  agentName: "Tala Design System",
  prompt: "Check if component exists"
})

// This will NOT work (system error):
runSubagent({
  agentName: "create-prd",  // ❌ This is a prompt, not an agent
  prompt: "Create a PRD"
})
```

**Example of a soft boundary:**
```markdown
# You CAN write this in a skill:
## Workflow
1. Read file X
2. Update field Y
3. Save file X

# But you SHOULD put workflows in agents:
# Agent file
WORKFLOW:
1. Load skill: read_file(".github/skills/my-skill/SKILL.md")
2. Follow conventions from skill
3. Execute task
```

The skill version will "work" but it's harder to maintain and violates conventions.

### Hard Boundaries (System-Enforced)

These are the ONLY things that are technically different:

| Capability | Instruction | Prompt | Agent | Skill |
|------------|:-----------:|:------:|:-----:|:-----:|
| **Auto-loads by file path** | ✅ YES | ❌ No | ❌ No | ❌ No |
| **Can be invoked via `runSubagent`** | ❌ No | ❌ No | ✅ YES | ❌ No |

**Only two hard rules exist:**

1. **Only instructions auto-load** based on `applyTo` file path patterns
   - When you edit a file matching `apps/tala/app/components/**/*`, the relevant instruction is automatically in the LLM's context
   - You don't ask for it. It just happens.

2. **Only agents work with `runSubagent`** for orchestration
   - An agent can call another agent programmatically
   - Prompts cannot be called by other agents
   - This enables multi-agent workflows

### Soft Boundaries (Conventions)

Everything else is convention for organization:

| Boundary | Hard or Soft? | Notes |
|----------|:-------------:|-------|
| Skills contain knowledge, agents contain workflows | SOFT | Convention for organization |
| Prompts are user-facing, agents are expert workers | SOFT | Convention for organization |
| Instructions are thin and reference skills | SOFT | Could be fat, but shouldn't be |
| Skills don't execute actions | SOFT | Could, but shouldn't |

### Why This Matters

Understanding hard vs. soft boundaries helps you:

1. **Make correct architecture decisions** - "I need orchestration" → Must be an agent (hard constraint)
2. **Avoid over-engineering** - "I need enforcement" → Instruction can be thin, just reference skill (soft convention)
3. **Debug issues** - "Why isn't my prompt callable by other agents?" → It can't be (hard constraint)

### The Complete Capabilities Matrix

Here's everything each artifact can and cannot do:

| Capability | Skill | Instruction | Agent | Prompt |
|------------|:-----:|:-----------:|:-----:|:------:|
| Contains reusable knowledge | ✅ Primary purpose | ⚠️ Should reference skill | ⚠️ Should reference skill | ⚠️ Should reference skill |
| Auto-loads by file path | ❌ | ✅ **ONLY ONE** | ❌ | ❌ |
| User can invoke directly | ❌ (loaded by others) | ❌ (auto-loads) | ✅ `@agent-name` | ✅ `/prompt-name` |
| Can be called via `runSubagent` | ❌ | ❌ | ✅ **ONLY ONE** | ❌ |
| Can call other agents | ❌ | ❌ | ✅ | ❌ |
| Has defined workflow/steps | ❌ | ⚠️ Simple rules only | ✅ Primary purpose | ✅ Primary purpose |
| Has identity (role, expertise) | ❌ | ❌ | ✅ | ❌ |
| Has tools defined | ❌ | ❌ | ✅ | ⚠️ Via mode: agent |

**Legend:** ✅ = Yes/Primary | ⚠️ = Possible but not primary | ❌ = No/Cannot

---

## Part 3: Deep Dive Into Each Artifact

Now that you understand the big picture, let's examine each artifact in detail.

### Skills

**Purpose:** Reusable knowledge library that any artifact can reference.

**File Location:** `.github/skills/{skill-name}/SKILL.md`

**Think of it as:** A reference book on your shelf. Anyone can pick it up and read it. The book doesn't do anything by itself—it just contains knowledge.

#### Key Characteristics

- Contains knowledge (facts, patterns, templates, conventions)
- No execution logic—it's passive
- Any artifact can load it via `read_file`
- Single source of truth (DRY principle)
- Structured with progressive disclosure (summary → details → references)

#### When to Create a Skill

| Situation | Create a Skill? | Why |
|-----------|:---------------:|-----|
| Knowledge needed by multiple agents | ✅ Yes | Avoids duplication |
| Conventions that must be consistent everywhere | ✅ Yes | Single source of truth |
| Templates and patterns for reuse | ✅ Yes | Easy to reference |
| Knowledge only one agent needs | ❌ No | Keep in agent |
| One-off task guidance | ❌ No | Use a prompt |

#### Example Structure

```markdown
---
name: tala-design-system
description: Guide for building UI with Tala ViewComponent design system
version: 1.0.0
---

# Tala Design System

## When to Use This Skill
- Creating new ViewComponents
- Updating existing component previews
- Auditing design system compliance

## Quick Reference
[Most commonly needed info - always visible]

## Detailed Conventions
[Full knowledge - loaded when needed]

## Templates
[Copy-paste starting points]
```

#### How Others Use Skills

```markdown
# In an agent:
## WORKFLOW
1. Load design system knowledge:
   read_file(".github/skills/tala-design-system/SKILL.md")
2. Apply conventions from skill
3. Execute task

# In an instruction:
When editing component files:
1. Load skill: read_file(".github/skills/tala-design-system/SKILL.md")
2. Enforce naming conventions from skill
```

#### Progressive Disclosure Pattern

Skills should be structured so the LLM can load just what it needs:

```
Level 1: Skill description (from skills list) - always loaded
         ↓
Level 2: SKILL.md body - loaded when skill is relevant
         ↓
Level 3: references/*.md - loaded on-demand for deep dives
```

---

### Instructions

**Purpose:** Rules that auto-apply when editing certain files.

**File Location:** `.github/instructions/{name}.instructions.md` or `apps/{app}/.copilot/instructions/`

**Think of it as:** Auto-pilot rules. When you enter certain airspace (file paths), these rules automatically engage. You don't turn them on—they just happen.

#### Key Characteristics

- Auto-loads based on `applyTo` file path pattern (**unique capability**)
- User doesn't invoke it explicitly
- Runs in background, always enforcing rules
- Should be thin (reference skills for knowledge)
- Cannot be called by other agents

#### The Auto-Load Behavior (What Makes Instructions Special)

This is the **only** artifact type that auto-loads. Here's how it works:

```yaml
---
applyTo: "apps/tala/app/components/**/*"
---
```

When you edit ANY file matching `apps/tala/app/components/**/*`:
1. This instruction is automatically added to the LLM's context
2. You don't ask for it
3. The rules are enforced without user action

**This is the ONLY hard constraint that instructions have that others don't.**

#### When to Create an Instruction

| Situation | Create an Instruction? | Why |
|-----------|:----------------------:|-----|
| Rules must apply to certain file paths automatically | ✅ Yes | Only instructions auto-load |
| Enforcement shouldn't require user action | ✅ Yes | Auto-loading handles this |
| Path-specific additions to skill knowledge | ✅ Yes | Combine with skill reference |
| Complex workflows | ❌ No | Use an agent |
| One-off tasks | ❌ No | Use a prompt |
| Knowledge without path context | ❌ No | Use a skill |

#### Example Structure (Thin Instruction)

```markdown
---
applyTo: "apps/tala/app/components/**/*"
---

# Component Development Rules

When editing component files, enforce these rules:

1. **Load design system knowledge:**
   read_file(".github/skills/tala-design-system/SKILL.md")

2. **Enforce from skill:**
   - Naming conventions
   - Preview file requirements
   - Prop patterns

3. **Path-specific additions:**
   - All components in this folder use `type:` not `kind:`
   - Preview files go in `test/components/previews/`
```

**Note how thin this is.** The instruction doesn't duplicate knowledge from the skill—it references it. This is the DRY pattern.

---

### Agents

**Purpose:** Expert that can be hired to do a job, including delegating to other experts.

**File Location:** `.github/agents/{name}.agent.md`

**Think of it as:** An expert contractor you can hire. They have a specialty, they know their tools, and they can subcontract to other experts when needed.

#### Key Characteristics

- Has identity (name, role, expertise)
- Has tools defined in frontmatter
- Can call other agents via `runSubagent` (**unique capability**)
- Can be invoked by user (`@agent-name`) or other agents
- Contains workflow logic

#### The runSubagent Capability (What Makes Agents Special)

This is the **only** artifact type that can be called programmatically by other agents:

```javascript
// An orchestrator agent can call specialist agents:
runSubagent({
  agentName: "Tala Design System",
  description: "Check if component exists",
  prompt: "Check if Documents::DrawerComponent has a preview file..."
})

// This ONLY works with agents
// Prompts CANNOT be called via runSubagent
// Skills CANNOT be called via runSubagent
// Instructions CANNOT be called via runSubagent
```

**This enables multi-agent workflows:**

```
User invokes @prd-enricher
        ↓
┌──────────────────────────────────┐
│ PRD Enricher Agent               │
│                                  │
│ 1. Analyze PRD                   │
│ 2. runSubagent("Discovery")      │──→ Discovery Agent
│ 3. runSubagent("UI/UX Designer") │──→ UI/UX Agent ──→ runSubagent("Design System")
│ 4. runSubagent("Verifier")       │──→ Verifier Agent
│ 5. Consolidate results           │
└──────────────────────────────────┘
        ↓
Enriched PRD output
```

#### When to Create an Agent

| Situation | Create an Agent? | Why |
|-----------|:----------------:|-----|
| Task that other agents need to delegate to | ✅ Yes | Only agents work with runSubagent |
| Complex workflow requiring orchestration | ✅ Yes | Agents can manage multi-step work |
| Expert that should be reusable across contexts | ✅ Yes | Can be invoked from anywhere |
| Simple enforcement rules | ❌ No | Use an instruction |
| Passive knowledge | ❌ No | Use a skill |
| One-off user task | ❌ No | Use a prompt (unless orchestration needed) |

#### Example Structure

```yaml
---
name: Tala Design System
description: Create, update, or audit ViewComponent previews
tools: ["read_file", "semantic_search", "grep_search", "replace_string_in_file", "create_file", "run_in_terminal"]
---

# Tala Design System Agent

## ROLE
You are an expert in the Tala ViewComponent design system. You execute
design system workflows: CREATE new previews, UPDATE existing previews,
or AUDIT compliance.

## WORKFLOW

### Step 1: Load Knowledge
read_file(".github/skills/tala-design-system/SKILL.md")

### Step 2: Determine Mode
- CREATE: Generate new preview file
- UPDATE: Modify existing preview
- AUDIT: Check compliance across components

### Step 3: Execute Mode
[Mode-specific steps]

### Step 4: Verify
- Preview renders without errors
- All scenarios covered
- Naming conventions followed

## BOUNDARIES
✅ **Always do:** Load skill first, follow conventions
⚠️ **Ask first:** Major architectural changes
🚫 **Never do:** Skip preview verification
```

---

### Prompts

**Purpose:** Template/form for completing a specific task.

**File Location:** `.github/prompts/{name}.prompt.md`

**Think of it as:** A fill-in-the-blank form or step-by-step checklist. The user follows it directly to complete a task.

#### Key Characteristics

- User invokes directly (`/prompt-name`)
- Guides user through a specific task
- Cannot be called by other agents
- Usually focused on one specific task
- Can load skills for knowledge

#### When to Create a Prompt

| Situation | Create a Prompt? | Why |
|-----------|:----------------:|-----|
| Guided task the user runs directly | ✅ Yes | Prompts are user-facing |
| Fill-in-the-blank style workflows | ✅ Yes | Natural fit |
| One-off tasks that don't need orchestration | ✅ Yes | Simpler than agent |
| Task other agents need to delegate to | ❌ No | Must be agent (runSubagent) |
| Path-based enforcement | ❌ No | Must be instruction (auto-load) |
| Reusable knowledge | ❌ No | Use a skill |

#### Example Structure

```markdown
---
description: Create a new PRD following Tala conventions
mode: agent
---

# Create PRD

I'll help you create a Product Requirements Document.

## Step 1: Gather Information
What feature are you building?

[Wait for user response]

## Step 2: Load Conventions
read_file(".github/skills/prd-authoring/SKILL.md")

## Step 3: Generate PRD
[Apply template from skill]
[Fill in with user's feature]

## Step 4: Verify
- [ ] All required sections present
- [ ] Acceptance criteria are testable
- [ ] Technical approach is clear
```

---

## Part 4: How They Work Together

Now that you understand each artifact individually, let's see how they compose into a complete system.

### The DRY Architecture

The most important architectural principle is **DRY (Don't Repeat Yourself)**. Knowledge should live in ONE place.

#### The Problem: Knowledge Duplication

Without discipline, the same knowledge ends up in multiple places:

```
Skill (323 lines):
  "Component names follow {Namespace}::{Purpose}Component"
  "Previews go in test/components/previews/"
  "Use type: not kind: for prop variants"

Agent (548 lines):
  "Component names follow {Namespace}::{Purpose}Component"  ← DUPLICATE!
  "Previews go in test/components/previews/"                ← DUPLICATE!
  "Use type: not kind: for prop variants"                   ← DUPLICATE!
  [Plus workflow logic]

Instruction (443 lines):
  "Component names follow {Namespace}::{Purpose}Component"  ← TRIPLICATE!
  "Previews go in test/components/previews/"                ← TRIPLICATE!
  "Use type: not kind: for prop variants"                   ← TRIPLICATE!
  [Plus enforcement rules]

TOTAL: 1,314 lines with ~50% duplication!
```

#### The Solution: Skill as Single Source of Truth

```
Skill (323 lines):
  ALL the knowledge lives here:
  - Naming conventions
  - File locations
  - Prop patterns
  - Templates

Agent (150 lines):
  WORKFLOW only:
  1. read_file(".github/skills/tala-design-system/SKILL.md")
  2. Apply conventions from skill
  3. Execute task

Instruction (50 lines):
  THIN reference:
  1. read_file(".github/skills/tala-design-system/SKILL.md")
  2. Enforce rules from skill for these paths

TOTAL: 523 lines with 0% duplication!
```

### Common Patterns

#### Pattern 1: Skill + Instruction + Agent (Full Stack)

**Use when:** Knowledge needs enforcement AND orchestration

```
┌─────────────────────────────────────────────┐
│ SKILL: tala-design-system                   │
│ Contains: All ViewComponent knowledge       │
└─────────────────────────────────────────────┘
        ↑                           ↑
        │ loads                     │ loads
        │                           │
┌───────┴───────┐           ┌───────┴───────┐
│ INSTRUCTION   │           │ AGENT         │
│               │           │               │
│ Auto-enforces │           │ Executes      │
│ for component │           │ CREATE/UPDATE │
│ files         │           │ workflows     │
└───────────────┘           └───────────────┘
```

**Real example:**
- Skill: `tala-design-system` (all knowledge)
- Instruction: `tala-viewcomponents.instructions.md` (enforces when editing components)
- Agent: `Tala Design System` (creates/updates previews on demand)

#### Pattern 2: Skill + Agent (No Auto-Enforcement)

**Use when:** Knowledge needs orchestration but not path-based enforcement

```
┌─────────────────────────────────────────────┐
│ SKILL: prd-authoring                        │
│ Contains: PRD templates, conventions        │
└─────────────────────────────────────────────┘
        ↑
        │ loads
        │
┌───────┴───────┐
│ AGENT         │
│               │
│ PRD Writer    │
│ (creates PRDs │
│ on demand)    │
└───────────────┘

No instruction needed—PRD creation is on-demand, not path-triggered.
```

#### Pattern 3: Skill + Instruction (Enforcement Only)

**Use when:** Need automatic enforcement but no complex workflows

```
┌─────────────────────────────────────────────┐
│ SKILL: code-style                           │
│ Contains: Formatting, naming, patterns      │
└─────────────────────────────────────────────┘
        ↑
        │ loads
        │
┌───────┴───────┐
│ INSTRUCTION   │
│               │
│ Auto-enforces │
│ style rules   │
│ for all files │
└───────────────┘

No agent needed—just enforcement, no complex workflows.
```

#### Pattern 4: Prompt + Skill (Simple User Task)

**Use when:** User-facing task that doesn't need orchestration

```
┌─────────────────────────────────────────────┐
│ SKILL: git-workflow                         │
│ Contains: Branch naming, commit conventions │
└─────────────────────────────────────────────┘
        ↑
        │ loads
        │
┌───────┴───────┐
│ PROMPT        │
│               │
│ /create-pr    │
│ (guides user  │
│ through PR    │
│ creation)     │
└───────────────┘

No agent needed—simple guided task, no orchestration.
```

### Agent Orchestration in Detail

One of the most powerful patterns is multi-agent orchestration:

```
User: "@prd-enricher Enrich my PRD with design system context"
        │
        ▼
┌──────────────────────────────────────────────────────────────────┐
│ PRD Enricher Agent (Orchestrator)                                │
│                                                                  │
│ Step 1: Load context                                             │
│   read_file(".github/agents/AGENT_INDEX.md")                     │
│   read_file("prds/tala/my-feature/01_prd.md")                    │
│                                                                  │
│ Step 2: Invoke Discovery Agent                                   │
│   runSubagent({                                                  │
│     agentName: "Tala Discovery Planner",                         │
│     description: "Analyze codebase for PRD context",             │
│     prompt: "Find existing patterns for [feature]..."            │
│   })                                                             │
│                                                                  │
│ Step 3: Invoke UI/UX Designer                                    │
│   runSubagent({                                                  │
│     agentName: "Tala UI/UX Designer",                            │
│     description: "Design UI approach",                           │
│     prompt: "Design component approach for [feature]..."         │
│   })                                                             │
│     │                                                            │
│     └──→ UI/UX Designer internally calls:                        │
│           runSubagent({                                          │
│             agentName: "Tala Design System",                     │
│             description: "Verify components exist",              │
│             prompt: "Check if needed components exist..."        │
│           })                                                     │
│                                                                  │
│ Step 4: Invoke Verifier                                          │
│   runSubagent({                                                  │
│     agentName: "Tala Verifier",                                  │
│     description: "Verify enrichment quality",                    │
│     prompt: "Check PRD enrichment for gaps..."                   │
│   })                                                             │
│                                                                  │
│ Step 5: Consolidate and output enriched PRD                      │
└──────────────────────────────────────────────────────────────────┘
        │
        ▼
Enriched PRD with design system context
```

**Key insight:** This orchestration is ONLY possible because agents can call other agents via `runSubagent`. If these were prompts, this workflow would be impossible.

---

## Part 5: Avoiding Common Mistakes

### Mistake 1: Duplicating Knowledge

**Wrong:**
```markdown
# Agent file
Component names follow {Namespace}::{Purpose}Component...
[50 lines of conventions copied from skill]

## WORKFLOW
1. Apply conventions above
```

**Right:**
```markdown
# Agent file
## WORKFLOW
1. Load knowledge:
   read_file(".github/skills/tala-design-system/SKILL.md")
2. Apply conventions from skill
```

### Mistake 2: Fat Instructions

**Wrong:**
```markdown
# Instruction file (400 lines)
---
applyTo: "apps/tala/app/components/**/*"
---

## Naming Conventions
[100 lines of conventions]

## Preview Requirements
[100 lines of requirements]

## Templates
[200 lines of templates]
```

**Right:**
```markdown
# Instruction file (30 lines)
---
applyTo: "apps/tala/app/components/**/*"
---

When editing component files:
1. Load skill: read_file(".github/skills/tala-design-system/SKILL.md")
2. Enforce conventions from skill
3. Ensure preview file exists per skill requirements
```

### Mistake 3: Using Prompts When Agents Are Needed

**Wrong:**
```markdown
# prompt file
I need other agents to call this...
```

This will never work. Prompts cannot be called via `runSubagent`.

**Right:**
```markdown
# agent file
---
name: My Specialist
---
[Now it can be called by other agents]
```

### Mistake 4: Using Agents When Prompts Are Sufficient

**Wrong:**
```yaml
# Agent file for simple one-off task
---
name: Create README
tools: ["create_file"]
---
Creates a README file.
```

If no orchestration is needed, this is overkill.

**Right:**
```markdown
# Prompt file
---
description: Create a README file
---
I'll help you create a README. What's the project name?
```

### Mistake 5: Skipping Skills for "Simple" Knowledge

**Wrong:**
```markdown
# Agent 1
Use type: not kind: for variants

# Agent 2
Use type: not kind: for variants

# Instruction
Use type: not kind: for variants
```

Even "simple" knowledge that appears in multiple places should be in a skill.

**Right:**
```markdown
# Skill
## Prop Conventions
Use `type:` not `kind:` for variants

# Agent 1, Agent 2, Instruction
read_file(".github/skills/tala-design-system/SKILL.md")
```

---

## Part 6: Decision Guide

Use these tables when deciding which artifact to create.

### Quick Decision Tree

```
Do I need this knowledge in multiple places?
├── YES → Create a SKILL (single source of truth)
│         Then decide how it's consumed:
│         ├── Needs auto-enforcement for file paths? → INSTRUCTION references skill
│         ├── Needs orchestration/delegation? → AGENT references skill
│         └── Simple user-facing task? → PROMPT references skill
│
└── NO → Does it need auto-loading by file path?
         ├── YES → INSTRUCTION (only option)
         └── NO → Does it need orchestration (called by other agents)?
                  ├── YES → AGENT (only option)
                  └── NO → PROMPT (simplest option)
```

### Decision Matrix

| If you need... | Use this | Example | Why this and not others |
|----------------|----------|---------|-------------------------|
| Knowledge reused by multiple artifacts | **Skill** | "Component naming rules" used by 3 agents | Update once, fixes everywhere |
| Auto-enforcement when editing certain files | **Instruction** | "Check for preview file when saving component" | Only instructions auto-load by path |
| A task other agents can delegate to | **Agent** | "Design System agent" called by UI/UX Designer | Only agents work with runSubagent |
| Complex multi-step workflow with orchestration | **Agent** | PRD Enricher calls Discovery → UI/UX → Verifier | Agents can call other agents |
| Simple guided task user runs directly | **Prompt** | "/create-readme" guides through README creation | Simpler than agent when no orchestration |
| Path-specific rules that reference a skill | **Instruction** | "Enforce design system for app/components/**/*" | Thin reference + auto-load |
| Reusable expert with identity | **Agent** | "Tala Verifier" (role: QA specialist) | Agents have name, role, expertise |

### The "Which Artifact?" Checklist

Ask these questions in order:

1. **Is this knowledge that multiple things need?**
   - Yes → Create a SKILL first
   - No → Continue

2. **Does it need to auto-load when editing certain files?**
   - Yes → Must be INSTRUCTION (hard constraint)
   - No → Continue

3. **Do other agents need to call this?**
   - Yes → Must be AGENT (hard constraint)
   - No → Continue

4. **Is it a complex workflow with multiple steps?**
   - Yes → Probably AGENT
   - No → Probably PROMPT

---

## Part 7: When NOT to Create an Artifact

Sometimes the answer is "just put it in code comments" or "keep it in one place":

### Don't Over-Engineer

| Situation | ❌ Don't Create | ✅ Do Instead |
|-----------|----------------|---------------|
| One-off fact used in one place | A skill | Code comment or inline doc |
| Simple task user can do in one prompt | An agent | A simple prompt (or no artifact) |
| Rule for one specific file | An instruction | Code comment or local doc |
| Knowledge used by only one agent | A skill | Keep in agent file |
| Workflow with no sub-tasks | An agent | A prompt (simpler) |
| Enforcement for non-path reason | An instruction | Manual review or linting |

### Decision Rules

**Create a skill when:**
- ✅ Knowledge used in 2+ places
- ✅ Conventions that must be consistent
- ✅ Templates for reuse

**Don't create a skill when:**
- ❌ Used in only one place
- ❌ One-off fact
- ❌ Tightly coupled to one workflow

**Create an agent when:**
- ✅ Other agents need to call it
- ✅ Complex multi-step workflow
- ✅ Needs to delegate to specialists

**Don't create an agent when:**
- ❌ Simple one-step task
- ❌ User can do it in one prompt
- ❌ No orchestration needed (use prompt)

**Create an instruction when:**
- ✅ Must apply to file path pattern
- ✅ Automatic enforcement needed
- ✅ No user action desired

**Don't create an instruction when:**
- ❌ Only applies to one file
- ❌ User should opt-in (use prompt)
- ❌ No path-based trigger

**Create a prompt when:**
- ✅ User-facing guided task
- ✅ Fill-in-the-blank workflow
- ✅ No orchestration needed

**Don't create a prompt when:**
- ❌ Agents need to call it (use agent)
- ❌ Needs path-based trigger (use instruction)
- ❌ Just one question (use inline)

---

## Part 8: Frequently Asked Questions

These questions came from real confusion while learning the system.

### Fundamental Questions

#### Q: Can a prompt load an agent file and act like an agent?

**Technically yes.** The LLM will read any file you tell it to. If a prompt says "read this agent file and behave like it," the LLM will try.

**But don't do this.** Here's why:
1. The prompt still won't be callable via `runSubagent` (hard constraint)
2. It creates confusion about what artifact you're actually using
3. If you need agent capabilities, just make it an agent

#### Q: Why have separate artifacts if the LLM can read anything?

**Organization and capabilities:**

1. **Skills** keep knowledge in one place (DRY)
2. **Instructions** auto-load (unique capability)
3. **Agents** enable orchestration (runSubagent)
4. **Prompts** provide simple user-facing guides

Without these boundaries, you'd have:
- Knowledge duplicated everywhere
- No automatic enforcement
- No multi-agent workflows
- Confusion about what does what

#### Q: What's the actual technical difference between them?

| | Technical Reality |
|---|---|
| **File contents** | All are markdown files the LLM can read |
| **File location** | Convention-based (`.github/agents/`, `.github/prompts/`, etc.) |
| **Frontmatter** | Different schemas (agents have `tools`, instructions have `applyTo`) |
| **System behavior** | Instructions auto-load; agents work with runSubagent |

**The two hard differences:**
1. Instructions auto-load based on `applyTo` path
2. Agents can be invoked via `runSubagent`

Everything else is convention.

### Practical Questions

#### Q: When should I create a skill vs. put knowledge in an agent?

**Create a skill when:**
- Multiple agents or instructions need the same knowledge
- The knowledge should be consistent everywhere
- You want to avoid duplication
- It's reference material (conventions, templates, patterns)

**Keep in agent when:**
- Only this one agent needs the knowledge
- It's tightly coupled to the workflow logic
- It would be awkward to separate

**Rule of thumb:** If you copy-paste the same knowledge into a second artifact, extract it to a skill.

#### Q: Can instructions call runSubagent?

**No.** Instructions are for enforcement rules, not workflows. They auto-load and apply rules. If you need orchestration, use an agent.

Think of it this way:
- Instructions are **reactive** (triggered by file edits)
- Agents are **active** (execute workflows)

#### Q: Can I have an instruction that also has a workflow?

**Technically you could write one**, but by convention you shouldn't. Instructions should be thin:

```markdown
# Good instruction (thin)
When editing these files:
1. Load skill
2. Enforce rules from skill

# Bad instruction (fat with workflow)
When editing these files:
1. Do step A
2. Do step B
3. Do step C
4. Make decision D
5. If X then Y else Z
...
```

If you need a workflow, make an agent. Have the instruction just reference the skill.

#### Q: How do I know if I need an agent or just a prompt?

Ask: **"Do other agents need to call this?"**

- Yes → Must be an agent (only agents work with runSubagent)
- No → Could be either, but prompt is simpler

Also ask: **"Is this a complex orchestration?"**

- Yes → Agent (can manage multi-step work, call specialists)
- No → Prompt (simpler, user-facing)

#### Q: Should skills have workflows?

**No.** Skills are passive knowledge. They're the reference book, not the worker.

If you find yourself writing "Step 1, Step 2, Step 3" in a skill, you're probably writing an agent.

**Skills contain:**
- Conventions
- Templates
- Patterns
- Facts
- Reference information

**Skills don't contain:**
- Workflows
- Decision logic
- Execution steps

### Architecture Questions

#### Q: How thin should instructions be?

**As thin as possible.** The ideal instruction:

```markdown
---
applyTo: "path/to/files/**/*"
---

When editing these files:
1. Load skill: read_file(".github/skills/relevant-skill/SKILL.md")
2. Enforce conventions from skill
3. [Maybe 1-2 path-specific additions]
```

If your instruction is over 50 lines, you're probably duplicating knowledge that should be in a skill.

#### Q: How do I structure a skill for progressive disclosure?

```
SKILL.md (Level 1 + 2)
├── Frontmatter (name, description) - always visible in skill list
├── When to Use - quick trigger guidance
├── Quick Reference - most common needs
├── Detailed Sections - full knowledge
└── references/ (Level 3)
    ├── templates.md - loaded on demand
    └── advanced.md - loaded on demand
```

The LLM loads Level 1 (skill list) first, then Level 2 (SKILL.md body) when relevant, then Level 3 (references) only when needed.

#### Q: Can an agent be both an orchestrator and a specialist?

**Yes, but be careful.** An agent can:
- Do work itself
- Call other agents to help

But if an agent does too much, it becomes hard to reuse. Consider splitting:
- Orchestrator agent (coordinates work)
- Specialist agents (do specific work)

### Debugging Questions

#### Q: My instruction isn't loading. Why?

Check:
1. **File location:** Is it in `.github/instructions/` or an app's `.copilot/instructions/`?
2. **`applyTo` pattern:** Does your file path match the glob pattern?
3. **Frontmatter syntax:** Is the YAML valid?

**Common mistake:** Using `**/*.rb` when you meant `apps/tala/**/*.rb`

#### Q: My agent isn't being called by runSubagent. Why?

Check:
1. **Name match:** Does the `agentName` exactly match the `name` in frontmatter?
2. **File location:** Is it in `.github/agents/`?
3. **Is it actually an agent?** (Has `name` in frontmatter)

**Common mistake:** Trying to call a prompt via runSubagent (impossible)

#### Q: Knowledge isn't consistent across agents. Why?

**You have duplication.** Each agent has its own copy that drifted.

**Fix:**
1. Extract knowledge to a skill
2. Have all agents load the skill
3. Update knowledge in ONE place

---

## Part 9: Summary

### The Complete Picture (GitHub Copilot Artifacts)

**Remember:** This is specific to GitHub Copilot. Other AI tools organize differently.

| Artifact | File Location | Invocation | Unique Capability | Best For |
|----------|---------------|------------|-------------------|----------|
| **Skill** | `.github/skills/{name}/SKILL.md` | Loaded by others | Single source of truth | Reusable knowledge |
| **Instruction** | `.github/instructions/` | Auto-loads | `applyTo` path matching | Path-based enforcement |
| **Agent** | `.github/agents/` | `@name` or `runSubagent` | Orchestration | Complex workflows |
| **Prompt** | `.github/prompts/` | `/name` | User-facing | Simple guided tasks |

### The Two Hard Constraints

1. **Only instructions auto-load** based on `applyTo` file paths
2. **Only agents work with `runSubagent`** for orchestration

Everything else is convention for organization.

### The DRY Architecture

```
SKILL = Knowledge (single source of truth)
   ↑
   └── Everyone loads skills for knowledge

INSTRUCTION = Thin enforcement (references skill)
AGENT = Workflow logic (references skill)
PROMPT = User guide (references skill)
```

### Key Takeaways

1. **Skills are the knowledge layer.** Everything else references them.
2. **Instructions auto-load.** Use them for path-based enforcement.
3. **Agents enable orchestration.** Use them when you need delegation.
4. **Prompts are user-facing.** Use them for simple guided tasks.
5. **Keep instructions thin.** Reference skills, don't duplicate.
6. **Most boundaries are conventions.** The hard constraints are auto-load and runSubagent.

---

**Remember:** The goal is organized, maintainable AI assistance. Skills prevent duplication. Instructions provide automatic enforcement. Agents enable orchestration. Prompts guide users. Together, they create a system where knowledge is consistent and capabilities are clear.
