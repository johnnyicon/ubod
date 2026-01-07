---
name: ubod-generate-complexity-matrix
description: "Generate app-specific complexity signals for model selection guidance"
---

# Generate App Complexity Matrix

You are creating an app-specific complexity signals file that extends the universal `task-complexity-signals.instructions.md`.

**Your role:** Analyze the app's tech stack and codebase to define framework-specific complexity indicators.

---

## Pre-Flight: Gather Stack Information

Before generating, collect this context:

### 1. Read Key Files

```
# Package/dependency files
Gemfile / package.json / requirements.txt / go.mod

# Configuration
config/routes.rb / app router structure / etc.

# Sample code
A controller, a model, a service, a component
```

### 2. Answer These Questions

```markdown
## Stack Analysis

**Backend Framework:** [Name and version]
**Frontend Framework:** [Name and version]
**Database:** [Type]
**Real-time:** [Technology if any]
**Background Jobs:** [Technology if any]
**Testing:** [Framework and tools]

**Key "Magic" in this stack:**
1. [Framework magic 1 - e.g., "Rails callbacks"]
2. [Framework magic 2 - e.g., "React hooks rules"]
3. [Framework magic 3 - e.g., "ORM lazy loading"]

**Common Integration Points:**
1. [Integration 1 - e.g., "Controller → Service → Job"]
2. [Integration 2 - e.g., "Component → API → State"]
```

---

## Template: App Complexity Signals

Generate this file at: `[app]/.copilot/instructions/[app]-complexity-signals.instructions.md`

```markdown
---
applyTo: "[app]/**/*"
---

# [App Name] Complexity Signals

**Purpose:** Stack-specific complexity indicators for [App Name]

**Extends:** `universal/task-complexity-signals.instructions.md`

---

## Stack Overview

**Backend:** [Framework] [Version]
**Frontend:** [Framework] [Version]
**Database:** [Type]
**Key Libraries:** [List important ones]

---

## Framework-Specific Complexity Levels

### [Backend Framework] Conventions

**Surface Level (Simple):**
- [Simple pattern specific to this framework]
- [Another simple pattern]
- [Example from codebase if available]

**Medium Level (Some Magic):**
- [Medium complexity pattern]
- [Pattern that needs verification]
- [Example from codebase if available]

**Deep Level (Heavy Magic):**
- [Complex pattern specific to this framework]
- [Implicit behavior to watch for]
- [Example from codebase if available]

---

### [Frontend Framework] Conventions

**Surface Level (Simple):**
- [Simple pattern]
- [Example]

**Medium Level (Some Magic):**
- [Medium pattern]
- [Example]

**Deep Level (Heavy Magic):**
- [Complex pattern]
- [Example]

---

## Integration Complexity in This App

### Single Layer Tasks
- [Example: "Just updating a model validation"]
- [Example: "Changing a component's styling"]

### Multi-Layer Tasks (2-3 Systems)
- [Real example from app: "Adding a form that saves to DB"]
- [What systems are involved]

### Complex Integration Tasks (4+ Systems)
- [Real example from app: "Feature X touches controller + model + job + component + tests"]
- [Why this is complex in YOUR app specifically]

---

## Known "Deep Magic" Areas

### 1. [Area Name - e.g., "Authentication Flow"]

**Why it's complex:**
- [Specific reason in your app]

**Watch for:**
- [Gotcha 1]
- [Gotcha 2]

**Files involved:**
- `[path/to/file]`
- `[path/to/file]`

---

### 2. [Area Name - e.g., "Real-time Updates"]

**Why it's complex:**
- [Specific reason]

**Watch for:**
- [Gotcha 1]

**Files involved:**
- `[path/to/file]`

---

### 3. [Area Name - e.g., "Multi-tenancy"]

**Why it's complex:**
- [Specific reason]

**Watch for:**
- [Gotcha 1]

**Files involved:**
- `[path/to/file]`

---

## Model Selection for This App

**Based on this app's complexity patterns:**

| Task Type | Recommended Model | Why |
|-----------|------------------|-----|
| Simple CRUD in [area] | Sonnet 4.5 / GPT 5 | Established patterns |
| [Complex area 1] | Opus 4.5 | Deep framework magic |
| [Complex area 2] | Opus 4.5 | Multi-layer integration |
| Testing [area] | Sonnet 4.5 | Clear patterns |
| New feature in [area] | Opus 4.5 | Architectural decisions |

---

## Red Flags Specific to This App

**Escalate to more capable model if:**

🚨 Working in [complex area 1] - requires deep [framework] knowledge
🚨 Touching [complex area 2] - multi-layer coordination needed
🚨 [Framework] [specific pattern] - implicit behavior is tricky
🚨 [Specific gotcha area] - easy to break without realizing

---

## Examples From This Codebase

### Example 1: [Feature that was complex]

**Task:** [What was being done]
**Complexity Level:** Deep
**Why:** [Specific reasons from actual experience]
**Lesson:** [What to watch for next time]

### Example 2: [Feature that seemed complex but wasn't]

**Task:** [What was being done]
**Complexity Level:** Medium (seemed Deep)
**Why it was simpler:** [Reason - e.g., "existing patterns to follow"]
**Lesson:** [Check for existing patterns first]
```

---

## Generation Process

### Step 1: Read the Codebase

Gather context by reading:
- [ ] Dependency files (Gemfile, package.json, etc.)
- [ ] Main configuration files
- [ ] 2-3 example files from each layer (model, controller, component)
- [ ] Test examples
- [ ] README or architecture docs if they exist

### Step 2: Identify Complexity Patterns

For each framework in the stack:
- What's simple (clear API, documented)?
- What's medium (conventions, some magic)?
- What's deep (implicit behavior, multiple systems)?

### Step 3: Find Real Examples

From the codebase, identify:
- A simple task that was straightforward
- A complex task that required more reasoning
- Areas where AI has gotten stuck before (if known)

### Step 4: Generate the File

Use the template above, filling in:
- Stack-specific details
- Real examples from codebase
- Honest assessment of complexity areas

### Step 5: Validate

- [ ] Examples are accurate (from real code)
- [ ] Complexity assessments are realistic
- [ ] Model recommendations make sense for this stack
- [ ] Red flags are genuinely risky areas

---

## Verification

After generating, check:

```bash
# Ensure file is in correct location
ls [app]/.copilot/instructions/[app]-complexity-signals.instructions.md

# Verify frontmatter
head -5 [app]/.copilot/instructions/[app]-complexity-signals.instructions.md
# Should show: applyTo: "[app]/**/*"
```

---

## Model Recommendation

For generating this file: **Sonnet 4.5** with full codebase context

- Needs to read and understand multiple files
- Pattern matching more than deep reasoning
- Implementation-focused task

For reviewing the generated file: **Human review recommended**

- Only you know what's truly complex in your app
- Add lessons learned from experience
- Refine model recommendations based on actual usage
