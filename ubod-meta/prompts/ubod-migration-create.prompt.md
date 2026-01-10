---
name: ubod-migration-create
description: Create migration file for breaking changes in Ubod release
---

# Ubod Migration Creator

**Purpose:** Create migration file when Ubod release includes breaking changes

**When to Use:** After `/ubod-version-bump` when breaking changes exist

---

## Overview

This prompt:
1. Checks if migration already exists for this release
2. Creates migration file from template if needed
3. Validates migration structure
4. Guides user through migration content

**Does NOT commit** - Use `/ubod-commit` after all files ready

---

## Step 1: Assess Need for Migration

**Ask user if not already known:**

```markdown
Does this release include breaking changes?

Breaking changes = changes that require consuming repos to update:
- ✅ Schema changes (agent/prompt/instruction format)
- ✅ Renamed core files or directories
- ✅ Changed file structure
- ✅ Removed required fields
- ✅ Changed workflow steps

Non-breaking changes = backward compatible:
- ❌ New optional fields
- ❌ New templates (consumers can ignore)
- ❌ Documentation updates
- ❌ Bug fixes that don't change API

Breaking changes in this release? yes | no
```

**If no → Skip migration:**
```markdown
✅ No breaking changes detected

No migration file needed. Proceed to `/ubod-validate`.
```

**If yes → Continue to Step 2**

---

## Step 2: Check Existing Migration

**Check if migration already exists:**

```bash
cd projects/ubod
ls ubod-meta/migrations/$(date +%Y-%m-%d)-*.md
```

**If migration exists:**
```markdown
✅ Migration already exists:
- ubod-meta/migrations/2026-01-10-adr-system-redesign.md

Review this migration file. Does it cover all breaking changes?

Options:
1. Update existing migration (I'll help you edit it)
2. Create additional migration (for separate concern)
3. Migration is complete (proceed to validation)
```

**If no migration exists → Continue to Step 3**

---

## Step 3: Gather Migration Context

**Ask user for details:**

```markdown
I'll create a migration file. Please provide:

1. **What changed?** (technical description)
   Example: "Agent schema now requires COMMANDS and BOUNDARIES sections"

2. **Why did it change?** (rationale)
   Example: "Clearer agent boundaries prevent scope creep"

3. **Who needs this migration?**
   - All consumers?
   - Only consumers who use specific features?
   - Only if customized certain files?

4. **What must consumers do?**
   - Update files manually?
   - Run upgrade script?
   - Both?

5. **How can they verify?**
   - Grep commands?
   - Test commands?
   - Visual inspection?
```

**Collect answers, then show summary for approval:**
```markdown
Migration Summary:
- What: [user's answer 1]
- Why: [user's answer 2]
- Who: [user's answer 3]
- Actions: [user's answer 4]
- Verification: [user's answer 5]

Ready to create migration file?
```

**Stop for approval before proceeding.**

---

## Step 4: Determine Severity

**Based on context, suggest severity level:**

| Severity | When to Use | Examples |
|----------|-------------|----------|
| 🔴 **CRITICAL** | Breaks existing setup, requires immediate action | Schema change blocks agent loading |
| ⚠️ **BREAKING** | Requires manual intervention but not urgent | Renamed files, changed structure |
| 🟡 **RECOMMENDED** | Should update but setup still works | New optional fields, deprecated patterns |
| 🟢 **OPTIONAL** | Nice-to-have improvements | Performance optimizations, new features |

**Suggest severity:**
```markdown
Suggested Severity: ⚠️ BREAKING

Reasoning: [why this severity level]

Agree with severity level? (or specify: CRITICAL/BREAKING/RECOMMENDED/OPTIONAL)
```

---

## Step 5: Create Migration File

**Generate migration filename:**
```
Format: YYYY-MM-DD-kebab-case-description.md
Example: 2026-01-10-adr-system-redesign.md
```

**Create file using this template:**

```markdown
---
version: OLD → NEW
date: YYYY-MM-DD
severity: [🔴 CRITICAL | ⚠️ BREAKING | 🟡 RECOMMENDED | 🟢 OPTIONAL]
---

# Migration: [Brief Title]

## What Changed

[Technical description of changes]

**Files affected:**
- `path/to/file1.md`
- `path/to/file2.agent.md`

**Changes:**
- Added: [new fields/sections]
- Changed: [modified fields/sections]
- Removed: [deleted fields/sections]
- Moved: [relocated files]

---

## Why This Change

[Rationale for breaking change]

**Problems solved:**
- [Problem 1]
- [Problem 2]

**Benefits:**
- [Benefit 1]
- [Benefit 2]

---

## Who Needs This Migration

**Affected consumers:**
- [All consumers | Specific use case]

**Unaffected consumers:**
- [Who can skip this migration]

**Check if affected:**
```bash
[Command to check if consumer uses affected features]
```

---

## Changes Required

### Before (Old Format)

```markdown
[Example of old format]
```

### After (New Format)

```markdown
[Example of new format]
```

**Key differences:**
- [Difference 1]
- [Difference 2]

---

## Migration Steps

### Automatic (via upgrade script)

The `ubod-upgrade.sh` script handles:
- [What script does automatically]

**Run:**
```bash
cd projects/ubod
./scripts/ubod-upgrade.sh
```

### Manual (if customized)

If you've customized these files, update manually:

**File: `path/to/customized-file.md`**

Find:
```markdown
[Old content to find]
```

Replace with:
```markdown
[New content]
```

**Repeat for each customized file.**

---

## Verification

**Run these checks after migration:**

```bash
# Check schema compliance
[Grep command to verify new format]

# Should return: [expected output]

# Check no old format remains
[Grep command to verify old format gone]

# Should return: empty
```

**Visual verification:**
- [ ] Open [file1] and verify [section] exists
- [ ] Check [file2] has [new field] in frontmatter
- [ ] Ensure [directory] structure matches [new layout]

**Functional verification:**
```bash
# Test that agents still work
[Command to test functionality]

# Should output: [expected result]
```

---

## Rollback

**If migration causes issues:**

```bash
# Option 1: Revert submodule
cd projects/ubod
git checkout <previous-commit>
cd ../..
git add projects/ubod
git commit -m "Revert Ubod to vOLD_VERSION"

# Option 2: Manual rollback
[Steps to manually undo changes]
```

**Note:** After rollback, do not run `ubod-upgrade.sh` again until ready to re-migrate.

---

## Resources

- **Ubod Docs:** [link to relevant docs]
- **Related PR/Issue:** [if applicable]
- **Discussion:** [link to decision discussion]

---

**Questions?** See [ubod-meta/migrations/README.md] or ask in [community/support channel].
```

**After creating file, show user:**
```markdown
✅ Migration Created

File: ubod-meta/migrations/2026-01-10-adr-system-redesign.md
Severity: ⚠️ BREAKING
Size: ~450 lines

Sections included:
- ✅ What Changed (with file paths)
- ✅ Why This Change (rationale)
- ✅ Who Needs This Migration
- ✅ Changes Required (before/after examples)
- ✅ Migration Steps (automatic + manual)
- ✅ Verification (commands + checklist)
- ✅ Rollback instructions

Review the migration file. Need any adjustments?
```

---

## Step 6: Validate Migration Structure

**Read created migration file and verify:**

```bash
cd projects/ubod
cat ubod-meta/migrations/2026-01-10-*.md
```

**Checklist:**
- [ ] Front matter includes: `version`, `date`, `severity`
- [ ] "What Changed" section complete with file paths
- [ ] "Why This Change" explains rationale
- [ ] "Who Needs This Migration" identifies affected consumers
- [ ] "Changes Required" shows before/after examples
- [ ] "Migration Steps" covers automatic + manual
- [ ] "Verification" includes commands + expected output
- [ ] "Rollback" provides recovery path

**If validation fails:**
```markdown
❌ Migration validation failed:

Missing/incomplete sections:
- [Section 1]
- [Section 2]

Would you like me to:
1. Add missing sections
2. You'll edit manually
```

**If validation passes:**
```markdown
✅ Migration Validated

All required sections present and complete.

File ready for commit (use `/ubod-commit` after validation passes).

**Summary for next step:**
- Migration file: ubod-meta/migrations/2026-01-10-adr-system-redesign.md
- Severity: ⚠️ BREAKING
- Verification commands included: yes
```

---

## Step 7: Summary Output

**Provide structured summary:**

```markdown
## Migration Created ✅

**File:** ubod-meta/migrations/2026-01-10-adr-system-redesign.md
**Severity:** ⚠️ BREAKING
**Date:** 2026-01-10

**Breaking Changes:**
- [Change 1]
- [Change 2]

**Affected Consumers:**
- [Who needs to migrate]

**Migration Path:**
- Automatic: `./scripts/ubod-upgrade.sh` handles [X, Y]
- Manual: Consumers with customized [A, B] files

**Verification:**
- [Command 1]: Expected output [...]
- [Command 2]: Should return empty

**Files Modified:**
- projects/ubod/ubod-meta/migrations/2026-01-10-adr-system-redesign.md

**Next Steps:**
1. Review migration file for completeness
2. Run `/ubod-validate` to check all files
3. After validation: Run `/ubod-commit`

**Context for Next Prompt:**
- Migration created: yes
- Migration path: ubod-meta/migrations/2026-01-10-adr-system-redesign.md
- Severity: BREAKING
```

---

## Error Handling

**If migration date collision:**
```markdown
❌ Migration already exists for today:
- ubod-meta/migrations/2026-01-10-existing-migration.md

Options:
1. Update existing migration (add new breaking changes to it)
2. Create with sequential suffix: 2026-01-10-02-new-migration.md
3. Cancel (migrate tomorrow, or use different date)
```

**If severity unclear:**
```markdown
⚠️ Severity level unclear

Based on your description, this could be:
- 🔴 CRITICAL: If [condition A]
- ⚠️ BREAKING: If [condition B]
- 🟡 RECOMMENDED: If [condition C]

Please clarify: [follow-up question]
```

---

## Tips

**Writing Good Migration Guides:**

✅ **Do:**
- Provide exact grep commands with expected output
- Show before/after examples for every change
- Include rollback instructions
- Test verification commands before documenting

❌ **Don't:**
- Assume consumers know internal changes
- Skip verification commands ("just check manually")
- Forget to document manual steps for customized files
- Use vague language ("update your files")

**Severity Guidelines:**

- **🔴 CRITICAL:** Setup won't work without migration (e.g., schema breaks agent loading)
- **⚠️ BREAKING:** Requires action but setup still loads (e.g., deprecated fields show warnings)
- **🟡 RECOMMENDED:** Should update but not required (e.g., new optional features)
- **🟢 OPTIONAL:** Nice-to-have (e.g., performance improvements)

---

## Integration with Other Prompts

**This prompt outputs context needed by:**

- `/ubod-validate` - Needs migration file path for validation
- `/ubod-commit` - Needs migration file for staging

**This prompt is invoked by:**

- `@ubod-checkin` agent - After version bump, if breaking changes
- User directly - When creating standalone migration

---

**Remember:** Migration file documents HOW to migrate, not just WHAT changed. Include verification and rollback!
