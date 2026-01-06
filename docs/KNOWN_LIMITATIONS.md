# Ubod Known Limitations

This document tracks known limitations and their expected resolution paths.

---

## VS Code Agent Discovery (Temporary Limitation)

**Status:** Active workaround in place (v1.3.1+)

### The Limitation

Agents are **only** discovered at `.github/agents/` root level in VS Code.

Unlike instructions and prompts (which support subfolders via `chat.instructionsFilesLocations` and `chat.promptFilesLocations`), there is **NO** `chat.agentFilesLocations` setting.

### Symptom

If you place agents in `apps/{app}/.copilot/agents/`, VS Code Copilot will NOT discover them:

```
❌ Not discoverable:
   apps/tala/.copilot/agents/tala-discovery-planner.agent.md

✅ Discoverable:
   .github/agents/tala-discovery-planner.agent.md
```

### Root Cause

VS Code's Copilot Chat implementation doesn't expose agent file location configuration. Investigation shows:
- `chat.instructionsFilesLocations` - ✅ Supported (object with paths)
- `chat.promptFilesLocations` - ✅ Supported (object with paths)
- `chat.agentFilesLocations` - ❌ NOT Supported (no setting exists)

### Current Workaround

**Ubod v1.3.1+ provides automatic migration:**

1. `ubod-upgrade.sh` detects agents in app folders
2. Automatically migrates them to `.github/agents/`
3. Removes empty directories after migration
4. Validates settings.json format

**You don't need to do anything manually** - the upgrade script handles it.

See [CHANGELOG.md](CHANGELOG.md#131---2026-01-06) for details.

### Future Solution

If/when VS Code adds `chat.agentFilesLocations` setting (like Copilot CLI requests), Ubod will:

1. ✅ Update documentation to support app-specific agent folders
2. ✅ Remove automatic migration logic (no longer needed)
3. ✅ Update settings.json schema to use `chat.agentFilesLocations`
4. ✅ Remove migration warnings from upgrade script

### What to Watch

Monitor these for updates:

**VS Code Copilot Chat:**
- GitHub: Check Copilot Chat extension release notes
- Look for: `chat.agentFilesLocations` setting announcement

**GitHub Copilot CLI:**
- Issue: [github/copilot-cli#452](https://github.com/github/copilot-cli/issues/452)
- Topic: User-level agents not loading from `~/.copilot/agents`
- Related: Request for `chat.agentFilesLocations` setting (anoblet's comment, 3 weeks ago)
- This shows user demand for configurable agent paths

### Historical Context

This limitation was discovered when deploying Ubod to the Tahua monorepo. Initial setup docs (v1.3.0) incorrectly instructed users to create `apps/{app}/.copilot/agents/` folders. v1.3.1 fixed this by:

- Correcting documentation
- Adding automated migration
- Adding validation warnings
- Explaining VS Code limitation

---

## Tracking Template

When adding new limitations, use this format:

```markdown
## [Feature/Limitation Name] (Status: Active/Waiting/Resolved)

### The Issue
[What is broken or limited]

### Symptom
[What users observe]

### Root Cause
[Why it happens]

### Current Workaround
[What ubod does now, or what users should do]

### Future Solution
[What will change when it's fixed]

### What to Watch
[Links, release notes, GitHub issues, etc.]
```

---

**Last Updated:** January 6, 2026  
**Next Review:** When Ubod reaches v2.0 or VS Code adds agent location configuration
