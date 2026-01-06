---
applyTo: "**/*.agent.md"
source: "https://code.visualstudio.com/docs/copilot/customization/custom-agents"
lastUpdated: 2026-01-06
---

# VS Code Custom Agents Specification

**Purpose:** VS Code-specific agent specification (complements GitHub Copilot agent spec)

**Source:** [VS Code Custom Agents Documentation](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

**Related Spec:** See `github-custom-agent-spec.instructions.md` for cross-product compatible specification

---

## What Are Custom Agents?

**Custom agents** enable you to configure AI with different personas tailored to specific development roles and tasks:
- Security reviewer
- Planner
- Solution architect
- Implementation specialist
- Code reviewer

**Key capabilities:**
- Specialized behavior and instructions
- Specific tool access (read-only vs full editing)
- Handoffs between agents for guided workflows
- Reusable in background agents and cloud agents

---

## VS Code-Specific Features

**These features are VS Code-only (not in GitHub Copilot coding agent):**

| Feature | Description | Availability |
|---------|-------------|--------------|
| `handoffs` | Guided sequential workflows between agents | VS Code only |
| `model` | Specify AI model for agent | VS Code only |
| `argument-hint` | Helper text in chat input | VS Code only |
| Subagents | Run custom agent with subagents (experimental) | VS Code only |

**For cross-product compatible agents:** See `github-copilot-agent-spec.instructions.md`

---

## File Structure

### Required Elements

```markdown
---
[YAML frontmatter - OPTIONAL]
---

[Markdown body - REQUIRED]
```

### File Naming and Location

**Extension:** `.agent.md` (REQUIRED)

**Note:** VS Code also detects `.md` files in `.github/agents/` as custom agents

**Location options:**

1. **Workspace agents:**
   - Location: `.github/agents/` folder
   - Scope: Only available in current workspace
   - Shared: Via version control with team

2. **User profile agents:**
   - Location: VS Code profile folder
   - Scope: Available across all workspaces
   - Personal: Not shared with team

3. **Organization-level agents (Experimental):**
   - Defined at GitHub organization level
   - Auto-detected by VS Code
   - Setting: `github.copilot.chat.customAgents.showOrganizationAndEnterpriseAgents: true`

---

## YAML Frontmatter Properties

**All properties are OPTIONAL:**

| Property | Type | VS Code | GitHub | Description |
|----------|------|---------|--------|-------------|
| `description` | string | ✅ | ✅ | Brief description (placeholder text in chat input) |
| `name` | string | ✅ | ✅ | Display name (defaults to filename) |
| `tools` | array | ✅ | ✅ | Available tools for this agent |
| `argument-hint` | string | ✅ | ❌ | Helper text in chat input field |
| `model` | string | ✅ | ❌ | AI model to use (defaults to current model picker) |
| `infer` | boolean | ✅ | ✅ | Enable as subagent (default `true`) |
| `target` | string | ✅ | ✅ | Environment: `vscode` or `github-copilot` |
| `mcp-servers` | object | ✅ | ✅ | MCP server config (for `target: github-copilot`) |
| `handoffs` | array | ✅ | ❌ | Workflow transitions to other agents |

### Handoffs Property (VS Code-Specific)

**Purpose:** Create guided sequential workflows between agents

**Structure:**
```yaml
handoffs:
  - label: "Button text"
    agent: "target-agent-name"
    prompt: "Pre-filled prompt for target agent"
    send: false  # Auto-submit? (default: false)
```

**Handoff object properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `label` | string | ✅ | Display text on handoff button |
| `agent` | string | ✅ | Target agent identifier |
| `prompt` | string | ✅ | Prompt text to send to target agent |
| `send` | boolean | ❌ | Auto-submit prompt (default: `false`) |

**Common handoff patterns:**
- **Planning → Implementation:** Generate plan, then hand off to implement
- **Implementation → Review:** Complete code, then switch to review agent
- **Write Failing Tests → Write Passing Tests:** Generate tests, then implement to pass

**Example:**
```yaml
handoffs:
  - label: Start Implementation
    agent: implementation
    prompt: Now implement the plan outlined above.
    send: false
  - label: Review Code
    agent: reviewer
    prompt: Review the implementation for quality and security.
    send: false
```

---

## Markdown Body

### Purpose

Contains specialized instructions that define agent behavior.

### Content Guidelines

**Include:**
- Specific prompts and guidelines for AI
- Role definition (what agent should/shouldn't do)
- Output format requirements
- Task-specific constraints

**Tool references:**
```markdown
Use #tool:githubRepo to search the repository.
Use #tool:fetch to retrieve external resources.
```

**Instruction file references:**
```markdown
Follow the [coding guidelines](../../.github/instructions/coding.instructions.md).
```

**Behavioral constraints:**
```markdown
Don't make any code edits, just generate a plan.
Focus only on security vulnerabilities.
```

---

## Tool Selection Strategy

**Choose tools based on agent's purpose:**

### Read-Only Agents (Planners, Reviewers)

```yaml
tools: ['search', 'fetch', 'usages', 'githubRepo']
```

**Use for:**
- Planning agents (research and analysis)
- Review agents (code inspection)
- Architecture agents (design only)

**Benefits:**
- Prevents accidental code changes
- Focused on analysis and recommendations

### Full-Capability Agents (Implementation)

```yaml
tools: ['search', 'fetch', 'edit', 'write', 'execute', 'githubRepo']
```

**Use for:**
- Implementation agents
- Refactoring agents
- Testing agents (that write code)

### MCP Server Tools

**Include all tools from MCP server:**
```yaml
tools: ['search', 'fetch', 'playwright/*']
```

**Include specific MCP tool:**
```yaml
tools: ['search', 'custom-mcp/specific-tool']
```

---

## Tool Priority Hierarchy

**When multiple sources specify tools:**

1. **Highest priority:** Prompt file's `tools` field
2. **Medium priority:** Custom agent's `tools` field (via prompt's `agent:`)
3. **Lowest priority:** Default tools for selected agent

**Example:**
```yaml
# In agent file
tools: ['search', 'fetch', 'edit']

# In prompt file using this agent
agent: my-custom-agent
tools: ['search']  # Only 'search' available (overrides agent)
```

---

## Creating Custom Agents

### Via VS Code UI

**Command:** `Chat: New Custom Agent`

**Or:**
1. Agents dropdown → Configure Custom Agents → Create new custom agent
2. Choose location: Workspace or User profile
3. Enter filename (without `.agent.md` extension)
4. Fill in YAML frontmatter
5. Add instructions in Markdown body

### Via File System

```bash
# Workspace agent
touch .github/agents/planner.agent.md

# Edit in VS Code - fill in frontmatter and body
```

### Modify Existing Agents

**Command:** `Chat: Configure Custom Agents`

**Or:**
- Agents dropdown → Configure Custom Agents → Select agent

---

## Customize Agents Dropdown

**Show/hide agents:**
1. Agents dropdown → Configure Custom Agents
2. Hover over agent
3. Click eye icon to toggle visibility

**Useful for:**
- Hiding experimental agents
- Organizing frequently used agents
- Reducing dropdown clutter

---

## Example: Planning Agent

```markdown
---
description: Generate an implementation plan for new features or refactoring existing code.
name: Planner
tools: ['fetch', 'githubRepo', 'search', 'usages']
model: Claude Sonnet 4
handoffs:
  - label: Implement Plan
    agent: agent
    prompt: Implement the plan outlined above.
    send: false
---

# Planning Instructions

You are in planning mode. Your task is to generate an implementation plan for a new feature or for refactoring existing code.

Don't make any code edits, just generate a plan.

The plan consists of a Markdown document that describes the implementation plan, including the following sections:

* **Overview:** A brief description of the feature or refactoring task.
* **Requirements:** A list of requirements for the feature or refactoring task.
* **Implementation Steps:** A detailed list of steps to implement the feature or refactoring task.
* **Testing:** A list of tests that need to be implemented to verify the feature or refactoring task.

## Research Phase

1. Use #tool:githubRepo to search for similar implementations
2. Use #tool:search to find relevant code patterns
3. Use #tool:usages to understand how existing code is used

## Output Format

Present the plan in structured Markdown with:
- Clear section headers
- Bullet points for actionable items
- Code examples where relevant
- Links to related files/issues
```

---

## Example: Implementation Agent

```markdown
---
description: Implement features and refactorings based on a plan
name: Implementer
tools: ['search', 'fetch', 'edit', 'write', 'execute', 'githubRepo']
model: Claude Sonnet 4
handoffs:
  - label: Review Changes
    agent: reviewer
    prompt: Review the implementation for quality and security issues.
    send: false
---

# Implementation Instructions

You are in implementation mode. Your task is to implement features or refactorings based on a provided plan.

## Guidelines

1. Follow the plan exactly as provided
2. Write clean, idiomatic code
3. Add appropriate tests
4. Update documentation as needed

## Process

1. Use #tool:search to understand existing code structure
2. Use #tool:edit to make changes
3. Use #tool:execute to run tests
4. Verify all tests pass before completing

## Code Quality

- Follow project coding standards
- Add comments for complex logic
- Keep functions small and focused
- Handle errors appropriately
```

---

## Example: Review Agent

```markdown
---
description: Review code for quality and security issues
name: Reviewer
tools: ['search', 'fetch', 'usages', 'githubRepo']
model: Claude Sonnet 4
---

# Review Instructions

You are in review mode. Your task is to review code for quality, security, and best practices.

Don't make any code edits, just provide recommendations.

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

### Testing
- [ ] Adequate test coverage
- [ ] Edge cases handled
- [ ] Tests are clear and maintainable

## Output Format

Provide:
1. Summary (Critical, High, Medium, Low issues)
2. Specific findings with line numbers
3. Recommendations for improvement
4. Code examples for fixes
```

---

## Subagents (Experimental)

**Custom agents can run with subagents:**

**Setting:** `infer: true` (default)

**Behavior:**
- Agent can spawn subagents for specialized tasks
- Subagents inherit parent agent's context
- Useful for complex multi-step workflows

**Learn more:** [Use custom agent with subagents](https://code.visualstudio.com/docs/copilot/chat/chat-sessions#_use-a-custom-agent-with-subagents-experimental)

---

## Migration from Chat Modes

**Previously known as:** Custom chat modes (`.chatmode.md`)

**Still supported:**
- VS Code recognizes `.chatmode.md` files as agents
- Files in `.github/chatmodes/` folder detected

**Migration:**
- Use Quick Fix action to rename `.chatmode.md` → `.agent.md`
- Move from `.github/chatmodes/` → `.github/agents/`

---

## Validation Checklist

Before deploying custom agent:

### File Structure
- [ ] Extension is `.agent.md`
- [ ] Located in `.github/agents/` (workspace) or profile folder (user)
- [ ] YAML frontmatter between `---` delimiters (if used)
- [ ] Markdown body contains instructions

### YAML Frontmatter (if used)
- [ ] Valid YAML syntax
- [ ] `description` is clear and concise
- [ ] `name` is descriptive (or omit for filename)
- [ ] `tools` contains valid tool names
- [ ] `model` is valid model name (or omit for default)
- [ ] `handoffs` array has valid structure (label, agent, prompt)

### Content Quality
- [ ] Clear role definition
- [ ] Specific behavioral instructions
- [ ] Tool references use `#tool:` syntax
- [ ] File references use Markdown links
- [ ] Output format specified

### Testing
- [ ] Agent appears in dropdown
- [ ] Tools work as expected
- [ ] Handoffs transition correctly
- [ ] Produces expected output

---

## Common Mistakes

### ❌ Wrong Extension

```
# WRONG
planner.md
```

```
# CORRECT
planner.agent.md
```

### ❌ Invalid Handoff Structure

```yaml
# WRONG - Missing required fields
handoffs:
  - label: Next Step
```

```yaml
# CORRECT - All required fields
handoffs:
  - label: Next Step
    agent: implementation
    prompt: Implement the plan above.
```

### ❌ Using VS Code Properties in GitHub Target

```yaml
# WRONG - handoffs not supported in github-copilot target
target: github-copilot
handoffs:
  - label: Next
    agent: other
    prompt: Continue
```

```yaml
# CORRECT - Use handoffs only with vscode target or no target
target: vscode
handoffs:
  - label: Next
    agent: other
    prompt: Continue
```

---

## Comparison: VS Code vs GitHub Copilot

| Feature | VS Code | GitHub.com | Notes |
|---------|---------|------------|-------|
| `tools` | ✅ | ✅ | Tool aliases same |
| `description` | ✅ | ✅ | Compatible |
| `name` | ✅ | ✅ | Compatible |
| `infer` | ✅ | ✅ | Compatible |
| `target` | ✅ | ✅ | Compatible |
| `mcp-servers` | ✅ | ✅ | Compatible |
| **`handoffs`** | ✅ | ❌ | VS Code only |
| **`model`** | ✅ | ❌ | VS Code only |
| **`argument-hint`** | ✅ | ❌ | VS Code only |

**For maximum compatibility:**
- Omit `handoffs`, `model`, `argument-hint`
- See `github-custom-agent-spec.instructions.md` for cross-product spec

**For VS Code-specific features:**
- Use `handoffs` for guided workflows
- Specify `model` for agent-specific model selection
- Add `argument-hint` for better UX

---

## References

- **Official Docs:** https://code.visualstudio.com/docs/copilot/customization/custom-agents
- **GitHub Agent Spec:** https://docs.github.com/en/copilot/reference/custom-agents-configuration
- **Custom Instructions:** https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- **Prompt Files:** https://code.visualstudio.com/docs/copilot/customization/prompt-files
- **Chat Tools:** https://code.visualstudio.com/docs/copilot/chat/chat-tools
- **Community Examples:** https://github.com/github/awesome-copilot

---

**Last Updated:** 2026-01-06 (based on VS Code docs as of this date)
