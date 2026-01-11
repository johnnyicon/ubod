# Ubod Deployment Model

**Status:** Current (v1.8.1+)
**Last Updated:** 2026-01-10

---

## Overview

Ubod uses **direct reference** via VS Code settings instead of copying files. This eliminates deployment friction and keeps consuming repos in sync automatically.

---

## Deployment Strategy by File Type

| File Type | Strategy | Location | Config |
|-----------|----------|----------|--------|
| **Prompts** | Direct reference | `projects/ubod/prompts/` | `chat.promptFilesLocations` |
| **Instructions** | Direct reference | `projects/ubod/templates/instructions/` | `chat.instructionsFilesLocations` |
| **Agents** | Copy to `.github/agents/` | `.github/agents/` | Hardcoded discovery |

---

## Setup (Consuming Repos)

### Step 1: Add Ubod as Submodule

```bash
git submodule add https://github.com/your-org/ubod.git projects/ubod
git submodule update --init --recursive
```

### Step 2: Configure VS Code Settings

Add to `.vscode/settings.json`:

```jsonc
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,  // Local/custom instructions
    "projects/ubod/templates/instructions": true  // Ubod universal instructions
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true,  // Local/custom prompts
    "projects/ubod/prompts": true  // Ubod prompts
  }
}
```

### Step 3: Copy Agents (One-Time)

Agents must be copied to `.github/agents/` (no settings option):

```bash
cp -r projects/ubod/templates/agents/* .github/agents/
```

**Update agents when ubod updates:**
```bash
./scripts/ubod-upgrade.sh agents
```

---

## Benefits

### ✅ Prompts & Instructions (Direct Reference)

- **Zero deployment friction** - Ubod updates immediately available
- **Single source of truth** - No sync issues
- **Explicit configuration** - Settings.json documents what's loaded
- **Cross-platform** - Works on macOS/Linux/Windows

### ⚠️ Agents (Copy Model)

- **Portable** - Works everywhere (Windows symlinks unreliable)
- **Manual sync required** - Run upgrade script after ubod updates
- **Small files** - Agents rarely change, copying is acceptable

---

## Updating Ubod

### For Prompts & Instructions

**No action needed!** Changes are immediately available:

```bash
cd projects/ubod
git pull origin main
```

That's it. Consuming repos see changes instantly.

### For Agents

After updating ubod, sync agents:

```bash
./scripts/ubod-upgrade.sh agents
# Or manually:
cp -r projects/ubod/templates/agents/* .github/agents/
```

---

## Why This Model?

### Research Summary

Tested 3 approaches:
1. **Copy** - Deployment friction, sync issues
2. **Symlinks** - Not cross-platform (Windows), inconsistent Copilot support
3. **Direct reference via settings** - Official mechanism, cross-platform ✅

**Finding:** VS Code provides `chat.instructionsFilesLocations` and `chat.promptFilesLocations` for exactly this use case. Agents lack equivalent setting, so copy model is necessary.

**Full research:** `ubod-meta/research/ubod-deployment-model/`

---

## Migration from Copy Model

If you're upgrading from ubod v1.8.0 or earlier (copy model):

### Step 1: Update settings.json

Add ubod paths (see Step 2 above).

### Step 2: Remove copied files (optional)

```bash
# Prompts (now referenced directly)
rm .github/prompts/ubod/*
rmdir .github/prompts/ubod

# Instructions (now referenced directly)
# Only remove if you have NO custom local instructions
# Otherwise, keep .github/instructions/ for local overrides
```

### Step 3: Keep agents

Agents still need to be in `.github/agents/`, so no change needed.

---

## Troubleshooting

### Prompts not appearing in `/` list

1. Check `.vscode/settings.json` includes `"projects/ubod/prompts": true`
2. Reload VS Code window (Cmd+Shift+P → "Reload Window")
3. Check ubod submodule is up to date (`cd projects/ubod && git status`)

### Instructions not applying

1. Check `.vscode/settings.json` includes `"projects/ubod/templates/instructions": true`
2. Verify instruction file has correct `applyTo` frontmatter
3. Check workspace trust (instructions only apply in trusted workspaces)
4. Reload VS Code window

### Agents not showing up

1. Verify files exist in `.github/agents/`
2. Check file extension is `.agent.md` (not `.md`)
3. Reload VS Code window

---

## Advanced: Custom Instructions Location

If you move ubod to a different path (e.g., `.ubod/` instead of `projects/ubod/`):

Update settings.json paths:
```jsonc
{
  "chat.instructionsFilesLocations": {
    ".ubod/templates/instructions": true  // Updated path
  },
  "chat.promptFilesLocations": {
    ".ubod/prompts": true  // Updated path
  }
}
```

---

## References

- [VS Code: Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [VS Code: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [VS Code: Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings)
- Research: `ubod-meta/research/ubod-deployment-model/`
