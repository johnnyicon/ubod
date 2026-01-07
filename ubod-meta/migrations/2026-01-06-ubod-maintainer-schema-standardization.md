# Migration: Ubod Maintainer Schema Standardization

**Date:** 2026-01-06  
**Version:** Ubod 1.4.0 → 1.4.1  
**Severity:** ⚠️ BREAKING - Deployed ubod-maintainer.agent.md must be updated

---

## What Changed

The `ubod-maintainer.agent.md` file has been refactored to follow the standard agent schema that all other agents use. This was identified during an upgrade scan in a consuming repo.

**Before (Non-standard):**
- `## Agent Persona` (custom)
- `## COMMANDS` (correct)
- `## BOUNDARIES` (plain list format)
- Missing `## SCOPE`
- `## Common Tasks` (custom)
- `## Key Directories` (at root level)

**After (Standard schema):**
- `## ROLE` (standard)
- `## COMMANDS` (standard)
- `## BOUNDARIES` (✅/⚠️/🚫 format)
- `## SCOPE` (added)
- `## WORKFLOW` (standard)
- `## DOMAIN CONTEXT` (contains Responsibilities, Key Directories, Maintenance Rules)

---

## Why This Happened

The ubod-maintainer agent was created early in the framework's development and predated the standardized schema. When we added COMMANDS and BOUNDARIES sections recently, we didn't fully align with the schema used by all other agents.

This was caught by a schema compliance scan in a consuming repo running `/ubod-upgrade`, which correctly flagged the inconsistency.

---

## Who Needs This Migration

**You need this migration if:**
- You have a deployed copy of `ubod-maintainer.agent.md` in `.github/agents/`
- You're consuming ubod as a submodule or template source
- Your upgrade scan flagged ubod-maintainer as "Missing Metadata/Body"

**Skip this migration if:**
- You don't have ubod-maintainer deployed (it's a meta agent)
- You're setting up ubod for the first time (templates are already fixed)

---

## Changes Required

### Option 1: Replace with Template (Recommended)

Delete your deployed copy and re-deploy from the template:

```bash
# From consuming repo root
rm .github/agents/ubod-maintainer.agent.md
cp projects/ubod/ubod-meta/agents/ubod-maintainer.agent.md .github/agents/
```

### Option 2: Manual Update

If you've customized the agent, apply these structural changes:

1. **Rename section:** `## Agent Persona` → `## ROLE`
2. **Update BOUNDARIES format:**
   ```markdown
   ## BOUNDARIES
   
   ✅ **Always do:**
   - [Items that were previously in BOUNDARIES]
   
   ⚠️ **Ask first:**
   - Breaking changes to agent/prompt schemas
   - Renaming core directories or files
   
   🚫 **Never do:**
   - [Items that were "NO ..." format]
   ```

3. **Add SCOPE section (after BOUNDARIES):**
   ```markdown
   ## SCOPE
   
   **What I maintain:**
   - Templates in `templates/`
   - Meta content in `ubod-meta/`
   - Documentation, CHANGELOG, migrations
   
   **What I do NOT maintain:**
   - App-specific implementations in consuming repos
   - Deployed copies in `.github/`
   ```

4. **Rename section:** `## Common Tasks` → `## WORKFLOW`
   Move task-specific content to DOMAIN CONTEXT

5. **Move to DOMAIN CONTEXT:**
   - Key Directories table
   - Ubod Maintenance Rules
   - Responsibilities list

---

## Verification Steps

**After updating, verify schema compliance:**

```bash
# Check for standard sections
grep -E "^## (ROLE|COMMANDS|BOUNDARIES|SCOPE|WORKFLOW|DOMAIN CONTEXT)" .github/agents/ubod-maintainer.agent.md

# Expected output (6 lines):
## ROLE
## COMMANDS
## BOUNDARIES
## SCOPE
## WORKFLOW
## DOMAIN CONTEXT
```

**Check BOUNDARIES format:**

```bash
grep -E "^(✅|⚠️|🚫)" .github/agents/ubod-maintainer.agent.md

# Should find emoji icons in BOUNDARIES section
```

**Check for legacy sections (should NOT exist):**

```bash
grep -E "^## (Agent Persona|Common Tasks|Key Directories)" .github/agents/ubod-maintainer.agent.md

# Expected: No matches (exit code 1)
```

---

## Why Standardization Matters

**Benefits:**
1. **LLM Parsing** - Consistent structure improves agent self-awareness
2. **Upgrade Automation** - Schema-compliant agents pass validation scans
3. **Maintainability** - Easier to understand and update across all agents
4. **Tooling** - Future tools can rely on predictable structure

**Risk of skipping:**
- Upgrade scans will continue to flag the agent
- Inconsistency with all other agents
- May break future automation tools

---

## Breaking Changes Summary

| Before | After | Breaking? |
|--------|-------|-----------|
| `## Agent Persona` | `## ROLE` | ✅ Yes (section rename) |
| BOUNDARIES (plain list) | BOUNDARIES (emoji format) | ✅ Yes (format change) |
| No `## SCOPE` | `## SCOPE` | ✅ Yes (required section) |
| `## Common Tasks` | `## WORKFLOW` + DOMAIN CONTEXT | ✅ Yes (restructure) |
| `## Key Directories` (root) | Under `## DOMAIN CONTEXT` | ✅ Yes (moved) |

---

## Rollback Plan

If issues occur after migration, you can temporarily revert:

```bash
# Get previous version from git
git show HEAD~1:.github/agents/ubod-maintainer.agent.md > .github/agents/ubod-maintainer.agent.md
```

However, this is NOT recommended as it will continue to fail schema validation.

---

## Support

If you encounter issues with this migration:

1. Check the verification steps pass
2. Compare your deployed copy against `projects/ubod/ubod-meta/agents/ubod-maintainer.agent.md`
3. Report issues in ubod repository with schema validation output

---

## Timeline

- **2026-01-06:** Schema standardization applied to ubod source
- **Next ubod upgrade:** Consuming repos will be prompted to update
- **Future:** Schema validation may become mandatory in `/ubod-upgrade`
