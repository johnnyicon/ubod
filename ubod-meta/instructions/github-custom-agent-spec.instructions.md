---
applyTo: "**/*.agent.md"
source: "https://docs.github.com/en/copilot/reference/custom-agents-configuration"
lastUpdated: 2026-01-06
---

# GitHub Copilot Custom Agent Specification

**Purpose:** Authoritative specification for creating GitHub Copilot custom agents

**Source:** [GitHub Copilot Custom Agents Configuration](https://docs.github.com/en/copilot/reference/custom-agents-configuration)

**Related Docs:**
- [Creating Custom Agents (How-To)](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents) - UI workflows for GitHub.com, VS Code, JetBrains, Eclipse, Xcode
- See `vscode-custom-agent-spec.instructions.md` for VS Code-specific features

---

## File Structure (MANDATORY)

### File Naming

- **Extension:** `.md` or `.agent.md`
- **Identifier:** Filename (minus extension) serves as agent identifier
- **Precedence:** Repository > Organization > Enterprise (lowest level wins)
- **Deduplication:** Agents with same filename override higher-level agents

### File Format

```markdown
---
[YAML frontmatter]
---

[Markdown prompt body]
```

---

## YAML Frontmatter Properties

### Required Properties

| Property | Type | Description |
|----------|------|-------------|
| `description` | string | **REQUIRED** - Description of agent's purpose and capabilities |

### Optional Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | (filename) | Display name for custom agent |
| `target` | string | both | Target environment: `vscode`, `github-copilot`, or both |
| `tools` | list/string | all tools | Tools agent can use (see Tools section) |
| `infer` | boolean | `true` | Allow automatic selection based on context |
| `mcp-servers` | object | (none) | MCP server configuration (org/enterprise only) |
| `metadata` | object | (none) | Name-value pairs for annotation (NOT in VS Code) |

### Unsupported Properties (VS Code Only)

⚠️ **These properties are IGNORED by GitHub Copilot coding agent:**

- `model` - Model selection not supported
- `argument-hint` - Argument hints not supported
- `handoffs` - Handoff configuration not supported

**Why ignored?** GitHub.com coding agent doesn't support these yet. They're ignored (not errors) for cross-product compatibility.

---

## Tools Configuration

### Tools Property Syntax

**Enable all tools:**
```yaml
# Option 1: Omit tools property
---
description: My agent
---

# Option 2: Explicit wildcard
---
description: My agent
tools: ["*"]
---
```

**Enable specific tools:**
```yaml
---
description: My agent
tools: ["read", "edit", "search"]
---
```

**Disable all tools:**
```yaml
---
description: My agent
tools: []
---
```

### Tool Aliases (Case-Insensitive)

| Alias | Alternative Names | Category | Description |
|-------|------------------|----------|-------------|
| `execute` | shell, Bash, powershell | Shell tools | Execute commands in bash/powershell |
| `read` | Read, NotebookRead | View tools | Read file contents |
| `edit` | Edit, MultiEdit, Write, NotebookEdit | Edit tools | Modify files (str_replace, etc) |
| `search` | Grep, Glob | Search tools | Search files or text in files |
| `agent` | custom-agent, Task | Agent tools | Invoke other custom agents |
| `web` | WebSearch, WebFetch | Web tools | Fetch URLs, web search (NOT in coding agent) |
| `todo` | TodoWrite | Task tools | Manage task lists (VS Code only) |

**Important notes:**
- All aliases are **case-insensitive**
- Unrecognized tool names are **ignored** (not errors)
- Use lowercase for consistency: `["read", "edit", "search"]`

### MCP Server Tools

**Repository-level agents:**
- Cannot configure MCP servers directly
- Have access to MCP tools configured in repository settings
- Reference MCP tools: `"some-mcp-server/some-tool"`
- Enable all MCP server tools: `"some-mcp-server/*"`

**Organization/Enterprise agents:**
- Can configure MCP servers in `mcp-servers` property
- Reference MCP tools same as repository-level

**Out-of-the-box MCP servers:**
- `github/*` - Read-only GitHub tools (scoped to source repo)
- `github/some-tool` - Specific GitHub MCP tool
- `playwright/*` - Playwright tools (localhost only)
- `playwright/some-tool` - Specific Playwright tool

**VS Code extension tools:**
- Reference: `"azure.some-extension/some-tool"`

### Tools Processing Rules

1. **No tools specified** → All available tools enabled (built-in + MCP)
2. **Empty list** (`tools: []`) → All tools disabled
3. **Specific list** → Only those tools enabled
4. **MCP processing order:**
   - Out-of-the-box MCP (github, playwright)
   - Custom agent MCP config (org/enterprise only)
   - Repository-level MCP config

---

## MCP Server Configuration (Org/Enterprise Only)

⚠️ **Repository-level agents CANNOT configure MCP servers in agent file.**

### MCP Server Syntax

```yaml
---
description: Agent with MCP
tools: ['read', 'custom-mcp/tool-1']
mcp-servers:
  custom-mcp:
    type: 'local'  # or 'stdio' (mapped to 'local')
    command: 'some-command'
    args: ['--arg1', '--arg2']
    tools: ["*"]  # or specific tool list
    env:
      ENV_VAR_NAME: $COPILOT_MCP_ENV_VAR_VALUE
---
```

### MCP Environment Variables

**Must be configured in repository's "copilot" environment settings.**

**Supported syntax patterns:**
- `$COPILOT_MCP_ENV_VAR_VALUE` - Environment variable and header
- `${COPILOT_MCP_ENV_VAR_VALUE}` - Environment variable and header (Claude Code syntax)
- `${{ secrets.COPILOT_MCP_ENV_VAR_VALUE }}` - Environment variable and header
- `${{ var.COPILOT_MCP_ENV_VAR_VALUE }}` - Environment variable and header

**NOT recommended:**
- `COPILOT_MCP_ENV_VAR_VALUE` (no prefix) - Environment variable only, header differences

### MCP Server Type

- `local` - Standard type for GitHub Copilot coding agent
- `stdio` - Mapped to `local` for compatibility with Claude Code and VS Code

---

## Markdown Prompt Body

### Constraints

- **Maximum length:** 30,000 characters
- **Location:** Below YAML frontmatter
- **Format:** Standard Markdown

### Content Guidelines

**Define:**
- Agent's behavior and expertise
- Responsibilities and scope
- Output format and style guidelines
- Constraints and limitations
- Best practices to follow

**Structure:**
- Use clear, imperative language
- Bullet points or numbered lists for clarity
- Specific focus areas and things to avoid
- Include examples where helpful

### Example Template

```markdown
---
name: specialist-name
description: Clear description of agent purpose and capabilities
tools: ["read", "edit", "search"]
infer: true
---

You are a [specialist type] focused on [primary focus]. Your responsibilities:

- [Responsibility 1]
- [Responsibility 2]
- [Responsibility 3]

Guidelines:
- [Guideline 1]
- [Guideline 2]
- [Guideline 3]

Always [behavioral instruction]. Focus on [priority areas]. Avoid [things to avoid].

Output format:
- [Format requirement 1]
- [Format requirement 2]
```

---

## Processing and Versioning

### Agent Name Conflicts

**Precedence (lowest wins):**
1. Repository-level agent (highest precedence)
2. Organization-level agent
3. Enterprise-level agent (lowest precedence)

**Example:** If `my-agent.agent.md` exists at all 3 levels, repository version is used.

### Versioning

- **Version identifier:** Git commit SHA of agent profile file
- **Branch support:** Different branches can have different agent versions
- **Assignment:** Agent instantiated with latest version for that branch
- **Pull request consistency:** Same agent version used throughout PR lifecycle

### Target Environment

- `target: vscode` - Only in VS Code
- `target: github-copilot` - Only in GitHub.com coding agent
- No `target` or both values - Works in both environments

---

## Validation Checklist

Before deploying an agent, verify:

### YAML Frontmatter
- [ ] Frontmatter between `---` delimiters
- [ ] `description` field present and descriptive
- [ ] `tools` list contains only valid aliases or MCP tool references
- [ ] No unsupported properties (`model`, `argument-hint`, `handoffs`)
- [ ] `infer` is boolean (`true` or `false`), not string

### Tools Configuration
- [ ] Tool names are lowercase for consistency
- [ ] Tool aliases match specification (execute, read, edit, search, agent, web, todo)
- [ ] MCP tools use correct format: `server-name/tool-name` or `server-name/*`
- [ ] VS Code extension tools use: `extension-name/tool-name`

### MCP Configuration (if applicable)
- [ ] `mcp-servers` only used in org/enterprise agents
- [ ] Environment variables reference "copilot" environment
- [ ] Environment variable syntax uses supported patterns
- [ ] MCP server type is `local` or `stdio`

### Prompt Body
- [ ] Prompt body is under 30,000 characters
- [ ] Uses clear, imperative language
- [ ] Includes behavioral instructions
- [ ] Specifies output format and constraints
- [ ] Structured with bullet points or lists

### File Naming
- [ ] Filename avoids conflicts with existing agents
- [ ] Filename (minus extension) is descriptive identifier
- [ ] Extension is `.md` or `.agent.md`

---

## Common Mistakes to Avoid

### ❌ Wrong Property Names

```yaml
# WRONG - These are VS Code only, ignored by GitHub Copilot
---
description: My agent
model: gpt-4
argument-hint: "Describe your task"
handoffs:
  - name: other-agent
    prompt: "Hand off to other agent"
---
```

```yaml
# CORRECT - GitHub Copilot compatible
---
description: My agent
tools: ["read", "edit", "search", "agent"]
---
```

### ❌ Wrong Tool Names

```yaml
# WRONG - Not valid tool aliases
---
tools: ["read_file", "grep_search", "create_file"]
---
```

```yaml
# CORRECT - Valid tool aliases
---
tools: ["read", "search", "edit"]
---
```

### ❌ MCP in Repository Agent

```yaml
# WRONG - Repository agents cannot configure MCP servers
---
description: Repo-level agent
mcp-servers:
  custom-mcp:
    type: 'local'
    command: 'some-command'
---
```

```yaml
# CORRECT - Repository agent using MCP tools
---
description: Repo-level agent
tools: ["read", "custom-mcp/some-tool"]
---
# Note: custom-mcp must be configured in repository settings
```

### ❌ Wrong Infer Type

```yaml
# WRONG - infer must be boolean
---
description: My agent
infer: "true"
---
```

```yaml
# CORRECT - boolean value
---
description: My agent
infer: true
---
```

---

## Cross-Product Compatibility

**Key principle:** Unrecognized properties and tool names are **ignored**, not errors.

**This allows:**
- VS Code-specific properties in agents that also work on GitHub.com
- Product-specific tools without breaking other products
- Graceful degradation across environments

**Example - Cross-compatible agent:**
```yaml
---
description: Works in both VS Code and GitHub.com
tools: ["read", "edit", "search", "web", "todo"]
target: # Defaults to both
---
# web and todo only work in their respective products, ignored elsewhere
```

---

## Schema Verification (CRITICAL)

**Before committing agent files, run these verification commands:**

### 1. No multiline prompts

```bash
grep -n "prompt: |" **/*.agent.md
```

**Must return:** 0 results (exit code 1)  
**If found:** Convert to single-line `prompt: "..."`

### 2. No invalid tool names

```bash
grep -E "tools:.*_(file|string|in_file|search)" **/*.agent.md
```

**Must return:** 0 results (exit code 1)  
**If found:** Use valid tool names: `read`, `search`, `edit`, `execute`

### 3. All handoffs have labels (if using VS Code features)

```bash
grep -A3 "handoffs:" **/*.agent.md | grep -B1 "agent:" | grep -v "label:"
```

**Must return:** 0 results (all handoffs have labels)  
**If found:** Add `label:` field (REQUIRED in VS Code)

**Schema violations break GitHub Copilot.** Always verify before commit.

---

## References

- **Official Docs:** https://docs.github.com/en/copilot/reference/custom-agents-configuration
- **How-To Guide:** https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents
- **VS Code Agents:** https://code.visualstudio.com/docs/copilot/customization/custom-agents
- **MCP Configuration:** https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/extend-coding-agent-with-mcp
- **Examples:** https://github.com/github/awesome-copilot/tree/main/agents
- **Migration Guide:** `ubod-meta/migrations/2026-01-06-vscode-agent-schema-fix.md`

---

**Last Updated:** 2026-01-06 (based on GitHub Docs as of this date)
