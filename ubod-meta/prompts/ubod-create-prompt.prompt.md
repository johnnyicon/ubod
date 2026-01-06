---
name: Create New Prompt File
description: Guided workflow to create a new prompt file following VS Code specification
---

# Create New Prompt File (Ubod Framework)

**Purpose:** Create a new prompt file for reusable workflows

**Before starting:** Read `vscode-custom-prompt-spec.instructions.md` for official specification

---

## Step 1: Understand Prompt Files

**Prompt files provide:**
- Reusable workflows for common tasks
- YAML frontmatter for configuration
- Variables for user input and context
- Tool restrictions for safety
- Agent selection for specialized behavior

**Example use cases:**
- `/implement-feature` - Implement features with tests
- `/debug-stuck` - Systematic debugging workflow
- `/create-prd` - Generate PRDs with template
- `/review-pr` - Code review checklist

---

## Step 2: Define Prompt Purpose

**Answer these questions:**

1. **What task does this prompt solve?**
   - Be specific: "Debug stuck loops" not "Fix bugs"
   - Single responsibility: One clear purpose

2. **Who will use this prompt?**
   - Developers? AI agents? Both?
   - What context do they need?

3. **What inputs are needed?**
   - User variables (e.g., feature name, bug description)
   - Workspace context (e.g., current file, selection)

4. **What outputs are expected?**
   - Code changes? Documentation? Analysis?
   - Specific format requirements?

5. **What tools are required?**
   - Read-only? Full editing? Execution?
   - Safety constraints?

---

## Step 3: Choose YAML Frontmatter Properties

**Consult:** `vscode-custom-prompt-spec.instructions.md` for all available properties

### Required Properties

```yaml
---
name: Display Name
description: Brief description shown in UI
---
```

### Common Optional Properties

```yaml
# Agent to use (references .agent.md file)
agent: planner

# Tools available to agent
tools: ['search', 'fetch', 'edit', 'write']

# Built-in variables to include
context: ['file', 'selection', 'problems']
```

### Input Variables

**For prompts that need user input:**

```yaml
variables:
  - name: feature_name
    prompt: What feature are you implementing?
    required: true
  - name: approach
    prompt: What approach should be used?
    required: false
```

**Variable properties:**
- `name`: Variable identifier (use in prompt as `{{feature_name}}`)
- `prompt`: Question text shown to user
- `required`: Mandatory? (default: `false`)

---

## Step 4: Write Prompt Body

**Structure your prompt:**

### A. Context Section (Optional)

```markdown
## Context

You are working on {{file}} in a {{language}} project.

Current selection:
{{selection}}
```

### B. Task Definition (Required)

```markdown
## Task

Implement the feature: {{feature_name}}

Follow these requirements:
1. Write tests first
2. Implement minimum viable solution
3. Add documentation
```

### C. Constraints (Recommended)

```markdown
## Constraints

- Don't modify files outside {{workspace}}
- Use existing patterns from {{githubRepo}}
- Follow coding standards in .github/instructions/
```

### D. Output Format (Recommended)

```markdown
## Output

Provide:
1. Implementation plan with file list
2. Test cases to cover
3. Verification steps

Format as checklist.
```

### E. Examples (Optional)

```markdown
## Example

For a "user authentication" feature:
- Tests: test/system/auth_test.rb
- Implementation: app/controllers/sessions_controller.rb
- Docs: docs/authentication.md
```

---

## Step 5: Use Built-in Variables

**Available context variables:**

| Variable | Content | Use Case |
|----------|---------|----------|
| `{{file}}` | Current file path | File-specific operations |
| `{{selection}}` | Selected text | Refactoring, analysis |
| `{{problems}}` | Diagnostics/errors | Debugging prompts |
| `{{language}}` | File language | Language-specific hints |
| `{{workspace}}` | Workspace path | Project-wide operations |
| `{{githubRepo}}` | Git repository name | Repository context |

**Declare in frontmatter:**
```yaml
context: ['file', 'selection', 'problems']
```

**Use in prompt:**
```markdown
Fix the errors in {{file}}:

Errors:
{{problems}}

Selected code:
{{selection}}
```

---

## Step 6: Choose Tools

**Tool selection strategy:**

### Read-Only Prompts (Analysis, Planning)

```yaml
tools: ['search', 'fetch', 'usages', 'githubRepo']
```

**Use for:**
- Planning prompts
- Review prompts
- Analysis prompts

### Edit Prompts (Implementation)

```yaml
tools: ['search', 'fetch', 'edit', 'write', 'execute', 'githubRepo']
```

**Use for:**
- Implementation prompts
- Refactoring prompts
- Testing prompts

### Custom Tool Sets

```yaml
tools: ['search', 'fetch', 'playwright/*']  # Include all playwright tools
```

**Note:** Tool priority is prompt → agent → default

---

## Step 7: Select Agent (Optional)

**Reference a custom agent:**

```yaml
agent: planner
```

**Agent file must exist:**
- `.github/agents/planner.agent.md` (workspace)
- Or in VS Code profile folder (user)

**When to specify agent:**
- Need specialized behavior
- Want specific tool set from agent
- Multi-step workflow with handoffs

**When to omit:**
- Use default agent behavior
- Simple one-off prompts
- Tool specification sufficient

---

## Step 8: File Naming and Location

**Extension:** `.prompt.md` (REQUIRED)

**Location:**

1. **Workspace prompts:**
   - `.github/prompts/` folder
   - Shared with team via git

2. **User profile prompts:**
   - VS Code profile folder
   - Personal, not shared

**Naming convention:**
- Use descriptive names: `implement-feature.prompt.md`
- Lowercase with hyphens
- Avoid spaces

---

## Step 9: Validation Checklist

Before committing your prompt file:

### File Structure
- [ ] Extension is `.prompt.md`
- [ ] Located in `.github/prompts/` or profile folder
- [ ] YAML frontmatter between `---` delimiters
- [ ] Markdown body contains prompt

### YAML Frontmatter
- [ ] Valid YAML syntax
- [ ] `name` is clear and concise
- [ ] `description` explains purpose
- [ ] `tools` contains valid tool names (if specified)
- [ ] `agent` references existing agent (if specified)
- [ ] `variables` have name and prompt (if specified)
- [ ] `context` contains valid context names (if specified)

### Prompt Body
- [ ] Clear task definition
- [ ] Specific requirements
- [ ] Output format specified
- [ ] Variables used correctly ({{variable}})
- [ ] Context variables declared in frontmatter

### Testing
- [ ] Prompt appears in slash command list
- [ ] Variables prompt for input correctly
- [ ] Tools work as expected
- [ ] Produces expected output

---

## Step 10: Testing Your Prompt

**Manual testing:**

1. Open VS Code chat panel
2. Type `/` to see prompt list
3. Select your prompt
4. Fill in variables (if prompted)
5. Verify behavior

**Verify:**
- [ ] Prompt appears in list with correct name
- [ ] Description shows in UI
- [ ] Variables prompt correctly
- [ ] Selected agent is used
- [ ] Tools are available
- [ ] Output matches expectations

---

## Example: Complete Prompt File

```markdown
---
name: Implement Feature
description: Implement a new feature with tests and documentation
agent: planner
tools: ['search', 'fetch', 'edit', 'write', 'execute', 'githubRepo']
context: ['workspace', 'githubRepo']
variables:
  - name: feature_name
    prompt: What feature are you implementing?
    required: true
  - name: acceptance_criteria
    prompt: What are the acceptance criteria?
    required: false
---

# Implement Feature: {{feature_name}}

## Context

Working in: {{workspace}}
Repository: {{githubRepo}}

## Task

Implement the feature: **{{feature_name}}**

{{#if acceptance_criteria}}
Acceptance criteria:
{{acceptance_criteria}}
{{/if}}

## Process

### 1. Discovery Phase
- Use #tool:githubRepo to find similar implementations
- Use #tool:search to understand existing patterns
- Read related files with #tool:search

### 2. Planning Phase
Create implementation plan with:
- Files to create/modify
- Tests to write
- Dependencies needed
- Potential issues

### 3. Implementation Phase
- Write tests first (test-driven development)
- Implement minimum viable solution
- Ensure all tests pass
- Add documentation

## Constraints

- Follow coding standards in .github/instructions/
- Use existing patterns from {{githubRepo}}
- Write tests before implementation
- Update documentation

## Output Format

Provide:
1. **Discovery findings** (patterns, similar code)
2. **Implementation plan** (files, tests, steps)
3. **Test list** (unit, integration, system)
4. **Verification steps** (how to confirm it works)

Present as structured Markdown with checkboxes.
```

---

## Template: Basic Prompt File

```markdown
---
name: Your Prompt Name
description: Brief description of what this prompt does
---

# Prompt Title

## Task

[Clear description of what this prompt accomplishes]

## Instructions

[Step-by-step instructions for the AI]

## Constraints

[Limitations and requirements]

## Output

[Expected output format]
```

---

## Template: Advanced Prompt File

```markdown
---
name: Your Prompt Name
description: Brief description of what this prompt does
agent: custom-agent-name
tools: ['search', 'fetch', 'edit', 'write']
context: ['file', 'workspace']
variables:
  - name: input_var
    prompt: What input do you need?
    required: true
---

# Prompt Title

## Context

Working in: {{workspace}}
Current file: {{file}}

## Task

[Task description using {{input_var}}]

## Process

1. Discovery phase
2. Implementation phase
3. Verification phase

## Constraints

- [Constraint 1]
- [Constraint 2]

## Output

[Expected output format]
```

---

## Common Patterns

### Pattern: Planning Prompt

```yaml
agent: planner
tools: ['search', 'fetch', 'usages', 'githubRepo']
```

**Body:** Focus on analysis and plan generation, no code edits

### Pattern: Implementation Prompt

```yaml
agent: implementation
tools: ['search', 'fetch', 'edit', 'write', 'execute', 'githubRepo']
```

**Body:** Execute plan, write code, run tests

### Pattern: Debug Prompt

```yaml
context: ['file', 'selection', 'problems']
tools: ['search', 'fetch', 'usages']
```

**Body:** Analyze errors, suggest fixes, reference similar code

### Pattern: Review Prompt

```yaml
agent: reviewer
context: ['file', 'selection']
tools: ['search', 'fetch', 'usages', 'githubRepo']
```

**Body:** Check quality, security, best practices

---

## Tips for Great Prompts

### Be Specific

❌ "Fix bugs"
✅ "Systematically debug the current error by analyzing logs, searching similar issues, and proposing fixes"

### Use Variables for Flexibility

❌ Hardcode feature names
✅ Use `{{feature_name}}` variable

### Constrain Behavior

❌ "Implement the feature"
✅ "Implement the feature following TDD: write tests first, then implement minimum viable solution"

### Specify Output Format

❌ "Provide a plan"
✅ "Provide a plan as Markdown checklist with file paths and verification steps"

### Reference Context

❌ Assume workspace structure
✅ "Search {{githubRepo}} for similar patterns"

---

## Troubleshooting

### Prompt Not Appearing

**Check:**
- Extension is `.prompt.md`
- File in `.github/prompts/` or profile folder
- VS Code reloaded (Command Palette: Reload Window)

### Variables Not Prompting

**Check:**
- YAML syntax valid
- `variables` array has `name` and `prompt`
- Variable used in body as `{{variable_name}}`

### Tools Not Available

**Check:**
- `tools` array has valid tool names
- Tool names match official aliases
- No typos in tool names

### Agent Not Found

**Check:**
- Agent file exists (`.github/agents/agent-name.agent.md`)
- Agent name matches file name (without `.agent.md`)
- Agent is visible in dropdown

---

## Next Steps

After creating your prompt:

1. **Test thoroughly** in VS Code chat
2. **Document in README** (list of prompts with descriptions)
3. **Share with team** (commit to `.github/prompts/`)
4. **Gather feedback** (improve based on usage)
5. **Iterate** (refine based on real-world use)

---

**Ready to create your prompt file? Use the templates above as starting points!**
