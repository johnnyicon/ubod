# Naming Conventions for Prompts and Agents

**Version:** 1.0.0  
**Last Updated:** 2026-01-20

---

## Purpose

Establish consistent naming for prompts and agents that:
- Makes them easy to find in VS Code dropdowns
- Clarifies purpose at a glance
- Groups related items together
- Follows natural language patterns

---

## TL;DR Rules

| File Type | Filename Pattern | Name Field Pattern | Example |
|-----------|-----------------|-------------------|---------|
| **Prompt** | `kebab-case.prompt.md` | `Namespace: Action` | `adr-commit.prompt.md` → `ADR: Commit & Validate` |
| **Agent** | `kebab-case.agent.md` | `Namespace Action` | `adr.agent.md` → `ADR Orchestrator` |

---

## Naming Pattern: Prompts

### Frontmatter `name:` Field

**Format:** `[Namespace]: [Action]` or `[Action] [Object]`

**Examples:**
```yaml
# Domain-specific prompts (use namespace prefix)
name: "ADR: Commit & Validate"       # adr-commit.prompt.md
name: "ADR: Assess Decision"         # adr-gatekeeper.prompt.md
name: "ADR: Create/Update Record"    # adr-writer.prompt.md
name: "ADR: Catalog Health Check"    # adr-health.prompt.md
name: "ADR: Generate Index"          # adr-index.prompt.md

# Framework prompts (use "Ubod" prefix)
name: "Ubod: Upgrade Framework"      # ubod-upgrade.prompt.md
name: "Ubod: Commit Changes"         # ubod-commit.prompt.md
name: "Ubod: Create Agent"           # ubod-create-agents.prompt.md
name: "Ubod: Validate Files"         # ubod-validate.prompt.md

# App-specific prompts (use app name prefix)
name: "Tala: Create Lookbook Preview"  # tala-create-lookbook-preview.prompt.md

# Generic prompts (no prefix, action-first)
name: "Create PRD"                   # create-prd.prompt.md
name: "Review PRD"                   # review-prd.prompt.md
name: "Debug Stuck Workflow"         # debug-stuck.prompt.md
```

### Why This Pattern?

**Grouping in dropdowns:**
```
VS Code dropdown (alphabetical):
  ADR: Assess Decision
  ADR: Catalog Health Check
  ADR: Commit & Validate
  ADR: Create/Update Record
  ADR: Generate Index
  ---
  Create PRD
  Debug Stuck Workflow
  ---
  Tala: Create Lookbook Preview
  ---
  Ubod: Commit Changes
  Ubod: Create Agent
  Ubod: Upgrade Framework
  Ubod: Validate Files
```

**Benefits:**
- ✅ Related items grouped together (all ADR prompts adjacent)
- ✅ Purpose clear at glance ("Commit & Validate")
- ✅ Natural language (reads like a menu)
- ✅ Searchable (type "adr" to see all ADR prompts)

---

## Naming Pattern: Agents

### Frontmatter `name:` Field

**Format:** `[Namespace] [Role]` or `[Object] [Action]`

**Examples:**
```yaml
# Orchestrator agents (use "Orchestrator" to clarify)
name: "ADR Orchestrator"             # adr.agent.md
name: "Ubod Orchestrator"            # ubod.agent.md

# Worker agents (use specific role)
name: "ADR Writer"                   # adr-writer.agent.md
name: "PRD Writer"                   # prd-writer.agent.md
name: "Ubod Maintainer"              # ubod-maintainer.agent.md

# App-specific agents (use app name + role)
name: "Tala Implementer"             # tala-implementer.agent.md
name: "Tala Verifier"                # tala-verifier.agent.md
name: "Tala UI/UX Designer"          # tala-ui-ux-designer.agent.md
name: "Tala Discovery Planner"       # tala-discovery-planner.agent.md

# Utility agents (action-first)
name: "Debug Stuck"                  # debug-stuck.agent.md
name: "Skill Foundry"                # skill-foundry.agent.md
```

### Why This Pattern?

**Grouping in dropdowns:**
```
VS Code agent dropdown (alphabetical):
  ADR Orchestrator
  ADR Writer
  ---
  Debug Stuck
  ---
  PRD Writer
  ---
  Skill Foundry
  ---
  Tala Discovery Planner
  Tala Implementer
  Tala UI/UX Designer
  Tala Verifier
  ---
  Ubod Maintainer
  Ubod Orchestrator
```

**Benefits:**
- ✅ Related agents grouped (all Tala agents adjacent)
- ✅ Role clear ("Orchestrator" vs "Writer")
- ✅ No redundant words (not "Tala Agent for Implementing")
- ✅ Consistent capitalization (Title Case)

---

## Filename Rules (Unchanged)

**Files always use kebab-case:**
- `adr-commit.prompt.md` ✅
- `ubod-upgrade.prompt.md` ✅
- `tala-implementer.agent.md` ✅

**Never use spaces or special characters:**
- `ADR Commit.prompt.md` ❌
- `ubod_upgrade.prompt.md` ❌

---

## Description Field Guidelines

### Prompts

**Format:** Concise action description (1 sentence, no period)

**Examples:**
```yaml
description: "Validate, dedupe, and commit ADR files to git"
description: "Orchestrate upgrading Ubod in your monorepo"
description: "Create comprehensive PRD using two-stage workflow"
description: "Assess whether decision warrants ADR creation"
```

**Tips:**
- Start with verb (Validate, Orchestrate, Create, Assess)
- Keep under 80 characters
- No period at end
- Avoid redundant words ("This prompt helps you to...")

### Agents

**Format:** Role summary (what agent does, not how)

**Examples:**
```yaml
description: "Architecture Decision Record orchestration agent"
description: "Creates Architecture Decision Records post-implementation"
description: "Tala implementer specialized in Rails + Hotwire stack"
description: "Verifies correctness beyond 'tests pass'"
```

---

## Migration Strategy

### Phase 1: Update Ubod Core (v1.15.0)

**Files to update in ubod-meta/prompts/:**

```yaml
# adr/adr-commit.prompt.md
name: "ADR: Commit & Validate"

# adr/adr-gatekeeper.prompt.md
name: "ADR: Assess Decision"

# adr/adr-writer.prompt.md
name: "ADR: Create/Update Record"

# adr/adr-health.prompt.md
name: "ADR: Catalog Health Check"

# adr/adr-index.prompt.md (new file)
name: "ADR: Generate Index"

# ubod-upgrade.prompt.md
name: "Ubod: Upgrade Framework"

# ubod-commit.prompt.md
name: "Ubod: Commit Changes"

# ubod-validate.prompt.md
name: "Ubod: Validate Files"

# ubod-version-bump.prompt.md
name: "Ubod: Bump Version"

# ubod-create-agents.prompt.md
name: "Ubod: Create Agent"

# ubod-create-prompt.prompt.md
name: "Ubod: Create Prompt"

# ubod-create-instruction.prompt.md
name: "Ubod: Create Instruction"

# ubod-update-agent.prompt.md
name: "Ubod: Update Agent"

# ubod-update-prompt.prompt.md
name: "Ubod: Update Prompt"

# ubod-update-instruction.prompt.md
name: "Ubod: Update Instruction"

# ubod-generate-complexity-matrix.prompt.md
name: "Ubod: Generate Complexity Matrix"

# ubod-migrate-copilot-instructions.prompt.md
name: "Ubod: Migrate Copilot Instructions"

# ubod-migration-create.prompt.md
name: "Ubod: Create Migration"

# harden-workflow.prompt.md
name: "Harden Workflow"
```

### Phase 2: Update Consumer Repos (After Upgrade)

**User runs:**
```bash
./projects/ubod/scripts/ubod-upgrade.sh
```

**Updated files in .github/prompts/ubod/:**
- All prompt names updated automatically
- VS Code shows new names immediately after reload

### Phase 3: Update App-Specific Prompts (Manual)

**Example for Tala:**
```yaml
# .github/prompts/tala-create-lookbook-preview.prompt.md
name: "Tala: Create Lookbook Preview"

# .github/prompts/create-prd.prompt.md
name: "Create PRD"  # Generic, no prefix needed

# .github/prompts/review-prd.prompt.md
name: "Review PRD"
```

---

## Checklist for New Files

### Creating New Prompt

- [ ] Filename: `kebab-case.prompt.md`
- [ ] Name: `[Namespace]: [Action]` or `[Action] [Object]`
- [ ] Description: Verb-first, under 80 chars, no period
- [ ] Test: Check dropdown appearance in VS Code

### Creating New Agent

- [ ] Filename: `kebab-case.agent.md`
- [ ] Name: `[Namespace] [Role]` (Title Case, no extra words)
- [ ] Description: Role summary, what not how
- [ ] Test: Check agent list appearance in VS Code

---

## Rationale

### Why Not Just Use Filename?

**Problem:** `adr-commit` vs `ADR: Commit & Validate`
- First is cryptic (what does "commit" mean?)
- Second is clear (commit ADR files and validate them)

**Dropdown experience:**
```
Bad (filename):
  adr-commit
  adr-gatekeeper
  adr-health
  adr-writer
  ubod-commit
  ubod-upgrade

Good (named):
  ADR: Assess Decision
  ADR: Catalog Health Check
  ADR: Commit & Validate
  ADR: Create/Update Record
  Ubod: Commit Changes
  Ubod: Upgrade Framework
```

### Why Namespace Prefix?

**Groups related items:**
- All `ADR:` prompts appear together
- All `Ubod:` prompts appear together
- All `Tala:` prompts appear together

**Searchable:**
- Type `/adr` → see all ADR prompts
- Type `/ubod` → see all Ubod prompts
- Type `/tala` → see all Tala prompts

### Why Title Case for Agents?

**Agents represent roles (people-like):**
- "Tala Implementer" (like a job title)
- "ADR Writer" (like a specialist)
- "Debug Stuck" (like a helper)

**Prompts represent actions (tool-like):**
- "ADR: Commit & Validate" (like a menu command)
- "Ubod: Upgrade Framework" (like a button label)

---

## Examples from Other Projects

### GitHub Copilot Extensions

```yaml
# Good naming in Copilot marketplace:
name: "Docker: Build Image"
name: "Docker: Run Container"
name: "Git: Interactive Rebase"
name: "Rails: Generate Model"
```

### VS Code Built-in Commands

```yaml
# VS Code command palette uses namespace prefix:
"File: New File"
"File: Save All"
"Git: Commit"
"Git: Pull"
"Terminal: New Terminal"
"View: Toggle Panel"
```

**We're following established UX patterns.**

---

## FAQ

**Q: Should I rename all existing prompts now?**  
A: No, migrate incrementally:
1. Update ubod core prompts (v1.15.0)
2. Update consumer repos via ubod-upgrade
3. Update app-specific prompts over time

**Q: What if namespace is unclear?**  
A: Use action-first naming: `"Create PRD"` instead of `"PRD: Create"`

**Q: Can I use emoji in names?**  
A: No, VS Code dropdowns don't render them well

**Q: What about long names?**  
A: Aim for under 40 characters; use abbreviations if needed:
- `"ADR: Commit & Validate"` ✅ (25 chars)
- `"Architecture Decision Record: Commit and Validate Files"` ❌ (58 chars)

**Q: Should agents and prompts use same namespace?**  
A: Yes, but different patterns:
- Agent: `ADR Orchestrator` (role)
- Prompt: `ADR: Commit & Validate` (action)

---

**Next:** Apply these naming standards to ubod v1.15.0 release
