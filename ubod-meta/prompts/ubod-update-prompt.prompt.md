---
name: Update Existing Prompt File
description: Update an existing prompt file to match VS Code specification and best practices
---

# Update Existing Prompt File (Ubod Framework)

**Purpose:** Update an existing prompt file for compliance with VS Code specification

**Before starting:** Read `vscode-custom-prompt-spec.instructions.md` for official specification

---

## Step 1: Identify Update Type

**What kind of update are you making?**

### A. Schema Compliance (Breaking Changes)

**Migrate invalid properties:**
- Remove `model:` field (not supported in GitHub Copilot)
- Fix tool names (use official aliases)
- Update agent references (case-sensitive)
- Fix YAML syntax errors

**When:** After framework specification updates

### B. Enhancement (New Features)

**Add capabilities:**
- Add variables for user input
- Add context (file, selection, problems)
- Specify tools for safety
- Reference custom agents
- Improve prompt instructions

**When:** Improving existing prompts

### C. Content Update (Refinement)

**Improve clarity:**
- Better task descriptions
- Clearer output format
- More specific constraints
- Better examples

**When:** Based on usage feedback

---

## Step 2: Read Current Prompt

**Before making changes:**

1. Read the entire file
2. Understand current behavior
3. Note what works well
4. Identify issues or gaps

**Questions to answer:**
- What is the prompt's purpose?
- Who uses it?
- What inputs does it need?
- What outputs does it produce?
- Are there issues with current version?

---

## Step 3: Schema Validation

**Check against specification:**

### YAML Frontmatter

**Valid properties:**
- `name` - Display name
- `description` - Brief description
- `agent` - Custom agent to use
- `tools` - Tool restrictions
- `context` - Built-in variables
- `variables` - User input variables

**Invalid properties (remove if present):**
- ❌ `model` - Not supported in GitHub Copilot
- ❌ `temperature` - Not supported
- ❌ Custom properties not in spec

### Tool Names

**Use official aliases:**
- ✅ `search` (not `grep_search` or `semantic_search`)
- ✅ `edit` (not `replace_string_in_file`)
- ✅ `write` (not `create_file`)
- ✅ `execute` (not `run_in_terminal`)

**See:** `vscode-custom-prompt-spec.instructions.md` for full list

### Agent References

**Ensure agent exists:**
- `.github/agents/agent-name.agent.md`
- Case-sensitive reference
- Agent is visible in dropdown

---

## Step 4: Add Missing Features

**Enhance the prompt:**

### Add Variables (If Needed)

**Before:**
```markdown
# Implement the user authentication feature
```

**After:**
```yaml
---
variables:
  - name: feature_name
    prompt: What feature are you implementing?
    required: true
---

# Implement the {{feature_name}} feature
```

### Add Context (If Helpful)

**Before:**
```markdown
Fix the errors in this file.
```

**After:**
```yaml
---
context: ['file', 'problems']
---

Fix the errors in {{file}}:

{{problems}}
```

### Add Tools (For Safety)

**Before:**
```yaml
---
# No tools specified - uses all default tools
---
```

**After:**
```yaml
---
tools: ['search', 'fetch', 'usages']  # Read-only for planning
---
```

### Add Agent (For Specialization)

**Before:**
```yaml
---
# Uses default agent
---
```

**After:**
```yaml
---
agent: planner  # Use specialized planning agent
---
```

---

## Step 5: Improve Prompt Instructions

**Make instructions clearer:**

### A. Structure the Task

**Before:**
```markdown
Implement the feature with tests.
```

**After:**
```markdown
## Task

Implement: {{feature_name}}

## Process

1. **Discovery:** Search for similar implementations
2. **Planning:** Create implementation plan
3. **Implementation:** Write tests first, then code
4. **Verification:** Ensure all tests pass

## Output

Provide checklist with:
- [ ] Files to create/modify
- [ ] Tests written
- [ ] All tests passing
```

### B. Add Constraints

**Before:**
```markdown
Write the code.
```

**After:**
```markdown
## Constraints

- Follow coding standards in .github/instructions/
- Use existing patterns from {{githubRepo}}
- Write tests before implementation
- Update documentation
```

### C. Specify Output Format

**Before:**
```markdown
Provide an implementation plan.
```

**After:**
```markdown
## Output Format

Provide as structured Markdown:

1. **Discovery Findings**
   - Similar implementations found
   - Patterns identified
   - Dependencies needed

2. **Implementation Plan**
   - [ ] File 1: description
   - [ ] File 2: description
   - [ ] Tests: description

3. **Verification Steps**
   - How to test manually
   - How to run automated tests
```

---

## Step 6: Update Examples

**If prompt includes examples:**

### Ensure Examples Match Current Spec

**Before:**
```markdown
Example:
- Use grep_search to find similar code
```

**After:**
```markdown
Example:
- Use #tool:search to find similar code
```

### Add More Examples If Helpful

**Before:**
```markdown
[Single example]
```

**After:**
```markdown
## Examples

### Example 1: User Authentication
- Feature: User login/logout
- Tests: test/system/auth_test.rb
- Implementation: app/controllers/sessions_controller.rb

### Example 2: API Endpoint
- Feature: REST API for users
- Tests: test/controllers/api/users_controller_test.rb
- Implementation: app/controllers/api/users_controller.rb
```

---

## Step 7: Validation Checklist

**After making changes:**

### File Structure
- [ ] Extension is `.prompt.md`
- [ ] Located in `.github/prompts/` or profile folder
- [ ] YAML frontmatter between `---` delimiters
- [ ] Markdown body contains prompt

### YAML Frontmatter
- [ ] Valid YAML syntax
- [ ] No unsupported properties (model, temperature)
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
- [ ] Tool references use `#tool:` syntax
- [ ] Examples are current and accurate

### Backward Compatibility
- [ ] Existing usage still works
- [ ] New variables are optional (or migration plan)
- [ ] Breaking changes documented

---

## Step 8: Test Updated Prompt

**Before committing:**

1. Reload VS Code window
2. Test prompt in chat panel
3. Verify variables prompt correctly
4. Verify tools work as expected
5. Verify output matches specification
6. Test with real use cases

**Verify:**
- [ ] Prompt still appears in list
- [ ] Name/description updated correctly
- [ ] Variables prompt as expected
- [ ] Tools restricted correctly
- [ ] Agent is used (if specified)
- [ ] Output format improved

---

## Step 9: Document Changes

**Update documentation:**

### A. Changelog Entry

```markdown
## [1.2.0] - 2026-01-06

### Changed
- **implement-feature:** Added feature_name variable, improved output format
- **debug-stuck:** Added file and problems context, restricted to read-only tools
```

### B. Migration Guide (If Breaking)

```markdown
## Migration: implement-feature.prompt.md

**Breaking Change:** Now requires `feature_name` variable

**Before:**
```
/implement-feature
```

**After:**
```
/implement-feature
[Prompts for feature name]
```

**Update user workflows to provide feature name when prompted.**
```

### C. README Update

```markdown
### Available Prompts

- **`/implement-feature`** - Implement new feature with tests and docs
  - Variables: `feature_name` (required), `acceptance_criteria` (optional)
  - Agent: planner
  - Tools: search, fetch, edit, write, execute
```

---

## Example: Schema Compliance Update

**Migration: Remove `model:` field**

**Before:**
```yaml
---
name: Implement Feature
description: Implement a new feature
model: claude-sonnet-4
---
```

**After:**
```yaml
---
name: Implement Feature
description: Implement a new feature
# Removed model field - not supported in GitHub Copilot
---
```

**Change log:**
```markdown
- Removed `model:` field (not supported in GitHub Copilot)
- Model selection now controlled by VS Code model picker
```

---

## Example: Enhancement Update

**Enhancement: Add variables and context**

**Before:**
```yaml
---
name: Debug Issue
description: Debug the current issue
---

Debug the issue in the current file.
```

**After:**
```yaml
---
name: Debug Issue
description: Debug the current issue systematically
context: ['file', 'problems', 'selection']
variables:
  - name: error_description
    prompt: Describe the error or unexpected behavior
    required: true
---

# Debug Issue in {{file}}

## Current State

**Errors:**
{{problems}}

**Selected code:**
{{selection}}

**User description:**
{{error_description}}

## Task

Systematically debug this issue:

1. Analyze error messages
2. Search for similar issues
3. Identify root cause
4. Propose fix with explanation

## Output

Provide:
1. **Root cause analysis**
2. **Proposed fix** (code changes)
3. **Why this fixes it** (explanation)
4. **How to verify** (test steps)
```

---

## Example: Content Refinement

**Refinement: Improve clarity and structure**

**Before:**
```markdown
---
name: Review Code
description: Review code for issues
---

Review the code for quality and security issues.
```

**After:**
```markdown
---
name: Review Code
description: Systematic code review for quality, security, and best practices
agent: reviewer
context: ['file', 'selection']
tools: ['search', 'fetch', 'usages', 'githubRepo']
---

# Code Review: {{file}}

{{#if selection}}
## Selected Code

{{selection}}
{{/if}}

## Review Checklist

### Code Quality
- [ ] Clear and descriptive naming
- [ ] Functions are small and focused
- [ ] Comments explain WHY, not WHAT
- [ ] No duplicate code

### Security
- [ ] Input validation present
- [ ] No hardcoded secrets
- [ ] Proper error handling
- [ ] Authentication/authorization checks

### Best Practices
- [ ] Follows project conventions
- [ ] Error handling appropriate
- [ ] Tests cover functionality
- [ ] Documentation updated

## Process

1. Use #tool:search to understand context
2. Use #tool:usages to see how code is used
3. Use #tool:githubRepo to find similar patterns
4. Provide findings with line numbers

## Output Format

Provide:

1. **Summary:** Critical, High, Medium, Low issues count
2. **Findings:** Specific issues with line numbers
3. **Recommendations:** How to fix each issue
4. **Examples:** Code snippets showing fixes
```

---

## Common Update Patterns

### Pattern: Add Safety with Tools

**Before:** Unrestricted tools
**After:** Specify read-only tools for planning prompts

```yaml
tools: ['search', 'fetch', 'usages', 'githubRepo']
```

### Pattern: Add Flexibility with Variables

**Before:** Hardcoded values
**After:** Variables for user input

```yaml
variables:
  - name: input_name
    prompt: Question text
    required: true
```

### Pattern: Add Context

**Before:** No file/selection context
**After:** Include relevant context

```yaml
context: ['file', 'selection', 'problems']
```

### Pattern: Use Specialized Agent

**Before:** Default agent
**After:** Reference custom agent

```yaml
agent: planner  # or reviewer, implementation, etc.
```

---

## Troubleshooting

### Changes Not Reflected

**Solution:** Reload VS Code window
- Command Palette: "Developer: Reload Window"
- Or restart VS Code

### Variables Not Working

**Check:**
- YAML syntax valid
- Variable declared in frontmatter
- Variable used correctly in body: `{{variable_name}}`

### Tools Not Restricted

**Check:**
- `tools` array in frontmatter
- Tool names valid (use official aliases)
- No typos

### Agent Not Loading

**Check:**
- Agent file exists: `.github/agents/agent-name.agent.md`
- Agent name correct (case-sensitive)
- Agent visible in dropdown

---

## Rollback Plan

**If update causes issues:**

### Immediate Rollback

```bash
git checkout HEAD~1 .github/prompts/your-prompt.prompt.md
```

### Gradual Rollout

1. Create new version: `your-prompt-v2.prompt.md`
2. Keep old version available
3. Test new version with team
4. Remove old version when stable

### Feature Flags

```yaml
---
variables:
  - name: use_new_flow
    prompt: Use new workflow? (yes/no)
    required: false
---

{{#if use_new_flow}}
[New implementation]
{{else}}
[Old implementation]
{{/if}}
```

---

## Best Practices

### Version Your Prompts

**Option 1: Git tags**
```bash
git tag -a prompts-v1.2.0 -m "Update implement-feature with variables"
```

**Option 2: Changelog**
```markdown
## Prompt Changelog

### 2026-01-06 - v1.2.0
- implement-feature: Added variables, improved structure
```

### Test Before Committing

- Test with real use cases
- Get feedback from users
- Verify backward compatibility

### Document Breaking Changes

```markdown
## Breaking Changes

**implement-feature.prompt.md**
- Now requires `feature_name` variable
- Migration: Provide feature name when prompted
```

### Keep Prompts Simple

- One clear purpose per prompt
- Don't try to handle everything
- Create multiple focused prompts instead

---

## Next Steps

After updating your prompt:

1. **Test thoroughly** with real use cases
2. **Update documentation** (README, changelog)
3. **Notify team** of changes
4. **Gather feedback** from users
5. **Iterate** based on usage patterns

---

**Ready to update your prompt file? Follow the checklist above for a smooth update!**
