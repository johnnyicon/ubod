# Verify Agent Schema Fixes Were Actually Applied

**Date:** 2026-01-06  
**Version:** 1.3.5  
**Type:** Verification Migration  
**Depends On:** `2026-01-06-vscode-agent-schema-fix.md`

---

## Summary

This migration **verifies** that the previous schema fix migration (`2026-01-06-vscode-agent-schema-fix`) was actually completed, not just marked as done.

**Problem:** LLMs were marking the migration "complete" by reading the guide and updating `.ubod-version`, but **skipping the actual fixes** (especially multiline handoff prompts).

**Solution:** This verification migration runs mandatory grep commands to detect unfixed issues.

---

## Who Needs This Migration

**You need this if:**
- You marked `2026-01-06-vscode-agent-schema-fix` as applied in `.ubod-version`
- BUT you haven't verified with grep commands that fixes were actually done
- Your agents might still have multiline `prompt: |` in handoffs

**Skip this if:**
- You're a brand new installation (no agents yet)
- You've already run the verification commands and they passed

---

## Verification Commands (MANDATORY)

Run ALL of these commands. **If ANY return results, fixes are incomplete.**

### 1. Check for multiline prompts

```bash
grep -n "prompt: |" .github/agents/*.agent.md
```

**Expected:** No results (exit code 1)  
**If you see results:** Multiline prompts still exist - FIX THEM

### 2. Check for invalid tool names

```bash
grep -E "tools:.*_(file|string|in_file|search)" .github/agents/*.agent.md
```

**Expected:** No results (exit code 1)  
**If you see results:** Invalid underscore tool names still exist - FIX THEM

### 3. Check for handoffs missing labels

```bash
grep -A3 "handoffs:" .github/agents/*.agent.md | grep -B1 "agent:" | grep -v "label:"
```

**Expected:** No results (only handoffs with labels)  
**If you see results:** Some handoffs missing `label:` field - FIX THEM

### 4. Check for model field in prompts

```bash
grep -n "^model:" .github/prompts/**/*.prompt.md
```

**Expected:** No results (exit code 1)  
**If you see results:** `model:` field still in prompts - FIX THEM

---

## If Verification Fails

**Step 1: Fix multiline prompts**

Find all multiline prompts:
```bash
grep -B2 -A5 "prompt: |" .github/agents/*.agent.md
```

For each one, convert to single-line format:

**BEFORE (Invalid):**
```yaml
handoffs:
  - label: "Next step"
    agent: "Agent Name"
    prompt: |
      Multi-line
      prompt text
```

**AFTER (Valid):**
```yaml
handoffs:
  - label: "Next step"
    agent: "Agent Name"
    prompt: "Single-line prompt text describing what next agent should do"
```

**Step 2: Fix invalid tool names**

Replace all underscore tool names:
- `read_file` → `read`
- `create_file` → `edit`
- `replace_string_in_file` → `edit`
- `grep_search` → `search`
- `semantic_search` → `search`
- `run_in_terminal` → `execute`

**Step 3: Add missing labels**

All handoffs MUST have `label:` field (VS Code requirement):
```yaml
handoffs:
  - label: "Button text"  # REQUIRED
    agent: "Agent Name"
    prompt: "Prompt text"
```

**Step 4: Remove model field**

Delete any `model:` field from `.prompt.md` files (not a valid field).

---

## Re-run Verification

After fixes, run ALL verification commands again.

**DO NOT mark this migration complete until ALL commands return 0 results.**

---

## Mark Migration Complete

Only after ALL verification commands pass:

```bash
# Add to .ubod-version
echo "  - 2026-01-06-verify-agent-schema-fixes" >> .ubod-version
```

Or manually add to `.ubod-version`:
```yaml
migrations:
  - 2026-01-06-vscode-agent-schema-fix
  - 2026-01-06-verify-agent-schema-fixes  # Add this line
```

---

## Why This Migration Exists

The original migration guide (`2026-01-06-vscode-agent-schema-fix.md`) was too advisory. LLMs interpreted it as:
1. Read the guide ✓
2. Update some files ✓
3. Mark complete ✓

But they **skipped actual verification**, leaving broken agents.

This migration forces explicit verification with grep commands that either pass or fail.

---

## Related Files

- **Original migration:** `ubod-meta/migrations/2026-01-06-vscode-agent-schema-fix.md`
- **Upgrade prompt:** `ubod-meta/prompts/ubod-upgrade.prompt.md`
- **Agent spec:** `.github/instructions/ubod/vscode-custom-agent-spec.instructions.md`
- **Prompt spec:** `.github/instructions/ubod/vscode-custom-prompt-spec.instructions.md`
