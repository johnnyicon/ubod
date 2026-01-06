# Migration: VS Code Agent Schema Fixes

**Date:** 2026-01-06  
**Version:** Ubod 1.x → 1.x+1  
**Severity:** ⚠️ BREAKING - Existing agents/prompts will have diagnostic errors

---

## What Changed

VS Code released updated agent/prompt schema requirements that break existing files:

1. **Agent `tools:` field** - Only accepts specific tool names
2. **Agent `handoffs:` format** - No multiline YAML prompts
3. **Agent name references** - Must be case-sensitive
4. **Prompt `model:` field** - Not a valid frontmatter field

---

## Why This Happened

**Root cause:** Ubod was initially designed for VS Code's internal tool names, but GitHub Copilot and VS Code now enforce the official specification.

**Official spec:** GitHub Copilot uses **tool aliases** (read, edit, search, execute, agent, web, todo), not internal tool names.

**For complete specification:** See `ubod-meta/instructions/github-custom-agent-spec.instructions.md`

**Key learnings:**
- VS Code-specific tools: `read_file`, `create_file`, `grep_search` are NOT standard
- Standard tools: `read`, `edit`, `search`, `execute`, `agent` work everywhere
- Prompt `model:` field: Only supported in VS Code, not GitHub Copilot coding agent
- Agent `handoffs:`: Format must be single-line for cross-product compatibility

---

## Who Needs This Migration

**You need this migration if:**
- You see "prompts-diagnostics-provider" errors in VS Code Problems panel
- Your agents were created before January 6, 2026
- You have `tools: ["read_file", "create_file", ...]` in agent frontmatter
- You have `model:` field in prompt frontmatter

**Skip this migration if:**
- You're setting up Ubod for the first time (templates are already fixed)
- Your agents were created after January 6, 2026

---

## Changes Required

### 1. Agent Tools Field

**BEFORE (Invalid):**
```yaml
tools: ["read_file", "create_file", "replace_string_in_file", "grep_search", "semantic_search"]
```

**AFTER (Valid):**
```yaml
tools: ["read", "search", "edit", "execute"]
```

**Valid tool names:**
- `"read"` - Read files
- `"search"` - Search codebase
- `"edit"` - Edit files  
- `"execute"` - Run commands

**Files affected:** All `.agent.md` files in `.github/agents/`

---

### 2. Agent Handoff Format

**BEFORE (Invalid):**
```yaml
handoffs:
  - label: "Next step"
    agent: "My Agent"
    prompt: |
      Multi-line
      prompt text
```

**AFTER (Valid):**
```yaml
handoffs:
  - label: "Next step"
    agent: "My Agent"
    prompt: "Single-line prompt text describing what next agent should do"
```

**Changes:**
- Keep `label:` field (REQUIRED by VS Code schema)
- Change `prompt: |` (multiline) → `prompt: "..."` (single-line string)
- Agent name must match declared name exactly (case-sensitive)

**Files affected:** All `.agent.md` files with handoffs

---

### 3. Agent Name Case-Sensitivity

**BEFORE:**
```yaml
handoffs:
  - agent: "tala-verifier"  # lowercase slug
```

**AFTER:**
```yaml
handoffs:
  - agent: "Tala Verifier"  # exact declared name
```

**Rule:** Agent references in handoffs must match the `name:` field exactly (case-sensitive)

**Files affected:** All `.agent.md` files with handoffs

---

### 4. Prompt Model Field

**BEFORE (Invalid):**
```yaml
---
description: "My prompt"
model: "sonnet-4-5"
---
```

**AFTER (Valid):**
```yaml
---
description: "My prompt"
---
```

**Rule:** Only `description:` is valid in prompt frontmatter. Remove `model:` field entirely.

**Files affected:** All `.prompt.md` files in `.github/prompts/`

---

## Migration Steps

### Automated Migration (Recommended)

Use the `/ubod-update-agent` prompt to fix agents:

```
@workspace /ubod-update-agent

Choose option 3: Batch mode - Update all agents
```

This will:
- Fix `tools:` field in all agents
- Convert multiline handoffs to single-line
- Fix agent name references

### Manual Migration

#### Step 1: Fix Agent Tools

```bash
# Find all agents with old tool names
grep -r "read_file\|create_file\|grep_search" .github/agents/
```

For each agent file:
1. Replace `tools:` array with `["read", "search", "edit", "execute"]`
2. Choose appropriate subset based on what agent does

#### Step 2: Fix Agent Handoffs

```bash
# Find all agents with multiline handoffs
grep -B2 "prompt: |" .github/agents/
```

For each agent file:
1. Remove `label:` field
2. Combine multiline prompt into single line
3. Change `prompt: |` → `prompt: "..."`
4. Verify agent name matches declared name exactly

#### Step 3: Fix Prompt Model Field

```bash
# Find all prompts with model field
grep -r "^model:" .github/prompts/
```

For each prompt file:
1. Remove the entire `model: ...` line from frontmatter

#### Step 4: Verify

Open VS Code and check Problems panel:
- Should see 0 errors from "prompts-diagnostics-provider"
- Any remaining errors are likely false positives (file path resolution issues)

---

## Verification Checklist

After migration:

- [ ] All `.agent.md` files use `tools: ["read", "search", ...]`
- [ ] All agent handoffs use single-line `prompt: "..."`
- [ ] All agent name references match declared names exactly
- [ ] All `.prompt.md` files have NO `model:` field
- [ ] VS Code Problems panel shows 0 (or only false positive) errors
- [ ] **Track migration**: Add to `.ubod-version`:
  ```yaml
  migrations:
    - 2026-01-06-vscode-agent-schema-fix
  ```

---

## Rollback

If migration causes issues:

```bash
# Restore from git
git checkout HEAD -- .github/agents/
git checkout HEAD -- .github/prompts/
```

Then re-run migration more carefully, one agent at a time.

---

## Related Files

- **Upgrade prompt:** `projects/ubod/ubod-meta/prompts/ubod-upgrade.prompt.md`
- **Update agent prompt:** `projects/ubod/ubod-meta/prompts/ubod-update-agent.prompt.md`
- **Agent templates:** `projects/ubod/templates/agents/*.agent.md`

---

## Questions?

See: `projects/ubod/docs/FAQ.md` or open an issue in the ubod repo.
