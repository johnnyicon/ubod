# Changelog Entry Template

**Purpose:** Standard format for CHANGELOG.md entries

**When to use:** When adding a new version entry to CHANGELOG.md

---

## Template

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Summary

[One-paragraph summary of what changed and why]

### [Category]

- **[Feature/Fix Name]** - [Brief description]
  ```yaml
  action: [ACTION_TYPE]
  file: [path/to/file]
  note: [Additional context for LLMs]
  ```
  - [Detail 1]
  - [Detail 2]
  - [Detail 3]

[Repeat for each change]

### [Optional: Root Cause / Technical Details]

[If this is a significant fix, explain the underlying issue]

---
```

## Categories

Use these categories in order of appearance:

1. **Added** - New features, files, or capabilities
2. **Fixed** - Bug fixes, corrections
3. **Enhanced** - Improvements to existing features
4. **Changed** - Breaking changes or significant modifications
5. **Deprecated** - Features marked for removal
6. **Removed** - Features that were removed

## Action Types

Use these in the YAML blocks:

- `REFERENCE_ONLY` - File exists for reference, no action needed
- `TEMPLATE_CHANGE` - Template content was modified
- `AUTOMATED_MIGRATION` - Script handles this automatically
- `VALIDATION_CHECK` - Script validates but doesn't modify
- `AUTO_FIX` - Prompt/script fixes automatically
- `DOCUMENTATION_FIX` - Documentation was corrected
- `BREAKING_CHANGE` - Requires manual intervention

## Version Number Guidelines

**Semantic Versioning:** MAJOR.MINOR.PATCH

- **MAJOR** (X.0.0) - Breaking changes
  - Prompts renamed or removed
  - Structure changed (file paths, directory layout)
  - Backwards-incompatible changes
  - Example: 2.0.0 (restructured all prompts)

- **MINOR** (0.X.0) - New features (backwards-compatible)
  - New prompts added
  - New agents added
  - New instructions added
  - New sections in templates
  - Example: 1.4.0 (added new prompt)

- **PATCH** (0.0.X) - Fixes (backwards-compatible)
  - Typos fixed
  - Improved wording
  - Bug fixes
  - Template corrections
  - Example: 1.3.2 (fixed tool definitions)

## Example Entry

```markdown
## [1.3.2] - 2026-01-06

### Summary

Fixed agent tool definitions in templates to use actual VS Code tool names instead of generic placeholders. This ensures generated agents can execute tasks correctly.

### Fixed

- **Agent tool definitions** - Templates now specify actual tool names
  ```yaml
  action: TEMPLATE_CHANGE
  files:
    - templates/prompts/ubod-create-agents.prompt.md
    - templates/prompts/ubod-update-agent.prompt.md
  note: Replaced generic ["read", "search", "execute"] with actual tool names
  ```
  - Discovery agents: `["read_file", "grep_search", "semantic_search", "file_search", "list_dir", "create_file"]`
  - Implementer agents: `["read_file", "create_file", "replace_string_in_file", "multi_replace_string_in_file", "run_in_terminal", "grep_search"]`
  - Verifier agents: `["read_file", "run_in_terminal", "grep_search", "get_terminal_output"]`
  - UI/UX Designer agents: `["read_file", "semantic_search", "grep_search", "create_file"]`

### Enhanced

- **ubod-maintainer agent** - Added changelog workflow guidance
  ```yaml
  action: REFERENCE_ONLY
  file: templates/agents/ubod-maintainer.agent.md (deployed to .github/agents/)
  added: Task for updating tool definitions and changelog workflow
  ```
  - New task: "Update Agent Tool Definitions"
  - References CHANGELOG_TEMPLATE.md for consistent entries
  - Clear steps for version bumps

- **CHANGELOG_TEMPLATE.md** - Created standard template for changelog entries
  ```yaml
  action: REFERENCE_ONLY
  file: templates/CHANGELOG_TEMPLATE.md
  note: Reference document for maintainers
  ```
  - Defines categories (Added, Fixed, Enhanced, etc.)
  - Explains action types (REFERENCE_ONLY, TEMPLATE_CHANGE, etc.)
  - Provides version numbering guidelines
  - Includes example entries

### Root Cause

**Issue:** Agent templates used generic tool names (`["read", "search", "execute"]`) that don't match actual VS Code tool capabilities.

**Impact:** Generated agents had incorrect tool definitions, preventing them from creating files, editing code, or running commands.

**Solution:**
1. Updated all agent templates with correct tool names
2. Documented standard tool assignment patterns
3. Added changelog template for future consistency
4. Enhanced ubod-maintainer agent with workflow guidance
```

---

## Workflow

### Step 1: Determine Version Number

Based on the change type:
- Breaking change? → Bump MAJOR
- New feature? → Bump MINOR
- Fix/improvement? → Bump PATCH

### Step 2: Create Entry

1. Copy template above
2. Fill in version number and date
3. Choose appropriate categories
4. Add YAML blocks for LLM-actionable instructions
5. Include human-readable descriptions

### Step 3: Add to CHANGELOG.md

1. Insert below `## [Unreleased]` section
2. Update README.md version reference (line ~344)
3. Commit with message: `docs(changelog): Add v[X.Y.Z] entry`

---

**Remember:** Changelog serves both humans AND LLMs. Include YAML blocks with action types so future AI maintainers can understand what to do.
