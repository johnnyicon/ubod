# GitHub Copilot Integration

This folder contains GitHub Copilot-specific guidance, examples, and customization tools for Ubod.

## What's Inside

- `README.md` - This file
- `examples/` - Working configuration examples from real projects
- `customization-guide.md` - How to adapt Ubod for Copilot's specific capabilities
- `settings-template.json` - Template VS Code settings file

## Quick Start

### 1. Copy Settings Template

Copy `settings-template.json` to your monorepo root as `.vscode/settings.json`

### 2. Update Paths

By default, the template only loads the universal instruction library.

For app-specific instructions, add an app-level `.vscode/settings.json` inside that app (example: `apps/tala/.vscode/settings.json`) and include both the universal and app-specific globs.

### 3. Load Instructions

Copilot will automatically load instructions from the paths you configured

### 4. Use in Chat

```
Ask Copilot: @instruction-name How should I approach X?
```

## Copilot's Strengths

✅ **Best at:**
- Code completion and inline suggestions
- IDE integration (immediate access in VS Code)
- Quick questions about code you're looking at
- Slash commands for specific tasks (`/test`, `/explain`, etc.)
- File context awareness

## Copilot's Limitations

❌ **Not ideal for:**
- Deep research and analysis
- Multi-turn complex reasoning
- Generating comprehensive documentation
- Understanding non-code patterns

**Workaround:** Use Claude for research, copy results to Copilot for coding.

## Common Patterns

### Pattern 1: Reference Instructions in Questions

```
@discovery-methodology I'm about to add chat history. What's the approach?
```

Copilot will consider the instruction file when responding.

### Pattern 2: Use Slash Commands

```
/test Write tests for this function
/explain Explain what this component does
```

Different VS Code versions support different commands.

### Pattern 3: Reference Files with @

```
@app-controller How should I modify the upload endpoint?
```

Point to the file you're working on.

## Configuration

### Enable for All Apps

`.vscode/settings.json` (root level):
```json
{
  "copilot.contextualActions.instructions": [
    ".github/instructions/*.instructions.md"
  ]
}
```

### Enable per App

`apps/{app-name}/.vscode/settings.json`:
```json
{
  "copilot.contextualActions.instructions": [
    "../../.github/instructions/*.instructions.md",
    ".copilot/instructions/*.instructions.md"
  ]
}
```

## Troubleshooting

### Copilot not loading instructions

**Problem:** Instructions not showing up in chat  
**Solution:**
1. Verify `.vscode/settings.json` exists in correct location
2. Check file paths in settings (should be relative to workspace root)
3. Reload VS Code window (Cmd+R)
4. Check Copilot output panel for errors

### Instructions too long

**Problem:** Copilot says context is too long  
**Solution:**
1. Split instructions into smaller files
2. Reference only needed instructions in settings
3. Use Claude for initial research instead

### Copilot giving generic answers

**Problem:** Copilot not using your patterns  
**Solution:**
1. Make sure app-specific instructions are loaded
2. Point to actual code files with `@` syntax
3. Be explicit: "Using the {{APP_NAME}} patterns, how would I..."

## Next Steps

1. Read `customization-guide.md` for Copilot-specific patterns
2. Copy settings template to your repo
3. Test with a simple question
4. Iterate based on results

---

**See also:**
- [Multi-Tool Support Guide](../../docs/MULTI_TOOL_SUPPORT.md)
- [Setup Guide](../../docs/SETUP_GUIDE.md)

**Last Updated:** January 5, 2026
