---
title: "Prompt Writer Agent"
project: ubod
type: feature
parent_prd: 00_master_index.md
complexity: medium
estimated_hours: 8-10
priority: high
status: planning
created: 2026-01-19
updated: 2026-01-19
tags: [agent, prompts, meta-tooling, scaffolding, workflow]
---

# PRD-02: Prompt Writer Agent

**Purpose:** Agent that generates `.prompt.md` files following ubod's prompt specification.

**User Story:** As a developer, I want to create workflow prompt files without manually structuring steps and examples, so I can document repeatable workflows in <15 minutes instead of 1.5 hours.

---

## Scope

### In Scope ✅

- Read `vscode-custom-prompt-spec.instructions.md`
- Ask targeted questions about workflow purpose, steps, success criteria
- Generate `.prompt.md` file with valid frontmatter
- Validate generated file against spec
- Support reusable workflow patterns

### Out of Scope ❌

- Executing prompts (agent generates definition, not execution)
- Modifying existing prompts (separate "update" mode)
- Multi-prompt workflows (one prompt at a time)

---

## User Workflow

### Invocation

```
User: @ubod-prompt-writer "Create component creation workflow"
```

### Agent Questions (Example)

```
Agent: I'll help you create a workflow prompt. Questions:

1. What's the workflow name?
   Example: "Create ViewComponent with Preview"

2. What's the goal/purpose?
   Example: "Guide AI through creating a ViewComponent + Lookbook preview"

3. What are the workflow steps? (List in order)
   Step 1: Search for similar components
   Step 2: Plan component structure
   Step 3: Generate component class
   Step 4: Generate preview file
   Step 5: Verify in Lookbook

4. What are the success criteria?
   - Component renders in Lookbook
   - Preview has 3+ scenarios
   - Follows naming conventions

5. Any prerequisites?
   - Design system instructions exist
   - Lookbook is running

6. Estimated time? (minutes)
   Default: 30

7. Tags? (comma-separated)
   Example: components, design-system, testing
```

### Agent Output

```
Agent: Generated prompt file at:
.github/prompts/create-component.prompt.md

Frontmatter validated ✅
Workflow steps validated ✅
Success criteria present ✅

Preview:
---
name: Create ViewComponent with Preview
description: Guide AI through component creation workflow
estimated_minutes: 30
tags: [components, design-system, testing]
---

# Create ViewComponent with Preview

[... workflow steps ...]

Ready to write file? (yes/review/edit)
```

---

## Technical Specification

### Input

**Spec File:** `ubod-meta/instructions/vscode-custom-prompt-spec.instructions.md`

**User Inputs:**
- `name`: Workflow name
- `description`: Purpose/goal
- `steps`: Ordered list of workflow steps
- `success_criteria`: How to know workflow succeeded
- `prerequisites`: What's needed before starting
- `estimated_minutes`: Time estimate
- `tags`: Categorization tags

### Processing

**Step 1: Parse Spec**
```
Read spec file
Extract required frontmatter: [name, description]
Extract optional frontmatter: [estimated_minutes, prerequisites, tags]
Extract step structure: [numbered steps with substeps]
Extract success criteria format
```

**Step 2: Collect User Input**
```
Ask workflow name
Ask description/goal
Ask for steps (allow multi-line, numbered list)
Ask for success criteria (checklist format)
Ask for prerequisites (optional)
Suggest time estimate
Suggest tags based on keywords
```

**Step 3: Generate Artifact**
```
Build frontmatter:
  ---
  name: <user input>
  description: <user input>
  estimated_minutes: <user input>
  prerequisites: [<list>]
  tags: [<list>]
  ---

Build workflow:
  # <Name>
  
  **Goal:** <description>
  
  ## Workflow Steps
  
  1. **<Step 1 title>**
     - <Substep 1a>
     - <Substep 1b>
  
  2. **<Step 2 title>**
     ...
  
  ## Success Criteria
  
  - [ ] <Criterion 1>
  - [ ] <Criterion 2>
```

**Step 4: Validate**
```
Check required frontmatter present
Check steps are numbered sequentially
Check success criteria formatted as checklist
Report violations
```

### Output

**File Path:** `.github/prompts/<workflow-name>.prompt.md`

**File Format:**
```markdown
---
name: Workflow Name
description: What this workflow accomplishes
estimated_minutes: 30
prerequisites:
  - Prerequisite 1
  - Prerequisite 2
tags: [tag1, tag2]
---

# Workflow Name

**Goal:** <description>

## Prerequisites

- Prerequisite 1
- Prerequisite 2

## Workflow Steps

1. **Step 1 Title**
   - Substep details
   - Expected outcome

2. **Step 2 Title**
   - Substep details
   - Expected outcome

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Troubleshooting

*Common issues and solutions*
```

---

## Agent Behavior

### Conversation Flow

```
1. Greet, explain purpose
2. Ask workflow name
3. Ask goal/description
4. Collect steps (iterative, allow editing)
5. Collect success criteria
6. Ask optional fields (prerequisites, time, tags)
7. Generate artifact
8. Validate
9. Preview
10. Approve/iterate
11. Write file
```

### Smart Features

**Step Collection:**
```
Agent: Describe Step 1:
User: Search for similar components

Agent: Any substeps for Step 1? (optional)
User: - Use semantic_search
      - Check similar domains

Agent: Describe Step 2:
User: Plan component structure

Agent: Continue adding steps? (yes/no/done)
```

**Tag Suggestions:**
```
User input: "Create ViewComponent with Preview"
Agent: Suggested tags based on keywords:
  - components (from "Component")
  - view (from "View")
  - testing (from "Preview")
Add these? (yes/edit/no)
```

**Time Estimation:**
```
Agent: Based on 5 workflow steps, estimated time: 25-30 minutes
Use this estimate? (yes/custom)
```

---

## Examples

### Example 1: Component Creation Workflow

**User Request:**
```
@ubod-prompt-writer "Create workflow for new ViewComponent"
```

**Generated File:**
```markdown
---
name: Create ViewComponent with Lookbook Preview
description: Systematic workflow for creating ViewComponents following Tala conventions
estimated_minutes: 30
prerequisites:
  - Design system instructions loaded
  - Lookbook running on localhost:3000
tags: [components, design-system, lookbook, testing]
---

# Create ViewComponent with Lookbook Preview

**Goal:** Create a new ViewComponent following Tala naming/structure conventions, with Lookbook preview scenarios, verified rendering.

## Prerequisites

- Tala design system instructions active
- Lookbook server running (`bin/dev`)
- Similar components exist for reference

## Workflow Steps

1. **Discover Similar Components**
   - Search for components in same domain: `semantic_search("similar component name")`
   - Read existing component: `read_file("path/to/similar_component.rb")`
   - Note patterns: naming, structure, preview scenarios

2. **Plan Component Structure**
   - Determine namespace (Documents::, Chat::, Shadcn::)
   - Choose component purpose name (ListItem, GridItem, etc.)
   - List props/initialize params
   - Identify slots needed

3. **Generate Component Class**
   - Create `app/components/{namespace}/{name}_component.rb`
   - Follow naming convention: `{Namespace}::{PurposeName}Component`
   - Add helper delegation if needed: `delegate :icon, to: :helpers`
   - Avoid DB queries in component methods

4. **Generate Component Template**
   - Create `app/components/{namespace}/{name}_component.html.erb`
   - Use slots for flexible content
   - Apply Tailwind classes
   - Add data attributes for Stimulus if interactive

5. **Generate Lookbook Preview**
   - Create `test/components/previews/{namespace}/{name}_component_preview.rb`
   - Add preview label: `@label {Namespace} - {Purpose}`
   - Create 3+ scenarios: default, variations, edge cases
   - Use realistic data (not "foo", "bar")

6. **Verify in Lookbook**
   - Open browser: `http://localhost:3000/rails/view_components`
   - Navigate to new component
   - Check all scenarios render without errors
   - Verify visual appearance

7. **Update Coverage Report**
   - Run: `bin/rails ui:preview_coverage`
   - Verify new component appears
   - Check coverage percentage increased

## Success Criteria

- [ ] Component class created with correct namespace
- [ ] Template renders without errors
- [ ] Preview file has 3+ scenarios
- [ ] Preview label follows convention
- [ ] All scenarios visible in Lookbook
- [ ] No coupling violations (DB queries, missing helpers)
- [ ] Coverage report shows new component

## Troubleshooting

**Lookbook shows errors:**
- Check for DB queries in component → Remove or delegate
- Check for missing helpers → Add delegation
- Check for route helpers → Add delegation or remove

**Preview not appearing:**
- Verify file location matches namespace
- Check preview class name matches component name
- Restart Lookbook: Stop `bin/dev`, restart

**Naming inconsistencies:**
- Follow ADR: Namespace - Purpose (e.g., "Documents - List Item")
- Component class: PascalCase (Documents::ListItemComponent)
- File: snake_case (list_item_component.rb)
```

---

## Testing Strategy

### Unit Tests

- ✅ Spec parser extracts frontmatter correctly
- ✅ Step collector handles multi-line input
- ✅ Success criteria formatter creates checklist
- ✅ Tag suggester finds keywords in workflow name

### Integration Tests

- ✅ End-to-end generation creates valid .prompt.md
- ✅ Generated file passes validation
- ✅ Iterative step editing works
- ✅ Optional fields handled correctly

### Validation Tests

- ✅ Regenerate existing prompts, compare outputs
- ✅ All generated prompts pass spec validation

---

## Acceptance Criteria

- ✅ Agent reads vscode-custom-prompt-spec.instructions.md
- ✅ Agent collects workflow steps iteratively
- ✅ Agent generates valid .prompt.md file
- ✅ Generated file has numbered steps
- ✅ Generated file has checklist success criteria
- ✅ Agent suggests tags based on workflow name
- ✅ Agent estimates time based on step count
- ✅ Agent completes workflow in <15 minutes

---

## Implementation Notes

### Reuse from PRD-01

- Spec parser (same pattern)
- Frontmatter generator (same YAML structure)
- Validator (same validation logic)
- Question collector (same conversational flow)

**Differences:**
- Step collection is iterative (not single question)
- Success criteria must be checklist format
- Time estimation based on step count heuristic

---

## Success Metrics

**Time Reduction:**
- Baseline: 1.5 hours manual
- Target: 15 minutes with agent
- **Goal: 83% faster**

**Quality:**
- Target: 100% spec compliance
- Target: All steps numbered sequentially
- Target: Success criteria in checklist format

---

**Status:** Planning  
**Next Step:** Implement after PRD-01 complete, reuse patterns
