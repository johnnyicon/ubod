# Ubod Deployment Model Research

**Date:** 2026-01-10
**Status:** Completed - Decision Made
**Decision:** Direct reference via settings.json (no symlinks)

---

## Research Question

What's the best deployment model for ubod framework files?

**Options considered:**
1. **Copy model** (current) - Copy from `projects/ubod/templates/` to `.github/`
2. **Symlink model** - Symlink from `.github/` to `projects/ubod/`
3. **Direct reference** - Configure VS Code to load from `projects/ubod/` directly

---

## Outcome

**Selected: Option 3 (Direct Reference)**

### Implementation

| File Type | Strategy | Reasoning |
|-----------|----------|-----------|
| **Prompts** | Direct reference via `chat.promptFilesLocations` | Official setting, cross-platform |
| **Instructions** | Direct reference via `chat.instructionsFilesLocations` | Official setting, cross-platform |
| **Agents** | Copy to `.github/agents/` | No settings option, hardcoded discovery |

### Key Finding

VS Code provides official settings to configure search paths:
- `chat.promptFilesLocations` - Where to find prompts
- `chat.instructionsFilesLocations` - Where to find instructions

No equivalent for agents, so copy model remains necessary.

---

## Research Artifacts

### LLM Analysis

- [ChatGPT 5.2 Analysis](./2026-01-10-chatgpt-52-symlink-support-analysis.md) - Comprehensive research on symlink support
  - **Key insight:** `chat.instructionsFilesLocations` is the official solution
  - **Evidence:** VS Code documentation + GitHub issues
  - **Recommendation:** Direct reference for instructions/prompts, copy for agents

### Empirical Tests

- **Prompts via symlink:** ✅ WORKED (invoked `/test-symlink` successfully)
- **Instructions via symlink:** ❌ FAILED (rules not applied)
- **Direct reference (untested):** Recommended by ChatGPT analysis

---

## Benefits of Direct Reference

✅ **Zero deployment friction** - Ubod updates immediately available
✅ **Single source of truth** - No sync issues between ubod and consumer
✅ **Cross-platform** - Works on macOS/Linux/Windows (unlike symlinks)
✅ **Official mechanism** - Uses documented VS Code settings
✅ **Explicit** - Settings.json clearly shows what's loaded

---

## Implementation

See: [Deployment Model Documentation](../../docs/deployment-model.md)

---

## References

- [VS Code: Copilot Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings)
- [VS Code: Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [VS Code: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
