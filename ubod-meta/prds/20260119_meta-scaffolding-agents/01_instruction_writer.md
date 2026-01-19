---
title: "Instruction Writer Agent"
project: ubod
type: feature
parent_prd: 00_master_index.md
complexity: medium
estimated_hours: 8-10
priority: high
status: planning
created: 2026-01-19
updated: 2026-01-19
tags: [agent, instructions, meta-tooling, scaffolding]
---

# PRD-01: Instruction Writer Agent

**Purpose:** Agent that generates `.instructions.md` files following ubod's instruction specification.

**User Story:** As a developer, I want to create domain-specific instruction files without manually structuring frontmatter and sections, so I can enforce conventions in <20 minutes instead of 2 hours.

---

## Scope

### In Scope ✅

- Read `vscode-custom-instructions-spec.instructions.md`
- Ask targeted questions about instruction purpose, rules, file patterns
- Generate `.instructions.md` file with valid frontmatter
- Validate generated file against spec
- Support both VS Code and GitHub Copilot spec variants

### Out of Scope ❌

- Modifying existing instructions (separate "update" mode)
- Bulk generation (generate one instruction at a time)
- Template-based generation (future enhancement)

---

## User Workflow

### Invocation

```
User: @ubod-instruction-writer "Create Tala design system instructions"
```

### Agent Questions (Example)

```
Agent: I'll help you create design system instructions. Let me ask a few questions:

1. What file patterns should these instructions apply to?
   Example: "apps/tala/app/components/**/*"

2. What conventions should be enforced?
   - Naming conventions
   - Code structure rules
   - Testing requirements
   - Documentation standards

3. What examples should I include?
   - Show before/after code samples
   - List common violations

4. Priority level? (high/medium/low)

5. Target platform? (vscode/github/both)
```

### Agent Output

```
Agent: Generated instruction file at:
apps/tala/.copilot/instructions/tala-design-system.instructions.md

Frontmatter validated ✅
Section structure validated ✅
File patterns checked ✅

Preview:
---
applyTo: "apps/tala/app/components/**/*"
priority: high
version: 1.0.0
---

# Tala Design System Instructions

[... content ...]

Ready to write file? (yes/review/edit)
```

---

## Technical Specification

### Input

**Spec File:** `ubod-meta/instructions/vscode-custom-instructions-spec.instructions.md`

**User Inputs (via conversation):**
- `domain`: What area (e.g., "Tala design system")
- `applyTo`: File glob pattern
- `rules`: List of conventions to enforce
- `examples`: Code samples or scenarios
- `priority`: high/medium/low
- `platform`: vscode/github/both

### Processing

**Step 1: Parse Spec**
```
Read spec file
Extract required frontmatter fields: [applyTo]
Extract optional frontmatter fields: [priority, version, tags, ...]
Extract section structure: [Purpose, Rules, Examples, ...]
```

**Step 2: Collect User Input**
```
For each required field:
  Ask question
  Validate response
  Store value

For optional fields:
  Suggest defaults
  Allow customization
```

**Step 3: Generate Artifact**
```
Build frontmatter YAML:
  ---
  applyTo: <user input>
  priority: <user input or default>
  version: 1.0.0
  created: <today>
  ---

Build sections:
  # <Domain> Instructions
  
  ## Purpose
  <Generated from user description>
  
  ## Rules
  <User-provided rules formatted as list>
  
  ## Examples
  <User-provided examples formatted as code blocks>
```

**Step 4: Validate**
```
Parse YAML frontmatter
Check required fields present
Check applyTo is valid glob pattern
Check section structure matches spec
Report any violations
```

### Output

**File Path:** User-specified or auto-generated from domain name

**File Format:**
```markdown
---
applyTo: "pattern"
priority: high
version: 1.0.0
created: 2026-01-19
---

# Domain Instructions

## Purpose
...

## Rules
...

## Examples
...
```

---

## Agent Behavior

### Conversation Flow

```
1. Greet user, explain purpose
2. Ask domain/purpose question
3. Ask applyTo pattern question
4. Ask rules question (multi-part)
5. Ask examples question (optional)
6. Ask priority question (suggest default)
7. Generate artifact
8. Validate artifact
9. Show preview
10. Request approval
11. Write file or iterate
```

### Error Handling

**Invalid applyTo pattern:**
```
Agent: The pattern "apps/tala/**.js" may not match as expected.
Did you mean "apps/tala/**/*.js"?
(Glob patterns need * for recursion)
```

**Missing required fields:**
```
Agent: I need the applyTo pattern to continue.
This field specifies which files these instructions apply to.

Example: "apps/tala/app/components/**/*"
```

**Validation failures:**
```
Agent: Generated artifact has issues:
- Missing required frontmatter field: applyTo
- Section "Examples" not in spec (did you mean "Example Scenarios"?)

Should I fix these automatically? (yes/manual)
```

### Smart Defaults

- **version:** Always 1.0.0 for new instructions
- **created:** Today's date
- **priority:** medium (if not specified)
- **tags:** Inferred from domain (e.g., "design-system" → [design-system, components, ui])

---

## Examples

### Example 1: Simple Instruction

**User Request:**
```
@ubod-instruction-writer "Create Rails model naming conventions"
```

**Agent Q&A:**
```
Domain: Rails model naming conventions
ApplyTo: app/models/**/*.rb
Rules:
  - Model names must be singular
  - File names must be snake_case
  - Class names must be PascalCase
Priority: high
```

**Generated File:**
```markdown
---
applyTo: "app/models/**/*.rb"
priority: high
version: 1.0.0
created: 2026-01-19
tags: [rails, models, naming]
---

# Rails Model Naming Conventions

## Purpose
Enforce consistent naming for Rails models

## Rules
- Model names must be singular (User, not Users)
- File names must be snake_case (user.rb, not User.rb)
- Class names must be PascalCase (User, not user)

## Examples

✅ Correct:
```ruby
# app/models/user.rb
class User < ApplicationRecord
end
```

❌ Wrong:
```ruby
# app/models/Users.rb
class users < ApplicationRecord
end
```
```

### Example 2: Complex Instruction (Tala Design System)

**User Request:**
```
@ubod-instruction-writer "Create Tala ViewComponent design system instructions"
```

**Agent Q&A:**
```
Domain: Tala ViewComponent Design System
ApplyTo: apps/tala/app/components/**/*
Rules:
  1. Naming: Documents::ListItemComponent (namespace + purpose)
  2. Preview labels: @label Documents - List Item
  3. No DB queries in components
  4. Delegate helpers: delegate :icon, to: :helpers
  5. Minimum 3 preview scenarios
Priority: high
Examples: Yes (show component + preview patterns)
```

**Generated File:** (See actual Tala instruction as example)

---

## Testing Strategy

### Unit Tests

**Test: Spec Parser**
- ✅ Reads spec file successfully
- ✅ Extracts required fields correctly
- ✅ Extracts optional fields with defaults
- ✅ Handles malformed spec gracefully

**Test: Question Generator**
- ✅ Generates questions for required fields
- ✅ Skips questions for fields with smart defaults
- ✅ Validates user responses (glob patterns, dates, etc.)

**Test: Artifact Generator**
- ✅ Generates valid YAML frontmatter
- ✅ Populates sections from user input
- ✅ Formats examples as code blocks
- ✅ Handles missing optional sections

**Test: Validator**
- ✅ Detects missing required fields
- ✅ Validates glob patterns
- ✅ Checks section structure
- ✅ Reports multiple violations

### Integration Tests

**Test: End-to-End Generation**
```
Input: Domain="Test", ApplyTo="test/**/*", Rules=["Rule 1"]
Expected: Valid .instructions.md file created
Verify: File exists, frontmatter valid, sections present
```

**Test: Iterative Refinement**
```
Generate artifact
User: "Change applyTo to app/**/*"
Expected: Regenerate with new pattern
Verify: Pattern updated, other fields preserved
```

**Test: Error Recovery**
```
User provides invalid glob pattern
Expected: Agent detects, asks for correction
Verify: Agent doesn't write invalid file
```

### Validation Tests

**Test: Against Existing Instructions**
```
For each instruction in ubod-meta/instructions/:
  Parse file
  Extract inputs (frontmatter + sections)
  Regenerate with agent
  Compare: Generated == Original
```

**Expected:** 100% match for core fields (applyTo, rules)

---

## Acceptance Criteria

- ✅ Agent reads vscode-custom-instructions-spec.instructions.md
- ✅ Agent asks minimum required questions
- ✅ Agent generates valid .instructions.md file
- ✅ Generated file passes frontmatter validation
- ✅ Generated file has all required sections
- ✅ Agent handles invalid input gracefully
- ✅ Agent provides preview before writing
- ✅ Agent supports iterative refinement
- ✅ Agent completes workflow in <20 minutes

---

## Implementation Notes

### File Structure

```
ubod/
├── agents/
│   └── ubod-instruction-writer.agent.md   ← Agent definition
└── ubod-meta/
    ├── instructions/
    │   └── vscode-custom-instructions-spec.instructions.md  ← Spec
    └── lib/
        └── instruction_generator.rb  ← Helper module (if needed)
```

### Dependencies

- YAML parser (Ruby: `YAML.load`, Python: `yaml.safe_load`)
- File glob matcher (Ruby: `File.fnmatch`, Python: `fnmatch`)
- Markdown formatter (basic string manipulation)

### Edge Cases

1. **User provides full file path instead of pattern**
   - Detect: No wildcards in pattern
   - Suggest: Convert to pattern (e.g., "file.rb" → "**/ file.rb")

2. **User wants platform-specific instructions**
   - Question: "Target platform?"
   - Generate: Platform-specific frontmatter

3. **User provides no examples**
   - Allow: Examples are optional
   - Suggest: "Examples help clarify rules. Add some?"

---

## Success Metrics

**Time Reduction:**
- Baseline: 2 hours manual
- Target: 20 minutes with agent
- **Goal: 83% faster**

**Quality:**
- Baseline: ~70% spec compliance (manual)
- Target: 100% spec compliance (agent)
- **Goal: Zero validation errors**

**Adoption:**
- Target: 80% of new instructions created via agent
- Measure: Track agent invocations vs manual creates

---

## Open Questions

1. Should agent support updating existing instructions?
   - **Decision: Out of scope for v1, separate "update" mode in v2**

2. Should agent suggest rules based on domain?
   - **Decision: No (too domain-specific), user knows best**

3. Should agent validate file paths exist?
   - **Decision: No (paths may be pre-create), just validate glob syntax**

---

**Status:** Planning  
**Next Step:** Implement spec parser + question generator
