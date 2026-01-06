---
applyTo: "**/*.instructions.md"
source: "https://code.visualstudio.com/docs/copilot/customization/custom-instructions"
lastUpdated: 2026-01-06
---

# VS Code Custom Instructions Specification

**Purpose:** Authoritative specification for creating VS Code custom instructions

**Source:** [VS Code Custom Instructions Documentation](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

---

## File Types and Locations

### 1. Workspace-Wide Instructions

**File:** `.github/copilot-instructions.md`

**Characteristics:**
- **Location:** Root of workspace (`.github/` folder)
- **Applies:** Automatically to all chat requests in workspace
- **Shared:** Via version control with team
- **Settings required:** `github.copilot.chat.codeGeneration.useInstructionFiles` must be enabled
- **Cross-product:** Works in VS Code, Visual Studio, and GitHub.com

**When to use:**
- General coding standards for entire workspace
- Team-wide conventions
- Project-level requirements

### 2. Conditional Instructions Files

**File:** `*.instructions.md`

**Characteristics:**
- **Extension:** `.instructions.md` (REQUIRED)
- **Location options:**
  - Workspace: `.github/instructions/` folder (default)
  - User profile: Available across workspaces
  - Custom: Additional folders via `chat.instructionsFilesLocations` setting
- **Applies:** Conditionally based on `applyTo` glob pattern
- **Timing:** Used when creating or modifying files (NOT for read operations)

**When to use:**
- Language-specific guidelines (Python, TypeScript, etc.)
- Framework-specific patterns (Rails, React, etc.)
- Task-specific instructions (documentation, testing, etc.)

### 3. Agent Instructions Files

**File:** `AGENTS.md`

**Characteristics:**
- **Location:** Root of workspace (or subfolders if nested enabled)
- **Applies:** Automatically to all chat requests
- **Settings required:** `chat.useAgentsMdFile` must be enabled
- **Nested support:** `chat.useNestedAgentsMdFiles` for folder-specific (experimental)

**When to use:**
- Working with multiple AI agents
- Folder-specific instructions (frontend vs backend)

---

## File Format

### Structure

```markdown
---
[YAML frontmatter - OPTIONAL]
---

[Markdown body - REQUIRED]
```

### YAML Frontmatter Properties

**All properties are OPTIONAL:**

| Property | Type | Description |
|----------|------|-------------|
| `description` | string | Short description of instructions file |
| `name` | string | Display name used in UI (defaults to filename) |
| `applyTo` | string | Glob pattern defining which files to apply to automatically |

**Important:** If no `applyTo` is specified, instructions are **not applied automatically**. You can still manually attach them to chat requests.

### Glob Pattern Syntax (applyTo)

**Pattern rules:**
- Relative to workspace root
- Use `**` for all files
- Use `**/*.py` for all Python files
- Use `apps/frontend/**/*` for specific folder
- Multiple patterns: `"**/*.ts,**/*.tsx"` (comma-separated)

**Examples:**

```yaml
# Apply to all Python files
applyTo: "**/*.py"

# Apply to multiple file types
applyTo: "**/*.ts,**/*.tsx"

# Apply to specific folder
applyTo: "apps/backend/**/*"

# Apply to all files
applyTo: "**"
```

### Markdown Body

**Content:**
- Natural language guidelines and rules
- Standard Markdown formatting
- Headers, bullet points, numbered lists
- Code examples (optional but helpful)
- Markdown links to reference other files/URLs

**Tool references:**
- Use `#tool:<tool-name>` syntax
- Example: `#tool:githubRepo`

**Whitespace:**
- Whitespace between instructions is **ignored**
- Can be written as single paragraph, each on new line, or separated by blank lines
- Format for human readability

---

## Content Guidelines

### Keep Instructions Focused

✅ **DO:**
- Write short, self-contained instructions
- Each instruction = single, simple statement
- Create multiple topic-specific files
- Use clear, imperative language

❌ **DON'T:**
- Create one large file with everything
- Write long, complex paragraphs
- Mix unrelated topics in one file

### Be Specific and Technical

**Include:**
- Naming conventions (PascalCase, camelCase, snake_case)
- Error handling patterns
- Formatting preferences (indentation, spacing, line length)
- Language-specific guidelines (type hints, access modifiers)
- External standards references ("Follow PEP 8", "Follow Airbnb style guide")

**Example - Specific vs Vague:**

```markdown
❌ VAGUE: "Use good naming conventions"

✅ SPECIFIC:
- Use PascalCase for class names
- Use camelCase for method names
- Use snake_case for variable names
- Boolean variables start with `is_` or `has_`
```

### Use Present Tense and Active Voice

```markdown
❌ PASSIVE: "Type hints should be added to functions"

✅ ACTIVE: "Add type hints to all functions"
```

### Include Code Examples

```markdown
## Error Handling

Always wrap database operations in try-catch blocks:

```python
try:
    result = db.query(sql)
except DatabaseError as e:
    logger.error(f"Query failed: {e}")
    raise
```
```

### Reference Other Files

```markdown
Apply the [general coding guidelines](./general-coding.instructions.md) to all code.

For React-specific patterns, see [React guidelines](./react.instructions.md).
```

---

## Settings Configuration

### Required Settings

**For `.github/copilot-instructions.md`:**
```json
{
  "github.copilot.chat.codeGeneration.useInstructionFiles": true
}
```

**For `*.instructions.md` files:**
```json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "apps/app-name/.copilot/instructions": true
  }
}
```

**For `AGENTS.md` files:**
```json
{
  "chat.useAgentsMdFile": true,
  "chat.useNestedAgentsMdFiles": true  // For nested support
}
```

### Task-Specific Instructions (Settings-Based)

**Settings for specialized scenarios:**

| Task | Setting |
|------|---------|
| Code review | `github.copilot.chat.reviewSelection.instructions` |
| Commit messages | `github.copilot.chat.commitMessageGeneration.instructions` |
| PR descriptions | `github.copilot.chat.pullRequestDescriptionGeneration.instructions` |

**Deprecated (use instruction files instead):**
- `github.copilot.chat.codeGeneration.instructions`
- `github.copilot.chat.testGeneration.instructions`

**Example:**

```json
{
  "github.copilot.chat.pullRequestDescriptionGeneration.instructions": [
    { "text": "Always include a list of key changes." }
  ],
  "github.copilot.chat.reviewSelection.instructions": [
    { "file": "guidance/backend-review-guidelines.md" },
    { "file": "guidance/frontend-review-guidelines.md" }
  ]
}
```

---

## Application Rules

### Automatic Application

**Instructions apply automatically when:**
1. `applyTo` glob pattern matches current file
2. File is being created or modified (NOT read-only operations)
3. Settings are configured correctly

### Manual Application

**Manually attach instructions:**
1. In Chat view, use Add Context > Instructions
2. Select specific instructions file from list

### Multiple Instructions Files

**When multiple files apply:**
- VS Code combines and adds all matching instructions to chat context
- No specific order is guaranteed
- Can reference other instruction files to avoid duplication

---

## Workspace vs User Instructions

### Workspace Instructions

**Location:** `.github/instructions/` (or custom folders)

**Characteristics:**
- Apply only to current workspace
- Shared with team via version control
- Project-specific guidelines

**Use for:**
- Project coding standards
- Team conventions
- Workspace-specific patterns

### User Instructions

**Location:** VS Code profile folder

**Characteristics:**
- Available across all workspaces
- Personal preferences
- Can sync via Settings Sync

**Use for:**
- Personal coding style
- Cross-project preferences
- General best practices

**To sync user instructions:**
1. Enable Settings Sync
2. Run `Settings Sync: Configure` from Command Palette
3. Select "Prompts and Instructions"

---

## Creating Instructions Files

### Via VS Code UI

**Command:** `Chat: New Instructions File`

**Or:**
1. Chat view → Configure Chat (gear icon) → Chat Instructions → New instruction file
2. Choose location: Workspace or User profile
3. Enter filename
4. Fill in YAML frontmatter (optional)
5. Add instructions in Markdown body

### Modify Existing Instructions

**Command:** `Chat: Configure Instructions`

**Or:**
- Chat view → Configure Chat (gear icon) → Chat Instructions → Select file

### Generate Instructions from Workspace

**Command:** `Chat: Generate Chat Instructions`

**Or:**
- Chat view → Configure Chat (gear icon) → Generate Chat Instructions
- Reviews workspace and generates `.github/copilot-instructions.md` with matching instructions

---

## Best Practices

### Organization Strategy

```markdown
.github/
├── copilot-instructions.md         # Workspace-wide (general)
└── instructions/
    ├── general-coding.instructions.md      # Universal coding standards
    ├── python.instructions.md              # Language-specific
    ├── typescript.instructions.md          # Language-specific
    ├── react.instructions.md               # Framework-specific
    ├── rails.instructions.md               # Framework-specific
    ├── testing.instructions.md             # Task-specific
    └── documentation.instructions.md       # Task-specific
```

### Reuse and Cross-Reference

```markdown
---
applyTo: "**/*.tsx"
description: "React + TypeScript guidelines"
---

# React TypeScript Guidelines

Apply [general TypeScript rules](./typescript.instructions.md).

Additional React-specific rules:
- Use functional components with hooks
- No conditional hooks
- Keep components small and focused
```

### Version Control

**Commit workspace instructions:**
- `.github/copilot-instructions.md` ✅
- `.github/instructions/*.instructions.md` ✅
- Team shares same guidelines

**Don't commit user instructions:**
- User profile instructions ❌
- Personal preferences stay personal

---

## Validation Checklist

Before deploying instructions file:

### File Location
- [ ] `.github/copilot-instructions.md` at root (if workspace-wide)
- [ ] `*.instructions.md` in configured locations
- [ ] Settings match file locations

### YAML Frontmatter (if used)
- [ ] Valid YAML syntax between `---` delimiters
- [ ] `description` is short and clear
- [ ] `name` is descriptive (or omit to use filename)
- [ ] `applyTo` glob pattern matches intended files

### Content Quality
- [ ] Instructions are short and focused
- [ ] Use present tense and active voice
- [ ] Specific technical details included
- [ ] Code examples for complex concepts
- [ ] References to other files use Markdown links

### Settings
- [ ] Required settings enabled
- [ ] `chat.instructionsFilesLocations` includes custom folders
- [ ] `applyTo` patterns tested with target files

---

## Troubleshooting

### Instructions Not Applied

**Check these:**

1. **File location**
   - `.github/copilot-instructions.md` must be in `.github/` at root
   - `*.instructions.md` must be in folders listed in `chat.instructionsFilesLocations`
   - `AGENTS.md` must be at root (or subfolder if nested enabled)

2. **Settings**
   - `github.copilot.chat.codeGeneration.useInstructionFiles` enabled (for copilot-instructions.md)
   - `chat.useAgentsMdFile` enabled (for AGENTS.md)

3. **Glob pattern**
   - `applyTo` pattern matches current file
   - Test pattern against actual file paths
   - No `applyTo` = not applied automatically

4. **Verify in chat**
   - Check "References" section in chat response
   - See which instructions were used

5. **Debug logs**
   - [Check Chat Debug view](https://github.com/microsoft/vscode/wiki/Copilot-Issues#language-model-requests-and-responses)
   - [Debug applyTo matching](https://github.com/microsoft/vscode/wiki/Copilot-Issues#custom-instructions-logs)

### On-Demand Instructions Not Used

**Solutions:**
- Refine instructions to be clearer
- Nudge LLM: "Don't forget to use [instruction name]"
- Older models may need more guidance

---

## Example Templates

### Template 1: Language-Specific

```markdown
---
applyTo: "**/*.py"
description: "Python coding standards for this project"
name: "Python Guidelines"
---

# Project Python Standards

## Style Guide
- Follow PEP 8 style guide
- Use Black for formatting (line length: 100)
- Use isort for import sorting

## Type Hints
- Add type hints to all function signatures
- Use `typing` module for complex types
- Example:
  ```python
  def process_data(items: list[dict[str, Any]]) -> pd.DataFrame:
      ...
  ```

## Error Handling
- Use specific exception types
- Always log exceptions with context
- Wrap external API calls in try-except

## Testing
- Write doctest for simple functions
- Use pytest for unit tests
- Aim for 80%+ coverage
```

### Template 2: Framework-Specific

```markdown
---
applyTo: "**/*.tsx,**/*.ts"
description: "React + TypeScript coding standards"
---

# React TypeScript Standards

Apply [general TypeScript guidelines](./typescript.instructions.md).

## Component Patterns
- Use functional components with hooks
- Props interface named `[Component]Props`
- Export component as default

Example:
```tsx
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export default function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return <button onClick={onClick} className={variant}>{label}</button>;
}
```

## Hooks Rules
- No conditional hooks
- Custom hooks start with `use`
- Extract complex logic to custom hooks

## State Management
- Use local state for UI-only state
- Use context for cross-component state
- Use Zustand for global app state
```

### Template 3: Task-Specific

```markdown
---
description: "Guidelines for writing documentation"
---

# Documentation Writing Guidelines

## Docstrings
- Use Google-style docstrings for Python
- Include examples in docstrings
- Document parameters, returns, and raises

## README Files
- Start with project description
- Include installation steps
- Provide usage examples
- Link to detailed docs

## Code Comments
- Explain WHY, not WHAT
- Keep comments up-to-date with code
- Use TODO comments with GitHub issue numbers
```

---

## Common Mistakes

### ❌ Wrong File Extension

```markdown
# WRONG - Won't be recognized
my-instructions.md
```

```markdown
# CORRECT - Proper extension
my-instructions.instructions.md
```

### ❌ Wrong Glob Pattern

```yaml
# WRONG - Doesn't match files
applyTo: "*.py"
```

```yaml
# CORRECT - Matches all Python files recursively
applyTo: "**/*.py"
```

### ❌ Vague Instructions

```markdown
# WRONG - Too vague
- Write good code
- Follow best practices
```

```markdown
# CORRECT - Specific and actionable
- Use descriptive variable names (min 3 characters)
- Extract functions over 20 lines into smaller functions
- Add type hints to all public functions
```

### ❌ Settings Format Error

```json
// WRONG - Array format (causes lint errors)
{
  "chat.instructionsFilesLocations": [
    ".github/instructions",
    "apps/app-name/.copilot/instructions"
  ]
}
```

```json
// CORRECT - Object format
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "apps/app-name/.copilot/instructions": true
  }
}
```

---

## Cross-Product Compatibility

### VS Code vs GitHub.com vs Visual Studio

**`.github/copilot-instructions.md`:**
- ✅ Works in VS Code
- ✅ Works in Visual Studio
- ✅ Works in GitHub.com
- Most portable option

**`*.instructions.md` files:**
- ✅ Works in VS Code
- ❓ Limited support elsewhere
- Best for VS Code-specific workflows

**`AGENTS.md`:**
- ✅ Works in VS Code
- ❓ Limited support elsewhere
- Best for multi-agent VS Code workflows

---

## References

- **Official Docs:** https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- **Prompt Files:** https://code.visualstudio.com/docs/copilot/customization/prompt-files
- **Custom Agents:** https://code.visualstudio.com/docs/copilot/customization/custom-agents
- **Agent Skills:** https://code.visualstudio.com/docs/copilot/customization/agent-skills
- **Community Examples:** https://github.com/github/awesome-copilot

---

**Last Updated:** 2026-01-06 (based on VS Code docs as of this date)
