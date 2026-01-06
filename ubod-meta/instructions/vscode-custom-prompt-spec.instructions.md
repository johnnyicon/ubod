---
applyTo: "**/*.prompt.md"
source: "https://code.visualstudio.com/docs/copilot/customization/prompt-files"
lastUpdated: 2026-01-06
---

# VS Code Prompt Files Specification

**Purpose:** Authoritative specification for creating VS Code prompt files

**Source:** [VS Code Prompt Files Documentation](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

---

## What Are Prompt Files?

**Prompt files** are reusable Markdown files that define common development tasks:
- Generating code (components, APIs, tests)
- Performing reviews (security, code quality)
- Scaffolding projects
- Standardized workflows

**Key characteristics:**
- Triggered on-demand (unlike custom instructions that apply automatically)
- Create a library of development workflows
- Can reference custom instructions
- Support variables for dynamic content

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

**Extension:** `.prompt.md` (REQUIRED)

**Location options:**

1. **Workspace prompts:**
   - Default: `.github/prompts/` folder
   - Custom: Additional folders via `chat.promptFilesLocations` setting
   - Scope: Only available in current workspace
   - Shared: Via version control with team

2. **User prompts:**
   - Location: VS Code profile folder
   - Scope: Available across all workspaces
   - Sync: Via Settings Sync

---

## YAML Frontmatter Properties

**All properties are OPTIONAL:**

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Command name after `/` in chat (defaults to filename) |
| `description` | string | Brief explanation of what prompt does |
| `argument-hint` | string | Helper text shown in chat input field |
| `agent` | string | Agent to run prompt: `ask`, `edit`, `agent`, or custom agent name |
| `model` | string | Language model to use (defaults to current model picker selection) |
| `tools` | array | Available tools for this prompt |

### Property Details

#### `name` Property

**Default behavior:**
- If omitted, filename (minus `.prompt.md`) is used
- Determines command: `/name` in chat

**Example:**
```yaml
name: create-react-form
```
**Usage:** `/create-react-form` in chat

#### `description` Property

**Purpose:** Appears in prompt list and help text

**Example:**
```yaml
description: "Generate a React form component with validation"
```

#### `argument-hint` Property

**Purpose:** Guide users on providing additional context

**Example:**
```yaml
argument-hint: "formName=MyForm fields=name,email,password"
```

**Appears as:** Placeholder text in chat input

#### `agent` Property

**Valid values:**
- `ask` - Ask agent (default for chat)
- `edit` - Edit agent (inline edits)
- `agent` - Agent with full tool access
- `custom-agent-name` - Reference custom agent

**Default behavior:**
- Uses current agent
- If `tools` specified and current agent is `ask` or `edit`, defaults to `agent`

**Example:**
```yaml
agent: edit
```

#### `model` Property

**Purpose:** Specify language model for this prompt

**Example:**
```yaml
model: gpt-4
```

**Default:** Currently selected model in model picker

#### `tools` Property

**Purpose:** Specify available tools for this prompt

**Syntax:**
```yaml
tools: ["read", "edit", "search", "githubRepo"]
```

**Can include:**
- Built-in tools (`read`, `edit`, `search`, `execute`, `agent`)
- Tool sets
- MCP tools (`server-name/tool-name`)
- All MCP server tools (`server-name/*`)
- Extension-contributed tools

**Important:** If a tool is not available, it's ignored (no error)

---

## Markdown Body

### Purpose

Contains prompt text sent to LLM when running the prompt.

### Content Guidelines

**Include:**
- Specific instructions and task description
- Expected output format
- Step-by-step guidelines or requirements
- Constraints and preferences
- Examples (input/output)

### File References

**Use Markdown links to reference workspace files:**
```markdown
See the [coding guidelines](../../.github/instructions/coding-guidelines.instructions.md).
```

**Path rules:**
- Relative paths based on prompt file location
- Ensure paths are correct

### Tool References

**Syntax:** `#tool:<tool-name>`

**Example:**
```markdown
Use #tool:githubRepo to search the repository for similar implementations.
```

### Variables

**Built-in variables** (use `${variableName}` syntax):

#### Workspace Variables
- `${workspaceFolder}` - Absolute path to workspace folder
- `${workspaceFolderBasename}` - Workspace folder name

#### Selection Variables
- `${selection}` - Currently selected text
- `${selectedText}` - Alias for `${selection}`

#### File Context Variables
- `${file}` - Full path to current file
- `${fileBasename}` - Current filename with extension
- `${fileDirname}` - Directory path of current file
- `${fileBasenameNoExtension}` - Filename without extension

#### Input Variables
- `${input:variableName}` - Capture value from chat input
- `${input:variableName:placeholder}` - With placeholder text

**Input variable example:**
```markdown
Create a ${input:componentType:component type} named ${input:componentName:ComponentName}.
```

**Usage:** `/create-component form MyForm`

---

## Tool Priority Hierarchy

**When both prompt files and custom agents specify tools:**

1. **Highest priority:** Tools in prompt file's `tools` field
2. **Medium priority:** Tools from custom agent in prompt file's `agent` field
3. **Lowest priority:** Default tools for selected agent

**Example:**
```yaml
agent: my-custom-agent  # Has tools: ["read", "edit", "search"]
tools: ["read"]          # Only "read" available (overrides agent)
```

---

## Creating Prompt Files

### Via VS Code UI

**Command:** `Chat: New Prompt File`

**Or:**
1. Chat view → Configure Chat (gear icon) → Prompt Files → New prompt file
2. Choose location: Workspace or User profile
3. Enter filename (without `.prompt.md` extension)
4. Author content (YAML frontmatter + Markdown body)

### Via File System

```bash
# Workspace prompt
touch .github/prompts/my-prompt.prompt.md

# Custom location (add to settings first)
touch prompts/custom/my-prompt.prompt.md
```

### Modify Existing Prompts

**Command:** `Chat: Configure Prompt Files`

**Or:**
- Chat view → Configure Chat → Prompt Files → Select file

---

## Using Prompt Files

### Method 1: Type Command in Chat

```
/prompt-name additional context
```

**Example:**
```
/create-react-form formName=LoginForm
```

### Method 2: Command Palette

1. `Chat: Run Prompt` (Cmd+Shift+P)
2. Select prompt from Quick Pick

### Method 3: Editor Play Button

1. Open prompt file in editor
2. Click play button in title bar
3. Choose: Run in current chat or new chat session

**Use case:** Testing and iterating on prompts

---

## Settings Configuration

### Workspace Prompt Locations

```json
{
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    ".github/prompts/custom": true,
    "scripts/prompts": true
  }
}
```

**Format:** Object (NOT array)

### Prompt Recommendations

```json
{
  "chat.promptFilesRecommendations": [
    "create-component",
    "review-security",
    "generate-tests"
  ]
}
```

**Effect:** Shows prompts as recommended actions when starting new chat

---

## Best Practices

### 1. Clear Task Description

✅ **GOOD:**
```markdown
---
description: "Generate a React form component with Zod validation"
---

Create a React functional component that:
- Accepts form fields as props
- Uses React Hook Form for state management
- Validates with Zod schema
- Includes submit handler with loading state
```

❌ **BAD:**
```markdown
Create a form component.
```

### 2. Specify Output Format

```markdown
Output requirements:
- TypeScript with strict type checking
- Use named exports
- Include JSDoc comments
- Add example usage in comments
```

### 3. Provide Examples

```markdown
## Example Input
`/create-react-form formName=LoginForm fields=email,password`

## Example Output
```tsx
interface LoginFormProps {
  onSubmit: (data: LoginFormData) => void;
}

export function LoginForm({ onSubmit }: LoginFormProps) {
  // ...
}
```
```

### 4. Reference Instructions (Don't Duplicate)

```markdown
Follow the [React coding standards](../../.github/instructions/react.instructions.md).

Apply [general TypeScript rules](../../.github/instructions/typescript.instructions.md).
```

### 5. Use Variables for Flexibility

```markdown
Create a ${input:componentType} in ${fileDirname} with these features:
- ${input:features}

Current file: ${file}
Selected code: ${selection}
```

### 6. Test Before Deploying

- Use editor play button
- Test with different inputs
- Refine based on results

---

## Organization Strategies

### By Task Type

```
.github/prompts/
├── generate/
│   ├── create-react-form.prompt.md
│   ├── create-api-endpoint.prompt.md
│   └── scaffold-test-suite.prompt.md
├── review/
│   ├── security-review.prompt.md
│   ├── code-quality-review.prompt.md
│   └── accessibility-review.prompt.md
└── refactor/
    ├── extract-component.prompt.md
    └── optimize-performance.prompt.md
```

### By Technology

```
.github/prompts/
├── react/
│   ├── create-component.prompt.md
│   └── create-hook.prompt.md
├── rails/
│   ├── create-controller.prompt.md
│   └── create-migration.prompt.md
└── testing/
    ├── create-unit-test.prompt.md
    └── create-e2e-test.prompt.md
```

---

## Workspace vs User Prompts

### Workspace Prompts

**Location:** `.github/prompts/` (or custom folders)

**Use for:**
- Project-specific workflows
- Team-shared prompts
- Framework conventions
- CI/CD templates

**Commit to version control:** ✅

### User Prompts

**Location:** VS Code profile folder

**Use for:**
- Personal workflows
- Cross-project utilities
- Individual preferences
- Experimental prompts

**Commit to version control:** ❌

**Sync across devices:**
1. Enable Settings Sync
2. `Settings Sync: Configure` from Command Palette
3. Select "Prompts and Instructions"

---

## Validation Checklist

Before deploying a prompt file:

### File Structure
- [ ] Extension is `.prompt.md`
- [ ] Located in configured prompt folder
- [ ] YAML frontmatter between `---` delimiters (if used)
- [ ] Markdown body contains instructions

### YAML Frontmatter (if used)
- [ ] Valid YAML syntax
- [ ] `name` is short and descriptive (or omit for filename)
- [ ] `description` clearly explains purpose
- [ ] `argument-hint` guides user input (if applicable)
- [ ] `agent` is valid: ask, edit, agent, or custom agent name
- [ ] `tools` contains valid tool names

### Content Quality
- [ ] Clear task description
- [ ] Expected output format specified
- [ ] Examples provided (input and output)
- [ ] References other files with correct relative paths
- [ ] Uses variables for dynamic content
- [ ] Tool references use `#tool:` syntax

### Testing
- [ ] Tested with editor play button
- [ ] Works with different inputs
- [ ] Produces expected output
- [ ] Error handling works (missing tools, invalid inputs)

---

## Common Mistakes

### ❌ Wrong Extension

```
# WRONG - Won't be recognized
my-prompt.md
```

```
# CORRECT
my-prompt.prompt.md
```

### ❌ Wrong Agent Value

```yaml
# WRONG - Invalid agent name
agent: copilot
```

```yaml
# CORRECT
agent: ask
# or
agent: edit
# or
agent: agent
# or
agent: my-custom-agent
```

### ❌ Wrong Path Reference

```markdown
# WRONG - Absolute path
See [guidelines](/Users/me/project/.github/instructions/coding.instructions.md).
```

```markdown
# CORRECT - Relative path
See [guidelines](../../.github/instructions/coding.instructions.md).
```

### ❌ Missing Variable Syntax

```markdown
# WRONG - Literal text
Create a component in fileDirname.
```

```markdown
# CORRECT - Variable syntax
Create a component in ${fileDirname}.
```

### ❌ Settings Array Format

```json
// WRONG - Array format (causes lint errors)
{
  "chat.promptFilesLocations": [
    ".github/prompts"
  ]
}
```

```json
// CORRECT - Object format
{
  "chat.promptFilesLocations": {
    ".github/prompts": true
  }
}
```

---

## Example Templates

### Template 1: Code Generation

```markdown
---
name: create-react-component
description: "Generate a React functional component with TypeScript"
argument-hint: "componentName=MyComponent props=title,onClick"
agent: agent
tools: ["read", "edit", "search"]
---

# Create React Component

Create a React functional component with the following specifications:

## Component Details
- Name: ${input:componentName:ComponentName}
- Location: ${fileDirname}
- Props: ${input:props:prop1,prop2}

## Requirements
- TypeScript with strict typing
- Functional component with hooks
- Follow [React guidelines](../../.github/instructions/react.instructions.md)
- Include JSDoc comments
- Export as default

## Output Format
```tsx
interface ${input:componentName}Props {
  // Props interface
}

/**
 * Component description
 */
export default function ${input:componentName}({ /* props */ }: ${input:componentName}Props) {
  // Implementation
}
```

## Additional Context
Current workspace: ${workspaceFolder}
```

### Template 2: Code Review

```markdown
---
name: security-review
description: "Perform security review of selected code or current file"
agent: ask
tools: ["read", "search"]
---

# Security Review

Perform a comprehensive security review of:
${selection}

If no selection, review: ${file}

## Review Checklist

### Input Validation
- [ ] All user inputs sanitized
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CSRF tokens present

### Authentication & Authorization
- [ ] Proper authentication checks
- [ ] Authorization for sensitive operations
- [ ] Session management secure

### Data Protection
- [ ] Sensitive data encrypted
- [ ] Secrets not hardcoded
- [ ] Secure communication (HTTPS)

### Dependencies
- [ ] No known vulnerabilities in dependencies
- [ ] Regular updates scheduled

## Output Format
Provide:
1. Summary of findings (Critical, High, Medium, Low)
2. Specific vulnerabilities with line numbers
3. Remediation recommendations
4. Code examples for fixes
```

### Template 3: Refactoring

```markdown
---
name: extract-component
description: "Extract selected code into reusable component"
argument-hint: "newComponentName=MyComponent"
agent: edit
tools: ["read", "edit"]
---

# Extract Component

Extract the selected code into a reusable component:

## Selected Code
${selection}

## New Component
- Name: ${input:newComponentName:NewComponent}
- Location: ${fileDirname}/components/

## Requirements
1. Extract selected code into new file
2. Create proper TypeScript interfaces
3. Update import in current file
4. Follow [component guidelines](../../.github/instructions/components.instructions.md)
5. Preserve existing functionality

## Steps
1. Analyze selected code for dependencies
2. Create component file with proper exports
3. Update current file with import and usage
4. Verify no breaking changes
```

---

## Troubleshooting

### Prompt Not Appearing

**Check:**
1. File extension is `.prompt.md`
2. File is in configured location
3. `chat.promptFilesLocations` setting includes folder
4. Restart VS Code if just added

### Tool Not Available Error

**Solutions:**
- Check tool name is correct
- Verify tool is available in current context
- Tool may be MCP server tool (check MCP configuration)
- Remove unavailable tool from `tools` array (tools are ignored if unavailable)

### Variables Not Expanding

**Check:**
- Syntax is `${variableName}`, not `{variableName}` or `$variableName`
- Variable name is valid (see Built-in Variables section)
- For input variables, user provided value in chat

### Agent Not Found

**Solutions:**
- Verify agent name matches exactly (case-sensitive)
- Check agent is available (custom agents must be defined)
- Use built-in agents: `ask`, `edit`, `agent`

---

## References

- **Official Docs:** https://code.visualstudio.com/docs/copilot/customization/prompt-files
- **Custom Instructions:** https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- **Custom Agents:** https://code.visualstudio.com/docs/copilot/customization/custom-agents
- **Chat Tools:** https://code.visualstudio.com/docs/copilot/chat/chat-tools
- **Community Examples:** https://github.com/github/awesome-copilot

---

**Last Updated:** 2026-01-06 (based on VS Code docs as of this date)
