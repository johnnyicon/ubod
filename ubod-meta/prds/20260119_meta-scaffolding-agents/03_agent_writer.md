---
title: "Agent Writer Agent"
project: ubod
type: feature
parent_prd: 00_master_index.md
complexity: medium-high
estimated_hours: 8-12
priority: high
status: planning
created: 2026-01-19
updated: 2026-01-19
tags: [agent, meta-tooling, scaffolding]
---

# PRD-03: Agent Writer Agent

**Purpose:** Agent that generates `.agent.md` files following ubod's agent specification.

**User Story:** As a developer, I want to create specialized agent definitions without manually structuring role/workflow/boundaries, so I can define new agents in <30 minutes instead of 3 hours.

---

## Scope

### In Scope ✅

- Read `vscode-custom-agent-spec.instructions.md`
- Ask targeted questions about agent purpose, expertise, workflow, boundaries
- Generate `.agent.md` file with valid frontmatter
- Validate generated file against spec
- Support multi-mode agents (CREATE/UPDATE/AUDIT patterns)

###Out of Scope ❌

- Modifying existing agents (separate "update" mode)
- Testing agent behavior (generate definition only)
- Multi-agent systems (one agent at a time)

---

## User Workflow

### Invocation

```
User: @ubod-agent-writer "Create Tala design system agent"
```

### Agent Questions (Example)

```
Agent: I'll help you create an agent definition. Questions:

1. What's the agent's name?
   Example: "Tala Design System"

2. What domain/expertise does this agent have?
   Example: "ViewComponent development, Lookbook previews, design system conventions"

3. What's the agent's primary purpose?
   Example: "Guide component creation following Tala conventions"

4. What modes should the agent support?
   - CREATE: Guide new component creation
   - UPDATE: Modify existing components
   - AUDIT: Review components for convention compliance
   - MIGRATE: Bulk updates when conventions change
   Select modes: (comma-separated, e.g., "CREATE,UPDATE")

5. What are the agent's boundaries?
   Always do:
   - Follow naming conventions
   - Generate preview files
   - Verify in Lookbook
   
   Never do:
   - Edit non-component files
   - Skip preview generation
   - Violate coupling rules

6. What instructions should this agent load?
   Example: "tala-design-system.instructions.md"

7. Estimated workflow time? (minutes per invocation)
   Default: 30

8. Tags?
   Example: components, design-system, testing
```

### Agent Output

```
Agent: Generated agent file at:
apps/tala/.copilot/agents/tala-design-system.agent.md

Frontmatter validated ✅
Role section complete ✅
Workflow section complete ✅
Boundaries section complete ✅

Preview:
---
name: Tala Design System
domain: ViewComponent Development
modes: [CREATE, UPDATE, AUDIT]
---

# Tala Design System Agent

ROLE: Specialized agent for creating/maintaining Tala ViewComponents...

WORKFLOW:
1. CREATE Mode: ...
2. UPDATE Mode: ...

BOUNDARIES:
✅ Always: ...
❌ Never: ...

Ready to write file? (yes/review/edit)
```

---

## Technical Specification

### Input

**Spec File:** `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md`

**User Inputs:**
- `name`: Agent name
- `domain`: Area of expertise
- `purpose`: Primary goal
- `modes`: Operating modes (CREATE/UPDATE/AUDIT/etc.)
- `always_do`: List of required behaviors
- `never_do`: List of forbidden behaviors
- `instructions`: Related instruction files
- `estimated_minutes`: Time per invocation
- `tags`: Categorization

### Processing

**Step 1: Parse Spec**
```
Read spec file
Extract required sections: [ROLE, WORKFLOW, BOUNDARIES]
Extract optional sections: [COMMANDS, SCOPE, EXAMPLES]
Extract frontmatter schema
```

**Step 2: Collect User Input**
```
Ask agent name/purpose
Ask domain expertise
Collect modes (multi-select)
Collect always_do list
Collect never_do list
Ask for instruction dependencies
Suggest time/tags
```

**Step 3: Generate Artifact**
```
Build frontmatter:
  ---
  name: <name>
  domain: <domain>
  modes: [<list>]
  instructions: [<list>]
  estimated_minutes: <time>
  tags: [<list>]
  ---

Build ROLE section:
  ROLE: <domain> specialist focusing on <purpose>

Build WORKFLOW section (per mode):
  1. **<MODE> Mode:**
     - <Step 1>
     - <Step 2>

Build BOUNDARIES section:
  ✅ Always do:
    - <behavior 1>
  
  ❌ Never do:
    - <behavior 1>
```

**Step 4: Validate**
```
Check all required sections present
Check modes are valid keywords
Check boundaries formatted correctly
Report violations
```

### Output

**File Path:** `.copilot/agents/<agent-name>.agent.md`

**File Format:**
```markdown
---
name: Agent Name
domain: Expertise Area
modes: [CREATE, UPDATE]
instructions: [file1.instructions.md]
estimated_minutes: 30
tags: [tag1, tag2]
---

# Agent Name

ROLE: Specialized agent for <domain> tasks

PURPOSE: <what this agent helps with>

MODES:

## CREATE Mode
<Workflow for creating new items>

## UPDATE Mode
<Workflow for updating existing items>

WORKFLOW:

1. **Understand Context**
   - <Step details>

2. **Plan Approach**
   - <Step details>

BOUNDARIES:

✅ **Always do:**
- <Required behavior 1>
- <Required behavior 2>

❌ **Never do:**
- <Forbidden behavior 1>
- <Forbidden behavior 2>

COMMANDS:
- <Command 1>: <Description>

SCOPE:

**I specialize in:**
- <Capability 1>

**I hand off to:**
- <Other agent>: <When>

## Examples

### Example 1: <Scenario>
<Usage example>
```

---

## Agent Behavior

### Conversation Flow

```
1. Greet, explain purpose
2. Ask agent name/purpose
3. Ask domain expertise
4. Collect modes (checkboxes)
5. For each mode, collect workflow steps
6. Collect always_do list
7. Collect never_do list
8. Ask instruction dependencies
9. Generate artifact
10. Validate
11. Preview
12. Approve/iterate
13. Write file
```

### Smart Features

**Mode Detection:**
```
Agent: Common agent modes:
  [ ] CREATE - Guide creation of new items
  [ ] UPDATE - Modify existing items
  [ ] AUDIT - Review for compliance
  [ ] MIGRATE - Bulk updates
  [ ] DEBUG - Troubleshoot issues

Select applicable modes:
```

**Boundary Suggestions:**
```
Based on "design system agent":
Always do:
  - Follow naming conventions
  - Generate preview files
  - Validate output

Never do:
  - Skip required steps
  - Modify unrelated files
  - Bypass validation

Use these suggestions? (yes/edit/custom)
```

**Instruction Linking:**
```
Found related instructions:
  - tala-design-system.instructions.md
  - tala-viewcomponents.instructions.md

Should agent reference these? (yes/select/no)
```

---

## Examples

### Example 1: Tala Design System Agent

**Generated File:**
```markdown
---
name: Tala Design System
domain: ViewComponent Development
modes: [CREATE, UPDATE, AUDIT]
instructions:
  - tala-design-system.instructions.md
  - tala-viewcomponents.instructions.md
estimated_minutes: 30
tags: [components, design-system, tala]
---

# Tala Design System Agent

ROLE: ViewComponent specialist for Tala design system

PURPOSE: Guide systematic creation/maintenance of ViewComponents following Tala conventions

MODES:

## CREATE Mode
Create new ViewComponents from scratch with Lookbook previews

## UPDATE Mode
Modify existing components while maintaining conventions

## AUDIT Mode
Review all components for convention compliance

WORKFLOW:

### CREATE Mode

1. **Discover Similar Components**
   - Search for components in same domain
   - Identify patterns to follow

2. **Plan Component Structure**
   - Determine namespace (Documents::, Chat::, etc.)
   - Choose purpose name (ListItem, GridItem, etc.)
   - List props and slots

3. **Generate Files**
   - Create component class
   - Create template
   - Create preview with 3+ scenarios
   - Create README

4. **Verify**
   - Check Lookbook rendering
   - Validate conventions
   - Update coverage report

### UPDATE Mode

1. **Read Existing Component**
   - Load component class, template, preview
   - Understand current structure

2. **Apply Changes**
   - Modify as requested
   - Maintain conventions
   - Update preview if needed

3. **Verify**
   - Check Lookbook still renders
   - Run tests
   - No convention violations

### AUDIT Mode

1. **Scan All Components**
   - List components in namespace
   - Check each against conventions

2. **Report Violations**
   - List naming issues
   - List missing previews
   - List coupling violations

3. **Suggest Fixes**
   - Prioritize by severity
   - Provide fix commands

BOUNDARIES:

✅ **Always do:**
- Follow namespace - purpose naming (Documents::ListItemComponent)
- Generate preview with @label {Namespace} - {Purpose}
- Create minimum 3 preview scenarios
- Delegate helpers (delegate :icon, to: :helpers)
- Avoid DB queries in components
- Verify Lookbook rendering before declaring done
- Update coverage report after changes

❌ **Never do:**
- Edit files outside app/components/, test/components/previews/
- Skip preview generation ("I'll add it later")
- Use generic names (RowComponent without namespace)
- Query database directly in component methods
- Assume conventions without checking instructions
- Declare complete without Lookbook verification

COMMANDS:
- Search for similar components: semantic_search()
- Read component source: read_file()
- Generate component files: create_file()
- Verify in Lookbook: "Open localhost:3000/rails/view_components"
- Update coverage: Run bin/rails ui:preview_coverage

SCOPE:

**I specialize in:**
- ViewComponent creation (class + template + preview)
- Lookbook preview scenarios
- Coupling avoidance (no DB, delegated helpers)
- Convention enforcement (naming, labeling, structure)
- Coverage tracking

**I hand off to:**
- Tala Implementer: For non-component code changes
- Tala UI/UX Designer: For design clarification

**I do NOT:**
- Edit controllers, models, routes
- Write business logic outside components
- Modify database schema
- Deploy or configure servers

## Examples

### Example: CREATE Mode

User: "@tala-design-system CREATE button component for document actions"

Agent:
1. Searches for similar button components
2. Plans: Documents::ActionButtonComponent
3. Generates:
   - app/components/documents/action_button_component.rb
   - app/components/documents/action_button_component.html.erb
   - test/components/previews/documents/action_button_component_preview.rb
4. Verifies in Lookbook
5. Updates coverage report
6. Reports: "Component created, 3 scenarios rendering successfully"
```

---

## Testing Strategy

### Unit Tests

- ✅ Mode collector handles multi-select
- ✅ Boundary formatter creates ✅/❌ lists
- ✅ Instruction linker finds related files
- ✅ Workflow generator creates per-mode sections

### Integration Tests

- ✅ End-to-end generation creates valid .agent.md
- ✅ Multi-mode agents have all mode workflows
- ✅ Boundaries section formatted correctly
- ✅ Instructions linked properly

### Validation Tests

- ✅ Regenerate existing agents, compare outputs
- ✅ All generated agents pass spec validation

---

## Acceptance Criteria

- ✅ Agent reads vscode-custom-agent-spec.instructions.md
- ✅ Agent collects modes (multi-select)
- ✅ Agent generates per-mode workflows
- ✅ Agent creates boundaries section
- ✅ Agent links related instructions
- ✅ Generated file passes validation
- ✅ Agent completes workflow in <30 minutes

---

## Implementation Notes

### Complexity vs PRD-01/02

**Slightly higher complexity because:**
- Multi-mode support (CREATE/UPDATE/AUDIT)
- Per-mode workflow generation
- Boundary formatting (✅/❌ emojis)
- Instruction dependency linking

**Reuses from PRD-01/02:**
- Spec parser
- Frontmatter generator
- Validator
- Question collector

**New components:**
- Mode selector (checkbox UI pattern)
- Per-mode workflow generator
- Boundary formatter
- Instruction linker (find related .instructions.md files)

---

## Success Metrics

**Time Reduction:**
- Baseline: 3 hours manual
- Target: 30 minutes with agent
- **Goal: 83% faster**

**Quality:**
- Target: 100% spec compliance
- Target: All modes have workflows
- Target: Boundaries properly formatted

---

**Status:** Planning  
**Next Step:** Implement after PRD-01, PRD-02 complete, reuse patterns
